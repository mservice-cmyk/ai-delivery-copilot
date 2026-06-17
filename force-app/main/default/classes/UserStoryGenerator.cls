/**
 * @description AI-powered User Story Generator
 * Generates comprehensive user stories with epic, acceptance criteria, and edge cases
 * @author Salesforce Technical Architect
 * @date 2026-06-17
 */
public with sharing class UserStoryGenerator {

    /**
     * @description Generate comprehensive user stories from business requirements
     * @param request UserStoryRequest with business context
     * @return UserStoryResponse with complete user stories
     */
    public static UserStoryResponse generateUserStories(UserStoryRequest request) {
        UserStoryResponse response = new UserStoryResponse();
        response.timestamp = DateTime.now();
        response.generatedBy = 'AI Delivery Copilot';
        response.request = request;

        // Generate Epic
        response.epic = generateEpic(request);

        // Generate User Stories
        response.userStories = generateStories(request);

        // Generate metadata
        response.totalStories = response.userStories.size();
        response.estimatedStoryPoints = calculateTotalPoints(response.userStories);
        response.confidenceScore = 88;
        response.readyForJira = true;

        return response;
    }

    /**
     * @description Generate Epic from business requirement
     */
    private static Epic generateEpic(UserStoryRequest request) {
        Epic epic = new Epic();
        epic.epicId = 'EPIC-' + generateRandomId();
        String requirement = String.isNotBlank(request.businessRequirement) ? request.businessRequirement : 'Business Requirement';
        String process = String.isNotBlank(request.businessProcess) ? request.businessProcess : 'business process';
        String personaName = String.isNotBlank(request.persona) ? request.persona : 'User';

        epic.title = 'Implement ' + requirement;
        epic.description = 'As a business stakeholder, I want to ' + requirement.toLowerCase() +
            ' so that we can improve ' + process + ' efficiency and user experience.';
        epic.businessValue = determineBusinessValue(request);
        epic.targetRelease = 'Q3 2026';
        epic.estimatedEffort = 'Large (3-6 months)';
        epic.strategicAlignment = 'High';
        epic.affectedPersonas = new List<String>{ personaName };

        return epic;
    }

    /**
     * @description Generate detailed user stories
     */
    private static List<UserStory> generateStories(UserStoryRequest request) {
        List<UserStory> stories = new List<UserStory>();

        // Story 1: Core Functionality
        stories.add(createCoreStory(request));

        // Story 2: Data Management
        stories.add(createDataManagementStory(request));

        // Story 3: User Interface
        stories.add(createUIStory(request));

        // Story 4: Security & Access
        stories.add(createSecurityStory(request));

        // Story 5: Integration
        stories.add(createIntegrationStory(request));

        // Story 6: Reporting & Analytics
        stories.add(createReportingStory(request));

        return stories;
    }

    /**
     * @description Create core functionality user story
     */
    private static UserStory createCoreStory(UserStoryRequest request) {
        UserStory story = new UserStory();
        story.storyId = 'US-' + generateRandomId();
        story.title = 'Core ' + request.businessRequirement + ' Functionality';
        story.asA = request.persona;
        story.iWant = 'to ' + request.businessRequirement.toLowerCase();
        story.soThat = 'I can streamline my ' + request.businessProcess + ' workflow';
        story.priority = 'High';
        story.storyPoints = 8;

        // Acceptance Criteria
        story.acceptanceCriteria = new List<String>{
            'GIVEN I am logged in as a ' + request.persona,
            'WHEN I access the ' + request.businessProcess + ' interface',
            'THEN I can view all relevant ' + String.join(request.objects, ', ') + ' data',
            'AND the system responds within 2 seconds',
            'AND all fields are properly validated'
        };

        // Dependencies
        story.dependencies = new List<String>{
            'Salesforce org with ' + String.join(request.objects, ', ') + ' objects configured',
            'User profile and permission sets configured',
            'Development environment set up'
        };

        // Edge Cases
        story.edgeCases = new List<String>{
            'User attempts to access without proper permissions',
            'Large dataset (>10,000 records) performance',
            'Concurrent user access scenarios',
            'System handles null or missing field values gracefully',
            'Mobile device compatibility'
        };

        // Definition of Done
        story.definitionOfDone = new List<String>{
            'Code reviewed and approved by Tech Lead',
            'Unit tests written with >80% coverage',
            'Integration tests passing',
            'UAT completed and signed off by Product Owner',
            'Documentation updated',
            'Security review completed',
            'Deployed to staging environment'
        };

        // Negative Scenarios
        story.negativeScenarios = new List<String>{
            'System displays error when required fields are missing',
            'Unauthorized users receive 401 error',
            'Invalid data types are rejected with clear error messages',
            'System handles timeout gracefully without data loss',
            'Duplicate records trigger validation error'
        };

        // Technical Notes
        story.technicalNotes = 'Implement using Lightning Web Components with Apex backend. ' +
            'Consider platform caching for performance optimization.';

        return story;
    }

    /**
     * @description Create data management user story
     */
    private static UserStory createDataManagementStory(UserStoryRequest request) {
        UserStory story = new UserStory();
        story.storyId = 'US-' + generateRandomId();
        story.title = 'Data Management for ' + String.join(request.objects, ' and ');
        story.asA = request.persona;
        story.iWant = 'to create, read, update, and delete ' + String.join(request.objects, ', ') + ' records';
        story.soThat = 'I can maintain accurate data throughout the ' + request.businessProcess;
        story.priority = 'High';
        story.storyPoints = 13;

        String firstObject = !request.objects.isEmpty() ? request.objects[0] : 'record';
        story.acceptanceCriteria = new List<String>{
            'GIVEN I have edit permissions',
            'WHEN I create a new ' + firstObject + ' record',
            'THEN all required fields are validated',
            'AND the record is saved with proper audit trail',
            'AND related records are updated automatically',
            'AND I receive confirmation of successful save'
        };

        story.dependencies = new List<String>{
            'Core functionality story completed',
            'Data model finalized for ' + String.join(request.objects, ', '),
            'Validation rules configured',
            'Workflow automation designed'
        };

        story.edgeCases = new List<String>{
            'Bulk data operations (>200 records)',
            'Concurrent updates to same record',
            'Related record dependencies',
            'Required fields with conditional logic',
            'Data migration scenarios'
        };

        story.definitionOfDone = new List<String>{
            'CRUD operations functional for all objects',
            'Field-level security enforced',
            'Trigger handlers implemented and tested',
            'Bulk API tested with production-like volumes',
            'Error handling implemented',
            'Rollback procedures documented'
        };

        story.negativeScenarios = new List<String>{
            'System prevents deletion of records with dependencies',
            'Validation errors display field-level messages',
            'Concurrent edit conflicts handled with clear notification',
            'Governor limits respected with proper batch processing',
            'Failed transactions rollback completely'
        };

        story.technicalNotes = 'Use trigger framework for maintainability. Implement bulkification patterns.';

        return story;
    }

    /**
     * @description Create UI/UX user story
     */
    private static UserStory createUIStory(UserStoryRequest request) {
        UserStory story = new UserStory();
        story.storyId = 'US-' + generateRandomId();
        story.title = 'Intuitive User Interface for ' + request.businessProcess;
        story.asA = request.persona;
        story.iWant = 'a user-friendly interface to ' + request.businessRequirement.toLowerCase();
        story.soThat = 'I can work efficiently without extensive training';
        story.priority = 'Medium';
        story.storyPoints = 5;

        story.acceptanceCriteria = new List<String>{
            'GIVEN I access the application',
            'WHEN I navigate through the interface',
            'THEN all elements follow SLDS design patterns',
            'AND the interface is responsive on all devices',
            'AND helpful tooltips guide me through the process',
            'AND keyboard navigation is fully supported'
        };

        story.dependencies = new List<String>{
            'UX mockups approved',
            'SLDS component library available',
            'Accessibility requirements documented'
        };

        story.edgeCases = new List<String>{
            'Screen reader compatibility',
            'Browser compatibility (Chrome, Firefox, Safari, Edge)',
            'Touch device interaction',
            'High contrast mode support',
            'Different screen resolutions (1920x1080 to 360x640)'
        };

        story.definitionOfDone = new List<String>{
            'WCAG 2.1 AA compliance verified',
            'Responsive design tested on multiple devices',
            'Cross-browser testing completed',
            'User acceptance testing passed',
            'Style guide compliance verified',
            'Performance metrics met (< 3s load time)'
        };

        story.negativeScenarios = new List<String>{
            'Graceful degradation on unsupported browsers',
            'Error messages are user-friendly and actionable',
            'Loading states prevent duplicate submissions',
            'Form validation prevents submission of incomplete data'
        };

        story.technicalNotes = 'Use Lightning Web Components with SLDS. Optimize for Core Web Vitals.';

        return story;
    }

    /**
     * @description Create security and access control story
     */
    private static UserStory createSecurityStory(UserStoryRequest request) {
        UserStory story = new UserStory();
        story.storyId = 'US-' + generateRandomId();
        story.title = 'Security and Access Control';
        story.asA = 'System Administrator';
        story.iWant = 'to control access to ' + request.businessRequirement + ' features';
        story.soThat = 'data security and compliance requirements are met';
        story.priority = 'Critical';
        story.storyPoints = 8;

        story.acceptanceCriteria = new List<String>{
            'GIVEN user roles are configured',
            'WHEN a user attempts to access restricted data',
            'THEN the system enforces field-level security',
            'AND sharing rules are respected',
            'AND audit logs capture all access attempts',
            'AND sensitive data is encrypted at rest'
        };

        story.dependencies = new List<String>{
            'Permission sets defined',
            'Sharing model documented',
            'Security review completed',
            'Compliance requirements documented'
        };

        story.edgeCases = new List<String>{
            'Users with multiple roles',
            'External users via community',
            'API access with OAuth',
            'Data export compliance',
            'Right to be forgotten requests'
        };

        story.definitionOfDone = new List<String>{
            'Security review passed',
            'Penetration testing completed',
            'OWASP Top 10 vulnerabilities addressed',
            'Permission sets tested for least privilege',
            'Audit logging verified',
            'Compliance documentation updated'
        };

        story.negativeScenarios = new List<String>{
            'Unauthorized access attempts logged and blocked',
            'SQL injection attempts prevented',
            'XSS attacks mitigated',
            'CSRF tokens validated',
            'Rate limiting enforced on API calls'
        };

        story.technicalNotes = 'Implement with sharing keyword. Use platform encryption where required.';

        return story;
    }

    /**
     * @description Create integration user story
     */
    private static UserStory createIntegrationStory(UserStoryRequest request) {
        UserStory story = new UserStory();
        story.storyId = 'US-' + generateRandomId();
        story.title = 'System Integration for ' + request.businessProcess;
        story.asA = request.persona;
        story.iWant = 'seamless integration with related systems';
        story.soThat = 'data flows automatically without manual intervention';
        story.priority = 'Medium';
        story.storyPoints = 13;

        story.acceptanceCriteria = new List<String>{
            'GIVEN external system is available',
            'WHEN data is updated in Salesforce',
            'THEN changes sync to external system within 5 minutes',
            'AND error handling logs failures for retry',
            'AND users are notified of sync status',
            'AND data integrity is maintained'
        };

        story.dependencies = new List<String>{
            'API documentation from external system',
            'Integration user credentials configured',
            'Middleware/ESB requirements identified',
            'Error handling strategy defined'
        };

        story.edgeCases = new List<String>{
            'External system downtime',
            'Network connectivity issues',
            'API rate limit exceeded',
            'Data transformation errors',
            'Large payload handling (>5MB)'
        };

        story.definitionOfDone = new List<String>{
            'Integration tests passing',
            'Error logging implemented',
            'Retry mechanism configured',
            'Monitoring and alerts set up',
            'Performance tested with production volumes',
            'Disaster recovery plan documented'
        };

        story.negativeScenarios = new List<String>{
            'Failed API calls trigger error notifications',
            'Timeout scenarios handled gracefully',
            'Invalid response formats logged and rejected',
            'Authentication failures trigger alerts',
            'Circuit breaker prevents cascading failures'
        };

        story.technicalNotes = 'Use Platform Events or Queueable for async processing. Implement exponential backoff.';

        return story;
    }

    /**
     * @description Create reporting and analytics story
     */
    private static UserStory createReportingStory(UserStoryRequest request) {
        UserStory story = new UserStory();
        story.storyId = 'US-' + generateRandomId();
        story.title = 'Reporting and Analytics';
        story.asA = request.persona;
        story.iWant = 'comprehensive reports and dashboards';
        story.soThat = 'I can make data-driven decisions about ' + request.businessProcess;
        story.priority = 'Medium';
        story.storyPoints = 5;

        story.acceptanceCriteria = new List<String>{
            'GIVEN data is available in ' + String.join(request.objects, ', '),
            'WHEN I access the analytics dashboard',
            'THEN I see real-time metrics and trends',
            'AND I can filter by date range and other criteria',
            'AND reports can be exported to PDF and Excel',
            'AND dashboards refresh automatically'
        };

        story.dependencies = new List<String>{
            'Reporting requirements documented',
            'Data model optimized for reporting',
            'Einstein Analytics licensed (if needed)',
            'Sample data available for testing'
        };

        story.edgeCases = new List<String>{
            'Large datasets (>1M records)',
            'Complex aggregations',
            'Custom fiscal year calendars',
            'Multi-currency scenarios',
            'Historical data comparisons'
        };

        story.definitionOfDone = new List<String>{
            'All required reports created',
            'Dashboard components configured',
            'Performance tested with large datasets',
            'Export functionality working',
            'Scheduled reports configured',
            'User training completed'
        };

        story.negativeScenarios = new List<String>{
            'Reports handle null values gracefully',
            'Long-running queries timeout with notification',
            'Export size limits enforced',
            'Invalid filter criteria display error message',
            'Missing data shows "No Data Available" message'
        };

        story.technicalNotes = 'Consider Report Types for complex queries. Use Dashboard Filters for flexibility.';

        return story;
    }

    // Helper methods

    private static String generateRandomId() {
        Integer randomNum = (Integer)(Math.random() * 10000);
        return String.valueOf(randomNum).leftPad(4, '0');
    }

    private static String determineBusinessValue(UserStoryRequest request) {
        if (request.businessRequirement.containsIgnoreCase('customer') ||
            request.businessRequirement.containsIgnoreCase('revenue')) {
            return 'High - Direct customer/revenue impact';
        } else if (request.businessRequirement.containsIgnoreCase('efficiency') ||
                   request.businessRequirement.containsIgnoreCase('automat')) {
            return 'Medium-High - Operational efficiency gains';
        }
        return 'Medium - Process improvement';
    }

    private static Integer calculateTotalPoints(List<UserStory> stories) {
        Integer total = 0;
        for (UserStory story : stories) {
            total += story.storyPoints;
        }
        return total;
    }

    /**
     * @description Input request wrapper class
     */
    public class UserStoryRequest {
        public String businessRequirement { get; set; }
        public String persona { get; set; }
        public String businessProcess { get; set; }
        public List<String> objects { get; set; }

        public UserStoryRequest() {
            this.objects = new List<String>();
        }
    }

    /**
     * @description Epic wrapper class
     */
    public class Epic {
        public String epicId { get; set; }
        public String title { get; set; }
        public String description { get; set; }
        public String businessValue { get; set; }
        public String targetRelease { get; set; }
        public String estimatedEffort { get; set; }
        public String strategicAlignment { get; set; }
        public List<String> affectedPersonas { get; set; }
    }

    /**
     * @description User Story wrapper class
     */
    public class UserStory {
        public String storyId { get; set; }
        public String title { get; set; }
        public String asA { get; set; }
        public String iWant { get; set; }
        public String soThat { get; set; }
        public String priority { get; set; }
        public Integer storyPoints { get; set; }
        public List<String> acceptanceCriteria { get; set; }
        public List<String> dependencies { get; set; }
        public List<String> edgeCases { get; set; }
        public List<String> definitionOfDone { get; set; }
        public List<String> negativeScenarios { get; set; }
        public String technicalNotes { get; set; }

        public UserStory() {
            this.acceptanceCriteria = new List<String>();
            this.dependencies = new List<String>();
            this.edgeCases = new List<String>();
            this.definitionOfDone = new List<String>();
            this.negativeScenarios = new List<String>();
        }
    }

    /**
     * @description Output response wrapper class
     */
    public class UserStoryResponse {
        public DateTime timestamp { get; set; }
        public String generatedBy { get; set; }
        public UserStoryRequest request { get; set; }
        public Epic epic { get; set; }
        public List<UserStory> userStories { get; set; }
        public Integer totalStories { get; set; }
        public Integer estimatedStoryPoints { get; set; }
        public Integer confidenceScore { get; set; }
        public Boolean readyForJira { get; set; }

        public UserStoryResponse() {
            this.userStories = new List<UserStory>();
        }
    }
}
