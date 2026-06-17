/**
 * @description Test class for UATTestCaseGenerator
 * @author Salesforce Technical Architect
 * @date 2026-06-17
 */
@isTest
private class UATTestCaseGeneratorTest {

    @isTest
    static void testGenerateTestCases_Success() {
        UATTestCaseGenerator.UATTestRequest request = createSampleRequest();

        Test.startTest();
        UATTestCaseGenerator.UATTestResponse response =
            UATTestCaseGenerator.generateTestCases(request);
        Test.stopTest();

        Assert.isNotNull(response, 'Response should not be null');
        Assert.isNotNull(response.timestamp, 'Timestamp should be set');
        Assert.isTrue(response.testCases.size() > 0, 'Should generate test cases');
        Assert.isTrue(response.totalTestCases > 0, 'Total count should be set');
        Assert.areEqual(true, response.exportReady, 'Should be export ready');
    }

    @isTest
    static void testGenerateTestCases_MultipleAC() {
        UATTestCaseGenerator.UATTestRequest request = createSampleRequest();
        request.acceptanceCriteria = new List<String>{
            'GIVEN user is logged in WHEN user clicks submit THEN record saves',
            'GIVEN form is valid WHEN validation runs THEN no errors display',
            'GIVEN data exists WHEN user searches THEN results appear'
        };

        Test.startTest();
        UATTestCaseGenerator.UATTestResponse response =
            UATTestCaseGenerator.generateTestCases(request);
        Test.stopTest();

        Assert.isTrue(response.testCases.size() >= 3,
            'Should generate at least one test per AC');
    }

    @isTest
    static void testTestCaseTypes() {
        UATTestCaseGenerator.UATTestRequest request = createSampleRequest();

        Test.startTest();
        UATTestCaseGenerator.UATTestResponse response =
            UATTestCaseGenerator.generateTestCases(request);
        Test.stopTest();

        Set<String> testTypes = new Set<String>();
        for (UATTestCaseGenerator.TestCase tc : response.testCases) {
            testTypes.add(tc.testType);
        }

        Assert.isTrue(testTypes.contains('Positive - Happy Path'),
            'Should have positive tests');
        Assert.isTrue(testTypes.size() > 1, 'Should have multiple test types');
    }

    @isTest
    static void testNegativeTestGeneration() {
        UATTestCaseGenerator.UATTestRequest request = createSampleRequest();

        Test.startTest();
        UATTestCaseGenerator.UATTestResponse response =
            UATTestCaseGenerator.generateTestCases(request);
        Test.stopTest();

        Integer negativeCount = 0;
        for (UATTestCaseGenerator.TestCase tc : response.testCases) {
            if (tc.testType.contains('Negative')) {
                negativeCount++;
            }
        }

        Assert.isTrue(negativeCount >= 4, 'Should generate multiple negative tests');
    }

    @isTest
    static void testBoundaryTestGeneration() {
        UATTestCaseGenerator.UATTestRequest request = createSampleRequest();

        Test.startTest();
        UATTestCaseGenerator.UATTestResponse response =
            UATTestCaseGenerator.generateTestCases(request);
        Test.stopTest();

        Integer boundaryCount = 0;
        for (UATTestCaseGenerator.TestCase tc : response.testCases) {
            if (tc.testType.contains('Boundary')) {
                boundaryCount++;
            }
        }

        Assert.isTrue(boundaryCount >= 4, 'Should generate multiple boundary tests');
    }

    @isTest
    static void testTestCaseStructure() {
        UATTestCaseGenerator.UATTestRequest request = createSampleRequest();

        Test.startTest();
        UATTestCaseGenerator.UATTestResponse response =
            UATTestCaseGenerator.generateTestCases(request);
        Test.stopTest();

        for (UATTestCaseGenerator.TestCase tc : response.testCases) {
            Assert.isNotNull(tc.testCaseId, 'Test case ID should be set');
            Assert.isTrue(tc.testCaseId.startsWith('UAT-'),
                'Test case ID should have correct prefix');
            Assert.isNotNull(tc.testScenario, 'Test scenario should be set');
            Assert.isNotNull(tc.testType, 'Test type should be set');
            Assert.isNotNull(tc.priority, 'Priority should be set');
            Assert.isTrue(tc.testSteps.size() > 0, 'Should have test steps');
            Assert.isTrue(tc.expectedResults.size() > 0, 'Should have expected results');
        }
    }

