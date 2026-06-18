/**
 * @description Test class for AIDeliveryRequestController
 * @author Salesforce Technical Architect
 * @date 2026-06-18
 */
@isTest
private class AIDeliveryRequestControllerTest {

    @testSetup
    static void setupTestData() {
        // Create test records
        List<AI_Delivery_Request__c> testRequests = new List<AI_Delivery_Request__c>();

        testRequests.add(new AI_Delivery_Request__c(
            Title__c = 'Test User Story',
            Category__c = 'User Story',
            Prompt__c = 'Generate user stories for customer portal',
            Generated_Response__c = '{"stories": []}',
            Status__c = 'Generated',
            Readiness_Score__c = 85.5
        ));

        testRequests.add(new AI_Delivery_Request__c(
            Title__c = 'Test UAT',
            Category__c = 'UAT Test',
            Prompt__c = 'Generate UAT tests',
            Generated_Response__c = '{"tests": []}',
            Status__c = 'Saved',
            Confidence_Score__c = 92.0,
            Readiness_Score__c = 88.0
        ));

        insert testRequests;
    }

    @isTest
    static void testSaveDeliveryRequest() {
        Test.startTest();

        AIDeliveryRequestController.SaveRequest request = new AIDeliveryRequestController.SaveRequest();
        request.title = 'New RAID Log';
        request.category = 'RAID Log';
        request.prompt = 'Generate RAID log from meeting notes';
        request.generatedResponse = '{"risks": [], "issues": []}';
        request.status = 'Generated';
        request.confidenceScore = 90.0;
        request.readinessScore = 87.5;
        request.rating = '5 - Excellent';

        String recordId = AIDeliveryRequestController.saveDeliveryRequest(request);

        Test.stopTest();

        // Verify record was created
        System.assertNotEquals(null, recordId, 'Record Id should not be null');

        AI_Delivery_Request__c savedRecord = [
            SELECT Title__c, Category__c, Status__c, Confidence_Score__c, Readiness_Score__c, Rating__c
            FROM AI_Delivery_Request__c
            WHERE Id = :recordId
        ];

        System.assertEquals('New RAID Log', savedRecord.Title__c);
        System.assertEquals('RAID Log', savedRecord.Category__c);
        System.assertEquals('Generated', savedRecord.Status__c);
        System.assertEquals(90.0, savedRecord.Confidence_Score__c);
        System.assertEquals(87.5, savedRecord.Readiness_Score__c);
        System.assertEquals('5 - Excellent', savedRecord.Rating__c);
    }

    @isTest
    static void testSaveDeliveryRequestMissingTitle() {
        Test.startTest();

        AIDeliveryRequestController.SaveRequest request = new AIDeliveryRequestController.SaveRequest();
        request.category = 'User Story';

        Boolean exceptionThrown = false;
        try {
            AIDeliveryRequestController.saveDeliveryRequest(request);
        } catch (AuraHandledException e) {
            exceptionThrown = true;
            System.assert(e.getMessage().contains('Title is required'));
        }

        Test.stopTest();

        System.assert(exceptionThrown, 'Exception should be thrown for missing title');
    }

    @isTest
    static void testSaveDeliveryRequestMissingCategory() {
        Test.startTest();

        AIDeliveryRequestController.SaveRequest request = new AIDeliveryRequestController.SaveRequest();
        request.title = 'Test Title';

        Boolean exceptionThrown = false;
        try {
            AIDeliveryRequestController.saveDeliveryRequest(request);
        } catch (AuraHandledException e) {
            exceptionThrown = true;
            System.assert(e.getMessage().contains('Category is required'));
        }

        Test.stopTest();

        System.assert(exceptionThrown, 'Exception should be thrown for missing category');
    }

    @isTest
    static void testGetDeliveryRequest() {
        AI_Delivery_Request__c testRecord = [
            SELECT Id FROM AI_Delivery_Request__c WHERE Title__c = 'Test User Story' LIMIT 1
        ];

        Test.startTest();

        AI_Delivery_Request__c result = AIDeliveryRequestController.getDeliveryRequest(testRecord.Id);

        Test.stopTest();

        System.assertNotEquals(null, result);
        System.assertEquals('Test User Story', result.Title__c);
        System.assertEquals('User Story', result.Category__c);
        System.assertEquals(85.5, result.Readiness_Score__c);
    }

    @isTest
    static void testGetRecentRequestsWithCategory() {
        Test.startTest();

        List<AI_Delivery_Request__c> results =
            AIDeliveryRequestController.getRecentRequests('User Story', 10);

        Test.stopTest();

        System.assert(results.size() > 0, 'Should return at least one record');
        for (AI_Delivery_Request__c record : results) {
            System.assertEquals('User Story', record.Category__c);
        }
    }

    @isTest
    static void testGetRecentRequestsWithoutCategory() {
        Test.startTest();

        List<AI_Delivery_Request__c> results =
            AIDeliveryRequestController.getRecentRequests(null, 10);

        Test.stopTest();

        System.assertEquals(2, results.size(), 'Should return all test records');
    }

    @isTest
    static void testGetRecentRequestsWithLimit() {
        Test.startTest();

        List<AI_Delivery_Request__c> results =
            AIDeliveryRequestController.getRecentRequests(null, 1);

        Test.stopTest();

        System.assertEquals(1, results.size(), 'Should respect limit parameter');
    }
}
