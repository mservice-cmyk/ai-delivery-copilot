/**
 * @description Test class for UserStoryController
 * @author Salesforce Technical Architect
 * @date 2026-06-17
 */
@isTest
private class UserStoryControllerTest {

    @isTest
    static void testGenerateUserStories_Success() {
        Test.startTest();
        String result = UserStoryController.generateUserStories(
            'customer self-service portal',
            'Customer Support Manager',
            'case management',
            'Case, Contact'
        );
        Test.stopTest();

        Assert.isNotNull(result, 'Result should not be null');
        UserStoryGenerator.UserStoryResponse response =
            (UserStoryGenerator.UserStoryResponse) JSON.deserialize(
                result,
                UserStoryGenerator.UserStoryResponse.class
            );

        Assert.isNotNull(response.epic, 'Epic should be generated');
        Assert.isTrue(response.userStories.size() > 0, 'Should generate user stories');
        Assert.areEqual(true, response.readyForJira, 'Should be Jira-ready');
    }

    @isTest
    static void testGenerateUserStories_MultipleObjects() {
        Test.startTest();
        String result = UserStoryController.generateUserStories(
            'sales pipeline automation',
            'Sales Manager',
            'opportunity management',
            'Account, Contact, Lead, Opportunity'
        );
        Test.stopTest();

        Assert.isNotNull(result, 'Result should not be null');
        UserStoryGenerator.UserStoryResponse response =
            (UserStoryGenerator.UserStoryResponse) JSON.deserialize(
                result,
                UserStoryGenerator.UserStoryResponse.class
            );

        Assert.areEqual(4, response.request.objects.size(),
            'Should parse all 4 objects');
    }

    @isTest
    static void testGenerateUserStories_NoObjects() {
        Test.startTest();
        String result = UserStoryController.generateUserStories(
            'process improvement',
            'Manager',
            'workflow optimization',
            ''
        );
        Test.stopTest();

        Assert.isNotNull(result, 'Result should not be null');
        UserStoryGenerator.UserStoryResponse response =
            (UserStoryGenerator.UserStoryResponse) JSON.deserialize(
                result,
                UserStoryGenerator.UserStoryResponse.class
            );

        Assert.areEqual(0, response.request.objects.size(),
            'Should handle empty objects');
    }

    @isTest
    static void testGenerateUserStories_ErrorHandling() {
        Boolean exceptionCaught = false;

        Test.startTest();
        try {
            String result = UserStoryController.generateUserStories(
                null,
                null,
                null,
                null
            );
        } catch (AuraHandledException e) {
            exceptionCaught = true;
            Assert.isTrue(e.getMessage().contains('Error generating user stories'),
                'Should throw AuraHandledException');
        }
        Test.stopTest();

        Assert.isTrue(exceptionCaught, 'Exception should be caught and wrapped');
    }

    @isTest
    static void testGetExampleInputs_Success() {
        Test.startTest();
        String result = UserStoryController.getExampleInputs();
        Test.stopTest();

        Assert.isNotNull(result, 'Result should not be null');
        Map<String, Object> examples =
            (Map<String, Object>) JSON.deserializeUntyped(result);

        Assert.isTrue(examples.containsKey('businessRequirements'),
            'Should contain business requirements');
        Assert.isTrue(examples.containsKey('personas'),
            'Should contain personas');
        Assert.isTrue(examples.containsKey('businessProcesses'),
            'Should contain business processes');
        Assert.isTrue(examples.containsKey('objectSuggestions'),
            'Should contain object suggestions');
    }

    @isTest
    static void testGetExampleInputs_Cacheable() {
        Test.startTest();
        String result1 = UserStoryController.getExampleInputs();
        String result2 = UserStoryController.getExampleInputs();
        Test.stopTest();

        Assert.isNotNull(result1, 'First result should not be null');
        Assert.isNotNull(result2, 'Second result should not be null');
        Assert.areEqual(result1, result2, 'Cacheable results should be identical');
    }

