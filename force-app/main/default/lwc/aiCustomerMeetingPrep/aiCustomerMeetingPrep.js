import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// TODO: Uncomment when AI_Delivery_Request__c object is available
// import saveMeetingPrep from '@salesforce/apex/CustomerMeetingPrepController.saveMeetingPrep';

export default class AiCustomerMeetingPrep extends LightningElement {
    @track customerName = '';
    @track industry = '';
    @track meetingType = '';
    @track selectedProducts = [];
    @track customerGoals = '';
    @track knownChallenges = '';
    @track isLoading = false;
    @track showResults = false;
    @track meetingResults = null;

    // Toggle states for expandable sections
    @track showExecutiveSummary = true;
    @track showBusinessObjectives = true;
    @track showDiscoveryQuestions = true;
    @track showTalkingPoints = true;
    @track showRisks = true;
    @track showProductRecommendations = true;
    @track showExpansion = true;
    @track showArchitecture = true;
    @track showDemo = true;
    @track showNextSteps = true;
    @track showEmail = true;

    industryOptions = [
        { label: 'Construction', value: 'Construction' },
        { label: 'Manufacturing', value: 'Manufacturing' },
        { label: 'Healthcare', value: 'Healthcare' },
        { label: 'Retail', value: 'Retail' },
        { label: 'Financial Services', value: 'Financial Services' },
        { label: 'Technology', value: 'Technology' },
        { label: 'Public Sector', value: 'Public Sector' }
    ];

    meetingTypeOptions = [
        { label: 'Discovery', value: 'Discovery' },
        { label: 'Executive Status', value: 'Executive Status' },
        { label: 'Solution Workshop', value: 'Solution Workshop' },
        { label: 'Architecture Review', value: 'Architecture Review' },
        { label: 'UAT Planning', value: 'UAT Planning' },
        { label: 'Steering Committee', value: 'Steering Committee' },
        { label: 'Go-Live Readiness', value: 'Go-Live Readiness' }
    ];

    salesforceProductOptions = [
        { label: 'Sales Cloud', value: 'Sales Cloud' },
        { label: 'Service Cloud', value: 'Service Cloud' },
        { label: 'Agentforce', value: 'Agentforce' },
        { label: 'Data Cloud', value: 'Data Cloud' },
        { label: 'Experience Cloud', value: 'Experience Cloud' },
        { label: 'Revenue Cloud', value: 'Revenue Cloud' },
        { label: 'MuleSoft', value: 'MuleSoft' },
        { label: 'Slack', value: 'Slack' }
    ];

    handleCustomerNameChange(event) {
        this.customerName = event.target.value;
    }

    handleIndustryChange(event) {
        this.industry = event.detail.value;
    }

    handleMeetingTypeChange(event) {
        this.meetingType = event.detail.value;
    }

    handleProductChange(event) {
        this.selectedProducts = event.detail.value;
    }

    handleCustomerGoalsChange(event) {
        this.customerGoals = event.target.value;
    }

    handleKnownChallengesChange(event) {
        this.knownChallenges = event.target.value;
    }

    get isGenerateDisabled() {
        return this.isLoading ||
               !this.customerName ||
               !this.industry ||
               !this.meetingType ||
               this.selectedProducts.length === 0 ||
               !this.customerGoals ||
               !this.knownChallenges;
    }

    handleGenerate() {
        this.isLoading = true;
        this.showResults = false;

        // Simulate AI API call with mock data
        setTimeout(() => {
            this.meetingResults = this.generateMockMeetingResults();
            this.showResults = true;
            this.isLoading = false;
            this.showToast('Success', 'Meeting brief generated successfully', 'success');

            // TODO: Uncomment when AI_Delivery_Request__c object is available
            // this.saveMeetingData();
        }, 2500);
    }

    // TODO: Implement when AI_Delivery_Request__c object is available
    // saveMeetingData() {
    //     const meetingData = {
    //         meetingType: this.meetingType,
    //         customerName: this.customerName,
    //         prompt: this.buildPrompt(),
    //         generatedResponse: JSON.stringify(this.meetingResults),
    //         requestDate: new Date().toISOString(),
    //         status: 'Completed'
    //     };
    //
    //     saveMeetingPrep({ meetingData })
    //         .then(() => {
    //             console.log('Meeting prep data saved successfully');
    //         })
    //         .catch(error => {
    //             console.error('Error saving meeting prep data:', error);
    //         });
    // }

