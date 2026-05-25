# 📄 Project Report: Autonomous Multi-Agent Automation Sandbox

## 🏆 Executive Summary
Congratulations! You have successfully built, validated, and deployed a **100% Free, Enterprise-Grade Multi-Agent Automation Pipeline**. 

Running entirely on local and free cloud tiers, this cognitive architecture connects a chatbot user interface to a **Supervisor-Critic self-correcting logic graph**, custom local data-crunching tools, semantic vector memory (RAG), and a transparent database audit dashboard, culminating in real-time verified business delivery via your own custom Google Cloud Gmail API integration.

---

## 🏗️ Technical Stack & Architecture

Your architecture utilizes a cost-free, high-performance tech stack:
* **Front-End Chatbot Interface:** **n8n Native Chat Hub** (Runs locally to trigger executions and chat with your supervisor agent).
* **Core Automation Engine:** **n8n Local Engine (NPM Edition)** (Runs locally in your terminal, fully unlocked).
* **Context & Memory Layer (RAG):** **Supabase pgvector Free Tier** (Holds corporate rules, manuals, and templates for semantic similarity search).
* **Analytics & Audit Dashboard:** **Supabase Table Editor + Custom SQL Views** (Provides spreadsheet-like real-time auditing and aggregate performance ratios).
* **AI Reasoning Engine:** **Google Gemini 1.5 Flash** (High-speed, cost-free AI model optimized for multi-agent tool-calling and planning).
* **Delivery Engine:** **Gmail API via Custom Google Cloud OAuth App** (Dispatches validated final deliverables directly to inboxes).

### 🕸️ Visual Logic Flow
```
                      ┌───────────────────────────────────────────────────┐
                      │          1. When Chat Message Received            │
                      └─────────────────────────┬─────────────────────────┘
                                                ▼
                      ┌───────────────────────────────────────────────────┐
         ┌───────────►│            2. Tools AI Agent Node                 │◄──────────────────┐
         │            │          (Supervisor & Task Planner)              │                   │
         │            └─────────────────────────┬─────────────────────────┘                   │
         │                                      │                                             │
         │     ┌────────────────────────────────┼────────────────────────────────┐            │
         │     ▼                                ▼                                ▼            │
         │┌──────────────┐              ┌──────────────┐                 ┌──────────────┐     │
         ││Supabase Vector│             │ Custom Code  │                 │Google Sheets │     │
         ││ (RAG Tool)   │              │ (Python Tool)│                 │/ Gmail Nodes │     │
         │└──────────────┘              └──────────────┘                 └──────────────┘     │
         │                                      │                                             │
         │                                      ▼                                             │
         │            ┌───────────────────────────────────────────────────┐                   │
         │            │               4. JavaScript Code Node             │                   │
         │            │             (The Critic & Output Validator)       │                   │
         │            └─────────────────────────┬─────────────────────────┘                   │
         │                                      │                                             │
         │                            Did output pass validation?                             │
         │                                    /   \                                           │
         │                                  No     Yes                                        │
         │                                  /       \                                         │
         └────[Loopback: Critic Error]─────┘         ▼                                        │
                                      ┌───────────────────────────────────┐                   │
                                      │     5. Supabase Database Node     │───────────────────┘
                                      │  (Logs Success & Dashboard Update)│
                                      └─────────────────┬─────────────────┘
                                                        ▼
                                      ┌───────────────────────────────────┐
                                      │            6. Gmail Node          │
                                      │   (Final Business Deliverable)    │
                                      └───────────────────────────────────┘
```

---

## 🛠️ What We Did (Implementation Steps)

We successfully transformed an empty directory into a fully configured production sandbox by implementing:

### 1. Database Provisioning (`supabase_schema.sql`)
* **Vector Setup:** Enabled the `vector` extension and created `corporate_knowledge_base` with a 1536-dimensional embedding column for RAG lookups.
* **Audit Dashboard:** Designed `agent_deliverables_dashboard` to log user requests, execution statuses, exact critic retry loop counts, complete critic feedback histories, and detailed step-by-step telemetry JSONs.
* **Vector Search Function:** Registered `match_documents` directly in your PostgreSQL schema, enabling n8n to perform fast similarity searches on guidelines.
* **Analytical Views:** Crafted SQL views (`view_critic_loop_analytics`) to instantly calculate overall success rates, failed runs, and average retry rates.
* **Dashboard Seed Data:** Pre-populated mock records capturing successful, audited, and self-corrected runs so your table visualization is fully operational immediately.

### 2. Environment Automation (`start_n8n.bat`)
* Programmed a robust Windows batch script that automatically verifies Node.js/NPM, globally installs the n8n package if missing, and boots the local workspace engine on port `5678` with a customized CLI dashboard.