    @isTest
    static void testValidateInputs_AllValid() {
        Test.startTest();
        String result = UserStoryController.validateInputs(
            'customer self-service portal with case management',
            'Customer Support Manager',
            'case resolution',
            'Case, Contact, Account'
        );
        Test.stopTest();

        Assert.isNotNull(result, 'Result should not be null');
        Map<String, Object> validation =
            (Map<String, Object>) JSON.deserializeUntyped(result);

        Assert.areEqual(true, validation.get('isValid'),
            'Validation should pass');
        List<Object> errors = (List<Object>) validation.get('errors');
        Assert.areEqual(0, errors.size(), 'Should have no errors');
    }

    @isTest
    static void testValidateInputs_MissingRequiredFields() {
        Test.startTest();
        String result = UserStoryController.validateInputs('', '', '', '');
        Test.stopTest();

        Assert.isNotNull(result, 'Result should not be null');
        Map<String, Object> validation =
            (Map<String, Object>) JSON.deserializeUntyped(result);

        Assert.areEqual(false, validation.get('isValid'),
            'Validation should fail');
        List<Object> errors = (List<Object>) validation.get('errors');
        Assert.isTrue(errors.size() >= 3, 'Should have errors for required fields');
    }

    @isTest
    static void testValidateInputs_Warnings() {
        Test.startTest();
        String result = UserStoryController.validateInputs(
            'short',
            'Manager',
            'process',
            ''
        );
        Test.stopTest();

        Assert.isNotNull(result, 'Result should not be null');
        Map<String, Object> validation =
            (Map<String, Object>) JSON.deserializeUntyped(result);

        List<Object> warnings = (List<Object>) validation.get('warnings');
        Assert.isTrue(warnings.size() > 0, 'Should have warnings');
    }

    @isTest
    static void testValidateInputs_TooManyObjects() {
        Test.startTest();
        String result = UserStoryController.validateInputs(
            'comprehensive system',
            'Administrator',
            'data management',
            'Account, Contact, Lead, Opportunity, Case, Task, Event'
        );
        Test.stopTest();

        Assert.isNotNull(result, 'Result should not be null');
        Map<String, Object> validation =
            (Map<String, Object>) JSON.deserializeUntyped(result);

        List<Object> warnings = (List<Object>) validation.get('warnings');
        Assert.isTrue(warnings.size() > 0, 'Should warn about too many objects');
    }

    @isTest
    static void testParseObjects_Various() {
        Test.startTest();
        String result1 = UserStoryController.generateUserStories(
            'test', 'test', 'test', 'Account,Contact'
        );
        String result2 = UserStoryController.generateUserStories(
            'test', 'test', 'test', 'Account, Contact, Lead'
        );
        String result3 = UserStoryController.generateUserStories(
            'test', 'test', 'test', ' Account , Contact '
        );
        Test.stopTest();

        Assert.isNotNull(result1, 'Should handle no spaces');
        Assert.isNotNull(result2, 'Should handle spaces after commas');
        Assert.isNotNull(result3, 'Should handle extra spaces');
    }

    @isTest
    static void testDifferentPersonas() {
        List<String> personas = new List<String>{
            'Sales Manager',
            'Customer Support Agent',
            'System Administrator'
        };

        Test.startTest();
        for (String persona : personas) {
            String result = UserStoryController.generateUserStories(
                'test requirement',
                persona,
                'test process',
                'Account'
            );

            Assert.isNotNull(result, 'Should generate for ' + persona);
        }
        Test.stopTest();
    }

    @isTest
    static void testJSONSerialization() {
        Test.startTest();
        String result = UserStoryController.generateUserStories(
            'customer portal',
            'Customer',
            'self-service',
            'Case'
        );
        Test.stopTest();

        Assert.isTrue(result.contains('epic'), 'JSON should contain epic');
        Assert.isTrue(result.contains('userStories'), 'JSON should contain userStories');
        Assert.isTrue(result.contains('acceptanceCriteria'),
            'JSON should contain acceptance criteria');
    }
}