    buildPrompt() {
        return `Customer: ${this.customerName}\nIndustry: ${this.industry}\nMeeting Type: ${this.meetingType}\nProducts: ${this.selectedProducts.join(', ')}\nGoals: ${this.customerGoals}\nChallenges: ${this.knownChallenges}`;
    }

    handleClearResults() {
        this.showResults = false;
        this.meetingResults = null;
        this.customerName = '';
        this.industry = '';
        this.meetingType = '';
        this.selectedProducts = [];
        this.customerGoals = '';
        this.knownChallenges = '';

        // Reset all toggle states
        this.showExecutiveSummary = true;
        this.showBusinessObjectives = true;
        this.showDiscoveryQuestions = true;
        this.showTalkingPoints = true;
        this.showRisks = true;
        this.showProductRecommendations = true;
        this.showExpansion = true;
        this.showArchitecture = true;
        this.showDemo = true;
        this.showNextSteps = true;
        this.showEmail = true;
    }

    generateMockMeetingResults() {
        const readinessScore = this.calculateReadinessScore();

        return {
            readinessScore: readinessScore,
            executiveSummary: `${this.customerName} is a ${this.industry} organization seeking to enhance their operational efficiency and customer experience through strategic adoption of ${this.selectedProducts.join(', ')}. This ${this.meetingType} meeting represents a critical opportunity to align Salesforce solutions with their stated goals: ${this.customerGoals.substring(0, 100)}... The customer faces key challenges including ${this.knownChallenges.substring(0, 100)}... which positions Salesforce as a strategic partner in their digital transformation journey.`,
            businessObjectives: [
                {
                    id: 'obj1',
                    description: `Drive digital transformation aligned with ${this.industry} industry best practices`
                },
                {
                    id: 'obj2',
                    description: 'Increase operational efficiency through automation and intelligent workflows'
                },
                {
                    id: 'obj3',
                    description: 'Enhance customer experience across all touchpoints and channels'
                },
                {
                    id: 'obj4',
                    description: 'Enable data-driven decision making with real-time insights and analytics'
                },
                {
                    id: 'obj5',
                    description: 'Scale business operations while maintaining quality and compliance standards'
                }
            ],
            discoveryQuestions: [
                {
                    id: 'q1',
                    description: `What are the top 3 pain points affecting your ${this.industry} operations today?`
                },
                {
                    id: 'q2',
                    description: 'How do you currently measure success for customer engagement initiatives?'
                },
                {
                    id: 'q3',
                    description: 'What systems and platforms are you currently using, and what integration challenges exist?'
                },
                {
                    id: 'q4',
                    description: 'What does your ideal end-state look like 12-18 months from now?'
                },
                {
                    id: 'q5',
                    description: 'Who are the key stakeholders involved in this initiative, and what are their priorities?'
                }
            ],
            talkingPoints: [
                {
                    id: 'tp1',
                    description: `Salesforce has deep expertise in ${this.industry} with proven success stories and industry-specific solutions`
                },
                {
                    id: 'tp2',
                    description: `${this.selectedProducts[0]} can directly address the challenges you've outlined while supporting scalability`
                },
                {
                    id: 'tp3',
                    description: 'Our AI-powered platform enables intelligent automation and predictive insights out of the box'
                },
                {
                    id: 'tp4',
                    description: 'Salesforce ecosystem provides seamless integration capabilities with existing systems through APIs and MuleSoft'
                },
                {
                    id: 'tp5',
                    description: 'We offer comprehensive change management support and user adoption resources to ensure project success'
                }
            ],
            risks: [
                {
                    id: 'risk1',
                    description: 'Potential resistance to change from existing teams accustomed to legacy systems'
                },
                {
                    id: 'risk2',
                    description: 'Data migration complexity from current systems may require additional planning and resources'
                },
                {
                    id: 'risk3',
                    description: 'Integration dependencies with third-party systems could impact timeline'
                }
            ],
            productRecommendations: this.generateProductRecommendations(),
            expansionOpportunities: [
                {
                    id: 'exp1',
                    description: 'Data Cloud integration to unify customer data across all systems for 360-degree view'
                },
                {
                    id: 'exp2',
                    description: 'Agentforce deployment to automate customer service interactions and reduce response times'
                },
                {
                    id: 'exp3',
                    description: 'Experience Cloud portal to enable self-service capabilities for customers and partners'
                },
                {
                    id: 'exp4',
                    description: 'Slack integration to improve internal collaboration and streamline project communication'
                }
            ],
            architectureTopics: [
                {
                    id: 'arch1',
                    description: 'Multi-cloud strategy and how Salesforce products work together in an integrated ecosystem'
                },
                {
                    id: 'arch2',
                    description: 'Security architecture including data encryption, authentication, and compliance certifications'
                },
                {
                    id: 'arch3',
                    description: 'Integration patterns for connecting Salesforce with existing ERP, billing, and operational systems'
                },
                {
                    id: 'arch4',
                    description: 'Scalability and performance optimization strategies for high-volume transactions'
                }
            ],
            demoRecommendations: [
                {
                    id: 'demo1',
                    description: `Show ${this.selectedProducts[0]} key features tailored to ${this.industry} use cases`
                },
                {
                    id: 'demo2',
                    description: 'Demonstrate AI-powered automation capabilities that address their stated challenges'
                },
                {
                    id: 'demo3',
                    description: 'Walk through real-time reporting and dashboards relevant to their business metrics'
                },
                {
                    id: 'demo4',
                    description: 'Highlight mobile capabilities and user experience across devices'
                }
            ],
            nextSteps: [
                {
                    id: 'step1',
                    description: 'Schedule technical deep-dive session with IT and architecture teams'
                },
                {
                    id: 'step2',
                    description: 'Provide detailed solution design document and implementation roadmap'
                },
                {
                    id: 'step3',
                    description: 'Arrange reference calls with similar customers in the same industry'
                },
                {
                    id: 'step4',
                    description: 'Develop proof-of-concept scope for pilot project with defined success criteria'
                }
            ],
            followUpEmail: {
                subject: `Thank you for today's ${this.meetingType} meeting - ${this.customerName}`,
                body: `Dear Team,\n\nThank you for taking the time to meet with us today. We enjoyed learning more about ${this.customerName}'s vision and strategic goals.\n\nKey takeaways from our discussion:\n• Your focus on ${this.customerGoals.substring(0, 80)}...\n• The challenges you're facing with ${this.knownChallenges.substring(0, 80)}...\n• Potential fit with ${this.selectedProducts.join(', ')}\n\nNext Steps:\n• We'll prepare a detailed solution design aligned with your requirements\n• Schedule follow-up architecture review session\n• Provide reference customer contacts in ${this.industry}\n\nPlease let us know if you have any questions or need additional information.\n\nLooking forward to our continued partnership.\n\nBest regards,\nYour Salesforce Team`
            }
        };
    }

