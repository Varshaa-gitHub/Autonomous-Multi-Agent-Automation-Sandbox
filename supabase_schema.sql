-- =====================================================================
-- 🛠️ SUPABASE DATABASE INITIALIZATION & ANALYTICS SCHEMAS
-- =====================================================================
-- Description: Provision RAG-based context memory and a high-transparency
--              business deliverables audit log dashboard with retry analytics.
-- =====================================================================

-- 1. Enable the native PostgreSQL Vector indexing extension for RAG
CREATE EXTENSION IF NOT EXISTS vector;

-- 2. Corporate Knowledge Base Table (RAG Store)
--    Holds company policies, guidelines, templates, and reference materials.
CREATE TABLE IF NOT EXISTS corporate_knowledge_base (
    id BIGSERIAL PRIMARY KEY,
    content TEXT NOT NULL,
    metadata JSONB DEFAULT '{}'::jsonb, -- Store category, tags, and document source references
    embedding VECTOR(1536)               -- 1536-dimensional OpenAI/compatible embeddings
);

COMMENT ON TABLE corporate_knowledge_base IS 'Holds vector embeddings of corporate guidelines and reference templates for agent RAG lookups.';
COMMENT ON COLUMN corporate_knowledge_base.content IS 'The text chunk containing organizational templates, styles, or policy manuals.';
COMMENT ON COLUMN corporate_knowledge_base.embedding IS '1536-dimension float array matching standard OpenAI text-embedding-3-small/ada-002 dimensions.';

-- 2b. Vector Similarity Search Function (match_documents)
--     Used by n8n to perform cosine similarity searches on text embeddings
CREATE OR REPLACE FUNCTION match_documents (
  query_embedding VECTOR(1536),
  match_count INT,
  filter JSONB DEFAULT '{}'::JSONB
) RETURNS TABLE (
  id BIGINT,
  content TEXT,
  similarity FLOAT
) LANGUAGE plpgsql AS $$
BEGIN
  RETURN QUERY
  SELECT
    corporate_knowledge_base.id,
    corporate_knowledge_base.content,
    1 - (corporate_knowledge_base.embedding <=> query_embedding) AS similarity
  FROM corporate_knowledge_base
  ORDER BY corporate_knowledge_base.embedding <=> query_embedding
  LIMIT match_count;
END;
$$;

-- 3. Business Deliverables & Transparency Audit Dashboard Table
--    Acts as a real-time, spreadsheet-like production logging interface.
CREATE TABLE IF NOT EXISTS agent_deliverables_dashboard (
    id BIGSERIAL PRIMARY KEY,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    user_request TEXT NOT NULL,
    execution_status TEXT DEFAULT 'Processing' 
        CONSTRAINT chk_status CHECK (execution_status IN ('Processing', 'Success', 'Critique Failed', 'Remediating', 'Fatal Error')),
    critic_loops_run INT DEFAULT 0,
    critic_feedback_history JSONB DEFAULT '[]'::jsonb, -- Array tracking full loop critique logs for absolute transparency
    deliverable_outcome TEXT,                            -- Clear summary of what was generated and where it went
    detailed_audit_logs JSONB NOT NULL,                 -- Full step-by-step trace of agent tools and reasoning history
    target_channel TEXT DEFAULT 'Slack/Gmail'           -- Intended destination of final deliverable
);

COMMENT ON TABLE agent_deliverables_dashboard IS 'Real-time dashboard audit trail logs capturing multi-agent execution steps, critic loops, and final deliverables.';
COMMENT ON COLUMN agent_deliverables_dashboard.execution_status IS 'Current processing state. Success indicates it passed validator checks.';
COMMENT ON COLUMN agent_deliverables_dashboard.critic_feedback_history IS 'Chronological array of reasons the output failed the validation critic before succeeding.';
COMMENT ON COLUMN agent_deliverables_dashboard.detailed_audit_logs IS 'Full JSON payload capturing n8n workflow variables, model parameters, and raw execution logs.';

-- 4. Create Indexes for High-Performance Dashboard Querying
CREATE INDEX IF NOT EXISTS idx_dashboard_status ON agent_deliverables_dashboard(execution_status);
CREATE INDEX IF NOT EXISTS idx_dashboard_timestamp ON agent_deliverables_dashboard(timestamp DESC);

-- 5. Create Helper Views for Transparent Analytics Reporting
--    Allows administrators to view aggregate efficiency metrics directly in Supabase
CREATE OR REPLACE VIEW view_critic_loop_analytics AS
SELECT 
    COUNT(*) AS total_runs,
    ROUND(AVG(critic_loops_run), 2) AS avg_critic_loops,
    COUNT(*) FILTER (WHERE execution_status = 'Success') AS successful_runs,
    COUNT(*) FILTER (WHERE execution_status = 'Fatal Error') AS failed_runs,
    ROUND((COUNT(*) FILTER (WHERE execution_status = 'Success')::NUMERIC / COUNT(*)::NUMERIC) * 100, 2) || '%' AS success_rate
FROM agent_deliverables_dashboard;

CREATE OR REPLACE VIEW view_recent_success_deliverables AS
SELECT 
    id,
    timestamp,
    user_request,
    critic_loops_run,
    deliverable_outcome
FROM agent_deliverables_dashboard
WHERE execution_status = 'Success'
ORDER BY timestamp DESC;

-- 6. Insert Mock Seed Data for Instant Dashboard Visualization
--    Gives the user immediate visual layout examples upon initial table creation!
INSERT INTO agent_deliverables_dashboard (
    user_request,
    execution_status,
    critic_loops_run,
    critic_feedback_history,
    deliverable_outcome,
    detailed_audit_logs,
    target_channel
) VALUES 
(
    'Compile the weekly vendor performance review report for Q2 logistics operations.',
    'Success',
    2,
    '[
        "CRITIC FAILURE: The generated output is missing the ''Weekly Performance'' section or is too short.",
        "CRITIC FAILURE: Vendor comparison data format does not match corporate template requirements. Re-align columns."
    ]'::jsonb,
    'Weekly Performance review report compiled, formatted to standard templates, and successfully dispatched to manager@company.com.',
    '{
        "agentName": "Supervisor / Planner Agent",
        "modelUsed": "claude-3-5-sonnet",
        "stepsExecuted": ["Fetch Sheets Data", "Query Supabase RAG", "Run Python Stats Cleanup", "Format Report Output"]
    }'::jsonb,
    'Gmail'
),
(
    'Format and synchronize the incoming financial ledger data from Excel to master PostgreSQL databases.',
    'Success',
    0,
    '[]'::jsonb,
    'Synchronized 423 ledger records, validated tax balances using local Python executor, updated primary tables.',
    '{
        "agentName": "Supervisor / Planner Agent",
        "modelUsed": "gpt-4o",
        "stepsExecuted": ["Read Excel Tool", "Verify Sums", "DB Bulk Insert"]
    }'::jsonb,
    'Supabase DB'
);
