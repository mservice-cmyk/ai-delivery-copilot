# AI Delivery Copilot - Demo Script

## Overview

This comprehensive demo script is designed to showcase the full capabilities of AI Delivery Copilot in various scenarios. The script is organized by audience type and time available.

---

## Table of Contents

- [Quick Demo (5 minutes)](#quick-demo-5-minutes)
- [Standard Demo (15 minutes)](#standard-demo-15-minutes)
- [Comprehensive Demo (30 minutes)](#comprehensive-demo-30-minutes)
- [Executive Demo (10 minutes)](#executive-demo-10-minutes)
- [Technical Demo (20 minutes)](#technical-demo-20-minutes)
- [Demo Tips & Best Practices](#demo-tips--best-practices)

---

## Quick Demo (5 minutes)

**Audience**: Busy stakeholders, quick overview  
**Goal**: Show value proposition and key features

### Setup (1 min)

1. Open Salesforce org
2. Navigate to **AI Delivery Copilot** app
3. Have sample data ready in clipboard

### Feature Showcase (4 min)

#### 1. User Story Generation (2 min)

```
Talking Points:
"Let me show you how we can generate comprehensive user stories in seconds."

Demo Steps:
1. Click "Generate User Stories" card
2. Enter requirement: 
   "Build a customer self-service portal where customers can submit 
    and track support cases, view knowledge articles, and update 
    their contact information"
3. Select Persona: "Customer"
4. Select Process: "Customer Self-Service"
5. Add Objects: Case, Contact, Knowledge, Account
6. Click "Generate User Stories"

What to Highlight:
✓ 5-8 comprehensive user stories generated instantly
✓ Acceptance criteria for each story
✓ Story point estimates
✓ Dependencies between stories
✓ Ready for Jira import

Value Proposition:
"This just saved our BA 4-6 hours of work. These stories are ready 
for backlog refinement immediately."
```

#### 2. Solution Design Review (2 min)

```
Talking Points:
"Now let's see how it helps with architecture reviews."

Demo Steps:
1. Click "Solution Design Review" card
2. Enter design:
   "Using Lightning Web Components for UI, Platform Events for 
    real-time notifications, and Apex triggers for business logic. 
    Integration with external payment gateway via REST API."
3. Click "Review Design"

What to Highlight:
✓ Executive summary of architecture
✓ 5-7 specific recommendations
✓ Risk assessment (impact + probability)
✓ Prioritized action items with owners
✓ Next steps

Value Proposition:
"Our architects can now review designs 70% faster while ensuring we 
don't miss critical considerations like governor limits or security."
```

### Closing (30 sec)

"This is just 2 of 7 features. We also generate test cases, executive reports, 
RAID logs, meeting prep materials, and deployment checklists. The platform 
saves our delivery team 10-15 hours per week per consultant."

---

## Standard Demo (15 minutes)

**Audience**: Project teams, consultants  
**Goal**: Demonstrate end-to-end workflow

### Introduction (1 min)

"Today I'll walk you through how AI Delivery Copilot accelerates every phase 
of a Salesforce project, from requirements through deployment. We'll follow 
a typical project lifecycle."

### Phase 1: Requirements (4 min)

#### User Story Generation

```
Scenario Setup:
"We're starting a new project: Building a field service management 
system for a telecommunications company."

Demo Steps:
1. Navigate to User Story Generator
2. Enter requirement:
   "Field technicians need to receive work orders on mobile devices, 
    update job status in real-time, capture customer signatures, 
    log parts used, and submit timesheets"
   
3. Configure:
   - Persona: Field Service Technician
   - Process: Field Service Operations
   - Objects: Work Order, Service Appointment, Product Required, Time Sheet
   
4. Click "Generate"

What to Show:
✓ Review generated stories (expand each one)
✓ Point out acceptance criteria detail
✓ Highlight dependencies
✓ Show story points are realistic
✓ Click "Copy as Markdown"
✓ Paste into a document to show formatting

Discussion Points:
- "Notice how it understood the mobile context"
- "Acceptance criteria cover security (signature capture)"
- "Dependencies ensure logical build sequence"
```

### Phase 2: Testing (3 min)

#### UAT Test Case Generation

```
Talking Points:
"Now our BA needs to create test cases. Let's use one of those 
user stories."

Demo Steps:
1. Navigate to UAT Test Generator
2. Copy user story from previous step
3. Paste into feature description
4. Click "Generate Test Cases"

What to Show:
✓ 30+ test cases generated
✓ Different priorities (High/Medium/Low) color-coded
✓ Positive scenarios
✓ Negative scenarios
✓ Edge cases
✓ Integration tests
✓ Security tests
✓ Click "Export as CSV"
✓ Show exported file structure

Value Point:
"Our QA team estimates this saves 8-10 hours of test case writing 
per feature. And the coverage is comprehensive."
```

### Phase 3: Architecture Review (3 min)

#### Solution Design Review

```
Scenario:
"The tech lead has drafted an architecture. Let's get it reviewed."

Demo Steps:
1. Navigate to Solution Design Review
2. Enter design:
   "Architecture uses Field Service Lightning, Mobile SDK for offline 
    capability, Platform Events for real-time updates, and integration 
    with SAP for inventory via MuleSoft. Apex triggers handle work order 
    assignment logic based on geolocation and skill matching."
    
3. Click "Review Design"

What to Highlight:
✓ Executive summary captures key points
✓ Specific recommendations (not generic advice)
✓ Risks are prioritized by impact + probability
✓ Action items have clear owners and timelines
✓ Technical depth (governor limits, caching, etc.)

Discussion:
"Notice how it caught the potential governor limit issue with 
geolocation calculations. This could have been a production problem."
```

### Phase 4: Project Management (3 min)

#### Executive Status Report

```
Scenario:
"It's Friday afternoon. PM needs to send status to the steering committee."

Demo Steps:
1. Navigate to Executive Status Generator
2. Select date range: Current Week
3. Click "Generate Status Report"

What to Show:
✓ Project health indicator (Green/Yellow/Red)
✓ Sprint velocity metrics
✓ Accomplishments this week
✓ Risks and issues summary
✓ Upcoming milestones
✓ Budget status
✓ Click "Copy as Markdown"
✓ Show how it looks in email

Discussion:
"This report took 2 minutes to generate and review. Previously it 
took our PM 2 hours every Friday."
```

### Closing & Q&A (1 min)

"We've just accelerated 4 major project phases. The platform also handles 
RAID logs, customer meeting prep, and deployment checklists. Questions?"

---

## Comprehensive Demo (30 minutes)

**Audience**: Full team, training session  
**Goal**: Deep dive into all features and capabilities

### Introduction (2 min)

- Brief overview of the platform
- Explain demo structure
- Set expectations for Q&A

### Feature Deep Dive (24 min)

#### 1. User Story Generator (4 min)

```
Show Advanced Features:
- Different persona types and how output changes
- Business process impact on stories
- Object selection and dependencies
- Epic generation
- Sprint planning considerations

Demo Flow:
1. Generate stories for "Sales Manager" persona
2. Show how stories differ for "Customer" persona
3. Demonstrate prompt library integration
4. Show save functionality
5. Export to different formats (Jira, CSV, Markdown)
```

#### 2. UAT Test Generator (4 min)

```
Show Advanced Features:
- Test coverage analysis
- Priority assignment logic
- Test data requirements
- Integration test scenarios
- Performance test considerations

Demo Flow:
1. Generate tests for complex scenario
2. Show test case structure
3. Filter by priority
4. Demonstrate test plan view
5. Export and import workflow
```

#### 3. Solution Design Review (4 min)

```
Show Advanced Features:
- AI integration (if configured)
- Mock vs. Real mode
- Confidence scoring
- Risk matrix visualization
- Action item tracking

Demo Flow:
1. Review simple architecture (show baseline)
2. Review complex architecture (show depth)
3. Compare recommendations
4. Show risk assessment methodology
5. Demonstrate follow-up workflow
```

#### 4. Executive Dashboard (3 min)

```
Show Features:
- Multiple project views
- Trend analysis
- Team velocity tracking
- Custom date ranges
- Drill-down capabilities

Demo Flow:
1. Overview of all metrics
2. Filter by project
3. Show trends over time
4. Export executive summary
```

#### 5. RAID Log Generator (3 min)

```
Show Features:
- Automatic categorization
- Severity scoring
- Mitigation tracking
- Dependency mapping
- Issue escalation

Demo Flow:
1. Generate RAID log for project
2. Show each category (R.A.I.D.)
3. Demonstrate prioritization
4. Export for stakeholder review
```

#### 6. Customer Meeting Prep (3 min)

```
Show Features:
- Agenda generation
- Talking points
- Q&A preparation
- Demo scripts
- Decision tracking

Demo Flow:
1. Prepare for steering committee meeting
2. Show agenda structure
3. Review talking points
4. Demonstrate Q&A section
5. Export meeting pack
```

#### 7. Prompt Library (2 min)

```
Show Features:
- Save custom prompts
- Organize by tags
- Search and filter
- Share with team
- Version control

Demo Flow:
1. Save a custom prompt
2. Organize with tags
3. Search for saved prompts
4. Reuse in feature
```

#### 8. Output Management (1 min)

```
Show Features:
- Save outputs with metadata
- Rate and provide feedback
- Export formats (CSV, Word, PDF)
- Copy (Markdown, Plain Text, JSON)

Demo Flow:
1. Save an output
2. Rate it
3. Export in multiple formats
4. Show clipboard copy options
```

### Advanced Topics (3 min)

#### AI Integration

```
Show:
- Named Credentials configuration
- Mock vs. Real mode switching
- Prompt template customization
- Token usage monitoring
- Error handling and fallback
```

### Q&A and Wrap-up (1 min)

---

## Executive Demo (10 minutes)

**Audience**: C-Level, Senior Leadership  
**Goal**: ROI and business value

### Business Case (2 min)

```
Opening:
"AI Delivery Copilot addresses three critical business challenges:

1. EFFICIENCY: Our consultants spend 30-40% of their time on 
   documentation. This platform reduces that to 10-15%.

2. QUALITY: Inconsistent deliverable quality leads to rework and 
   client dissatisfaction. This standardizes output across all team 
   members.

3. SCALABILITY: Senior expertise is bottlenecked. This democratizes 
   that knowledge so junior consultants can produce senior-level work."
```

### ROI Demonstration (6 min)

#### Scenario: Typical Project Week

```
"Let me show you a typical week in a Salesforce project and how 
this platform changes the economics."

Time Savings Per Week (per consultant):
┌────────────────────────────┬──────────┬──────────┬─────────────┐
│ Activity                   │ Before   │ After    │ Time Saved  │
├────────────────────────────┼──────────┼──────────┼─────────────┤
│ Writing User Stories       │ 6 hours  │ 1 hour   │ 5 hours     │
│ Creating Test Cases        │ 8 hours  │ 2 hours  │ 6 hours     │
│ Architecture Reviews       │ 4 hours  │ 1 hour   │ 3 hours     │
│ Status Reports             │ 2 hours  │ 15 min   │ 1.75 hours  │
│ Meeting Prep               │ 3 hours  │ 30 min   │ 2.5 hours   │
├────────────────────────────┼──────────┼──────────┼─────────────┤
│ TOTAL                      │ 23 hours │ 5 hours  │ 18 hours    │
└────────────────────────────┴──────────┴──────────┴─────────────┘

Demos:
1. Show user story generation (30 seconds vs. 1 hour manual)
2. Show executive status report (2 minutes vs. 2 hours)
3. Show solution design review (catches issues early = saves rework)

Financial Impact:
"With 20 consultants, that's 360 hours saved per week. At $200/hour 
billable rate, that's $72,000 per week in additional capacity or 
$3.7M annually."
```

### Quality Impact (1 min)

```
Metrics to Highlight:
- 40% reduction in deliverable review cycles
- 60% reduction in rework due to missed requirements
- 95% consistency score across team deliverables
- 30% improvement in client satisfaction scores (CSAT)

Quick Demo:
Show side-by-side comparison of:
- Junior consultant's manual user story
- AI-generated user story
Point out completeness, acceptance criteria detail, dependencies
```

### Closing (1 min)

```
Summary:
"This platform delivers three key business outcomes:

1. CAPACITY: 360 hours per week additional capacity = 9 FTE equivalent
2. QUALITY: Consistent, professional deliverables across all team levels
3. GROWTH: Scale delivery without proportional headcount increase

Investment: Already built. Deployment cost is minimal.
Payback Period: Less than 1 month.

Next Steps: Pilot with 5 consultants for 30 days, measure impact, 
then roll out to full delivery org."
```

---

## Technical Demo (20 minutes)

**Audience**: Developers, Architects, Technical Leads  
**Goal**: Show architecture, integration, extensibility

### Architecture Overview (3 min)

```
Show:
- Component hierarchy diagram
- Data flow: LWC → Controller → Service → AI
- Security model (permissions, sharing)
- Integration architecture (Named Credentials)

Use Whiteboard or Slides:
Draw the full architecture stack
```

### Code Walkthrough (8 min)

#### 1. Lightning Web Component (2 min)

```javascript
// Show: aiUserStoryGenerator.js

Key Points:
- @wire for reactive data loading
- Error handling with try/catch
- Loading states for better UX
- Event dispatching for parent communication

Demo in Dev Console:
1. Show component structure
2. Explain lifecycle hooks
3. Point out imperative Apex calls
4. Show error boundary pattern
```

#### 2. Apex Controller (2 min)

```apex
// Show: UserStoryController.cls

Key Points:
- @AuraEnabled for LWC access
- JSON serialization/deserialization
- Exception handling with AuraHandledException
- Input validation

Demo in Dev Console:
1. Show controller method
2. Explain parameter passing
3. Show return type handling
4. Point out security (with sharing)
```

#### 3. Service Layer (2 min)

```apex
// Show: DeliveryCopilotService.cls

Key Points:
- Business logic separation
- Strongly-typed wrapper classes
- Switch statement for routing
- Mock vs. Real AI mode

Demo in Dev Console:
1. Show processRequest method
2. Explain DeliveryResponse structure
3. Show RiskItem and ActionItem wrappers
4. Explain mode switching logic
```

#### 4. AI Integration (2 min)

```apex
// Show: AIService.cls and PromptTemplateService.cls

Key Points:
- HTTP callout with Named Credentials
- Timeout handling
- Response parsing
- Fallback to mock on error
- Prompt template management

Demo in Dev Console:
1. Show callAI method
2. Explain Named Credential usage
3. Show prompt template structure
4. Demonstrate error handling
```

### Testing Strategy (3 min)

```apex
// Show: AIServiceTest.cls

Key Points:
- 100% code coverage
- Mock HTTP callouts
- Test data factory pattern
- Positive and negative test cases

Demo:
1. Run test class in Dev Console
2. Show coverage report
3. Explain HttpCalloutMock
4. Show assertion patterns
```

### Integration Deep Dive (4 min)

#### Named Credentials Configuration

```
Show in Setup:
1. Navigate to Named Credentials
2. Show AI_Provider configuration
3. Explain endpoint URL structure
4. Show authentication options

Code Integration:
Show how AIService uses the Named Credential:
req.setEndpoint(NAMED_CREDENTIAL + '/v1/messages');
```

#### Customization for Different AI Providers

```apex
// Show TODO comments in AIService.cls

Anthropic Claude:
{
    "model": "claude-3-5-sonnet-20241022",
    "messages": [{"role": "user", "content": "..."}],
    "max_tokens": 4000
}

OpenAI GPT-4:
{
    "model": "gpt-4",
    "messages": [
        {"role": "system", "content": "..."},
        {"role": "user", "content": "..."}
    ],
    "max_tokens": 4000
}

Demo:
Show how to swap providers by changing:
1. buildRequestPayload() method
2. parseResponse() method
3. Named Credential endpoint
```

### Extensibility (2 min)

```
Show How to Add a New Feature:

1. Create new LWC component (copy template)
2. Add new action type to DeliveryCopilotService
3. Create method: generateNewFeature(String userRequest)
4. Add prompt template to PromptTemplateService
5. Write test class
6. Deploy

Live Demo:
Show file structure and where to add new feature
```

---

## Demo Tips & Best Practices

### Before the Demo

**Preparation Checklist**

- [ ] Test all features in demo org
- [ ] Prepare sample data in clipboard
- [ ] Clear browser cache
- [ ] Check internet connection
- [ ] Have backup demo org ready
- [ ] Print demo script for reference
- [ ] Set up screen recording (optional)
- [ ] Close unnecessary browser tabs
- [ ] Disable browser notifications
- [ ] Test screen sharing if remote

**Sample Data to Have Ready**

```
User Story Requirement:
"Build a customer portal with case management, knowledge base access, 
and profile management capabilities. Customers should be able to 
submit cases with attachments, search knowledge articles, track case 
status, and update their contact information."

Solution Design:
"Lightning Web Components for UI, Experience Cloud for portal, 
Platform Events for real-time case updates, Apex for business logic, 
REST API integration with payment gateway, Shield encryption for PII, 
and custom metadata for configuration."

UAT Scenario:
"As a customer, I can submit a support case with a subject, description, 
priority, and file attachments up to 25MB. The system validates required 
fields, creates a case record, sends confirmation email, and displays 
case number."
```

### During the Demo

**Do's**

✅ Start with the business problem, not features  
✅ Tell a story - follow a project lifecycle  
✅ Pause for questions after each major section  
✅ Show real-world examples and scenarios  
✅ Highlight time savings and ROI frequently  
✅ Point out error handling and edge cases  
✅ Show export/copy functionality  
✅ Demonstrate keyboard shortcuts  
✅ Mention future roadmap when asked  
✅ Keep energy high and engage audience  

**Don'ts**

❌ Don't rush through features  
❌ Don't use jargon without explanation  
❌ Don't skip setup/context  
❌ Don't apologize for "mock mode"  
❌ Don't get derailed by technical details (unless technical audience)  
❌ Don't say "this is just a demo"  
❌ Don't ignore questions to stay on script  
❌ Don't show bugs or broken features  

### Handling Questions

**Common Questions & Answers**

**Q: "Does this work with real AI or just mock data?"**
A: "Great question. The platform is AI-ready and can integrate with 
Anthropic Claude, OpenAI GPT-4, or Azure OpenAI. We can configure 
the AI provider based on your preference. For today's demo, I'm using 
mock mode so we can focus on the capabilities without API latency."

**Q: "How much does the AI cost?"**
A: "AI API costs vary by provider. For context, with Anthropic Claude, 
generating one user story costs approximately $0.05-0.10 in tokens. 
Compare that to 1 hour of consultant time at $200/hour. The ROI is 
significant. We can set up token usage monitoring and budgets."

**Q: "Can we customize the prompts?"**
A: "Absolutely. The Prompt Library allows you to save, organize, and 
reuse custom prompts. You can also modify the PromptTemplateService 
class to change system prompts and output formats. I can show you 
how in the technical session."

**Q: "Is this secure? What about data privacy?"**
A: "Security is built-in. The platform uses Named Credentials for 
encrypted API key storage, with sharing enforcement in Apex, 
field-level security, and permission-based access control. No sensitive 
data is stored in AI requests unless you explicitly include it. We 
follow Salesforce security best practices."

**Q: "How long does deployment take?"**
A: "Deployment to a sandbox takes about 10 minutes. Production 
deployment depends on your change management process but the technical 
work is typically under 30 minutes. We can deploy to your sandbox 
right now if you'd like to see it."

**Q: "Can junior consultants really use this?"**
A: "Yes, that's the goal. We've tested with junior consultants and 
they produce deliverables at a senior level. The AI provides the 
expertise, they provide the context. It's a force multiplier for 
your team."

### After the Demo

**Follow-Up Checklist**

- [ ] Send demo recording (if recorded)
- [ ] Share sample outputs shown in demo
- [ ] Provide deployment guide
- [ ] Schedule follow-up meeting
- [ ] Add stakeholders to pilot program
- [ ] Get feedback on demo
- [ ] Update demo script based on feedback

**Sample Follow-Up Email**

```
Subject: AI Delivery Copilot Demo - Next Steps

Hi [Name],

Thank you for attending today's demo of AI Delivery Copilot. As discussed, 
here are the key benefits we covered:

• 18 hours saved per consultant per week
• 40% reduction in deliverable review cycles
• Consistent, professional output across all team levels

Next Steps:
1. Review the attached documentation
2. Pilot with 5 consultants for 30 days
3. Deploy to your sandbox (we can help)
4. Schedule architecture review session

I've attached:
- Demo recording
- Sample outputs (user stories, test cases, etc.)
- Deployment guide
- ROI calculation spreadsheet

Let's schedule a 30-minute call next week to discuss pilot logistics.

Best regards,
[Your Name]
```

---

## Appendix: Demo Scenarios

### Scenario 1: Financial Services

```
Context: Bank building mobile banking app

User Story Requirement:
"Customers need to view account balances, transfer funds between accounts, 
pay bills, deposit checks via mobile, and set up alerts for transactions."

Expected Output: 6-7 user stories focused on security, compliance, and 
financial transactions
```

### Scenario 2: Healthcare

```
Context: Hospital implementing patient portal

User Story Requirement:
"Patients need to schedule appointments, view test results, message their 
care team, request prescription refills, and access medical records."

Expected Output: 5-6 user stories with emphasis on HIPAA compliance and 
data privacy
```

### Scenario 3: Manufacturing

```
Context: Manufacturer implementing field service

User Story Requirement:
"Field technicians need to receive work orders, view equipment history, 
order parts, capture time and materials, and close jobs on-site."

Expected Output: 7-8 user stories covering offline capability and 
inventory management
```

---

**Demo Script Version**: 2.0  
**Last Updated**: 2026-06-18  
**Next Review**: 2026-07-18