    @isTest
    static void testTestSteps() {
        UATTestCaseGenerator.UATTestRequest request = createSampleRequest();

        Test.startTest();
        UATTestCaseGenerator.UATTestResponse response =
            UATTestCaseGenerator.generateTestCases(request);
        Test.stopTest();

        for (UATTestCaseGenerator.TestCase tc : response.testCases) {
            Assert.isNotNull(tc.testSteps, 'Test steps should not be null');
            Assert.isTrue(tc.testSteps.size() >= 3,
                'Should have at least 3 test steps');
        }
    }

    @isTest
    static void testExpectedResults() {
        UATTestCaseGenerator.UATTestRequest request = createSampleRequest();

        Test.startTest();
        UATTestCaseGenerator.UATTestResponse response =
            UATTestCaseGenerator.generateTestCases(request);
        Test.stopTest();

        for (UATTestCaseGenerator.TestCase tc : response.testCases) {
            Assert.isNotNull(tc.expectedResults, 'Expected results should not be null');
            Assert.isTrue(tc.expectedResults.size() >= 3,
                'Should have at least 3 expected results');
        }
    }

    @isTest
    static void testPreconditions() {
        UATTestCaseGenerator.UATTestRequest request = createSampleRequest();

        Test.startTest();
        UATTestCaseGenerator.UATTestResponse response =
            UATTestCaseGenerator.generateTestCases(request);
        Test.stopTest();

        Boolean hasPreconditions = false;
        for (UATTestCaseGenerator.TestCase tc : response.testCases) {
            if (tc.preconditions != null && tc.preconditions.size() > 0) {
                hasPreconditions = true;
                break;
            }
        }

        Assert.isTrue(hasPreconditions, 'Some tests should have preconditions');
    }

    @isTest
    static void testTestData() {
        UATTestCaseGenerator.UATTestRequest request = createSampleRequest();

        Test.startTest();
        UATTestCaseGenerator.UATTestResponse response =
            UATTestCaseGenerator.generateTestCases(request);
        Test.stopTest();

        Boolean hasTestData = false;
        for (UATTestCaseGenerator.TestCase tc : response.testCases) {
            if (tc.testData != null && tc.testData.size() > 0) {
                hasTestData = true;
                break;
            }
        }

        Assert.isTrue(hasTestData, 'Some tests should have test data specified');
    }

    @isTest
    static void testPersonaCoverage() {
        UATTestCaseGenerator.UATTestRequest request = createSampleRequest();
        request.userStory = 'As a Sales Manager I want to track leads';

        Test.startTest();
        UATTestCaseGenerator.UATTestResponse response =
            UATTestCaseGenerator.generateTestCases(request);
        Test.stopTest();

        Assert.isNotNull(response.personaCoverage, 'Persona coverage should be set');
        Assert.isTrue(response.personaCoverage.size() > 0,
            'Should identify at least one persona');
    }

    @isTest
    static void testPriorityDistribution() {
        UATTestCaseGenerator.UATTestRequest request = createSampleRequest();

        Test.startTest();
        UATTestCaseGenerator.UATTestResponse response =
            UATTestCaseGenerator.generateTestCases(request);
        Test.stopTest();

        Assert.isNotNull(response.priorityDistribution,
            'Priority distribution should be set');
        Assert.isTrue(response.priorityDistribution.size() > 0,
            'Should have priority distribution');

        Integer totalCount = 0;
        for (Integer count : response.priorityDistribution.values()) {
            totalCount += count;
        }
        Assert.areEqual(response.totalTestCases, totalCount,
            'Priority counts should match total test cases');
    }