### 3. Visual Workflow Engineering (`n8n_workflow.json`)
* Developed a complete, fully connected visual workflow file featuring:
  * **When Chat Message Received** trigger connected to a version 2 **AI Agent** node.
  * **Gemini 1.5 Flash Model & Simple Memory** nodes linked to the agent's core cognitive slots.
  * **Supabase Vector Store Tool & Python Code Tool** connected to the agent's tool-calling slots.
  * **JavaScript Critic Code Node** containing strict validation logic (checking for length and required `"Weekly Performance"` headers) and incrementing attempts.
  * **Feedback Loop Mapper** that maps errors and dynamically loops control back into the agent input using `{{ $json.chatInput || $json.feedback_prompt }}`.
  * **Supabase Database Insert Node** configured under "Define below" to insert custom execution audits.
  * **Gmail Node** linked to your verified Google Developer Console OAuth Client, sending the final validated output report to your target inbox with a dynamic subject line.

---

## 📊 What You Can Do With This (High-Value Features)

1. **Self-Correcting AI Workflows:** 
   * If the AI drafts a report that is missing headers or is too brief, the Critic blocks it, writes a constructive criticism prompt, and forces the AI to try again. The user only ever receives high-quality, verified results!
2. **Absolute Transparency Auditing:**
   * Open your Supabase `agent_deliverables_dashboard` table. You can inspect every single mistake the AI made behind the scenes, read the Critic's specific feedback, and see the exact number of loops it took to self-correct.
3. **Hybrid Local/Cloud Computing:**
   * The agent can write and run custom Python scripts locally on your machine for heavy calculations (saving API tokens), while utilizing Gemini in the cloud for high-level reasoning.
4. **Instant Business Outcome Delivery:**
   * The AI generates documents, validates them, saves them to a central database, and emails them automatically—requiring zero human interaction.

---

## 💡 Example Scenarios (Playbooks)

### Scenario A: Weekly Operations & Performance Reviews (Active Now!)
* **The Goal:** Compile and deliver a weekly summary of warehouse shipments, project milestones, and bottlenecks.
* **How it works:**
  1. You type in the n8n chat: `"Generate the weekly logistics report for the manager."`
  2. The Agent queries the Supabase Vector Store for standard styles and templates.
  3. The Agent drafts a report.
  4. The Critic intercepts it: if the report is too brief, the Critic rejects it and says: *"Report must be at least 150 characters and have a 'Weekly Performance' heading."*
  5. The Agent expands the details, formats the headers, and resubmits.
  6. The Critic passes it.
  7. Supabase records the success (e.g., `critic_loops_run: 1`).
  8. Gmail sends the final, polished report directly to your manager with the subject: `[AUTONOMOUS REPORT] Generate the weekly logistics report...`.

### Scenario B: Vendor Invoice & Expense Auditor
* **The Goal:** Scan incoming vendor expense lines, double-check tax calculations, and flag any discrepancies.
* **How to configure it:**
  1. Link a **Google Sheets** node as a tool to your AI Agent (to read raw expense rows).
  2. In your Critic JS node, write a rule: *Verify that (subtotal + tax === total). If not, reject.*
  3. **The Run:** You type: `"Audit Q2 vendor expenses."` ➔ The Agent reads the sheet ➔ Runs a Python tool script to sum the rows and calculate tax ➔ The Critic flags a $10 mismatch on invoice #104 and loops back ➔ The Agent highlights the discrepancy, writes a warning summary, and logs it to Supabase ➔ An email is sent to accounting detailing the audited list and the flagged discrepancy.

### Scenario C: Legal & Brand Voice Compliance Engine
* **The Goal:** Write social media copy, blog articles, or emails and guarantee they match legal compliance guidelines and brand voice.
* **How to configure it:**
  1. Insert your brand compliance manuals and banned word list into your Supabase `corporate_knowledge_base` table.
  2. In your Critic JS node, write a validation check (e.g. *Must not contain banned regulatory words*).
  3. **The Run:** You ask: `"Draft a promo email for the new product."` ➔ The Agent performs a vector similarity search on brand policies ➔ Drafts the copy ➔ The Critic scans the copy, catches a prohibited regulatory word, and loops back ➔ The Agent rewrites the sentence, the Critic passes the compliant version, logs the audit, and slacks the finalized text.

---

## 🚀 Recommended Future Extensions

1. **Automate on a Cron Schedule:**
   * Replace the **When Chat Message Received** trigger with a **Schedule Trigger** (Cron) to run this pipeline automatically every Friday at 5:00 PM without clicking a button!
2. **Expand RAG Memory:**
   * Insert your own actual company policy PDFs, standard document layouts, and standard email formats into the `corporate_knowledge_base` table so the AI writes reports that look exactly like your business documents.
3. **Generate PDFs:**
   * Add a **Markdown to PDF** node in n8n before the Gmail node to automatically compile the final text into a premium PDF attachment, emailing it as a clean document!
