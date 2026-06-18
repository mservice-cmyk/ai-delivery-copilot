import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import saveDeliveryRequest from '@salesforce/apex/AIDeliveryRequestController.saveDeliveryRequest';
import { copyToClipboard, downloadFile, convertToMarkdown, convertToCSV, generateFilename } from 'c/exportUtility';

export default class AiRaidGenerator extends LightningElement {
    @track meetingNotes = '';
    @track statusUpdate = '';
    @track emailContent = '';
    @track isLoading = false;
    @track showResults = false;
    @track raidResults = null;
    @track isSaving = false;

    riskColumns = [
        { label: 'Risk Description', fieldName: 'description', type: 'text', wrapText: true },
        { label: 'Severity', fieldName: 'severity', type: 'text' },
        { label: 'Impact', fieldName: 'impact', type: 'text' },
        { label: 'Owner', fieldName: 'owner', type: 'text' },
        { label: 'Due Date', fieldName: 'dueDate', type: 'text' },
        { label: 'Mitigation', fieldName: 'mitigation', type: 'text', wrapText: true },
        { label: 'Status', fieldName: 'status', type: 'text' }
    ];

    assumptionColumns = [
        { label: 'Assumption Description', fieldName: 'description', type: 'text', wrapText: true },
        { label: 'Severity', fieldName: 'severity', type: 'text' },
        { label: 'Impact', fieldName: 'impact', type: 'text' },
        { label: 'Owner', fieldName: 'owner', type: 'text' },
        { label: 'Due Date', fieldName: 'dueDate', type: 'text' },
        { label: 'Mitigation', fieldName: 'mitigation', type: 'text', wrapText: true },
        { label: 'Status', fieldName: 'status', type: 'text' }
    ];

    issueColumns = [
        { label: 'Issue Description', fieldName: 'description', type: 'text', wrapText: true },
        { label: 'Severity', fieldName: 'severity', type: 'text' },
        { label: 'Impact', fieldName: 'impact', type: 'text' },
        { label: 'Owner', fieldName: 'owner', type: 'text' },
        { label: 'Due Date', fieldName: 'dueDate', type: 'text' },
        { label: 'Mitigation', fieldName: 'mitigation', type: 'text', wrapText: true },
        { label: 'Status', fieldName: 'status', type: 'text' }
    ];

    dependencyColumns = [
        { label: 'Dependency Description', fieldName: 'description', type: 'text', wrapText: true },
        { label: 'Severity', fieldName: 'severity', type: 'text' },
        { label: 'Impact', fieldName: 'impact', type: 'text' },
        { label: 'Owner', fieldName: 'owner', type: 'text' },
        { label: 'Due Date', fieldName: 'dueDate', type: 'text' },
        { label: 'Mitigation', fieldName: 'mitigation', type: 'text', wrapText: true },
        { label: 'Status', fieldName: 'status', type: 'text' }
    ];

    handleMeetingNotesChange(event) {
        this.meetingNotes = event.target.value;
    }

    handleStatusUpdateChange(event) {
        this.statusUpdate = event.target.value;
    }

    handleEmailContentChange(event) {
        this.emailContent = event.target.value;
    }

    get isGenerateDisabled() {
        return this.isLoading || (!this.meetingNotes && !this.statusUpdate && !this.emailContent);
    }

    get riskCount() {
        return this.raidResults?.risks?.length || 0;
    }

    get assumptionCount() {
        return this.raidResults?.assumptions?.length || 0;
    }

    get issueCount() {
        return this.raidResults?.issues?.length || 0;
    }

    get dependencyCount() {
        return this.raidResults?.dependencies?.length || 0;
    }

    get totalCount() {
        return this.riskCount + this.assumptionCount + this.issueCount + this.dependencyCount;
    }

    handleGenerate() {
        this.isLoading = true;
        this.showResults = false;

        // Simulate AI API call with mock data
        setTimeout(() => {
            this.raidResults = this.generateMockRAIDResults();
            this.showResults = true;
            this.isLoading = false;
            this.showToast('Success', 'RAID Log generated successfully', 'success');
        }, 2000);
    }

    handleClearResults() {
        this.showResults = false;
        this.raidResults = null;
        this.meetingNotes = '';
        this.statusUpdate = '';
        this.emailContent = '';
    }

