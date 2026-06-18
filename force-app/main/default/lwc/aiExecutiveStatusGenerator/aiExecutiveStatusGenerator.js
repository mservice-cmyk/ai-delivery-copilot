import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import saveDeliveryRequest from '@salesforce/apex/AIDeliveryRequestController.saveDeliveryRequest';

export default class AiExecutiveStatusGenerator extends LightningElement {
    @track projectNotes = '';
    @track meetingTakeaways = '';
    @track risksBlockers = '';
    @track upcomingMilestones = '';
    @track audience = '';
    @track isLoading = false;
    @track showResults = false;
    @track statusResults = null;
    @track isSaving = false;

    handleProjectNotesChange(event) {
        this.projectNotes = event.target.value;
    }

    handleMeetingTakeawaysChange(event) {
        this.meetingTakeaways = event.target.value;
    }

    handleRisksBlockersChange(event) {
        this.risksBlockers = event.target.value;
    }

    handleUpcomingMilestonesChange(event) {
        this.upcomingMilestones = event.target.value;
    }

    handleAudienceChange(event) {
        this.audience = event.target.value;
    }

    get isGenerateDisabled() {
        return this.isLoading ||
               !this.projectNotes ||
               !this.meetingTakeaways ||
               !this.risksBlockers ||
               !this.upcomingMilestones ||
               !this.audience;
    }

    get healthBadgeClass() {
        if (!this.statusResults) return '';
        const health = this.statusResults.projectHealth;
        if (health === 'Green') return 'health-badge-green';
        if (health === 'Yellow') return 'health-badge-yellow';
        if (health === 'Red') return 'health-badge-red';
        return '';
    }

    handleGenerate() {
        this.isLoading = true;
        this.showResults = false;

        // Simulate AI API call with mock data
        setTimeout(() => {
            this.statusResults = this.generateMockStatusResults();
            this.showResults = true;
            this.isLoading = false;
            this.showToast('Success', 'Executive status generated successfully', 'success');
        }, 2000);
    }

    handleClearResults() {
        this.showResults = false;
        this.statusResults = null;
        this.projectNotes = '';
        this.meetingTakeaways = '';
        this.risksBlockers = '';
        this.upcomingMilestones = '';
        this.audience = '';
    }

    handleSaveResults() {
        this.isSaving = true;

        const saveRequest = {
            title: `Executive Status - ${new Date().toLocaleDateString()} (${this.audience})`,
            category: 'Executive Status',
            prompt: this.buildPrompt(),
            generatedResponse: JSON.stringify(this.statusResults),
            status: 'Saved'
        };

        saveDeliveryRequest({ request: saveRequest })
            .then(recordId => {
                this.isSaving = false;
                this.showToast('Success', 'Executive status saved successfully', 'success');
            })
            .catch(error => {
                this.isSaving = false;
                this.showToast('Error', 'Failed to save: ' + (error.body?.message || error.message), 'error');
            });
    }

    buildPrompt() {
        return `Project Notes: ${this.projectNotes}\nMeeting Takeaways: ${this.meetingTakeaways}\nRisks/Blockers: ${this.risksBlockers}\nUpcoming Milestones: ${this.upcomingMilestones}\nAudience: ${this.audience}`;
    }

    generateMockStatusResults() {
        // Determine health status based on risks/blockers content
        const hasHighRisk = this.risksBlockers.toLowerCase().includes('critical') ||
                           this.risksBlockers.toLowerCase().includes('blocker');
        const hasMediumRisk = this.risksBlockers.toLowerCase().includes('risk') ||
                             this.risksBlockers.toLowerCase().includes('concern');

        let projectHealth = 'Green';
        if (hasHighRisk) {
            projectHealth = 'Red';
        } else if (hasMediumRisk) {
            projectHealth = 'Yellow';
        }

        return {
            executiveSummary: `The Salesforce implementation project is progressing well with key milestones on track. The team has successfully completed critical deliverables while addressing ${this.audience} priorities. Strategic alignment remains strong with proactive risk management in place.`,
            projectHealth: projectHealth,
            keyAccomplishments: [
                {
                    id: 'acc1',
                    description: 'Successfully deployed user story generation capability ahead of schedule'
                },
                {
                    id: 'acc2',
                    description: 'Completed UAT test framework implementation with 100% persona coverage'
                },
                {
                    id: 'acc3',
                    description: 'Achieved stakeholder alignment on solution design and architecture decisions'
                }
            ],
            keyDecisions: [
                {
                    id: 'dec1',
                    description: 'Approved phased rollout approach to minimize business disruption'
                },
                {
                    id: 'dec2',
                    description: 'Prioritized core functionality for initial release with enhancements in Phase 2'
                },
                {
                    id: 'dec3',
                    description: 'Allocated additional resources for integration testing and data migration'
                }
            ],
            risksAndBlockers: [
                {
                    id: 'risk1',
                    title: 'Integration Dependencies',
                    severity: hasHighRisk ? 'High' : 'Medium',
                    severityClass: hasHighRisk ? 'severity-badge-high' : 'severity-badge-medium',
                    description: this.risksBlockers.split('\n')[0] || 'Third-party API integration timeline dependencies may impact go-live date'
                },
                {
                    id: 'risk2',
                    title: 'Resource Availability',
                    severity: 'Low',
                    severityClass: 'severity-badge-low',
                    description: 'Two key team members have upcoming PTO during critical testing phase'
                }
            ],
            executiveAsks: [
                {
                    id: 'ask1',
                    description: 'Approval for 2-week timeline extension to ensure thorough integration testing'
                },
                {
                    id: 'ask2',
                    description: 'Support in securing dedicated sandbox environment for UAT activities'
                },
                {
                    id: 'ask3',
                    description: 'Executive sponsorship for change management communications to end users'
                }
            ],
            recommendedNextActions: [
                {
                    id: 'action1',
                    description: 'Finalize integration test scenarios with technical architecture team by EOW'
                },
                {
                    id: 'action2',
                    description: 'Conduct executive demo of MVP features and gather feedback next week'
                },
                {
                    id: 'action3',
                    description: 'Complete security review and compliance validation before UAT kickoff'
                }
            ],
            owners: [
                {
                    id: 'owner1',
                    name: 'Project Manager',
                    responsibility: 'Overall project coordination and stakeholder management'
                },
                {
                    id: 'owner2',
                    name: 'Technical Lead',
                    responsibility: 'Solution architecture and technical implementation oversight'
                },
                {
                    id: 'owner3',
                    name: 'Business Analyst',
                    responsibility: 'Requirements validation and UAT coordination'
                }
            ],
            nextMilestone: {
                title: this.upcomingMilestones.split('\n')[0] || 'UAT Kickoff and Initial Testing',
                targetDate: 'June 30, 2026',
                description: 'Begin comprehensive user acceptance testing with all identified personas across core business processes'
            }
        };
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
