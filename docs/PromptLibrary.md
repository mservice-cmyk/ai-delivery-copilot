# Prompt Library

## Overview

This document contains a comprehensive library of AI prompts for AI Delivery Copilot. Use these prompts as templates and customize them for your specific needs.

---

## Table of Contents

- [User Story Prompts](#user-story-prompts)
- [Test Case Prompts](#test-case-prompts)
- [Solution Design Prompts](#solution-design-prompts)
- [Executive Status Prompts](#executive-status-prompts)
- [RAID Log Prompts](#raid-log-prompts)
- [Meeting Prep Prompts](#meeting-prep-prompts)
- [Deployment Checklist Prompts](#deployment-checklist-prompts)
- [Custom Prompt Template](#custom-prompt-template)

---

## User Story Prompts

### System Context

```
You are an experienced Business Analyst specializing in Salesforce projects. 
You excel at writing clear, actionable user stories with comprehensive 
acceptance criteria. You follow agile best practices and understand Salesforce 
data models, platform capabilities, and limitations.
```

### Template 1: Standard User Story Generation

```
Generate 5-8 comprehensive user stories for the following requirement:

Requirement: {business_requirement}
Persona: {user_persona}
Business Process: {business_process}
Salesforce Objects: {object_list}

For each user story, provide:

1. Story Title (clear, concise)
2. Story Description: "As a {persona}, I want {feature} so that {benefit}"
3. Acceptance Criteria (3-5 specific, testable criteria)
4. Story Points (Fibonacci scale: 1, 2, 3, 5, 8, 13)
5. Priority (Critical, High, Medium, Low)
6. Dependencies (list any dependent stories)
7. Edge Cases (2-3 scenarios to consider)
8. Technical Notes (Salesforce-specific considerations)
9. Definition of Done (what "complete" means)

Also provide:
- Epic Title and Description
- Sprint Planning Recommendations
- Total Story Points Estimate
- Target Release Timeline

Format the output as structured JSON.
```

**Example Usage:**

```
Requirement: Build a customer self-service portal
Persona: Customer
Business Process: Case Management
Objects: Case, Contact, Account, Knowledge Article
```

### Template 2: Persona-Specific Stories

```
Generate user stories specifically for a {persona_type} persona.

Context:
- Industry: {industry}
- Company Size: {company_size}
- Technical Proficiency: {technical_level}
- Primary Goals: {goals}

Focus on:
- User experience and ease of use
- Mobile vs. desktop considerations
- Accessibility requirements
- Permission and security needs

Generate 5 user stories that address this persona's daily workflow.
```

### Template 3: Data Migration Stories

```
Generate user stories for data migration from {source_system} to Salesforce.

Migration Details:
- Objects to migrate: {object_list}
- Record volume: {volume}
- Data quality issues: {known_issues}
- Cutover approach: {big_bang_or_phased}

Include stories for:
1. Data mapping and transformation
2. Data cleansing requirements
3. Migration validation
4. Rollback procedures
5. Post-migration verification
```

---

## Test Case Prompts

### System Context

```
You are a QA Engineer with expertise in Salesforce testing. You create 
comprehensive test cases covering positive, negative, boundary, integration, 
and security scenarios. You understand Salesforce governor limits, security 
model, and platform behavior.
```

### Template 1: Functional Test Cases

```
Generate comprehensive test cases for the following feature:

Feature: {feature_description}
User Story: {user_story_text}

Create test cases for:

1. Positive Scenarios (happy path)
   - Standard user flow
   - Expected outcomes
   - Success validations

2. Negative Scenarios (error handling)
   - Invalid inputs
   - Missing required fields
   - Permission errors
   - System errors

3. Boundary Conditions
   - Minimum values
   - Maximum values
   - Empty/null values
   - Special characters

4. Integration Scenarios
   - Cross-object dependencies
   - External system integration
   - API testing
   - Real-time updates

5. Security Test Cases
   - Permission-based access
   - Field-level security
   - Record-level security
   - Cross-user data access

For each test case provide:
- Test ID
- Test Scenario (what we're testing)
- Prerequisites (setup required)
- Test Steps (numbered, detailed)
- Test Data (specific values to use)
- Expected Result (specific, measurable)
- Priority (High/Medium/Low)
- Test Type (Functional/Integration/Security/Performance)

Format as structured JSON with test case array.
```

### Template 2: Regression Test Suite

```
Generate a regression test suite for {release_name}.

Changes in this release:
{list_of_changes}

Generate regression tests covering:
1. Unchanged functionality (ensure no breakage)
2. Integration points affected by changes
3. Related workflows that might be impacted
4. Performance baseline tests
5. Security regression tests

Organize tests by:
- Priority (P0: Critical, P1: High, P2: Medium)
- Test type
- Estimated execution time
- Automation candidate (Yes/No)
```

### Template 3: UAT Test Scenarios

```
Generate User Acceptance Test scenarios for stakeholder validation.

Feature: {feature_name}
Business Value: {business_value}
Stakeholders: {stakeholder_roles}

Create UAT scenarios that:
1. Validate business requirements are met
2. Test real-world workflows
3. Verify user experience quality
4. Confirm integration with existing processes

For each scenario:
- Business scenario description
- Actor (who performs the test)
- Steps in business language (no technical jargon)
- Expected business outcome
- Success criteria
- Rollback if failed

Target 15-20 UAT scenarios.
```

---

## Solution Design Prompts

### System Context

```
You are an expert Salesforce Technical Architect with 15+ years of experience. 
You review solution designs and provide actionable recommendations focused on 
scalability, security, best practices, and governor limits. You provide specific, 
concrete recommendations with clear rationale.
```

### Template 1: Comprehensive Architecture Review

```
Review the following Salesforce solution design and provide a comprehensive 
analysis:

Architecture Description:
{architecture_details}

Please analyze and provide:

1. Executive Summary (2-3 sentences)
   - Overall assessment
   - Key strengths
   - Critical concerns

2. Architecture Recommendations (5-7 specific items)
   - Specific component or pattern
   - Why it needs attention
   - Recommended approach
   - Expected benefit

3. Risk Assessment (4-5 risks)
   For each risk:
   - Description (what could go wrong)
   - Impact (High/Medium/Low)
   - Probability (High/Medium/Low)
   - Mitigation strategy

4. Action Items (5-7 prioritized tasks)
   For each item:
   - Task description
   - Priority (High/Medium/Low)
   - Owner role (who should do it)
   - Estimated duration

5. Next Steps (4-5 immediate actions)
   - Ordered by priority
   - Concrete, actionable

Focus your analysis on:
- Salesforce governor limits and bulkification
- Security and sharing model
- Integration patterns and error handling
- Performance and scalability at volume
- Best practices and maintainability
- Data model optimization
- User experience considerations

Format as structured JSON.
Assign a confidence score (0-100) to your assessment.
```

### Template 2: Integration Architecture Review

```
Review this integration architecture:

Integration Details:
- Source System: {source_system}
- Target System: Salesforce
- Integration Pattern: {rest_api_or_soap_or_bulk_or_streaming}
- Data Volume: {volume_per_day}
- Frequency: {real_time_or_batch}
- Authentication: {auth_method}

Evaluate:
1. Integration pattern suitability for volume and frequency
2. Error handling and retry logic
3. Data transformation complexity
4. Security considerations (encryption, authentication)
5. Governor limit implications
6. Monitoring and logging approach
7. Disaster recovery and rollback

Provide recommendations for optimization.
```

### Template 3: Data Model Review

```
Review this Salesforce data model:

Objects: {object_list}
Relationships: {relationship_description}
Expected Record Volumes: {volumes}

Analyze:
1. Object relationship design (Master-Detail vs. Lookup)
2. Sharing model implications
3. Query performance at scale
4. Roll-up summary field usage
5. Formula field complexity
6. Record access patterns
7. Data skew risks

Recommendations for:
- Performance optimization
- Scalability at 10x volume
- Sharing model simplification
- Index strategy
```

---

## Executive Status Prompts

### System Context

```
You are a Program Manager skilled at creating executive-level status reports. 
Your reports are concise, highlight key metrics, and focus on decision-making 
information. You understand what executives care about: business impact, risks, 
budget, and timeline.
```

### Template 1: Weekly Status Report

```
Create an executive status report for the week of {date_range}.

Project Context:
- Project Name: {project_name}
- Phase: {current_phase}
- Team Size: {team_size}
- Budget: {budget_status}

Include:

1. Executive Summary (2-3 sentences)
   - Overall project health (Green/Yellow/Red)
   - Week's key outcome
   - Critical decision needed (if any)

2. Progress This Week
   - Milestones achieved
   - Sprint velocity (story points)
   - Deliverables completed
   - Percentage complete overall

3. Upcoming Week Plan
   - Key activities
   - Expected milestones
   - Resource needs

4. Risks & Issues
   - Top 3 risks with mitigation
   - Active blockers
   - Escalations needed

5. Budget Status
   - Spent to date
   - Forecast to complete
   - Variance explanation

6. Decisions Needed
   - Decision description
   - Options
   - Recommendation
   - Deadline

7. Team Health
   - Velocity trend
   - Resource utilization
   - Training needs

Format as structured JSON suitable for dashboard display.
```

### Template 2: Steering Committee Report

```
Create a steering committee presentation for {project_name}.

Focus on:
1. Business value delivered (metrics, ROI)
2. Major accomplishments since last meeting
3. Critical path items
4. Budget and timeline status
5. Strategic risks requiring executive attention
6. Go/No-Go recommendation for next phase

Use executive language (business impact, not technical details).
Include recommendation and rationale for any decisions needed.
```

---

## RAID Log Prompts

### System Context

```
You are a Risk Manager with Salesforce project expertise. You identify and 
categorize Risks, Assumptions, Issues, and Dependencies with precision. You 
provide actionable mitigation strategies and realistic severity assessments.
```

### Template 1: Comprehensive RAID Log

```
Generate a RAID log for {project_name} in {current_phase} phase.

Project Context:
{project_context}

Identify:

**RISKS** (potential future problems)
For each risk:
- Description (what might happen)
- Category (Technical/Resource/Timeline/Budget/External)
- Likelihood (High/Medium/Low)
- Impact (High/Medium/Low)
- Risk Score (Likelihood × Impact)
- Mitigation Strategy (preventive actions)
- Contingency Plan (if it happens)
- Owner (who monitors it)

**ASSUMPTIONS** (things we believe to be true)
For each assumption:
- Description
- Validation Status (Validated/Pending/Invalid)
- Impact if wrong
- Validation approach
- Owner

**ISSUES** (current problems)
For each issue:
- Description
- Category (Blocker/Critical/Major/Minor)
- Impact on timeline
- Resolution status
- Action plan
- Owner
- Due date

**DEPENDENCIES** (things we rely on)
For each dependency:
- Description
- Type (Internal/External)
- Status (On Track/At Risk/Delayed)
- Impact if delayed
- Mitigation plan
- Owner

Provide:
- Overall project health assessment
- Top 3 items requiring immediate attention
- Recommended escalations

Format as structured JSON with RAID categories.
```

### Template 2: Risk-Focused Assessment

```
Perform a risk assessment for {specific_area}.

Focus on:
1. Technical risks (architecture, integration, performance)
2. Resource risks (availability, skillset, knowledge gaps)
3. Schedule risks (dependencies, unknowns, complexity)
4. External risks (vendor, third-party, customer)

For each risk:
- Detailed description
- Probability score (1-10)
- Impact score (1-10)
- Risk ranking (P × I)
- Early warning indicators
- Mitigation strategy with timeline
- Residual risk after mitigation

Prioritize risks and recommend focus areas.
```

---

## Meeting Prep Prompts

### System Context

```
You are a Client Engagement Manager preparing for a customer meeting. You 
create thorough meeting materials including agenda, talking points, and Q&A 
prep. You anticipate questions and prepare compelling answers.
```

### Template 1: Customer Demo Meeting

```
Prepare meeting materials for a customer demo of {feature_or_release}.

Meeting Details:
- Attendees: {attendee_list}
- Duration: {duration}
- Objectives: {objectives}

Create:

1. **Meeting Agenda** (with time allocations)
   - Intro / Context setting (5 min)
   - Demo sections with timing
   - Q&A periods
   - Next steps / Closeout

2. **Demo Script**
   - For each demo section:
     - Feature overview
     - Business value (why it matters)
     - Demo steps (detailed)
     - Key points to highlight
     - Potential questions to address proactively

3. **Talking Points**
   - Key messages (what they should remember)
   - Success metrics to highlight
   - ROI discussion points
   - Differentiation (why this approach)

4. **Anticipated Questions & Answers**
   - Technical questions
   - Timeline questions
   - Cost/budget questions
   - Risk/concern questions
   For each: question, recommended answer, supporting data

5. **Success Metrics to Share**
   - Performance improvements
   - User adoption numbers
   - Business impact metrics

6. **Decisions Needed**
   - Decision description
   - Options presented
   - Recommendation with rationale
   - Impact of delay

7. **Follow-Up Actions**
   - Action items list
   - Owner assignments
   - Due dates
   - Success criteria

Format as structured JSON.
```

### Template 2: Steering Committee Meeting

```
Prepare for steering committee meeting for {project_name}.

Focus on:
1. Project status (Green/Yellow/Red with explanation)
2. Major accomplishments since last meeting
3. Value delivered (business metrics)
4. Critical path updates
5. Budget and timeline variance
6. Risks requiring executive attention
7. Decisions needed with recommendations

Prepare talking points that:
- Lead with business impact
- Use metrics and data
- Be transparent about challenges
- Provide clear recommendations
- Anticipate tough questions

Include pre-read materials summary.
```

---

## Deployment Checklist Prompts

### System Context

```
You are a Release Manager for Salesforce deployments. You create comprehensive 
deployment checklists following DevOps best practices. You anticipate risks 
and plan for contingencies.
```

### Template 1: Production Deployment Checklist

```
Create a deployment checklist for deploying {release_name} to production.

Deployment Details:
- Components: {component_list}
- Deployment Method: {change_set_or_metadata_or_dx}
- Estimated Duration: {duration}
- Maintenance Window: {window}

Generate checklist for:

**Pre-Deployment** (Day before)
- Code freeze enforcement
- Backup procedures
- Rollback package preparation
- Test environment validation
- Dependency verification
- Team communication
- Change approval confirmation

**Deployment Day** (Morning of)
- Team readiness check
- Environment verification
- Maintenance window communication
- Pre-deployment snapshot
- Final go/no-go decision

**Deployment Execution** (During maintenance window)
- Ordered deployment steps
- Validation checkpoints
- Monitoring points
- Decision points (continue/rollback)

**Post-Deployment Validation** (Immediately after)
- Smoke tests (critical paths)
- Integration tests
- Performance baseline check
- Error log review
- User acceptance spot check

**Rollback Procedures** (If needed)
- Trigger criteria
- Rollback steps
- Communication plan
- Data integrity verification

**Post-Deployment** (Next day)
- User feedback collection
- Performance monitoring
- Issue log review
- Retrospective scheduling
- Success metrics capture

For each checklist item:
- Task description
- Owner/Role
- Estimated time
- Success criteria
- Rollback point (Yes/No)

Provide:
- Total estimated time
- Critical path items
- Communication templates
- War room procedures

Format as structured JSON.
```

### Template 2: Emergency Hotfix Checklist

```
Create abbreviated checklist for emergency hotfix deployment.

Hotfix Details:
- Issue: {issue_description}
- Severity: {critical_or_high}
- Components Affected: {components}

Fast-track checklist focusing on:
1. Minimal testing requirements
2. Fast rollback ability
3. Communication (brief stakeholders)
4. Validation (critical paths only)
5. Monitoring (what to watch)

Balance speed with safety.
```

---

## Custom Prompt Template

### How to Create Effective Prompts

**Structure:**

1. **System Context** - Who is the AI? What expertise does it have?
2. **Task Description** - What should the AI do?
3. **Input Format** - What information will be provided?
4. **Output Requirements** - What should the output include?
5. **Constraints** - Any limitations or requirements?
6. **Examples** - Sample input/output (if helpful)
7. **Format** - How should the output be structured?

**Example Custom Prompt:**

```
[SYSTEM CONTEXT]
You are a {role} with expertise in {domain}. You excel at {capability}.

[TASK]
{what_to_do}

[INPUT]
I will provide:
- {input_1}
- {input_2}
- {input_3}

[OUTPUT REQUIREMENTS]
Please provide:
1. {output_item_1}
2. {output_item_2}
3. {output_item_3}

[CONSTRAINTS]
- {constraint_1}
- {constraint_2}

[FORMAT]
Format the output as {format_type}.

[EXAMPLE]
Input: {example_input}
Output: {example_output}
```

---

## Prompt Engineering Tips

### 1. Be Specific

❌ Bad: "Review this design"  
✅ Good: "Review this Salesforce integration architecture and provide recommendations for performance, security, and error handling"

### 2. Provide Context

❌ Bad: "Generate user stories"  
✅ Good: "Generate user stories for a field service mobile app used by technicians with limited connectivity"

### 3. Specify Output Format

❌ Bad: "List the risks"  
✅ Good: "List 5 risks in JSON format with fields: description, impact (High/Medium/Low), probability (High/Medium/Low), and mitigation"

### 4. Set Constraints

```
Constraints:
- Maximum 8 user stories
- Story points using Fibonacci (1,2,3,5,8,13)
- Focus on customer-facing features only
- Consider mobile-first design
```

### 5. Use Examples

```
Example Output Format:
{
  "story_title": "View Account Balance",
  "description": "As a customer, I want to...",
  "acceptance_criteria": ["Given...", "When...", "Then..."],
  "story_points": 3
}
```

### 6. Iterate and Refine

- Test your prompt
- Review the output
- Refine the prompt based on results
- Save successful prompts to the library

---

## Prompt Variables

### Common Variables to Use

| Variable | Description | Example |
|----------|-------------|---------|
| `{business_requirement}` | What needs to be built | "Customer self-service portal" |
| `{user_persona}` | Who will use it | "Customer", "Sales Manager" |
| `{business_process}` | Workflow context | "Case Management", "Lead-to-Cash" |
| `{object_list}` | Salesforce objects | "Case, Contact, Account" |
| `{architecture_details}` | Design description | "LWC + Platform Events + REST API" |
| `{project_name}` | Project identifier | "Customer Portal Q3" |
| `{current_phase}` | Project phase | "Development", "UAT", "Deployment" |
| `{date_range}` | Time period | "June 10-16, 2026" |
| `{component_list}` | Components to deploy | "2 Apex classes, 3 LWC, 1 Flow" |

---

## Saving Prompts in the App

### Using the Prompt Library Feature

1. Navigate to **Prompt Library** tab
2. Click **Save New Prompt**
3. Enter:
   - Prompt Name
   - Prompt Text
   - Tags (comma-separated)
   - Description
4. Click **Save**

### Organizing Prompts

**Recommended Tag Structure:**

- **By Feature**: `user-stories`, `testing`, `architecture`, `raid`, `meeting-prep`
- **By Industry**: `financial`, `healthcare`, `manufacturing`, `retail`
- **By Complexity**: `simple`, `standard`, `complex`, `enterprise`
- **By Role**: `ba`, `architect`, `pm`, `qa`, `developer`

**Example:**
```
Tags: user-stories, financial, complex, ba
```

### Searching Prompts

- Use the search bar to find prompts by name or tags
- Filter by tag categories
- Sort by most recently used or most frequently used

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-06-18 | Initial prompt library |
| 2.0 | TBD | Add industry-specific prompts |
| 3.0 | TBD | Add advanced AI techniques |

---

**Maintained by**: Salesforce Technical Architects  
**Last Updated**: 2026-06-18  
**Next Review**: 2026-07-18
