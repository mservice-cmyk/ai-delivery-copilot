/**
 * @description AI-powered UAT Test Case Generator
 * Generates comprehensive UAT test cases from user stories and acceptance criteria
 * @author Salesforce Technical Architect
 * @date 2026-06-17
 */
public with sharing class UATTestCaseGenerator {

    /**
     * @description Generate comprehensive UAT test cases
     * @param request UATTestRequest with user story and acceptance criteria
     * @return UATTestResponse with complete test cases
     */
    public static UATTestResponse generateTestCases(UATTestRequest request) {
        UATTestResponse response = new UATTestResponse();
        response.timestamp = DateTime.now();
        response.generatedBy = 'AI Delivery Copilot - UAT Generator';
        response.request = request;

        // Generate test cases for each acceptance criterion
        response.testCases = generateTestCasesFromAC(request);

        // Add comprehensive negative tests
        response.testCases.addAll(generateNegativeTests(request));

        // Add boundary/edge case tests
        response.testCases.addAll(generateBoundaryTests(request));

        // Calculate metrics
        response.totalTestCases = response.testCases.size();
        response.estimatedExecutionTime = calculateExecutionTime(response.testCases);
        response.personaCoverage = extractPersonas(response.testCases);
        response.priorityDistribution = calculatePriorityDistribution(response.testCases);
        response.confidenceScore = 90;
        response.exportReady = true;

        return response;
    }

    /**
     * @description Generate test cases from acceptance criteria
     */
    private static List<TestCase> generateTestCasesFromAC(UATTestRequest request) {
        List<TestCase> testCases = new List<TestCase>();

        for (Integer i = 0; i < request.acceptanceCriteria.size(); i++) {
            String criterion = request.acceptanceCriteria[i];

            // Generate positive test case for each AC
            TestCase positiveTest = new TestCase();
            positiveTest.testCaseId = 'UAT-' + generateRandomId();
            positiveTest.testScenario = 'Verify ' + extractScenario(criterion, i + 1);
            positiveTest.userStory = request.userStory;
            positiveTest.acceptanceCriterion = criterion;
            positiveTest.testType = 'Positive - Happy Path';
            positiveTest.priority = determinePriority(criterion, i);

            // Generate test steps
            positiveTest.testSteps = generatePositiveTestSteps(criterion, request.userStory);

            // Generate expected results
            positiveTest.expectedResults = generateExpectedResults(criterion);

            // Set execution details
            positiveTest.estimatedDuration = '5-10 minutes';
            positiveTest.persona = extractPersonaFromStory(request.userStory);
            positiveTest.preconditions = generatePreconditions(request.userStory);
            positiveTest.testData = generateTestData(criterion);
            positiveTest.postConditions = generatePostConditions(criterion);

            testCases.add(positiveTest);

            // Generate variation test if AC is complex
            if (isComplexCriterion(criterion)) {
                testCases.add(generateVariationTest(positiveTest, i));
            }
        }

        return testCases;
    }

    /**
     * @description Generate negative test cases
     */
    private static List<TestCase> generateNegativeTests(UATTestRequest request) {
        List<TestCase> negativeTests = new List<TestCase>();

        // Negative test 1: Missing required fields
        TestCase test1 = new TestCase();
        test1.testCaseId = 'UAT-' + generateRandomId();
        test1.testScenario = 'Verify system handles missing required fields';
        test1.userStory = request.userStory;
        test1.testType = 'Negative - Missing Data';
        test1.priority = 'High';
        test1.testSteps = new List<String>{
            'Navigate to the application',
            'Leave required fields empty',
            'Attempt to submit/save',
            'Observe system response'
        };
        test1.expectedResults = new List<String>{
            'System displays field-level error messages',
            'Required fields are highlighted in red',
            'Clear error message indicates which fields are required',
            'No data is saved to the database',
            'User remains on the same page'
        };
        test1.estimatedDuration = '3-5 minutes';
        test1.persona = extractPersonaFromStory(request.userStory);
        negativeTests.add(test1);

        // Negative test 2: Invalid data types
        TestCase test2 = new TestCase();
        test2.testCaseId = 'UAT-' + generateRandomId();
        test2.testScenario = 'Verify system validates data types correctly';
        test2.userStory = request.userStory;
        test2.testType = 'Negative - Invalid Input';
        test2.priority = 'High';
        test2.testSteps = new List<String>{
            'Navigate to the application',
            'Enter invalid data types (text in number field, etc.)',
            'Attempt to submit',
            'Verify validation messages'
        };
        test2.expectedResults = new List<String>{
            'System rejects invalid data types',
            'Specific error messages display for each invalid field',
            'No partial data is saved',
            'Error messages are user-friendly',
            'Cursor focuses on first error field'
        };
        test2.estimatedDuration = '5-8 minutes';
        test2.persona = extractPersonaFromStory(request.userStory);
        negativeTests.add(test2);

        // Negative test 3: Unauthorized access
        TestCase test3 = new TestCase();
        test3.testCaseId = 'UAT-' + generateRandomId();
        test3.testScenario = 'Verify unauthorized users cannot access functionality';
        test3.userStory = request.userStory;
        test3.testType = 'Negative - Security';
        test3.priority = 'Critical';
        test3.testSteps = new List<String>{
            'Login as user without required permissions',
            'Attempt to navigate to the functionality',
            'Try to access via direct URL',
            'Verify access is denied'
        };
        test3.expectedResults = new List<String>{
            'User receives "Insufficient Privileges" message',
            'User is redirected to appropriate page',
            'No data is visible to unauthorized user',
            'Access attempt is logged in audit trail',
            'User sees helpful message about requesting access'
        };
        test3.estimatedDuration = '5-7 minutes';
        test3.persona = 'Unauthorized User';
        negativeTests.add(test3);

        // Negative test 4: Duplicate records
        TestCase test4 = new TestCase();
        test4.testCaseId = 'UAT-' + generateRandomId();
        test4.testScenario = 'Verify system prevents duplicate records';
        test4.userStory = request.userStory;
        test4.testType = 'Negative - Business Rule';
        test4.priority = 'Medium';
        test4.testSteps = new List<String>{
            'Create a new record with specific unique identifier',
            'Save the record',
            'Attempt to create another record with same identifier',
            'Try to save the duplicate',
            'Verify system response'
        };
        test4.expectedResults = new List<String>{
            'System displays duplicate detection warning',
            'Clear message identifies which field(s) are duplicated',
            'Option to view existing record is provided',
            'No duplicate record is created',
            'User can modify identifier to proceed'
        };
        test4.estimatedDuration = '5-8 minutes';
        test4.persona = extractPersonaFromStory(request.userStory);
        negativeTests.add(test4);

        return negativeTests;
    }

    /**
     * @description Generate boundary test cases
     */
    private static List<TestCase> generateBoundaryTests(UATTestRequest request) {
        List<TestCase> boundaryTests = new List<TestCase>();

        // Boundary test 1: Maximum field length
        TestCase test1 = new TestCase();
        test1.testCaseId = 'UAT-' + generateRandomId();
        test1.testScenario = 'Verify system handles maximum field length correctly';
        test1.userStory = request.userStory;
        test1.testType = 'Boundary - Field Length';
        test1.priority = 'Medium';
        test1.testSteps = new List<String>{
            'Navigate to form/interface',
            'Identify field with character limit (e.g., 255 characters)',
            'Enter exactly maximum allowed characters',
            'Save the record',
            'Attempt to enter one character over limit',
            'Verify system behavior'
        };
        test1.expectedResults = new List<String>{
            'System accepts maximum allowed characters',
            'Record saves successfully at maximum length',
            'System prevents entering characters beyond limit',
            'Character counter shows remaining characters',
            'Clear message indicates character limit reached'
        };
        test1.estimatedDuration = '5-8 minutes';
        test1.persona = extractPersonaFromStory(request.userStory);
        boundaryTests.add(test1);

        // Boundary test 2: Large dataset performance
        TestCase test2 = new TestCase();
        test2.testCaseId = 'UAT-' + generateRandomId();
        test2.testScenario = 'Verify system performance with large dataset';
        test2.userStory = request.userStory;
        test2.testType = 'Boundary - Performance';
        test2.priority = 'High';
        test2.testSteps = new List<String>{
            'Create test data with >10,000 records',
            'Navigate to list view/report',
            'Apply filters and search',
            'Sort by different columns',
            'Measure response time'
        };
        test2.expectedResults = new List<String>{
            'Page loads within acceptable time (<3 seconds)',
            'Pagination works correctly',
            'Search returns results within 2 seconds',
            'Sorting completes within 2 seconds',
            'No timeout errors occur',
            'UI remains responsive during operations'
        };
        test2.estimatedDuration = '10-15 minutes';
        test2.persona = extractPersonaFromStory(request.userStory);
        test2.testData = new List<String>{'Large dataset with 10,000+ records'};
        boundaryTests.add(test2);

        // Boundary test 3: Concurrent users
        TestCase test3 = new TestCase();
        test3.testCaseId = 'UAT-' + generateRandomId();
        test3.testScenario = 'Verify system handles concurrent user access';
        test3.userStory = request.userStory;
        test3.testType = 'Boundary - Concurrency';
        test3.priority = 'High';
        test3.testSteps = new List<String>{
            'Have 2+ users login simultaneously',
            'Both users navigate to same record',
            'User 1 begins editing record',
            'User 2 also begins editing same record',
            'Both users save changes',
            'Verify conflict handling'
        };
        test3.expectedResults = new List<String>{
            'System detects concurrent edit conflict',
            'Clear warning message appears for second user',
            'Data integrity is maintained (no data loss)',
            'Users can see who is editing record',
            'Lock mechanism prevents data corruption',
            'Users can refresh to see latest changes'
        };
        test3.estimatedDuration = '10-12 minutes';
        test3.persona = 'Multiple Users';
        boundaryTests.add(test3);

        // Boundary test 4: Minimum values
        TestCase test4 = new TestCase();
        test4.testCaseId = 'UAT-' + generateRandomId();
        test4.testScenario = 'Verify system handles minimum values and empty states';
        test4.userStory = request.userStory;
        test4.testType = 'Boundary - Minimum Values';
        test4.priority = 'Medium';
        test4.testSteps = new List<String>{
            'Enter minimum allowed values in numeric fields',
            'Leave optional fields empty',
            'Test with zero quantities/amounts',
            'Save and verify',
            'Test negative numbers if applicable'
        };
        test4.expectedResults = new List<String>{
            'System accepts valid minimum values',
            'Zero values are handled correctly',
            'Optional empty fields don\'t cause errors',
            'Negative numbers are rejected if not allowed',
            'Appropriate validation messages display',
            'Data is stored accurately'
        };
        test4.estimatedDuration = '5-8 minutes';
        test4.persona = extractPersonaFromStory(request.userStory);
        boundaryTests.add(test4);

        return boundaryTests;
    }

    // Helper methods

    private static List<String> generatePositiveTestSteps(String criterion, String userStory) {
        List<String> steps = new List<String>{
            'Login to Salesforce with appropriate user credentials',
            'Navigate to the application/feature',
            'Verify all required elements are visible',
            'Perform the action described in acceptance criteria',
            'Complete all required fields with valid data',
            'Click Save/Submit button',
            'Verify success message displays',
            'Confirm data is saved correctly'
        };
        return steps;
    }

    private static List<String> generateExpectedResults(String criterion) {
        List<String> results = new List<String>{
            'User can successfully complete the action',
            'All data is saved accurately',
            'Success message/confirmation displays',
            'Page updates/refreshes appropriately',
            'No error messages appear',
            'Related records are updated as expected',
            'Audit trail records the action'
        };
        return results;
    }

    private static List<String> generatePreconditions(String userStory) {
        return new List<String>{
            'User has valid Salesforce login credentials',
            'User has appropriate permissions/licenses',
            'Test data is available and valid',
            'System is accessible and stable',
            'Browser is supported (Chrome, Firefox, Safari, Edge)'
        };
    }

    private static List<String> generateTestData(String criterion) {
        return new List<String>{
            'Valid test user account',
            'Sample data records (minimum 3)',
            'Valid input values for all fields',
            'Reference data (lookups, picklists)',
            'Test environment configured'
        };
    }

    private static List<String> generatePostConditions(String criterion) {
        return new List<String>{
            'Data is saved in database',
            'System state is consistent',
            'Test data can be cleaned up or reused',
            'No orphaned records exist'
        };
    }

    private static String extractScenario(String criterion, Integer index) {
        if (criterion.contains('WHEN')) {
            Integer startIdx = criterion.indexOf('WHEN') + 5;
            Integer endIdx = criterion.contains('THEN') ? criterion.indexOf('THEN') : criterion.length();
            return criterion.substring(startIdx, endIdx).trim();
        }
        return 'acceptance criterion ' + index;
    }

    private static String extractPersonaFromStory(String userStory) {
        if (userStory.contains('As a ') || userStory.contains('As an ')) {
            Integer startIdx = userStory.contains('As a ') ? userStory.indexOf('As a ') + 5 : userStory.indexOf('As an ') + 6;
            Integer endIdx = userStory.indexOf('\n', startIdx);
            if (endIdx == -1) endIdx = userStory.length();
            String extracted = userStory.substring(startIdx, endIdx).trim();
            if (extracted.length() > 50) extracted = 'User';
            return extracted;
        }
        return 'User';
    }

    private static Boolean isComplexCriterion(String criterion) {
        return criterion.contains('AND') || criterion.length() > 150;
    }

    private static TestCase generateVariationTest(TestCase baseTest, Integer index) {
        TestCase variation = new TestCase();
        variation.testCaseId = 'UAT-' + generateRandomId();
        variation.testScenario = baseTest.testScenario + ' - Alternative Path';
        variation.userStory = baseTest.userStory;
        variation.acceptanceCriterion = baseTest.acceptanceCriterion;
        variation.testType = 'Positive - Alternative Flow';
        variation.priority = 'Medium';
        variation.testSteps = baseTest.testSteps.clone();
        variation.testSteps.add('Verify alternative path works correctly');
        variation.expectedResults = baseTest.expectedResults.clone();
        variation.estimatedDuration = '5-8 minutes';
        variation.persona = baseTest.persona;
        return variation;
    }

    private static String determinePriority(String criterion, Integer index) {
        if (criterion.containsIgnoreCase('security') || criterion.containsIgnoreCase('critical')) {
            return 'Critical';
        } else if (index == 0 || criterion.containsIgnoreCase('must')) {
            return 'High';
        } else if (criterion.containsIgnoreCase('should')) {
            return 'Medium';
        }
        return 'Medium';
    }

    private static String generateRandomId() {
        Integer randomNum = (Integer)(Math.random() * 10000);
        return String.valueOf(randomNum).leftPad(4, '0');
    }

    private static String calculateExecutionTime(List<TestCase> testCases) {
        Integer totalMinutes = 0;
        for (TestCase tc : testCases) {
            String duration = tc.estimatedDuration;
            if (duration.contains('-')) {
                String avgTime = duration.split('-')[1].trim().replace(' minutes', '');
                totalMinutes += Integer.valueOf(avgTime);
            }
        }
        Integer hours = totalMinutes / 60;
        Integer minutes = Math.mod(totalMinutes, 60);
        return hours + ' hours ' + minutes + ' minutes';
    }

    private static List<String> extractPersonas(List<TestCase> testCases) {
        Set<String> personaSet = new Set<String>();
        for (TestCase tc : testCases) {
            if (String.isNotBlank(tc.persona)) {
                personaSet.add(tc.persona);
            }
        }
        return new List<String>(personaSet);
    }

    private static Map<String, Integer> calculatePriorityDistribution(List<TestCase> testCases) {
        Map<String, Integer> distribution = new Map<String, Integer>{
            'Critical' => 0,
            'High' => 0,
            'Medium' => 0,
            'Low' => 0
        };
        for (TestCase tc : testCases) {
            Integer current = distribution.get(tc.priority);
            distribution.put(tc.priority, current + 1);
        }
        return distribution;
    }

    // Wrapper Classes

    /**
     * @description Input request wrapper
     */
    public class UATTestRequest {
        public String userStory { get; set; }
        public List<String> acceptanceCriteria { get; set; }

        public UATTestRequest() {
            this.acceptanceCriteria = new List<String>();
        }
    }

    /**
     * @description Test case wrapper
     */
    public class TestCase {
        public String testCaseId { get; set; }
        public String testScenario { get; set; }
        public String userStory { get; set; }
        public String acceptanceCriterion { get; set; }
        public String testType { get; set; }
        public String priority { get; set; }
        public List<String> testSteps { get; set; }
        public List<String> expectedResults { get; set; }
        public List<String> preconditions { get; set; }
        public List<String> testData { get; set; }
        public List<String> postConditions { get; set; }
        public String estimatedDuration { get; set; }
        public String persona { get; set; }

        public TestCase() {
            this.testSteps = new List<String>();
            this.expectedResults = new List<String>();
            this.preconditions = new List<String>();
            this.testData = new List<String>();
            this.postConditions = new List<String>();
        }
    }

    /**
     * @description Output response wrapper
     */
    public class UATTestResponse {
        public DateTime timestamp { get; set; }
        public String generatedBy { get; set; }
        public UATTestRequest request { get; set; }
        public List<TestCase> testCases { get; set; }
        public Integer totalTestCases { get; set; }
        public String estimatedExecutionTime { get; set; }
        public List<String> personaCoverage { get; set; }
        public Map<String, Integer> priorityDistribution { get; set; }
        public Integer confidenceScore { get; set; }
        public Boolean exportReady { get; set; }

        public UATTestResponse() {
            this.testCases = new List<TestCase>();
            this.personaCoverage = new List<String>();
            this.priorityDistribution = new Map<String, Integer>();
        }
    }
}
