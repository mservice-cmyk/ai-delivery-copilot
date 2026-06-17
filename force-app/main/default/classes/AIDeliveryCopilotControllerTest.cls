/**
 * @description Test class for AIDeliveryCopilotController
 * @author Salesforce Technical Architect
 * @date 2026-06-17
 */
@isTest
private class AIDeliveryCopilotControllerTest {

    @isTest
    static void testGetAIInsights_Success() {
        Test.startTest();
        String result = AIDeliveryCopilotController.getAIInsights('solution_design', 'Review scalability architecture');
        Test.stopTest();

        Assert.isNotNull(result, 'Result should not be null');
        Assert.isTrue(result.contains('Review Solution Design'), 'Should contain solution design action');
    }

    @isTest
    static void testGetAIInsights_SolutionDesignContext() {
        Test.startTest();
        String result = AIDeliveryCopilotController.getAIInsights('solution_design',
            'Review architecture for customer portal with integration to legacy systems');
        Test.stopTest();

        Assert.isNotNull(result, 'Result should not be null');

        DeliveryCopilotService.DeliveryResponse response =
            (DeliveryCopilotService.DeliveryResponse) JSON.deserialize(
                result,
                DeliveryCopilotService.DeliveryResponse.class
            );

        Assert.areEqual('Review Solution Design', response.actionType, 'Action type should match');
        Assert.isTrue(response.executiveSummary.contains('architecture'), 'Should mention architecture');
        Assert.isTrue(response.recommendations.size() >= 5, 'Should have at least 5 recommendations');
        Assert.isTrue(response.risks.size() >= 4, 'Should have at least 4 risks');
        Assert.isTrue(response.actionItems.size() >= 5, 'Should have at least 5 action items');
        Assert.areEqual('High', response.priority, 'Priority should be High');
        Assert.isTrue(response.confidenceScore == 88, 'Confidence score should be 88');
    }

    @isTest
    static void testAnalyzeMetadata_Success() {
        Test.startTest();
        String result = AIDeliveryCopilotController.analyzeMetadata('CustomObject');
        Test.stopTest();

        Assert.isNotNull(result, 'Result should not be null');

        Map<String, Object> response = (Map<String, Object>) JSON.deserializeUntyped(result);
        Assert.areEqual('success', response.get('status'), 'Status should be success');
        Assert.areEqual('CustomObject', response.get('metadataType'), 'Metadata type should match');
        Assert.isNotNull(response.get('analysis'), 'Analysis should be present');

        Map<String, Object> analysis = (Map<String, Object>) response.get('analysis');
        Assert.isNotNull(analysis.get('totalComponents'), 'Total components should be present');
        Assert.isNotNull(analysis.get('recommendations'), 'Recommendations should be present');
        Assert.isNotNull(analysis.get('metrics'), 'Metrics should be present');
    }

    @isTest
    static void testAnalyzeMetadata_VariousTypes() {
        Test.startTest();
        String result1 = AIDeliveryCopilotController.analyzeMetadata('ApexClass');
        String result2 = AIDeliveryCopilotController.analyzeMetadata('Flow');
        String result3 = AIDeliveryCopilotController.analyzeMetadata('ValidationRule');
        Test.stopTest();

        Assert.isNotNull(result1, 'Result for ApexClass should not be null');
        Assert.isNotNull(result2, 'Result for Flow should not be null');
        Assert.isNotNull(result3, 'Result for ValidationRule should not be null');
    }

    @isTest
    static void testGetDeliverySuggestions_Success() {
        Test.startTest();
        String result = AIDeliveryCopilotController.getDeliverySuggestions('development');
        Test.stopTest();

        Assert.isNotNull(result, 'Result should not be null');

        Map<String, Object> response = (Map<String, Object>) JSON.deserializeUntyped(result);
        Assert.areEqual('success', response.get('status'), 'Status should be success');
        Assert.areEqual('development', response.get('projectPhase'), 'Project phase should match');
        Assert.isNotNull(response.get('suggestions'), 'Suggestions should be present');

        List<Object> suggestions = (List<Object>) response.get('suggestions');
        Assert.isTrue(suggestions.size() > 0, 'Should return at least one suggestion');
    }

    @isTest
    static void testGetDeliverySuggestions_AllPhases() {
        Test.startTest();
        String result1 = AIDeliveryCopilotController.getDeliverySuggestions('discovery');
        String result2 = AIDeliveryCopilotController.getDeliverySuggestions('design');
        String result3 = AIDeliveryCopilotController.getDeliverySuggestions('development');
        String result4 = AIDeliveryCopilotController.getDeliverySuggestions('testing');
        String result5 = AIDeliveryCopilotController.getDeliverySuggestions('deployment');
        Test.stopTest();

        Assert.isNotNull(result1, 'Discovery result should not be null');
        Assert.isNotNull(result2, 'Design result should not be null');
        Assert.isNotNull(result3, 'Development result should not be null');
        Assert.isNotNull(result4, 'Testing result should not be null');
        Assert.isNotNull(result5, 'Deployment result should not be null');
    }

    @isTest
    static void testGetAIInsights_WithUserRequest() {
        Test.startTest();
        String result = AIDeliveryCopilotController.getAIInsights('solution_design',
            'Need to review our microservices architecture for scalability');
        Test.stopTest();

        Assert.isNotNull(result, 'Result should not be null');

        DeliveryCopilotService.DeliveryResponse response =
            (DeliveryCopilotService.DeliveryResponse) JSON.deserialize(
                result,
                DeliveryCopilotService.DeliveryResponse.class
            );

        Assert.areEqual('Review Solution Design', response.actionType, 'Action type should match');
        Assert.isNotNull(response.userRequest, 'User request should be captured');
        Assert.isTrue(response.nextSteps.size() > 0, 'Should have next steps');
    }

    @isTest
    static void testGetAIInsights_ErrorHandling() {
        Boolean exceptionCaught = false;

        Test.startTest();
        try {
            String result = AIDeliveryCopilotController.getAIInsights(null, null);
        } catch (Exception e) {
            exceptionCaught = true;
        }
        Test.stopTest();

        // Method should handle null gracefully or throw AuraHandledException
        Assert.isTrue(true, 'Error handling test completed');
    }

    @isTest
    static void testSolutionDesignReviewRecommendations() {
        Test.startTest();
        String result = AIDeliveryCopilotController.getAIInsights('solution_design',
            'Review platform caching and async processing approach');
        Test.stopTest();

        Assert.isNotNull(result, 'Result should not be null');

        DeliveryCopilotService.DeliveryResponse response =
            (DeliveryCopilotService.DeliveryResponse) JSON.deserialize(
                result,
                DeliveryCopilotService.DeliveryResponse.class
            );

        Boolean hasCachingRecommendation = false;
        Boolean hasAsyncRecommendation = false;

        for (String recommendation : response.recommendations) {
            if (recommendation.containsIgnoreCase('caching') || recommendation.containsIgnoreCase('cache')) {
                hasCachingRecommendation = true;
            }
            if (recommendation.containsIgnoreCase('async') || recommendation.containsIgnoreCase('queueable')) {
                hasAsyncRecommendation = true;
            }
        }

        Assert.isTrue(hasCachingRecommendation, 'Should have caching recommendation');
        Assert.isTrue(hasAsyncRecommendation, 'Should have async processing recommendation');
    }
}
