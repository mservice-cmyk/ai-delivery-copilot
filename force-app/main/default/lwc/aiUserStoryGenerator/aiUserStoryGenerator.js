import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import saveDeliveryRequest from '@salesforce/apex/AIDeliveryRequestController.saveDeliveryRequest';
import { copyToClipboard, downloadFile, convertToMarkdown, convertToCSV, generateFilename } from 'c/exportUtility';

export default class AiUserStoryGenerator extends LightningElement {
    @track businessRequirement = '';
    @track userPersona = '';
    @track businessProcess = '';
    @track salesforceObjects = '';
    @track isLoading = false;
    @track showResults = false;
    @track storyResults = null;
    @track isSaving = false;

    handleBusinessRequirementChange(event) {
        this.businessRequirement = event.target.value;
    }

    handleUserPersonaChange(event) {
        this.userPersona = event.target.value;
    }

    handleBusinessProcessChange(event) {
        this.businessProcess = event.target.value;
    }

    handleSalesforceObjectsChange(event) {
        this.salesforceObjects = event.target.value;
    }

    get isGenerateDisabled() {
        return this.isLoading ||
               !this.businessRequirement ||
               !this.userPersona ||
               !this.businessProcess ||
               !this.salesforceObjects;
    }

    get storyCount() {
        return this.storyResults?.userStories?.length || 0;
    }

    get totalStoryPoints() {
        if (!this.storyResults?.userStories) return 0;
        return this.storyResults.userStories.reduce((sum, story) => sum + parseInt(story.storyPoints || 0), 0);
    }

    get displayEpicName() {
        return this.storyResults?.epicName || 'N/A';
    }

    handleGenerate() {
        this.isLoading = true;
        this.showResults = false;

        // Simulate AI API call with mock data
        setTimeout(() => {
            this.storyResults = this.generateMockUserStories();
            this.showResults = true;
            this.isLoading = false;
            this.showToast('Success', 'User stories generated successfully', 'success');
        }, 2000);
    }

    handleClearResults() {
        this.showResults = false;
        this.storyResults = null;
        this.businessRequirement = '';
        this.userPersona = '';
        this.businessProcess = '';
        this.salesforceObjects = '';
    }

    handleSaveResults() {
        this.isSaving = true;

        const saveRequest = {
            title: `User Stories - ${this.businessRequirement.substring(0, 50)}${this.businessRequirement.length > 50 ? '...' : ''}`,
            category: 'User Stories',
            prompt: this.buildPrompt(),
            generatedResponse: JSON.stringify(this.storyResults),
            status: 'Saved',
            readinessScore: 85
        };

        saveDeliveryRequest({ request: saveRequest })
            .then(recordId => {
                this.isSaving = false;
                this.showToast('Success', 'User stories saved successfully', 'success');
            })
            .catch(error => {
                this.isSaving = false;
                this.showToast('Error', 'Failed to save: ' + (error.body?.message || error.message), 'error');
            });
    }

    buildPrompt() {
        return `Business Requirement: ${this.businessRequirement}\nPersona: ${this.userPersona}\nBusiness Process: ${this.businessProcess}\nSalesforce Objects: ${this.salesforceObjects}`;
    }