    @isTest
    static void testEstimatedExecutionTime() {
        UATTestCaseGenerator.UATTestRequest request = createSampleRequest();

        Test.startTest();
        UATTestCaseGenerator.UATTestResponse response =
            UATTestCaseGenerator.generateTestCases(request);
        Test.stopTest();

        Assert.isNotNull(response.estimatedExecutionTime,
            'Execution time should be calculated');
        Assert.isTrue(response.estimatedExecutionTime.contains('hour') ||
                     response.estimatedExecutionTime.contains('minute'),
            'Execution time should be in hours/minutes');
    }

    @isTest
    static void testConfidenceScore() {
        UATTestCaseGenerator.UATTestRequest request = createSampleRequest();

        Test.startTest();
        UATTestCaseGenerator.UATTestResponse response =
            UATTestCaseGenerator.generateTestCases(request);
        Test.stopTest();

        Assert.isNotNull(response.confidenceScore, 'Confidence score should be set');
        Assert.isTrue(response.confidenceScore >= 0 && response.confidenceScore <= 100,
            'Confidence score should be 0-100');
    }

    @isTest
    static void testExportReady() {
        UATTestCaseGenerator.UATTestRequest request = createSampleRequest();

        Test.startTest();
        UATTestCaseGenerator.UATTestResponse response =
            UATTestCaseGenerator.generateTestCases(request);
        Test.stopTest();

        Assert.areEqual(true, response.exportReady, 'Should be export ready');

        // Verify export-ready attributes
        for (UATTestCaseGenerator.TestCase tc : response.testCases) {
            Assert.isNotNull(tc.testCaseId, 'ID required for export');
            Assert.isNotNull(tc.testScenario, 'Scenario required for export');
            Assert.isNotNull(tc.priority, 'Priority required for export');
        }
    }

    @isTest
    static void testTestCaseIdUniqueness() {
        UATTestCaseGenerator.UATTestRequest request = createSampleRequest();

        Test.startTest();
        UATTestCaseGenerator.UATTestResponse response =
            UATTestCaseGenerator.generateTestCases(request);
        Test.stopTest();

        Set<String> testCaseIds = new Set<String>();
        for (UATTestCaseGenerator.TestCase tc : response.testCases) {
            Assert.isFalse(testCaseIds.contains(tc.testCaseId),
                'Test case IDs should be unique: ' + tc.testCaseId);
            testCaseIds.add(tc.testCaseId);
        }
    }

    @isTest
    static void testComplexAcceptanceCriteria() {
        UATTestCaseGenerator.UATTestRequest request = createSampleRequest();
        request.acceptanceCriteria = new List<String>{
            'GIVEN user is logged in AND has permissions ' +
            'WHEN user submits form ' +
            'THEN data saves AND email sends AND audit log updates'
        };

        Test.startTest();
        UATTestCaseGenerator.UATTestResponse response =
            UATTestCaseGenerator.generateTestCases(request);
        Test.stopTest();

        Assert.isTrue(response.testCases.size() > 0,
            'Should handle complex criteria');
    }

    @isTest
    static void testSecurityTestPriority() {
        UATTestCaseGenerator.UATTestRequest request = createSampleRequest();
        request.acceptanceCriteria = new List<String>{
            'GIVEN user lacks security permissions WHEN attempting access THEN denied'
        };

        Test.startTest();
        UATTestCaseGenerator.UATTestResponse response =
            UATTestCaseGenerator.generateTestCases(request);
        Test.stopTest();

        Boolean hasCriticalPriority = false;
        for (UATTestCaseGenerator.TestCase tc : response.testCases) {
            if (tc.priority == 'Critical') {
                hasCriticalPriority = true;
                break;
            }
        }

        Assert.isTrue(hasCriticalPriority, 'Security tests should have critical priority');
    }