    generateProductRecommendations() {
        const recommendations = [];
        const productDescriptions = {
            'Sales Cloud': 'Accelerate sales productivity with AI-powered insights, streamline lead-to-cash processes, and enable sales teams with mobile-first capabilities.',
            'Service Cloud': 'Deliver exceptional customer service with omnichannel support, AI-powered case management, and self-service portals that reduce resolution times.',
            'Agentforce': 'Deploy intelligent AI agents that handle routine inquiries, automate workflows, and provide 24/7 customer support with natural language understanding.',
            'Data Cloud': 'Unify customer data from all sources into a single source of truth, enabling real-time personalization and data-driven decision making.',
            'Experience Cloud': 'Build branded digital experiences for customers, partners, and employees with low-code tools and seamless Salesforce integration.',
            'Revenue Cloud': 'Streamline quote-to-cash processes with CPQ, billing, and revenue management on a single platform to accelerate deal cycles.',
            'MuleSoft': 'Connect any application, data source, or API with enterprise-grade integration platform that enables digital transformation at scale.',
            'Slack': 'Transform teamwork with real-time collaboration platform integrated with Salesforce to bring customer context into every conversation.'
        };

        this.selectedProducts.forEach((product, index) => {
            recommendations.push({
                id: `prod${index + 1}`,
                name: product,
                description: productDescriptions[product] || `${product} provides enterprise-grade capabilities to support your business transformation.`
            });
        });

        return recommendations;
    }