    handleSaveResults() {
        this.isSaving = true;

        const saveRequest = {
            title: `RAID Log - ${new Date().toLocaleDateString()}`,
            category: 'RAID Log',
            prompt: this.buildPrompt(),
            generatedResponse: JSON.stringify(this.raidResults),
            status: 'Saved'
        };

        saveDeliveryRequest({ request: saveRequest })
            .then(recordId => {
                this.isSaving = false;
                this.showToast('Success', 'RAID log saved successfully', 'success');
            })
            .catch(error => {
                this.isSaving = false;
                this.showToast('Error', 'Failed to save: ' + (error.body?.message || error.message), 'error');
            });
    }

    buildPrompt() {
        return `Meeting Notes: ${this.meetingNotes}\nStatus Update: ${this.statusUpdate}\nEmail Content: ${this.emailContent}`;
    }

    generateMockRAIDResults() {
        const hasHighPriorityContent =
            (this.meetingNotes + this.statusUpdate + this.emailContent).toLowerCase().includes('critical') ||
            (this.meetingNotes + this.statusUpdate + this.emailContent).toLowerCase().includes('urgent') ||
            (this.meetingNotes + this.statusUpdate + this.emailContent).toLowerCase().includes('blocker');

        return {
            summary: 'Comprehensive RAID analysis has identified key areas requiring attention to ensure project success and timely delivery.',
            risks: [
                {
                    id: 'risk1',
                    description: hasHighPriorityContent
                        ? 'Critical third-party API integration delay may impact go-live timeline'
                        : 'Integration timeline with external systems requires close monitoring',
                    severity: hasHighPriorityContent ? 'High' : 'Medium',
                    impact: hasHighPriorityContent ? 'Schedule Delay' : 'Minor Delay',
                    owner: 'Technical Lead',
                    dueDate: '2026-06-30',
                    mitigation: 'Weekly sync with vendor, escalation path established, parallel development of mock interfaces for testing',
                    status: 'Active'
                },
                {
                    id: 'risk2',
                    description: 'Data migration complexity from legacy system may require additional validation cycles',
                    severity: 'Medium',
                    impact: 'Quality Impact',
                    owner: 'Data Architect',
                    dueDate: '2026-07-15',
                    mitigation: 'Implement comprehensive data validation framework, conduct dry-run migrations, establish rollback procedures',
                    status: 'Active'
                },
                {
                    id: 'risk3',
                    description: 'User adoption challenges due to significant process changes',
                    severity: 'Low',
                    impact: 'User Experience',
                    owner: 'Change Manager',
                    dueDate: '2026-08-01',
                    mitigation: 'Develop comprehensive training materials, conduct early user previews, establish super-user network',
                    status: 'Monitoring'
                }
            ],
            assumptions: [
                {
                    id: 'assume1',
                    description: 'Stakeholders will provide timely feedback on UAT test cycles within 48-72 hours',
                    severity: 'Medium',
                    impact: 'Schedule',
                    owner: 'Project Manager',
                    dueDate: '2026-07-01',
                    mitigation: 'Establish clear SLA with stakeholders, build buffer time into testing schedule, escalation protocol ready',
                    status: 'Valid'
                },
                {
                    id: 'assume2',
                    description: 'All required Salesforce licenses will be available prior to UAT kickoff',
                    severity: 'High',
                    impact: 'Resource Availability',
                    owner: 'License Manager',
                    dueDate: '2026-06-25',
                    mitigation: 'Submit license request with 3-week lead time, confirm procurement approval, identify backup users',
                    status: 'Valid'
                },
                {
                    id: 'assume3',
                    description: 'Current integration architecture will support anticipated transaction volumes',
                    severity: 'Medium',
                    impact: 'Performance',
                    owner: 'Solution Architect',
                    dueDate: '2026-07-10',
                    mitigation: 'Conduct load testing with 150% of expected volume, implement monitoring and alerts, optimize queries',
                    status: 'To Validate'
                }
            ],
            issues: [
                {
                    id: 'issue1',
                    description: 'Sandbox environment refresh delayed by 1 week impacting development timeline',
                    severity: hasHighPriorityContent ? 'High' : 'Medium',
                    impact: 'Development Delay',
                    owner: 'DevOps Lead',
                    dueDate: '2026-06-20',
                    mitigation: 'Expedite refresh request with Salesforce support, utilize partial sandbox for urgent work, re-baseline schedule',
                    status: 'In Progress'
                },
                {
                    id: 'issue2',
                    description: 'Two key team members scheduled for overlapping PTO during critical testing phase',
                    severity: 'Medium',
                    impact: 'Resource Constraint',
                    owner: 'Resource Manager',
                    dueDate: '2026-06-25',
                    mitigation: 'Cross-train backup resources, adjust testing schedule to frontload critical scenarios, offshore team support',
                    status: 'In Progress'
                },
                {
                    id: 'issue3',
                    description: 'Security review identified additional requirements for data encryption at rest',
                    severity: 'Medium',
                    impact: 'Scope Change',
                    owner: 'Security Lead',
                    dueDate: '2026-07-05',
                    mitigation: 'Implement Shield Platform Encryption, update design documentation, conduct security re-validation',
                    status: 'Open'
                }
            ],
            dependencies: [
                {
                    id: 'dep1',
                    description: 'Marketing Cloud integration requires completion of Sales Cloud configuration first',
                    severity: 'High',
                    impact: 'Sequential Blocking',
                    owner: 'Integration Lead',
                    dueDate: '2026-07-15',
                    mitigation: 'Clearly defined interface contracts, weekly status checks, parallel mock development for early testing',
                    status: 'On Track'
                },
                {
                    id: 'dep2',
                    description: 'Mobile app deployment dependent on final API endpoints being published',
                    severity: 'Medium',
                    impact: 'Mobile Release',
                    owner: 'Mobile Lead',
                    dueDate: '2026-07-20',
                    mitigation: 'API contract finalized and shared, mock services for mobile development, coordinated release planning',
                    status: 'On Track'
                },
                {
                    id: 'dep3',
                    description: 'Production deployment requires successful completion of all security compliance scans',
                    severity: 'High',
                    impact: 'Go-Live Gate',
                    owner: 'Compliance Officer',
                    dueDate: '2026-08-01',
                    mitigation: 'Schedule scans 2 weeks prior to deployment, address findings promptly, maintain audit trail documentation',
                    status: 'Pending'
                }
            ]
        };
    }