    generateMockUserStories() {
        const epicName = `${this.businessProcess} Enhancement`;

        return {
            epicName: epicName,
            userStories: [
                {
                    id: 'story1',
                    title: `US-001: ${this.userPersona} - Core Functionality`,
                    storyPoints: '5',
                    userStory: `As a ${this.userPersona}, I want to ${this.businessRequirement.toLowerCase()}, so that I can improve my ${this.businessProcess.toLowerCase()} efficiency.`,
                    acceptanceCriteria: [
                        `Given I am logged in as ${this.userPersona}, When I access the ${this.businessProcess} module, Then I can see all relevant ${this.salesforceObjects.split(',')[0] || 'records'}`,
                        'Given valid data is entered, When I submit the form, Then the record is created successfully',
                        'Given the action is completed, When I check the audit trail, Then all changes are properly logged'
                    ],
                    technicalNotes: `Implement using ${this.salesforceObjects}. Consider governor limits for bulk operations. Use Lightning Data Service for record management.`,
                    dependencies: 'Requires completion of data model setup and security configuration'
                },
                {
                    id: 'story2',
                    title: `US-002: ${this.userPersona} - Data Validation`,
                    storyPoints: '3',
                    userStory: `As a ${this.userPersona}, I want to have proper data validation rules, so that I can maintain data quality in ${this.salesforceObjects.split(',')[0] || 'the system'}.`,
                    acceptanceCriteria: [
                        'Given invalid data is entered, When I try to save, Then I see clear error messages',
                        'Given required fields are empty, When I submit the form, Then validation errors are displayed',
                        'Given duplicate records exist, When I try to create a new record, Then I receive a warning'
                    ],
                    technicalNotes: 'Implement validation rules at both client-side (LWC) and server-side (Apex). Use custom metadata for configurable validation.',
                    dependencies: 'None'
                },
                {
                    id: 'story3',
                    title: `US-003: ${this.userPersona} - Reporting & Analytics`,
                    storyPoints: '8',
                    userStory: `As a ${this.userPersona}, I want to view reports and dashboards for ${this.businessProcess}, so that I can make data-driven decisions.`,
                    acceptanceCriteria: [
                        `Given I have access to reports, When I navigate to the dashboard, Then I can see key metrics for ${this.businessProcess}`,
                        'Given data is updated, When I refresh the dashboard, Then I see the latest information',
                        'Given I need specific insights, When I apply filters, Then the data updates accordingly'
                    ],
                    technicalNotes: 'Create Lightning reports and dashboard components. Consider using Einstein Analytics for advanced analytics.',
                    dependencies: 'Requires data collection to be in place for at least 30 days'
                },
                {
                    id: 'story4',
                    title: `US-004: ${this.userPersona} - Mobile Access`,
                    storyPoints: '5',
                    userStory: `As a ${this.userPersona}, I want to access ${this.businessProcess} functionality on mobile devices, so that I can work from anywhere.`,
                    acceptanceCriteria: [
                        'Given I am on a mobile device, When I access the application, Then all features are responsive',
                        'Given I have limited connectivity, When I work offline, Then changes sync when connection is restored',
                        'Given mobile-specific features, When I use the app, Then the UX is optimized for touch'
                    ],
                    technicalNotes: 'Ensure Lightning components are mobile-responsive. Test on iOS and Android. Consider offline capabilities using Local Storage.',
                    dependencies: 'Core functionality must be completed first'
                },
                {
                    id: 'story5',
                    title: `US-005: ${this.userPersona} - Integration Support`,
                    storyPoints: '13',
                    userStory: `As a ${this.userPersona}, I want ${this.salesforceObjects.split(',')[0] || 'records'} to sync with external systems, so that data remains consistent across platforms.`,
                    acceptanceCriteria: [
                        'Given an external system is configured, When a record is updated in Salesforce, Then the external system receives the update',
                        'Given external system data changes, When sync runs, Then Salesforce data is updated accordingly',
                        'Given sync errors occur, When I check the logs, Then I can see detailed error messages and resolution steps'
                    ],
                    technicalNotes: 'Implement using Platform Events or Change Data Capture. Consider idempotency and error handling. Use Named Credentials for secure authentication.',
                    dependencies: 'Requires API documentation from external system and security review approval'
                }
            ],
            estimationBreakdown: [
                { points: '3', count: 1 },
                { points: '5', count: 2 },
                { points: '8', count: 1 },
                { points: '13', count: 1 }
            ],
            estimatedDuration: '2-3 sprints (4-6 weeks)',
            sprintPlanning: [
                { id: 'sprint1', sprint: 'Sprint 1', stories: 2, points: 8 },
                { id: 'sprint2', sprint: 'Sprint 2', stories: 2, points: 13 },
                { id: 'sprint3', sprint: 'Sprint 3', stories: 1, points: 13 }
            ]
        };
    }

    async handleCopyToClipboard() {
        if (!this.storyResults) return;

        const markdown = this.convertStoriesToMarkdown();
        const success = await copyToClipboard(markdown);

        if (success) {
            this.showToast('Success', 'User stories copied to clipboard', 'success');
        } else {
            this.showToast('Error', 'Failed to copy to clipboard', 'error');
        }
    }

    handleDownloadMarkdown() {
        if (!this.storyResults) return;

        const markdown = this.convertStoriesToMarkdown();
        const filename = generateFilename('User_Stories', 'md');
        downloadFile(markdown, filename, 'text/markdown');
        this.showToast('Success', 'Markdown file downloaded', 'success');
    }

    handleDownloadCSV() {
        if (!this.storyResults) return;

        const csvData = [];

        if (this.storyResults.userStories) {
            this.storyResults.userStories.forEach(story => {
                csvData.push({
                    'Story ID': story.title.split(':')[0],
                    'Title': story.title,
                    'Story Points': story.storyPoints,
                    'User Story': story.userStory,
                    'Acceptance Criteria': story.acceptanceCriteria.join(' | '),
                    'Technical Notes': story.technicalNotes || '',
                    'Dependencies': story.dependencies || ''
                });
            });
        }

        const csv = convertToCSV(csvData);
        const filename = generateFilename('User_Stories', 'csv');
        downloadFile(csv, filename, 'text/csv');
        this.showToast('Success', 'CSV file downloaded', 'success');
    }

    convertStoriesToMarkdown() {
        let markdown = `# User Stories\n\n`;
        markdown += `**Epic:** ${this.storyResults.epicName}\n\n`;
        markdown += `**Total Stories:** ${this.storyCount}\n`;
        markdown += `**Total Story Points:** ${this.totalStoryPoints}\n\n`;
        markdown += `---\n\n`;

        this.storyResults.userStories.forEach(story => {
            markdown += `## ${story.title}\n\n`;
            markdown += `**Story Points:** ${story.storyPoints}\n\n`;
            markdown += `**User Story:**\n${story.userStory}\n\n`;
            markdown += `**Acceptance Criteria:**\n`;
            story.acceptanceCriteria.forEach((criteria, index) => {
                markdown += `${index + 1}. ${criteria}\n`;
            });
            markdown += `\n`;
            if (story.technicalNotes) {
                markdown += `**Technical Notes:**\n${story.technicalNotes}\n\n`;
            }
            if (story.dependencies) {
                markdown += `**Dependencies:**\n${story.dependencies}\n\n`;
            }
            markdown += `---\n\n`;
        });

        return markdown;
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
