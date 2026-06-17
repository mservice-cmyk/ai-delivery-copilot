/**
 * @description Test class for UATTestController
 * @author Salesforce Technical Architect
 * @date 2026-06-17
 */
@isTest
private class UATTestControllerTest {

    @isTest
    static void testGenerateTestCases_Success() {
        String userStory = 'As a Sales Manager I want to track leads';
        String acceptanceCriteria = 'GIVEN user is logged in WHEN user views dashboard THEN data displays\n' +
            'GIVEN form is complete WHEN user saves THEN record is created';

        Test.startTest();
        String result = UATTestController.generateTestCases(userStory, acceptanceCriteria);
        Test.stopTest();

        Assert.isNotNull(result, 'Result should not be null');
        UATTestCaseGenerator.UATTestResponse response =
            (UATTestCaseGenerator.UATTestResponse) JSON.deserialize(
                result,
                UATTestCaseGenerator.UATTestResponse.class
            );

        Assert.isTrue(response.testCases.size() > 0, 'Should generate test cases');
        Assert.areEqual(true, response.exportReady, 'Should be export ready');
    }

    @isTest
    static void testGenerateTestCases_PipeSeparated() {
        String userStory = 'As a user I want functionality';
        String acceptanceCriteria = 'AC 1: Given scenario | AC 2: When action | AC 3: Then result';

        Test.startTest();
        String result = UATTestController.generateTestCases(userStory, acceptanceCriteria);
        Test.stopTest();

        Assert.isNotNull(result, 'Result should not be null');
    }

    @isTest
    static void testGenerateTestCases_EmptyAC() {
        String userStory = 'As a user I want functionality';
        String acceptanceCriteria = '';

        Test.startTest();
        String result = UATTestController.generateTestCases(userStory, acceptanceCriteria);
        Test.stopTest();

        Assert.isNotNull(result, 'Result should not be null');
        UATTestCaseGenerator.UATTestResponse response =
            (UATTestCaseGenerator.UATTestResponse) JSON.deserialize(
                result,
                UATTestCaseGenerator.UATTestResponse.class
            );

        // Should still generate negative and boundary tests
        Assert.isTrue(response.testCases.size() > 0,
            'Should generate tests even without AC');
    }

    @isTest
    static void testGenerateTestCases_ErrorHandling() {
        Boolean exceptionCaught = false;

        Test.startTest();
        try {
            String result = UATTestController.generateTestCases(null, null);
        } catch (AuraHandledException e) {
            exceptionCaught = true;
            Assert.isTrue(e.getMessage().contains('Error generating UAT test cases'),
                'Should throw AuraHandledException');
        }
        Test.stopTest();

        Assert.isTrue(exceptionCaught, 'Exception should be caught');
    }
}