    async handleCopyToClipboard() {
        if (!this.raidResults) return;

        const markdown = convertToMarkdown(this.raidResults, 'RAID Log');
        const success = await copyToClipboard(markdown);

        if (success) {
            this.showToast('Success', 'RAID log copied to clipboard', 'success');
        } else {
            this.showToast('Error', 'Failed to copy to clipboard', 'error');
        }
    }

    handleDownloadMarkdown() {
        if (!this.raidResults) return;

        const markdown = convertToMarkdown(this.raidResults, 'RAID Log');
        const filename = generateFilename('RAID_Log', 'md');
        downloadFile(markdown, filename, 'text/markdown');
        this.showToast('Success', 'Markdown file downloaded', 'success');
    }

    handleDownloadCSV() {
        if (!this.raidResults) return;

        const csvData = [];

        if (this.raidResults.risks) {
            this.raidResults.risks.forEach(item => {
                csvData.push({
                    Type: 'Risk',
                    Description: item.description,
                    Severity: item.severity,
                    Impact: item.impact,
                    Owner: item.owner,
                    DueDate: item.dueDate,
                    Mitigation: item.mitigation,
                    Status: item.status
                });
            });
        }

        if (this.raidResults.assumptions) {
            this.raidResults.assumptions.forEach(item => {
                csvData.push({
                    Type: 'Assumption',
                    Description: item.description,
                    Severity: item.severity,
                    Impact: item.impact,
                    Owner: item.owner,
                    DueDate: item.dueDate,
                    Mitigation: item.mitigation,
                    Status: item.status
                });
            });
        }

        if (this.raidResults.issues) {
            this.raidResults.issues.forEach(item => {
                csvData.push({
                    Type: 'Issue',
                    Description: item.description,
                    Severity: item.severity,
                    Impact: item.impact,
                    Owner: item.owner,
                    DueDate: item.dueDate,
                    Mitigation: item.mitigation,
                    Status: item.status
                });
            });
        }

        if (this.raidResults.dependencies) {
            this.raidResults.dependencies.forEach(item => {
                csvData.push({
                    Type: 'Dependency',
                    Description: item.description,
                    Severity: item.severity,
                    Impact: item.impact,
                    Owner: item.owner,
                    DueDate: item.dueDate,
                    Mitigation: item.mitigation,
                    Status: item.status
                });
            });
        }

        const csv = convertToCSV(csvData);
        const filename = generateFilename('RAID_Log', 'csv');
        downloadFile(csv, filename, 'text/csv');
        this.showToast('Success', 'CSV file downloaded', 'success');
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
