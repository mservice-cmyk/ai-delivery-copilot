import { LightningElement, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AiPromptLibrary extends NavigationMixin(LightningElement) {
    @track searchTerm = '';
    @track showCopySuccess = false;
    @track promptTemplates = [];

    totalPrompts = 6;
    totalUses = 421;

    connectedCallback() {
        this.initializePromptTemplates();
    }

    initializePromptTemplates() {
        this.promptTemplates = [
            {
                id: 'solution-design',
                name: 'Solution Design Review',
                useCase: 'Review technical solution design for completeness, best practices, and potential gaps',
                category: 'Architecture',
                icon: 'utility:builder',
                colorClass: 'purple',
                exampleInput: 'Integration with SAP for real-time inventory sync, Custom object for tracking shipments',
                usageCount: 89,
                satisfaction: 94,
                isLaunching: false,
                promptTemplate: `Analyze the following Salesforce solution design for completeness and best practices:

Solution Components:
{solution_components}

Requirements:
{requirements}

Please review:
1. Architecture patterns and scalability
2. Data model design and relationships
3. Integration approach and security
4. Potential risks and gaps
5. Best practice recommendations

Provide a detailed review with specific improvement suggestions.`,
                featureRoute: null
            },
            {
                id: 'user-story',
                name: 'User Story Generation',
                useCase: 'Generate comprehensive user stories with acceptance criteria and story points',
                category: 'Agile',
                icon: 'utility:list',
                colorClass: 'green',
                exampleInput: 'As a sales rep, I need to quickly create opportunities from leads with auto-populated data',
                usageCount: 124,
                satisfaction: 96,
                isLaunching: false,
                promptTemplate: `Generate detailed user stories for the following requirement:

Requirement:
{requirement_description}

Context:
{business_context}

For each user story, provide:
- User Story (As a... I want... So that...)
- Acceptance Criteria (Given/When/Then format)
- Story Points (Fibonacci scale)
- Technical Notes
- Dependencies

Generate 3-5 user stories that fully cover the requirement.`,
                featureRoute: 'user-stories'
            },
            {
                id: 'uat-test',
                name: 'UAT Test Generation',
                useCase: 'Create comprehensive UAT test scenarios with persona coverage and test data',
                category: 'Testing',
                icon: 'utility:check',
                colorClass: 'blue',
                exampleInput: 'Opportunity management flow from lead to closed-won, including approval processes',
                usageCount: 87,
                satisfaction: 92,
                isLaunching: false,
                promptTemplate: `Generate comprehensive UAT test scenarios for:

Feature:
{feature_description}

User Personas:
{personas}

For each test scenario, provide:
- Test Scenario Name
- User Persona
- Pre-conditions
- Test Steps
- Expected Results
- Test Data Requirements
- Priority (High/Medium/Low)

Generate 5-8 test scenarios covering happy path and edge cases.`,
                featureRoute: 'uat-test-generator'
            },
            {
                id: 'executive-status',
                name: 'Executive Status Update',
                useCase: 'Generate executive-level status reports with key metrics, risks, and insights',
                category: 'Reporting',
                icon: 'utility:graph',
                colorClass: 'orange',
                exampleInput: 'Sprint 3 complete, integration testing in progress, 2 blockers identified',
                usageCount: 67,
                satisfaction: 91,
                isLaunching: false,
                promptTemplate: `Generate an executive status update based on:

Project Notes:
{project_notes}

Meeting Takeaways:
{meeting_takeaways}

Risks/Blockers:
{risks_blockers}

Upcoming Milestones:
{upcoming_milestones}

Audience:
{audience}

Provide:
- Executive Summary
- Project Health (Red/Yellow/Green)
- Key Accomplishments
- Critical Decisions Made
- Risks and Blockers with Severity
- Executive Asks
- Recommended Next Actions
- Next Milestone`,
                featureRoute: 'executive-status'
            },
            {
                id: 'raid-log',
                name: 'RAID Log',
                useCase: 'Create Risks, Assumptions, Issues, and Dependencies tracking log',
                category: 'Risk Management',
                icon: 'utility:warning',
                colorClass: 'red',
                exampleInput: 'Data migration from legacy system, third-party API integration, tight timeline',
                usageCount: 42,
                satisfaction: 89,
                isLaunching: false,
                promptTemplate: `Generate a comprehensive RAID log for the project:

Project Context:
{project_context}

Scope:
{scope_description}

Timeline:
{timeline}

Generate:

RISKS:
- Description, Likelihood, Impact, Mitigation, Owner

ASSUMPTIONS:
- Description, Validation Status, Impact if Invalid

ISSUES:
- Description, Severity, Status, Resolution Plan

DEPENDENCIES:
- Description, Type, Owner, Target Date

Provide 3-5 items for each category.`,
                featureRoute: 'raid-log'
            },
            {
                id: 'meeting-prep',
                name: 'Customer Meeting Prep',
                useCase: 'Prepare comprehensive customer meeting materials and talking points',
                category: 'Communication',
                icon: 'utility:groups',
                colorClass: 'teal',
                exampleInput: 'Quarterly business review with VP of Sales, discuss adoption metrics and Phase 2 scope',
                usageCount: 12,
                satisfaction: 95,
                isLaunching: false,
                promptTemplate: `Prepare materials for customer meeting:

Meeting Purpose:
{meeting_purpose}

Attendees:
{attendees}

Project Context:
{project_context}

Discussion Topics:
{topics}

Provide:
- Meeting Objectives
- Key Talking Points
- Success Metrics to Highlight
- Potential Questions & Answers
- Risks/Concerns to Address
- Call to Action
- Follow-up Items

Create a comprehensive meeting preparation guide.`,
                featureRoute: 'meeting-prep'
            }
        ];
    }

    get filteredPrompts() {
        if (!this.searchTerm) {
            return this.promptTemplates;
        }

        const searchLower = this.searchTerm.toLowerCase();
        return this.promptTemplates.filter(prompt =>
            prompt.name.toLowerCase().includes(searchLower) ||
            prompt.useCase.toLowerCase().includes(searchLower) ||
            prompt.category.toLowerCase().includes(searchLower)
        );
    }

    get hasPrompts() {
        return this.filteredPrompts && this.filteredPrompts.length > 0;
    }

    handleSearch(event) {
        this.searchTerm = event.target.value;
    }

    handleCopyPrompt(event) {
        const promptId = event.target.dataset.id;
        const prompt = this.promptTemplates.find(p => p.id === promptId);

        if (!prompt) return;

        // Copy to clipboard
        const textarea = document.createElement('textarea');
        textarea.value = prompt.promptTemplate;
        textarea.style.position = 'fixed';
        textarea.style.opacity = '0';
        document.body.appendChild(textarea);
        textarea.select();

        try {
            document.execCommand('copy');
            this.showCopySuccess = true;

            // Hide success message after 3 seconds
            setTimeout(() => {
                this.showCopySuccess = false;
            }, 3000);

            this.showToast('Success', 'Prompt template copied to clipboard', 'success');
        } catch (err) {
            this.showToast('Error', 'Failed to copy prompt template', 'error');
        } finally {
            document.body.removeChild(textarea);
        }
    }

    handleLaunchFeature(event) {
        const promptId = event.target.dataset.id;
        const prompt = this.promptTemplates.find(p => p.id === promptId);

        if (!prompt || !prompt.featureRoute) {
            this.showToast('Info', 'This feature will be available soon', 'info');
            return;
        }

        // Set loading state
        this.promptTemplates = this.promptTemplates.map(p => ({
            ...p,
            isLaunching: p.id === promptId
        }));

        // Navigate to feature
        setTimeout(() => {
            this.navigateToFeature(prompt.featureRoute);

            // Clear loading state
            this.promptTemplates = this.promptTemplates.map(p => ({
                ...p,
                isLaunching: false
            }));
        }, 500);
    }

    navigateToFeature(route) {
        switch (route) {
            case 'user-stories':
                this.navigateToTab('AI_Delivery_Copilot', { c__view: 'userStories' });
                break;
            case 'uat-test-generator':
                this.navigateToTab('UAT_Test_Generator');
                break;
            case 'executive-status':
                this.navigateToTab('Executive_Status_Generator');
                break;
            case 'raid-log':
                this.navigateToTab('RAID_Generator');
                break;
            case 'meeting-prep':
                this.navigateToTab('Customer_Meeting_Prep');
                break;
            default:
                break;
        }
    }

    navigateToTab(apiName, state = {}) {
        this[NavigationMixin.Navigate]({
            type: 'standard__navItemPage',
            attributes: {
                apiName: apiName
            },
            state: state
        });
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }
}
