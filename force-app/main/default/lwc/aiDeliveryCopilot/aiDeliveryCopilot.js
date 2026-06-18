import { LightningElement, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class AiDeliveryCopilot extends NavigationMixin(LightningElement) {
    @track isLoading = false;

    // Mock Dashboard Metrics
    totalRequests = 247;
    timeSaved = 156;
    deliveryScore = 87;
    readinessStatus = 'On Track';

    // Readiness Progress
    userStoriesProgress = 92;
    testCoverageProgress = 85;
    documentationProgress = 84;

    // Recent AI Requests (Mock Data)
    recentRequests = [
        {
            id: 'req-1',
            title: 'Generate UAT test scenarios for Customer Portal',
            timeAgo: '5 minutes ago',
            type: 'UAT Testing',
            icon: 'utility:check',
            iconClass: 'icon-success',
            statusIcon: 'utility:success',
            statusClass: 'status-badge status-success'
        },
        {
            id: 'req-2',
            title: 'Create executive status report for Q2 delivery',
            timeAgo: '23 minutes ago',
            type: 'Executive Status',
            icon: 'utility:graph',
            iconClass: 'icon-info',
            statusIcon: 'utility:success',
            statusClass: 'status-badge status-success'
        },
        {
            id: 'req-3',
            title: 'Generate RAID log for integration project',
            timeAgo: '1 hour ago',
            type: 'RAID Log',
            icon: 'utility:warning',
            iconClass: 'icon-warning',
            statusIcon: 'utility:success',
            statusClass: 'status-badge status-success'
        },
        {
            id: 'req-4',
            title: 'Customer meeting prep for enterprise client',
            timeAgo: '2 hours ago',
            type: 'Meeting Prep',
            icon: 'utility:groups',
            iconClass: 'icon-default',
            statusIcon: 'utility:success',
            statusClass: 'status-badge status-success'
        },
        {
            id: 'req-5',
            title: 'Generate user stories for mobile app feature',
            timeAgo: '3 hours ago',
            type: 'User Stories',
            icon: 'utility:list',
            iconClass: 'icon-success',
            statusIcon: 'utility:success',
            statusClass: 'status-badge status-success'
        }
    ];

    // Feature Cards (All Tools)
    featureCards = [
        {
            id: 'user-stories',
            title: 'User Story Generator',
            description: 'Create comprehensive user stories with acceptance criteria and story points',
            icon: 'utility:list',
            colorClass: 'green',
            badge: 'Popular',
            badgeClass: 'badge-success',
            usageCount: 89,
            satisfaction: 94,
            isLoading: false,
            isNavigate: true
        },
        {
            id: 'uat-test-generator',
            title: 'UAT Test Generator',
            description: 'Generate comprehensive UAT test scenarios with persona coverage and test data',
            icon: 'utility:check',
            colorClass: 'blue',
            badge: 'Active',
            badgeClass: 'badge-info',
            usageCount: 67,
            satisfaction: 91,
            isLoading: false,
            isNavigate: true
        },
        {
            id: 'executive-status',
            title: 'Executive Status Generator',
            description: 'Generate executive-level status reports with key metrics and insights',
            icon: 'utility:graph',
            colorClass: 'purple',
            badge: 'Trending',
            badgeClass: 'badge-warning',
            usageCount: 54,
            satisfaction: 89,
            isLoading: false,
            isNavigate: true
        },
        {
            id: 'raid-log',
            title: 'RAID Generator',
            description: 'Create Risks, Assumptions, Issues, and Dependencies tracking log',
            icon: 'utility:warning',
            colorClass: 'orange',
            badge: 'New',
            badgeClass: 'badge-new',
            usageCount: 42,
            satisfaction: 92,
            isLoading: false,
            isNavigate: true
        },
        {
            id: 'meeting-prep',
            title: 'Customer Meeting Prep',
            description: 'Prepare comprehensive customer meeting materials and talking points',
            icon: 'utility:groups',
            colorClass: 'teal',
            badge: 'Essential',
            badgeClass: 'badge-default',
            usageCount: 38,
            satisfaction: 96,
            isLoading: false,
            isNavigate: true
        },
        {
            id: 'test-cases',
            title: 'Test Case Generator',
            description: 'Build detailed test cases with test data and expected outcomes',
            icon: 'utility:checkbox',
            colorClass: 'blue',
            badge: 'Available',
            badgeClass: 'badge-neutral',
            usageCount: 31,
            satisfaction: 88,
            isLoading: false,
            isNavigate: false
        }
    ];

    // Most Used Features (Mock Data)
    mostUsedFeatures = [
        {
            id: 'mu-1',
            rank: '1',
            name: 'User Story Generator',
            count: 89,
            icon: 'utility:list',
            barStyle: 'width: 100%;'
        },
        {
            id: 'mu-2',
            rank: '2',
            name: 'UAT Test Generator',
            count: 67,
            icon: 'utility:check',
            barStyle: 'width: 75%;'
        },
        {
            id: 'mu-3',
            rank: '3',
            name: 'Executive Status',
            count: 54,
            icon: 'utility:graph',
            barStyle: 'width: 61%;'
        },
        {
            id: 'mu-4',
            rank: '4',
            name: 'RAID Generator',
            count: 42,
            icon: 'utility:warning',
            barStyle: 'width: 47%;'
        },
        {
            id: 'mu-5',
            rank: '5',
            name: 'Meeting Prep',
            count: 38,
            icon: 'utility:groups',
            barStyle: 'width: 43%;'
        }
    ];

    // Quick Actions
    quickActions = [
        { id: 'qa-1', label: 'New Request', icon: 'utility:add' },
        { id: 'qa-2', label: 'View History', icon: 'utility:history' },
        { id: 'qa-3', label: 'Settings', icon: 'utility:settings' },
        { id: 'qa-4', label: 'Help & Docs', icon: 'utility:info' },
        { id: 'qa-5', label: 'Export Data', icon: 'utility:download' },
        { id: 'qa-6', label: 'Share Report', icon: 'utility:share' }
    ];

    // Computed Properties
    get hasRecentRequests() {
        return this.recentRequests && this.recentRequests.length > 0;
    }

    get hasMostUsedFeatures() {
        return this.mostUsedFeatures && this.mostUsedFeatures.length > 0;
    }

    get readinessCircleStyle() {
        // SVG circle circumference: 2 * π * r = 2 * 3.14159 * 50 = 314.159
        const circumference = 314.159;
        const offset = circumference - (this.deliveryScore / 100) * circumference;
        return `stroke-dasharray: ${circumference}; stroke-dashoffset: ${offset};`;
    }

    // Event Handlers
    handleFeatureLaunch(event) {
        const featureId = event.currentTarget.dataset.id;
        const feature = this.featureCards.find(f => f.id === featureId);

        if (!feature) return;

        // Set loading state for the specific card
        this.featureCards = this.featureCards.map(f => ({
            ...f,
            isLoading: f.id === featureId
        }));

        // Navigate based on feature
        setTimeout(() => {
            if (feature.isNavigate) {
                switch (featureId) {
                    case 'user-stories':
                        this.navigateToUserStoryGenerator();
                        break;
                    case 'uat-test-generator':
                        this.navigateToUATGenerator();
                        break;
                    case 'executive-status':
                        this.navigateToExecutiveStatusGenerator();
                        break;
                    case 'raid-log':
                        this.navigateToRAIDGenerator();
                        break;
                    case 'meeting-prep':
                        this.navigateToCustomerMeetingPrep();
                        break;
                    default:
                        break;
                }
            }

            // Clear loading state
            this.featureCards = this.featureCards.map(f => ({
                ...f,
                isLoading: false
            }));
        }, 500);
    }

    handleQuickAction(event) {
        const actionId = event.currentTarget.dataset.id;
        console.log('Quick action clicked:', actionId);
        // Add quick action handling logic here
    }

    // Navigation Methods
    navigateToUserStoryGenerator() {
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                componentName: 'c__aiDeliveryCopilot'
            },
            state: {
                c__view: 'userStories'
            }
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

    navigateToCustomerMeetingPrep() {
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                componentName: 'c__aiCustomerMeetingPrep'
            }
        });
    }
}