    @isTest
    static void testRequestConstructor() {
        Test.startTest();
        UATTestCaseGenerator.UATTestRequest request =
            new UATTestCaseGenerator.UATTestRequest();
        Test.stopTest();

        Assert.isNotNull(request.acceptanceCriteria,
            'Acceptance criteria list should be initialized');
        Assert.areEqual(0, request.acceptanceCriteria.size(),
            'Should start empty');
    }

    @isTest
    static void testTestCaseConstructor() {
        Test.startTest();
        UATTestCaseGenerator.TestCase testCase = new UATTestCaseGenerator.TestCase();
        Test.stopTest();

        Assert.isNotNull(testCase.testSteps, 'Test steps should be initialized');
        Assert.isNotNull(testCase.expectedResults, 'Expected results should be initialized');
        Assert.isNotNull(testCase.preconditions, 'Preconditions should be initialized');
        Assert.isNotNull(testCase.testData, 'Test data should be initialized');
        Assert.isNotNull(testCase.postConditions, 'Post conditions should be initialized');
    }

    @isTest
    static void testResponseConstructor() {
        Test.startTest();
        UATTestCaseGenerator.UATTestResponse response =
            new UATTestCaseGenerator.UATTestResponse();
        Test.stopTest();

        Assert.isNotNull(response.testCases, 'Test cases should be initialized');
        Assert.isNotNull(response.personaCoverage, 'Persona coverage should be initialized');
        Assert.isNotNull(response.priorityDistribution,
            'Priority distribution should be initialized');
    }

    @isTest
    static void testEmptyAcceptanceCriteria() {
        UATTestCaseGenerator.UATTestRequest request = new UATTestCaseGenerator.UATTestRequest();
        request.userStory = 'As a user I want functionality';
        request.acceptanceCriteria = new List<String>();

        Test.startTest();
        UATTestCaseGenerator.UATTestResponse response =
            UATTestCaseGenerator.generateTestCases(request);
        Test.stopTest();

        // Should still generate negative and boundary tests even without AC
        Assert.isTrue(response.testCases.size() >= 8,
            'Should generate at least negative and boundary tests');
    }

    @isTest
    static void testDifferentPersonas() {
        List<String> personas = new List<String>{
            'As a Sales Manager',
            'As an Administrator',
            'As a Customer Support Agent'
        };

        Test.startTest();
        for (String persona : personas) {
            UATTestCaseGenerator.UATTestRequest request = createSampleRequest();
            request.userStory = persona + ' I want functionality';

            UATTestCaseGenerator.UATTestResponse response =
                UATTestCaseGenerator.generateTestCases(request);

            Assert.isTrue(response.testCases.size() > 0,
                'Should generate tests for ' + persona);
        }
        Test.stopTest();
    }

    @isTest
    static void testJSONSerialization() {
        UATTestCaseGenerator.UATTestRequest request = createSampleRequest();

        Test.startTest();
        UATTestCaseGenerator.UATTestResponse response =
            UATTestCaseGenerator.generateTestCases(request);
        String jsonResponse = JSON.serialize(response);
        Test.stopTest();

        Assert.isNotNull(jsonResponse, 'JSON should serialize');
        Assert.isTrue(jsonResponse.contains('testCases'), 'Should contain test cases');
        Assert.isTrue(jsonResponse.contains('testScenario'), 'Should contain scenarios');
    }

    // Helper method
    private static UATTestCaseGenerator.UATTestRequest createSampleRequest() {
        UATTestCaseGenerator.UATTestRequest request =
            new UATTestCaseGenerator.UATTestRequest();
        request.userStory = 'As a Sales Manager I want to track customer interactions ' +
            'So that I can improve customer relationships';
        request.acceptanceCriteria = new List<String>{
            'GIVEN user is logged in WHEN user accesses dashboard THEN all data displays',
            'GIVEN form is complete WHEN user saves THEN record is created'
        };
        return request;
    }
}
