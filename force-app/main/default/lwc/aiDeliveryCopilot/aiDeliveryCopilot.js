import { LightningElement, track } from 'lwc';
import getAIInsights from '@salesforce/apex/AIDeliveryCopilotController.getAIInsights';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

export default class AiDeliveryCopilot extends NavigationMixin(LightningElement) {
    @track searchQuery = '';
    @track userRequest = '';
    @track isLoading = false;
    @track activeCard = null;
    @track generatedContent = '';
    @track showResults = false;

    quickActions = [
        {
            id: 'user-stories',
            title: 'Generate User Stories',
            description: 'Create comprehensive user stories with acceptance criteria and story points',
            icon: 'utility:list',
            iconColor: 'slds-icon-text-success',
            context: 'user_stories'
        },
        {
            id: 'test-cases',
            title: 'Generate Test Cases',
            description: 'Build detailed test cases with test data and expected outcomes',
            icon: 'utility:check',
            iconColor: 'slds-icon-text-warning',
            context: 'test_cases'
        },
        {
            id: 'uat-test-generator',
            title: 'UAT Test Generator',
            description: 'Generate comprehensive UAT test scenarios with persona coverage and test data',
            icon: 'utility:check',
            iconColor: 'slds-icon-text-success',
            context: 'uat_tests',
            isNavigate: true
        },
        {
            id: 'solution-design',
            title: 'Review Solution Design',
            description: 'Analyze and validate your solution architecture and design decisions',
            icon: 'utility:layers',
            iconColor: 'slds-icon-text-default',
            context: 'solution_design'
        },
        {
            id: 'executive-status',
            title: 'Create Executive Status',
            description: 'Generate executive-level status reports with key metrics and insights',
            icon: 'utility:graph',
            iconColor: 'slds-icon-text-error',
            context: 'executive_status',
            isNavigate: true
        },
        {
            id: 'raid-log',
            title: 'Generate RAID Log',
            description: 'Create Risks, Assumptions, Issues, and Dependencies tracking log',
            icon: 'utility:warning',
            iconColor: 'slds-icon-text-warning',
            context: 'raid_log',
            isNavigate: true
        },
        {
            id: 'meeting-prep',
            title: 'Customer Meeting Prep',
            description: 'Prepare comprehensive customer meeting materials and talking points',
            icon: 'utility:groups',
            iconColor: 'slds-icon-text-success',
            context: 'meeting_prep'
        },
        {
            id: 'deployment-checklist',
            title: 'Deployment Checklist',
            description: 'Generate detailed deployment checklist with pre/post deployment tasks',
            icon: 'utility:checkin',
            iconColor: 'slds-icon-text-default',
            context: 'deployment_checklist'
        }
    ];

    handleSearchChange(event) {
        this.searchQuery = event.target.value.toLowerCase();
    }

    handleRequestChange(event) {
        this.userRequest = event.target.value;
    }

    handleGenerate(event) {
        const actionId = event.currentTarget.dataset.id;
        const action = this.quickActions.find(a => a.id === actionId);

        if (!action) return;

        // Check if this action should navigate to a separate component
        if (action.isNavigate) {
            if (actionId === 'uat-test-generator') {
                this.navigateToUATGenerator();
            } else if (actionId === 'executive-status') {
                this.navigateToExecutiveStatusGenerator();
            } else if (actionId === 'raid-log') {
                this.navigateToRAIDGenerator();
            }
            return;
        }

        this.activeCard = actionId;
        this.isLoading = true;
        this.showResults = false;

        getAIInsights({ context: action.context, userRequest: this.userRequest })
            .then(result => {
                const response = JSON.parse(result);
                this.generatedContent = this.formatResponse(action, response);
                this.showResults = true;
                this.showToast('Success', `${action.title} generated successfully`, 'success');
            })
            .catch(error => {
                this.showToast('Error', this.getErrorMessage(error), 'error');
            })
            .finally(() => {
                this.isLoading = false;
                this.activeCard = null;
            });
    }

