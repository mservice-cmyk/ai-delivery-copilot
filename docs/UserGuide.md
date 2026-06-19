# AI Delivery Copilot - User Guide

## Welcome!

Welcome to AI Delivery Copilot, your AI-powered assistant for accelerating Salesforce delivery activities. This guide will help you get the most out of the platform.

---

## Table of Contents

- [Getting Started](#getting-started)
- [Feature Guides](#feature-guides)
  - [User Story Generator](#user-story-generator)
  - [UAT Test Generator](#uat-test-generator)
  - [Solution Design Review](#solution-design-review)
  - [Executive Status Generator](#executive-status-generator)
  - [RAID Log Generator](#raid-log-generator)
  - [Customer Meeting Prep](#customer-meeting-prep)
  - [Prompt Library](#prompt-library)
  - [Export & Copy Features](#export--copy-features)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)
- [FAQs](#faqs)
- [Getting Help](#getting-help)

---

## Getting Started

### Accessing the Application

1. **Log in to Salesforce**
   - Open your web browser
   - Navigate to your Salesforce org URL
   - Enter your credentials

2. **Open AI Delivery Copilot**
   - Click the **App Launcher** (9 dots icon in the top left)
   - Search for "AI Delivery Copilot"
   - Click on the application name

3. **First Time Setup**
   - Your administrator should have assigned you the **AI_Delivery_Copilot_User** permission set
   - If you see "Insufficient Privileges" error, contact your admin

### Understanding the Interface

**Main Dashboard**

```
┌─────────────────────────────────────────────────────────┐
│         AI Delivery Copilot                              │
├─────────────────────────────────────────────────────────┤
│  Accelerate your Salesforce delivery with AI insights   │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  [Generate User Stories]  [UAT Test Generator]          │
│                                                          │
│  [Solution Design Review] [Executive Status]            │
│                                                          │
│  [RAID Log Generator]     [Customer Meeting Prep]       │
│                                                          │
│  [Deployment Checklist]   [Prompt Library]              │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

Click any card to access that feature.

---

## Feature Guides

### User Story Generator

**Purpose**: Generate comprehensive user stories from business requirements

#### When to Use

- Starting a new project or feature
- Translating requirements into user stories
- Creating backlog items for sprint planning
- Documenting stakeholder requests

#### How to Use

**Step 1: Enter Business Requirement**

```
Click: Generate User Stories card

In the "Business Requirement" field, describe what needs to be built:

Example:
"Build a customer self-service portal where customers can submit 
support cases, view case status, search knowledge articles, and 
update their contact information."

Tips:
✓ Be specific about functionality needed
✓ Include business context
✓ Mention user types if multiple personas
✓ Describe integrations or external systems
```

**Step 2: Select Persona**

```
Choose the primary user:
- Customer (external user)
- Sales Manager
- Customer Support Manager
- Marketing Manager
- Business User (generic)
- Field Service Technician
- Partner User
- System Administrator

The AI will tailor stories to this persona's needs.
```

**Step 3: Choose Business Process**

```
Select the business process context:
- Case Management
- Sales Pipeline
- Marketing Operations
- Customer Self-Service
- Field Service Operations
- Partner Management
- Order Management
- Business Operations (generic)

This helps generate relevant acceptance criteria.
```

**Step 4: Add Salesforce Objects**

```
Enter the Salesforce objects involved (comma-separated):

Examples:
- "Case, Contact, Account"
- "Opportunity, Lead, Campaign"
- "Work Order, Product Required, Service Appointment"

This ensures stories reference the correct data model.
```

**Step 5: Generate**

```
Click "Generate User Stories"

Wait 5-10 seconds for generation (mock mode)
Wait 15-30 seconds if real AI integration is configured

The system will generate 5-8 user stories.
```

#### Understanding the Output

**Each User Story Includes:**

```
Story Title: "Submit Support Case"

Description:
"As a Customer, I want to submit a support case with details 
so that I can get help from the support team."

Acceptance Criteria:
✓ Given I am logged into the portal
  When I click "New Case"
  Then I see a case submission form

✓ Given I am on the case form
  When I enter subject, description, and priority
  Then the form validates required fields

✓ Given I submit a valid case
  When I click "Submit"
  Then a case is created and I receive a confirmation

Story Points: 5
Priority: High
Dependencies: "User Authentication" story must be complete

Edge Cases:
- User tries to submit without required fields
- User uploads file larger than 25MB
- Session expires during case submission

Technical Notes:
- Use Experience Cloud for portal
- Implement file upload with virus scanning
- Consider governor limits for attachments
```

#### Actions After Generation

**Copy Story**
```
Click: "Copy as Markdown" button
Paste into: Jira, Azure DevOps, Confluence, Word document
```

**Export Stories**
```
Click: "Export as CSV"
Opens: Spreadsheet with all stories
Use for: Jira import, Excel planning, sharing with team
```

**Save Output**
```
Click: "Save Output"
Enter: Title for this set of stories
Tags: "sprint-1, customer-portal, user-stories"
Later: Find in Executive Dashboard > Saved Outputs
```

**Rate the Output**
```
Click: Star rating (1-5 stars)
Purpose: Help improve the AI and track quality
Optional: Add feedback comments
```

#### Tips for Better Results

✅ **Be Specific**
```
❌ Bad: "Build a portal"
✅ Good: "Build a customer self-service portal with case management, 
         knowledge base search, and profile management"
```

✅ **Provide Context**
```
Include:
- Industry (if relevant): "for financial services customers"
- Volume: "handling 1000+ cases per day"
- Compliance: "must comply with HIPAA"
- Integration: "integrate with legacy billing system"
```

✅ **Use the Prompt Library**
```
- Save prompts that work well
- Reuse for similar projects
- Share with team members
```

---

### UAT Test Generator

**Purpose**: Generate comprehensive UAT test cases from user stories or features

#### When to Use

- Creating test plans for new features
- Preparing for UAT phase
- Generating regression test suites
- Documenting test scenarios for QA team

#### How to Use

**Step 1: Enter Feature or User Story**

```
Click: UAT Test Generator card

Paste the user story or describe the feature:

Example:
"As a customer, I can submit a support case with subject, 
description, priority, and file attachments up to 25MB. 
The system validates required fields, creates a case record, 
sends confirmation email, and displays case number."
```

**Step 2: Generate Test Cases**

```
Click: "Generate Test Cases"

The system will create 30+ test cases covering:
- Positive scenarios (happy path)
- Negative scenarios (error handling)
- Boundary conditions
- Integration tests
- Security tests
```

#### Understanding the Output

**Test Cases Include:**

```
Test ID: TC-001
Scenario: Submit case with all valid information
Priority: High

Prerequisites:
- User is logged into customer portal
- User has valid account
- Test data: Valid subject and description text

Test Steps:
1. Navigate to "Support" tab
2. Click "New Case" button
3. Enter subject: "Test Case Subject"
4. Enter description: "This is a test case description"
5. Select priority: "Medium"
6. Click "Submit"

Expected Result:
- Case is created successfully
- Case number is displayed (format: 00001234)
- Confirmation email is sent to user's email
- Case appears in "My Cases" list
- Case status is "New"

Test Data:
Subject: "Test Portal Case Creation"
Description: "Testing case submission functionality"
Priority: "Medium"
```

**Priority Color Coding:**

- 🔴 **High Priority**: Critical path, must pass before release
- 🟡 **Medium Priority**: Important functionality
- 🟢 **Low Priority**: Edge cases, nice-to-have validations

#### Test Case Categories

**Functional Tests** - Standard feature functionality
```
Examples:
- Submit case with valid data
- View list of submitted cases
- Update case status
- Add comment to case
```

**Negative Tests** - Error handling
```
Examples:
- Submit case without required subject
- Attach file larger than 25MB limit
- Access case belonging to another user
- Submit case while logged out
```

**Boundary Tests** - Limits and edge values
```
Examples:
- Submit case with subject at 255 character limit
- Submit case with empty description (if allowed)
- Upload file at exactly 25MB
- Submit 100 cases in rapid succession
```

**Integration Tests** - Cross-system functionality
```
Examples:
- Verify case appears in Service Console
- Confirm email notification is sent
- Check case assignment rules trigger
- Validate API integration with external system
```

**Security Tests** - Permission and access control
```
Examples:
- User can only see their own cases
- Unauthenticated user cannot submit cases
- Field-level security is enforced
- Sharing rules prevent cross-account access
```

#### Actions After Generation

**Export Test Cases**
```
Click: "Export as CSV"
Import to: TestRail, Zephyr, Excel, Google Sheets
Use for: Test execution tracking
```

**Copy Individual Test**
```
Hover over test case
Click: Copy icon
Paste into: Test management tool
```

**Filter Test Cases**
```
Use: Priority filter (High/Medium/Low)
Use: Category filter (Functional/Security/etc.)
Search: By keyword in scenario or steps
```

**Create Test Execution Plan**
```
1. Sort by Priority (High first)
2. Estimate execution time per test
3. Assign test cases to QA team members
4. Track pass/fail status
```

---

### Solution Design Review

**Purpose**: Get architecture review and recommendations for Salesforce solution designs

#### When to Use

- Reviewing technical design before implementation
- Getting second opinion on architecture decisions
- Identifying potential issues early
- Validating best practices compliance

#### How to Use

**Step 1: Describe Your Solution Design**

```
Click: Solution Design Review card

Enter your architecture description:

Example:
"Using Lightning Web Components for the UI layer, with Platform 
Events for real-time notifications between users. Apex triggers 
handle business logic for work order assignment based on geolocation 
and technician skills. Integration with SAP for inventory management 
via MuleSoft API. Mobile SDK provides offline capability for field 
technicians. All data encrypted at rest using Shield."
```

**Tips for Better Reviews:**

```
Include:
✓ UI technology (LWC, Visualforce, Experience Cloud)
✓ Business logic approach (Apex, Flow, Process Builder)
✓ Data model (objects, relationships)
✓ Integration patterns (REST, SOAP, Platform Events)
✓ Security approach (Sharing, Field Security, Encryption)
✓ Performance considerations (caching, bulkification)
✓ Scale (expected data volume, user concurrency)
```

**Step 2: Generate Review**

```
Click: "Review Design"

Wait for analysis (15-30 seconds with AI integration)
```

#### Understanding the Output

**1. Executive Summary**

```
Example:
"Solution architecture is sound with modern patterns using LWC and 
Platform Events. Strong security posture with Shield encryption. 
Primary concern is geolocation calculation governor limits with 
high volume. Recommend async processing for bulk operations and 
platform caching for frequently accessed data."
```

**2. Recommendations (5-7 specific items)**

```
Example:
1. "Implement Platform Caching for frequently accessed technician 
   skill data to reduce SOQL queries by ~70%"

2. "Move geolocation calculations to Queueable Apex to avoid 
   governor limit issues with bulk work order assignments"

3. "Add retry logic for SAP integration calls with exponential 
   backoff to handle intermittent connectivity"

4. "Consider batch processing for end-of-day inventory 
   synchronization instead of real-time to reduce API call volume"

5. "Implement comprehensive error logging using Platform Events 
   to capture integration failures without blocking user transactions"
```

**3. Risk Assessment**

```
Risk: Governor limits may be exceeded with bulk geolocation processing
Impact: High (could fail in production)
Probability: Medium (depends on actual volume)
Mitigation: Implement Queueable Apex with chunking strategy

Risk: SAP integration latency could timeout during peak hours
Impact: Medium (users experience delays)
Probability: High (observed in similar integrations)
Mitigation: Implement async pattern with callback mechanism
```

**4. Action Items**

```
Task: Refactor geolocation logic to use Queueable Apex
Priority: High
Owner: Senior Developer
Duration: 3 days

Task: Implement platform caching for skill data
Priority: Medium
Owner: Tech Lead
Duration: 2 days
```

**5. Next Steps**

```
1. Conduct load testing with 1000+ concurrent work order assignments
2. Create proof-of-concept for async SAP integration
3. Document error handling patterns for team
4. Schedule architecture review board presentation
```

#### Actions After Review

**Share with Team**
```
Copy as Markdown → Paste into:
- Confluence technical design document
- Slack architecture channel
- Email to tech lead and architect
```

**Track Action Items**
```
Export to CSV → Import into:
- Jira as technical debt stories
- Project plan as tasks
- Risk register
```

**Iterate on Design**
```
Update your design based on recommendations
Re-run review to validate improvements
Compare confidence scores
```

---

### Executive Status Generator

**Purpose**: Generate executive-level project status reports

#### When to Use

- Weekly status updates for stakeholders
- Steering committee presentations
- Monthly business reviews
- Project health check-ins

#### How to Use

**Step 1: Access Dashboard**

```
Click: Executive Status Generator card
Or: Navigate to "Executive Dashboard" tab
```

**Step 2: Select Date Range**

```
Options:
- Current Week
- Current Month
- Current Quarter
- Custom Date Range

The system will analyze project activity in that period.
```

**Step 3: Generate Report**

```
Click: "Generate Status Report"

The report will include:
- Project health indicator
- Progress metrics
- Risks and issues
- Budget status
- Team velocity
- Upcoming milestones
```

#### Understanding the Dashboard

**Project Health Indicators**

```
🟢 GREEN - On Track
- All milestones on schedule
- No critical risks
- Budget within 5% variance
- Team velocity stable

🟡 YELLOW - At Risk
- One or more milestones delayed
- Medium-high risks present
- Budget variance 5-10%
- Team velocity declining

🔴 RED - Off Track
- Critical milestones missed
- High-impact risks realized
- Budget variance >10%
- Major blockers present
```

**Key Metrics Panel**

```
Sprint Velocity: 42 points (↑ 5% from last sprint)
Completed Stories: 8 / 10 planned
Team Utilization: 87%
Budget Consumed: 65% of allocated
Days to Next Milestone: 12
```

**Recent Activity**

```
Shows last 10 generated outputs:
- User stories created
- Test cases generated
- Solution designs reviewed
- Status reports created

Each with:
- Timestamp
- Feature used
- Confidence score
- Quick actions (view, copy, export)
```

#### Actions with Status Reports

**Copy for Email**
```
Format: Markdown
Paste directly into: Outlook, Gmail
Renders as: Formatted text with bullets and headers
```

**Export Slide Deck**
```
Format: PowerPoint-ready
Content: One slide per section
Use for: Steering committee presentation
```

**Schedule Recurring Reports**
```
(Future Feature)
Set cadence: Weekly / Biweekly / Monthly
Auto-generate and email to stakeholders
```

---

### RAID Log Generator

**Purpose**: Generate and manage Risks, Assumptions, Issues, and Dependencies

#### When to Use

- Project kickoff (identify initial risks and assumptions)
- Phase gates (review RAID before proceeding)
- Weekly project reviews
- Preparing for steering committees
- Issue escalation documentation

#### How to Use

**Step 1: Enter Project Context**

```
Click: RAID Log Generator card

Enter context:
- Project name: "Customer Portal Phase 2"
- Current phase: "Development"
- Team size: 8 people
- Timeline: 12 weeks
- Key challenges: "Tight timeline, complex integration"
```

**Step 2: Generate RAID Log**

```
Click: "Generate RAID Log"

System analyzes context and generates:
- 5-8 Risks
- 4-6 Assumptions
- 3-5 Current Issues
- 5-7 Dependencies
```

#### Understanding RAID Categories

**RISKS** (Things that MIGHT go wrong)

```
Example Risk:
Description: Integration API may not support required transaction volume
Category: Technical
Likelihood: Medium
Impact: High
Risk Score: Medium-High
Mitigation: Conduct load testing in week 3, identify alternative API if needed
Contingency: If API insufficient, implement async batch processing instead
Owner: Integration Lead
Status: Active - Monitoring

Use When:
- Identifying potential future problems
- Planning mitigation strategies
- Communicating concerns to stakeholders
```

**ASSUMPTIONS** (Things we believe to be TRUE but haven't validated)

```
Example Assumption:
Description: Legacy system data quality is acceptable for migration
Validation Status: Pending
Impact if Wrong: High (delays migration by 2-3 weeks)
Validation Approach: Run data quality assessment in week 2
Owner: Data Architect
Due Date: End of week 2

Use When:
- Making planning decisions without complete information
- Tracking what needs to be validated
- Identifying dependencies on external factors
```

**ISSUES** (Current PROBLEMS that need resolution)

```
Example Issue:
Description: Production org storage limit approaching capacity
Category: Blocker
Impact: Cannot deploy to production until resolved
Current Status: Escalated to IT
Resolution Plan: 
  1. Request storage increase from Salesforce (1-2 days)
  2. Archive old data if increase denied (3-5 days)
Owner: System Administrator
Due Date: End of week
Priority: Critical

Use When:
- Tracking active blockers
- Managing escalations
- Reporting impediments to progress
```

**DEPENDENCIES** (Things we're WAITING FOR)

```
Example Dependency:
Description: Third-party vendor API documentation and test credentials
Type: External
Status: Delayed (was due last Friday)
Impact if Delayed: Integration development cannot start, 1 week slip
Mitigation: Start UI development first, parallel track API integration
Owner: Vendor Manager
Expected Date: This Friday
Critical Path: Yes

Use When:
- Tracking external deliverables
- Managing vendor/partner commitments
- Identifying schedule impacts
```

#### RAID Log Management

**Updating Status**
```
Weekly Review Process:
1. Review each RAID item
2. Update status (Active/Mitigated/Closed)
3. Add new items as identified
4. Re-assess impact and probability
5. Update mitigation progress
```

**Escalation Criteria**
```
Escalate to Steering Committee when:
- High Impact + High Likelihood risk
- Issue remains unresolved for 2 weeks
- Critical dependency delayed
- Assumption validated as FALSE with high impact
```

**Prioritization**
```
Focus attention on:
1. Critical Issues (resolve immediately)
2. High-Impact, High-Likelihood Risks (mitigate now)
3. Delayed Critical-Path Dependencies (escalate)
4. High-Impact Assumptions (validate ASAP)
```

---

### Customer Meeting Prep

**Purpose**: Prepare comprehensive materials for customer meetings

#### When to Use

- Demo meetings with customers
- Steering committee presentations
- Sprint reviews with stakeholders
- Architecture review sessions
- Go-live readiness reviews

#### How to Use

**Step 1: Enter Meeting Details**

```
Click: Customer Meeting Prep card

Fill in:
- Meeting Type: Demo / Status Review / Decision Session
- Attendees: [List names and roles]
- Duration: 60 minutes
- Objectives: 
  * Demonstrate Phase 1 functionality
  * Get approval for Phase 2 scope
  * Address security concerns
```

**Step 2: Add Context**

```
Project Background:
"Customer Portal project, Phase 1 complete, includes case submission, 
knowledge base search, and profile management. Phase 2 will add 
community features and chatbot integration."

Key Points to Cover:
- Success metrics from Phase 1
- Phase 2 scope and timeline
- Security and compliance approach
- Cost and resource needs
```

**Step 3: Generate Materials**

```
Click: "Generate Meeting Materials"

Outputs:
✓ Meeting agenda with time allocations
✓ Demo script with talking points
✓ Anticipated questions and answers
✓ Decision items needing approval
✓ Follow-up action plan
```

#### Understanding the Output

**Meeting Agenda**
```
Customer Portal Phase 1 Review & Phase 2 Planning
Duration: 60 minutes

0:00-0:05 | Welcome & Objectives
  - Introductions
  - Meeting goals overview
  - Agenda review

0:05-0:25 | Phase 1 Demonstration (20 min)
  - Case submission workflow
  - Knowledge base search
  - Profile management
  - Q&A on functionality

0:25-0:35 | Success Metrics & ROI (10 min)
  - User adoption numbers
  - Time savings achieved
  - User satisfaction scores
  - Business impact

0:35-0:45 | Phase 2 Proposal (10 min)
  - Scope overview
  - Timeline and milestones
  - Resource requirements
  - Cost estimate

0:45-0:55 | Discussion & Questions (10 min)
  - Security concerns
  - Timeline questions
  - Integration questions
  - Open discussion

0:55-1:00 | Decisions & Next Steps (5 min)
  - Phase 2 approval (Go/No-Go)
  - Action item assignments
  - Next meeting scheduled
```

**Demo Script**
```
SECTION: Case Submission Workflow (7 minutes)

Setup:
- Browser open to customer portal login
- Test user credentials ready
- Sample case data prepared

Script:
"Let me show you how easy it is for customers to submit support cases. 
This was one of the top requirements from our user research."

[Action: Log in as customer]

"Once logged in, customers see a clean dashboard with their open cases. 
I'll show you the submission process."

[Action: Click 'New Case']

Key Points to Highlight:
✓ Form validation prevents incomplete submissions
✓ File attachment supports PDFs and images up to 25MB
✓ Auto-save prevents data loss
✓ Confirmation email provides case number

[Action: Fill out form with sample data]

"Notice how the priority field has helpful tooltips explaining what 
each priority level means."

[Action: Attach test file]

"Customers can attach supporting documents. The system automatically 
scans for viruses and validates file types."

[Action: Submit case]

"Upon submission, the customer immediately gets a case number and 
confirmation email. The case also appears in their dashboard."

Potential Questions to Address:
Q: Can customers attach multiple files?
A: Yes, up to 10 files per case, 25MB each, 250MB total per case.

Q: How long does case creation take?
A: Typically under 2 seconds. We've optimized for performance.
```

**Anticipated Q&A**
```
QUESTION: What about security? How do we ensure data privacy?

ANSWER:
"Excellent question. Security was a top priority. We've implemented 
several layers:

1. Authentication: Multi-factor authentication for all portal users

2. Authorization: Customers can only see their own cases and data. 
   Sharing rules enforce strict data isolation.

3. Encryption: All sensitive data is encrypted at rest using 
   Salesforce Shield. Data in transit uses TLS 1.2+.

4. Audit Trail: Every access and modification is logged for 
   compliance purposes.

5. Compliance: Solution meets SOC 2, GDPR, and CCPA requirements.

We can provide detailed security documentation if needed."

Supporting Data:
- Security assessment completed: June 1, 2026
- Penetration testing: Passed with no critical findings
- Compliance audit: Completed, report available
```

**Decision Items**
```
DECISION #1: Phase 2 Scope Approval

Decision Needed: Approve Phase 2 scope and budget

Options:
A) Approve full scope ($150K, 12 weeks)
B) Approve reduced scope ($100K, 8 weeks, defer chatbot)
C) Defer Phase 2 to Q4

Recommendation: Option A (Full Scope)

Rationale:
- User feedback strongly requests community features
- Chatbot expected to reduce support ticket volume by 30%
- Q3 timeline aligns with marketing campaign launch
- Cost is within approved budget

Impact of Delay:
- Miss Q3 campaign opportunity
- User dissatisfaction if community features delayed
- Competitive disadvantage (competitor launching similar features)

Decision Maker: VP of Customer Experience
Deadline: End of this meeting (needed to reserve team resources)
```

#### Actions After Meeting

**Send Follow-Up**
```
Include:
✓ Meeting recording link (if recorded)
✓ Action items with owners and due dates
✓ Decision log with rationale
✓ Next meeting date/time
✓ Any requested documentation
```

**Track Action Items**
```
Create tasks in project management tool
Assign owners
Set reminders for due dates
```

**Update RAID Log**
```
Add any new:
- Risks identified in discussion
- Issues raised by customer
- Dependencies on customer deliverables
- Assumptions made during meeting
```

---

### Prompt Library

**Purpose**: Save, organize, and reuse effective AI prompts

#### When to Use

- You've crafted a prompt that works well
- Want to share prompts with team members
- Need to maintain consistency across projects
- Building organizational knowledge base

#### How to Use

**Saving a Prompt**

```
After generating output you like:

1. Click: "Save to Prompt Library" button
2. Enter:
   - Prompt Name: "Customer Portal User Stories"
   - Prompt Text: [Your exact prompt]
   - Tags: "user-stories, customer-portal, financial"
   - Description: "Generates user stories for customer-facing portals"
   - Category: User Stories
3. Click: "Save"
```

**Finding a Prompt**

```
Option 1: Search
- Type keywords in search box
- Searches name, text, tags, description

Option 2: Filter by Tag
- Click tag filter dropdown
- Select one or more tags
- View matching prompts

Option 3: Browse by Category
- User Stories
- Testing
- Architecture
- RAID
- Meeting Prep
- Status Reports
- Custom
```

**Using a Saved Prompt**

```
1. Find the prompt using search or filters
2. Click: "Use This Prompt"
3. System loads prompt into the appropriate feature
4. Customize variables (marked with {curly_braces})
5. Generate output
```

**Organizing Prompts**

```
Tagging Strategy:

By Feature:
- user-stories
- testing
- architecture
- raid

By Industry:
- financial
- healthcare
- manufacturing
- retail

By Project:
- customer-portal
- field-service
- sales-cloud

By Role:
- business-analyst
- architect
- project-manager
- qa-engineer

Example:
Tags: "user-stories, healthcare, hipaa, business-analyst"
```

#### Best Practices

**Naming Conventions**
```
✓ Good Names:
- "Healthcare Patient Portal User Stories"
- "Financial Services Integration Architecture Review"
- "High-Volume Data Migration Test Cases"

❌ Bad Names:
- "Prompt 1"
- "Test"
- "User Stories"
```

**Writing Effective Descriptions**
```
Include:
- What does this prompt generate?
- When should you use it?
- What makes it special?
- Any prerequisites or requirements

Example:
"Generates comprehensive UAT test cases for Salesforce Experience 
Cloud portals. Use when building customer or partner portals. 
Includes security testing specific to guest user access and external 
user sharing. Requires: Persona type and portal functionality description."
```

---

### Export & Copy Features

**Purpose**: Share and distribute generated outputs in various formats

#### Copy Options

**Copy as Markdown**
```
Use When: Pasting into Confluence, Notion, GitHub, Slack
Format: Formatted text with headers, bullets, links
Preserves: Structure and formatting
Best For: Documentation, wikis, tickets

How To:
1. Click "Copy as Markdown"
2. Paste into destination (Ctrl+V / Cmd+V)
3. Formatting is automatically applied
```

**Copy as Plain Text**
```
Use When: Email, simple text editors, SMS
Format: Unformatted text, line breaks preserved
Removes: All formatting
Best For: Email body, quick notes

How To:
1. Click "Copy as Plain Text"
2. Paste anywhere
3. Manually format if needed
```

**Copy as JSON**
```
Use When: Technical integration, API consumption
Format: Structured JSON
Use For: Importing into tools, custom processing
Best For: Developers, automation

How To:
1. Click "Copy as JSON"
2. Paste into IDE, API tool, or code
3. Parse programmatically
```

#### Export Options

**Export as CSV**
```
Use When: Excel analysis, data manipulation
Contains: All data fields in spreadsheet format
Best For: Test cases, RAID logs, action items

Opens In:
- Microsoft Excel
- Google Sheets
- Numbers (Mac)
- Any spreadsheet application

Common Use Cases:
- Import test cases to TestRail
- Track action items in Excel
- Share with non-Salesforce users
- Create pivot tables for analysis
```

**Export as Word** (Future Feature)
```
Use When: Formal documentation, Word templates
Format: .docx with styles applied
Best For: Requirements docs, proposals, reports
```

**Export as PDF** (Future Feature)
```
Use When: Read-only distribution, printing
Format: PDF with preserved layout
Best For: Executive reports, customer-facing docs
```

#### Saving Outputs

**Save for Later Use**
```
Why Save:
- Refer back to previous outputs
- Track what you've generated
- Build knowledge repository
- Share with team members
- Rate and provide feedback

How to Save:
1. Click "Save Output"
2. Enter:
   - Title: "Q3 Customer Portal User Stories"
   - Tags: "q3, customer-portal, sprint-1"
   - Notes: "Reviewed by product owner, ready for sprint"
3. Click "Save"

Where Saved:
- Executive Dashboard > Saved Outputs
- AI_Delivery_Request__c custom object
- Searchable by title, tags, date
```

**Rating Outputs**
```
1-5 Star Rating:

⭐ 1 Star: Not useful, major issues
⭐⭐ 2 Stars: Somewhat useful, needs heavy editing
⭐⭐⭐ 3 Stars: Useful, minor edits needed
⭐⭐⭐⭐ 4 Stars: Very useful, minimal editing
⭐⭐⭐⭐⭐ 5 Stars: Excellent, used as-is

Your ratings help:
- Track quality over time
- Improve AI prompts
- Identify best practices
- Measure ROI
```

---

## Best Practices

### General Tips

**1. Start with Context**
```
✓ Provide background information
✓ Explain the business problem
✓ Mention industry or compliance requirements
✓ Describe user types and volume

❌ Don't just list requirements
❌ Don't assume the AI knows your project
```

**2. Be Specific**
```
✓ Use concrete examples
✓ Name specific Salesforce objects
✓ Mention integration systems
✓ Provide numbers (users, volume, timeline)

❌ Don't use vague terms
❌ Don't be overly generic
```

**3. Iterate and Refine**
```
First Generation:
- Review the output
- Identify what's good and what needs improvement

Second Generation:
- Adjust your prompt based on first output
- Add clarifying details
- Refine requirements

Third Generation:
- Usually close to final product
- Minor edits only
```

**4. Use the Right Feature**
```
User Stories → For requirements and backlog
UAT Tests → For test cases and QA documentation
Solution Design → For architecture review
RAID Log → For risk management
Meeting Prep → For stakeholder presentations
```

**5. Save and Reuse**
```
When you get good results:
✓ Save the output for reference
✓ Save the prompt to library
✓ Share with team members
✓ Document what worked

Build your team's knowledge base over time.
```

### Feature-Specific Tips

**User Stories**
```
✓ Use persona-based approach
✓ Include acceptance criteria in your mind
✓ Think about dependencies
✓ Consider edge cases
✓ Mention data model objects
```

**Test Cases**
```
✓ Include the full user story
✓ Mention specific fields and values
✓ Think about boundary conditions
✓ Consider integration points
✓ Include security requirements
```

**Solution Design**
```
✓ Describe all layers (UI, logic, data, integration)
✓ Mention scalability requirements
✓ Include security approach
✓ Specify technologies (LWC, Apex, etc.)
✓ Note any constraints
```

**RAID Logs**
```
✓ Provide project context
✓ Mention current phase
✓ Note known challenges
✓ Include timeline pressure
✓ Specify team size and experience
```

**Meeting Prep**
```
✓ Define meeting objectives
✓ List attendees and roles
✓ Specify decisions needed
✓ Include political context (if any)
✓ Note any sensitive topics
```

### Team Collaboration

**Sharing Prompts**
```
When you find a good prompt:
1. Save it to Prompt Library
2. Use descriptive tags
3. Add clear description
4. Share in team channel
5. Document when to use it
```

**Standardizing Output**
```
Team Guidelines:
- Agree on story point scale
- Define priority levels
- Establish acceptance criteria format
- Set testing standards
- Create risk matrix definitions
```

**Building Knowledge**
```
Regular Team Activities:
- Weekly prompt review session
- Share best outputs
- Discuss what worked/didn't work
- Build prompt templates together
- Create team standards
```

---

## Troubleshooting

### Common Issues

#### Issue: "Insufficient Privileges" Error

**Problem**: Can't access the application

**Solution**:
1. Check with your administrator
2. Ensure you have the **AI_Delivery_Copilot_User** permission set
3. Administrator steps:
   - Setup → Permission Sets
   - Select "AI_Delivery_Copilot_User"
   - Click "Manage Assignments"
   - Add your user
   - Save

---

#### Issue: Generation Takes Too Long

**Problem**: "Generating..." spinner doesn't complete

**Possible Causes**:
1. Network connectivity issue
2. Org performance issue
3. AI API timeout (if real mode)

**Solutions**:
1. Refresh the page
2. Try again in a few minutes
3. Check your internet connection
4. Contact administrator if persists

---

#### Issue: Output Quality is Poor

**Problem**: Generated content is too generic or incorrect

**Solutions**:
1. **Add More Context**
   - Provide more detailed requirements
   - Add industry-specific information
   - Mention constraints and requirements

2. **Use Better Prompts**
   - Browse Prompt Library for examples
   - Study prompts that generated good results
   - Iterate and refine your prompt

3. **Try Different Phrasing**
   - Rephrase your requirement
   - Break complex requirements into smaller pieces
   - Use more specific terminology

4. **Provide Examples**
   - Show an example of what you want
   - Reference similar existing work
   - Clarify format expectations

---

#### Issue: Can't Save Output

**Problem**: "Save Output" button doesn't work

**Solution**:
1. Check you have Create permission on AI_Delivery_Request__c
2. Ensure storage limits not exceeded
3. Try copying output to clipboard first
4. Contact administrator to check object permissions

---

#### Issue: Export Doesn't Work

**Problem**: CSV file doesn't download or is empty

**Solutions**:
1. Check browser popup blocker settings
2. Allow downloads from Salesforce domain
3. Try different browser (Chrome recommended)
4. Try "Copy" instead of "Export"
5. Clear browser cache and cookies

---

#### Issue: Can't Find Saved Outputs

**Problem**: Saved outputs don't appear in dashboard

**Solutions**:
1. Check filters (date range, tags)
2. Ensure you saved (not just copied)
3. Try searching by title
4. Check Executive Dashboard → Saved Outputs tab
5. Verify you're looking at correct date range

---

### Browser Compatibility

**Supported Browsers**:
- ✅ Chrome (latest 2 versions) - Recommended
- ✅ Firefox (latest 2 versions)
- ✅ Edge (Chromium-based, latest 2 versions)
- ✅ Safari (latest 2 versions)

**Not Supported**:
- ❌ Internet Explorer (any version)
- ❌ Mobile browsers (limited support)

---

### Performance Tips

**For Faster Performance**:
1. Use Chrome browser
2. Close unnecessary tabs
3. Clear browser cache weekly
4. Disable browser extensions temporarily
5. Use wired internet connection (not Wi-Fi) if possible

---

## FAQs

### General Questions

**Q: Is this real AI or just mock data?**

A: The system can work in both modes:
- **Mock Mode** (default): Uses pre-built response templates. Fast, reliable, great for testing.
- **Real Mode**: Integrates with AI providers (Anthropic Claude, OpenAI). Requires configuration by administrator.

Your administrator controls which mode is active.

---

**Q: How much does using AI cost?**

A: 
- **Mock Mode**: No additional cost
- **Real Mode**: AI API costs apply (typically $0.05-$0.10 per generation)

Costs are managed at the organizational level. Individual users don't pay directly.

---

**Q: Can I use this for client deliverables?**

A: Yes, but always review and edit the output:
- ✅ Use as a starting point
- ✅ Customize for your specific context
- ✅ Review for accuracy and completeness
- ✅ Add client-specific details
- ❌ Don't send AI output without review
- ❌ Don't include sensitive client data in prompts

---

**Q: Is my data secure?**

A: Yes:
- All data stored in Salesforce (enterprise security)
- Named Credentials for encrypted API keys
- Permission-based access control
- with sharing enforcement in Apex
- No AI training on your data (if using Anthropic/OpenAI commercial APIs)

---

**Q: Can I customize the prompts?**

A: Yes:
- Save custom prompts to Prompt Library
- Modify prompts before generating
- Your administrator can update PromptTemplateService class
- No coding required for basic customization

---

**Q: How do I share outputs with non-Salesforce users?**

A: Multiple options:
- **Copy as Markdown** → Paste into email
- **Export as CSV** → Send as attachment
- **Save Output** → Generate public link (future feature)
- **Copy as Plain Text** → Paste anywhere

---

**Q: What's the difference between Save and Export?**

A:
- **Save**: Stores in Salesforce, searchable, trackable, rate-able
- **Export**: Downloads file to your computer, for external use

Use Save for internal reference, Export for external sharing.

---

### Feature-Specific Questions

**Q: How many user stories will be generated?**

A: Typically 5-8 stories, depending on:
- Complexity of requirement
- Number of personas
- Scope of business process

---

**Q: Can I edit generated user stories?**

A: Yes:
1. Copy output (Markdown or Plain Text)
2. Paste into your editor (Word, Confluence, Jira)
3. Edit as needed
4. Save the final version

The app doesn't have in-app editing (yet).

---

**Q: How do I know if a solution design review is good?**

A: Look for:
- ✅ Specific recommendations (not generic)
- ✅ Clear risk assessments
- ✅ Actionable next steps
- ✅ Confidence score above 80%
- ✅ Technical depth (mentions Salesforce specifics)

Low confidence scores suggest vague input or complex scenarios.

---

**Q: Can I generate test cases in other languages?**

A: Currently English only. Multi-language support planned for future release.

---

### Technical Questions

**Q: How do I switch between Mock and Real AI mode?**

A: This is controlled by administrators:
```apex
// Admin sets mode in code or via Custom Metadata
AIService.setMode(AIService.AIMode.REAL);
```

Individual users cannot change this.

---

**Q: Which AI provider do you support?**

A: Architecture supports:
- Anthropic Claude (recommended)
- OpenAI GPT-4
- Azure OpenAI

Your administrator configures the provider.

---

**Q: Can I access this via API?**

A: Yes, all controller methods are @AuraEnabled:
```javascript
// Example JavaScript callout
import getAIInsights from '@salesforce/apex/AIDeliveryCopilotController.getAIInsights';

getAIInsights({ context: 'user_stories', userRequest: 'Build a portal' })
    .then(result => {
        console.log(result);
    });
```

Contact your developer for integration details.

---

## Getting Help

### In-App Help

**Help Icon**: Click the (?) icon in the top right of any feature for context-sensitive help.

### Documentation

- **User Guide** (this document): End-user instructions
- **Architecture Guide**: Technical architecture details
- **Demo Script**: Walkthrough demonstrations
- **Prompt Library**: Sample prompts and templates
- **AI Integration Guide**: AI provider setup

### Support Channels

**Internal Support**:
- **Slack**: `#ai-delivery-copilot`
- **Email**: architects@company.com
- **Wiki**: [Confluence Link]

**Training**:
- Weekly office hours: Thursdays 2-3pm
- On-demand training videos: [Link]
- Getting started guide: [Link]

### Reporting Issues

**If you encounter a bug**:

1. Gather information:
   - What were you trying to do?
   - What did you expect to happen?
   - What actually happened?
   - Screenshot (if applicable)
   - Browser and version

2. Check if it's a known issue:
   - Review FAQ above
   - Check Slack channel
   - Search wiki

3. Report the issue:
   - Post in #ai-delivery-copilot Slack channel
   - Or email architects@company.com
   - Include all gathered information

**If you have a feature request**:
- Post in #ai-delivery-copilot-ideas Slack channel
- Describe the desired functionality
- Explain the business value
- Vote on existing requests

---

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl/Cmd + Enter` | Generate (when in input field) |
| `Ctrl/Cmd + S` | Save output |
| `Ctrl/Cmd + C` | Copy (after selecting copy format) |
| `Ctrl/Cmd + E` | Export |
| `Esc` | Close modal or cancel |
| `Tab` | Navigate between fields |
| `/` | Focus search (in Prompt Library) |

---

## Tips for Success

1. **Start Simple** - Get comfortable with one feature before exploring others
2. **Practice** - The more you use it, the better your prompts become
3. **Share** - Share good prompts and outputs with teammates
4. **Iterate** - First output is rarely perfect, refine as needed
5. **Provide Feedback** - Rate outputs to help improve the system
6. **Stay Updated** - Check for new features and improvements
7. **Ask Questions** - Use support channels, we're here to help!

---

**User Guide Version**: 2.0  
**Last Updated**: 2026-06-18  
**Next Review**: 2026-07-18

---

**We're here to help!** Reach out anytime in #ai-delivery-copilot Slack channel.