    calculateReadinessScore() {
        let score = 60; // Base score

        // Add points for completeness
        if (this.customerName) score += 5;
        if (this.industry) score += 5;
        if (this.meetingType) score += 5;
        if (this.selectedProducts.length > 0) score += 5;
        if (this.customerGoals && this.customerGoals.length > 50) score += 10;
        if (this.knownChallenges && this.knownChallenges.length > 50) score += 10;

        return Math.min(score, 100);
    }

    get readinessMessage() {
        const score = this.meetingResults.readinessScore;
        if (score >= 90) return 'Excellent preparation! You\'re well-equipped for a successful meeting.';
        if (score >= 75) return 'Good preparation! Review key talking points before the meeting.';
        if (score >= 60) return 'Adequate preparation. Consider gathering additional customer context.';
        return 'More preparation recommended. Review all sections carefully.';
    }

    get progressCircleStyle() {
        const score = this.meetingResults.readinessScore;
        const circumference = 2 * Math.PI * 45;
        const offset = circumference - (score / 100) * circumference;
        return `stroke-dashoffset: ${offset};`;
    }

    // Toggle methods
    toggleExecutiveSummary() {
        this.showExecutiveSummary = !this.showExecutiveSummary;
    }

    toggleBusinessObjectives() {
        this.showBusinessObjectives = !this.showBusinessObjectives;
    }

    toggleDiscoveryQuestions() {
        this.showDiscoveryQuestions = !this.showDiscoveryQuestions;
    }

    toggleTalkingPoints() {
        this.showTalkingPoints = !this.showTalkingPoints;
    }

    toggleRisks() {
        this.showRisks = !this.showRisks;
    }

    toggleProductRecommendations() {
        this.showProductRecommendations = !this.showProductRecommendations;
    }

    toggleExpansion() {
        this.showExpansion = !this.showExpansion;
    }

    toggleArchitecture() {
        this.showArchitecture = !this.showArchitecture;
    }

    toggleDemo() {
        this.showDemo = !this.showDemo;
    }

    toggleNextSteps() {
        this.showNextSteps = !this.showNextSteps;
    }

    toggleEmail() {
        this.showEmail = !this.showEmail;
    }

    // Computed properties for toggle icons
    get executiveSummaryIcon() {
        return this.showExecutiveSummary ? 'utility:chevrondown' : 'utility:chevronright';
    }

    get businessObjectivesIcon() {
        return this.showBusinessObjectives ? 'utility:chevrondown' : 'utility:chevronright';
    }

    get discoveryQuestionsIcon() {
        return this.showDiscoveryQuestions ? 'utility:chevrondown' : 'utility:chevronright';
    }

    get talkingPointsIcon() {
        return this.showTalkingPoints ? 'utility:chevrondown' : 'utility:chevronright';
    }

    get risksIcon() {
        return this.showRisks ? 'utility:chevrondown' : 'utility:chevronright';
    }

    get productRecommendationsIcon() {
        return this.showProductRecommendations ? 'utility:chevrondown' : 'utility:chevronright';
    }

    get expansionIcon() {
        return this.showExpansion ? 'utility:chevrondown' : 'utility:chevronright';
    }

    get architectureIcon() {
        return this.showArchitecture ? 'utility:chevrondown' : 'utility:chevronright';
    }

    get demoIcon() {
        return this.showDemo ? 'utility:chevrondown' : 'utility:chevronright';
    }

    get nextStepsIcon() {
        return this.showNextSteps ? 'utility:chevrondown' : 'utility:chevronright';
    }

    get emailIcon() {
        return this.showEmail ? 'utility:chevrondown' : 'utility:chevronright';
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