    navigateToUATGenerator() {
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                componentName: 'c__aiUatTestGenerator'
            }
        });
    }

    navigateToExecutiveStatusGenerator() {
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                componentName: 'c__aiExecutiveStatusGenerator'
            }
        });
    }

    navigateToRAIDGenerator() {
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                componentName: 'c__aiRaidGenerator'
            }
        });
    }

    handleClearResults() {
        this.showResults = false;
        this.generatedContent = '';
        this.userRequest = '';
    }

    formatResponse(action, response) {
        let formatted = `═══════════════════════════════════════════════════════\n`;
        formatted += `${response.actionType || action.title}\n`;
        formatted += `═══════════════════════════════════════════════════════\n\n`;

        formatted += `Generated: ${new Date(response.timestamp).toLocaleString()}\n`;
        formatted += `Priority: ${response.priority || 'N/A'}\n`;
        formatted += `Confidence Score: ${response.confidenceScore || 0}%\n\n`;

        if (response.userRequest) {
            formatted += `───────────────────────────────────────────────────────\n`;
            formatted += `YOUR REQUEST\n`;
            formatted += `───────────────────────────────────────────────────────\n`;
            formatted += `${response.userRequest}\n\n`;
        }

        formatted += `───────────────────────────────────────────────────────\n`;
        formatted += `EXECUTIVE SUMMARY\n`;
        formatted += `───────────────────────────────────────────────────────\n`;
        formatted += `${response.executiveSummary || 'No summary available'}\n\n`;

        if (response.recommendations && response.recommendations.length > 0) {
            formatted += `───────────────────────────────────────────────────────\n`;
            formatted += `RECOMMENDATIONS\n`;
            formatted += `───────────────────────────────────────────────────────\n`;
            response.recommendations.forEach((rec, index) => {
                formatted += `${index + 1}. ${rec}\n`;
            });
            formatted += '\n';
        }

        if (response.risks && response.risks.length > 0) {
            formatted += `───────────────────────────────────────────────────────\n`;
            formatted += `RISKS & MITIGATION\n`;
            formatted += `───────────────────────────────────────────────────────\n`;
            response.risks.forEach((risk, index) => {
                formatted += `${index + 1}. ${risk.description}\n`;
                formatted += `   Impact: ${risk.impact} | Probability: ${risk.probability}\n`;
            });
            formatted += '\n';
        }

        if (response.actionItems && response.actionItems.length > 0) {
            formatted += `───────────────────────────────────────────────────────\n`;
            formatted += `ACTION ITEMS\n`;
            formatted += `───────────────────────────────────────────────────────\n`;
            response.actionItems.forEach((item, index) => {
                formatted += `${index + 1}. ${item.task}\n`;
                formatted += `   Priority: ${item.priority} | Owner: ${item.owner} | Duration: ${item.duration}\n`;
            });
            formatted += '\n';
        }

        if (response.nextSteps && response.nextSteps.length > 0) {
            formatted += `───────────────────────────────────────────────────────\n`;
            formatted += `NEXT STEPS\n`;
            formatted += `───────────────────────────────────────────────────────\n`;
            response.nextSteps.forEach((step, index) => {
                formatted += `${index + 1}. ${step}\n`;
            });
            formatted += '\n';
        }

        formatted += `═══════════════════════════════════════════════════════\n`;
        formatted += `End of Report\n`;
        formatted += `═══════════════════════════════════════════════════════`;

        return formatted;
    }

    getErrorMessage(error) {
        if (error.body && error.body.message) {
            return error.body.message;
        } else if (error.message) {
            return error.message;
        }
        return 'An unknown error occurred';
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

    get filteredActions() {
        if (!this.searchQuery) {
            return this.quickActions;
        }
        return this.quickActions.filter(action =>
            action.title.toLowerCase().includes(this.searchQuery) ||
            action.description.toLowerCase().includes(this.searchQuery)
        );
    }

    get hasFilteredActions() {
        return this.filteredActions.length > 0;
    }

    get requestPlaceholder() {
        return 'Example: Generate user stories for a customer portal with self-service case management...';
    }

    isCardLoading(actionId) {
        return this.isLoading && this.activeCard === actionId;
    }
}
