/**
 * @description Test class for DeliveryCopilotService
 * @author Salesforce Technical Architect
 * @date 2026-06-17
 */
@isTest
private class DeliveryCopilotServiceTest {

    @isTest
    static void testGenerateUserStories_Success() {
        Test.startTest();
        DeliveryCopilotService.DeliveryResponse response =
            DeliveryCopilotService.generateUserStories('Create user stories for customer portal');
        Test.stopTest();

        Assert.isNotNull(response, 'Response should not be null');
        Assert.areEqual('Generate User Stories', response.actionType, 'Action type should match');
        Assert.isNotNull(response.executiveSummary, 'Executive summary should be present');
        Assert.isTrue(response.recommendations.size() > 0, 'Should have recommendations');
        Assert.isTrue(response.risks.size() > 0, 'Should have risks');
        Assert.isTrue(response.actionItems.size() > 0, 'Should have action items');
        Assert.isNotNull(response.priority, 'Priority should be set');
        Assert.isTrue(response.confidenceScore > 0, 'Confidence score should be positive');
        Assert.isTrue(response.nextSteps.size() > 0, 'Should have next steps');
    }

    @isTest
    static void testGenerateUserStories_WithoutUserRequest() {
        Test.startTest();
        DeliveryCopilotService.DeliveryResponse response =
            DeliveryCopilotService.generateUserStories(null);
        Test.stopTest();

        Assert.isNotNull(response, 'Response should not be null');
        Assert.areEqual('Generate User Stories', response.actionType, 'Action type should match');
        Assert.isNull(response.userRequest, 'User request should be null');
    }

    @isTest
    static void testGenerateTestCases_Success() {
        Test.startTest();
        DeliveryCopilotService.DeliveryResponse response =
            DeliveryCopilotService.generateTestCases('Create test cases for authentication module');
        Test.stopTest();

        Assert.isNotNull(response, 'Response should not be null');
        Assert.areEqual('Generate Test Cases', response.actionType, 'Action type should match');
        Assert.isNotNull(response.executiveSummary, 'Executive summary should be present');
        Assert.isTrue(response.recommendations.size() >= 5, 'Should have at least 5 recommendations');
        Assert.isTrue(response.risks.size() >= 4, 'Should have at least 4 risks');
        Assert.areEqual('High', response.priority, 'Priority should be High');
        Assert.isTrue(response.confidenceScore == 90, 'Confidence score should be 90');
    }

    @isTest
    static void testReviewSolutionDesign_Success() {
        Test.startTest();
        DeliveryCopilotService.DeliveryResponse response =
            DeliveryCopilotService.reviewSolutionDesign('Review architecture for scalability');
        Test.stopTest();

        Assert.isNotNull(response, 'Response should not be null');
        Assert.areEqual('Review Solution Design', response.actionType, 'Action type should match');
        Assert.isTrue(response.executiveSummary.contains('architecture'), 'Should mention architecture');
        Assert.isTrue(response.confidenceScore >= 80, 'Should have high confidence');
    }

    @isTest
    static void testCreateExecutiveStatus_Success() {
        Test.startTest();
        DeliveryCopilotService.DeliveryResponse response =
            DeliveryCopilotService.createExecutiveStatus('Weekly status for executives');
        Test.stopTest();

        Assert.isNotNull(response, 'Response should not be null');
        Assert.areEqual('Create Executive Status', response.actionType, 'Action type should match');
        Assert.areEqual('Critical', response.priority, 'Executive status should be Critical priority');
        Assert.isTrue(response.executiveSummary.contains('Status'), 'Should contain status information');
    }

    @isTest
    static void testGenerateRAIDLog_Success() {
        Test.startTest();
        DeliveryCopilotService.DeliveryResponse response =
            DeliveryCopilotService.generateRAIDLog('Generate RAID log for Q3 project');
        Test.stopTest();

        Assert.isNotNull(response, 'Response should not be null');
        Assert.areEqual('Generate RAID Log', response.actionType, 'Action type should match');
        Assert.isTrue(response.risks.size() >= 5, 'Should have multiple RAID items');
        Assert.areEqual('Critical', response.priority, 'RAID log should be Critical priority');
        Assert.isTrue(response.confidenceScore == 75, 'Confidence should be 75');
    }

    @isTest
    static void testPrepareCustomerMeeting_Success() {
        Test.startTest();
        DeliveryCopilotService.DeliveryResponse response =
            DeliveryCopilotService.prepareCustomerMeeting('Prepare for quarterly business review');
        Test.stopTest();

        Assert.isNotNull(response, 'Response should not be null');
        Assert.areEqual('Customer Meeting Prep', response.actionType, 'Action type should match');
        Assert.isTrue(response.recommendations.size() >= 5, 'Should have meeting recommendations');
        Assert.areEqual('High', response.priority, 'Meeting prep should be High priority');
    }

    @isTest
    static void testGenerateDeploymentChecklist_Success() {
        Test.startTest();
        DeliveryCopilotService.DeliveryResponse response =
            DeliveryCopilotService.generateDeploymentChecklist('Production deployment checklist');
        Test.stopTest();

        Assert.isNotNull(response, 'Response should not be null');
        Assert.areEqual('Deployment Checklist', response.actionType, 'Action type should match');
        Assert.areEqual('Critical', response.priority, 'Deployment should be Critical priority');
        Assert.isTrue(response.confidenceScore == 92, 'Should have high confidence score');
        Assert.isTrue(response.executiveSummary.contains('checklist'), 'Should mention checklist');
    }

    @isTest
    static void testProcessRequest_UserStories() {
        Test.startTest();
        String jsonResponse = DeliveryCopilotService.processRequest('user_stories', 'Test request');
        Test.stopTest();

        Assert.isNotNull(jsonResponse, 'JSON response should not be null');
        DeliveryCopilotService.DeliveryResponse response =
            (DeliveryCopilotService.DeliveryResponse) JSON.deserialize(
                jsonResponse,
                DeliveryCopilotService.DeliveryResponse.class
            );
        Assert.areEqual('Generate User Stories', response.actionType, 'Should route to user stories');
    }

    @isTest
    static void testProcessRequest_TestCases() {
        Test.startTest();
        String jsonResponse = DeliveryCopilotService.processRequest('test_cases', 'Test request');
        Test.stopTest();

        Assert.isNotNull(jsonResponse, 'JSON response should not be null');
        DeliveryCopilotService.DeliveryResponse response =
            (DeliveryCopilotService.DeliveryResponse) JSON.deserialize(
                jsonResponse,
                DeliveryCopilotService.DeliveryResponse.class
            );
        Assert.areEqual('Generate Test Cases', response.actionType, 'Should route to test cases');
    }

    @isTest
    static void testProcessRequest_SolutionDesign() {
        Test.startTest();
        String jsonResponse = DeliveryCopilotService.processRequest('solution_design', 'Test request');
        Test.stopTest();

        Assert.isNotNull(jsonResponse, 'JSON response should not be null');
        DeliveryCopilotService.DeliveryResponse response =
            (DeliveryCopilotService.DeliveryResponse) JSON.deserialize(
                jsonResponse,
                DeliveryCopilotService.DeliveryResponse.class
            );
        Assert.areEqual('Review Solution Design', response.actionType, 'Should route to solution design');
    }

    @isTest
    static void testProcessRequest_ExecutiveStatus() {
        Test.startTest();
        String jsonResponse = DeliveryCopilotService.processRequest('executive_status', 'Test request');
        Test.stopTest();

        Assert.isNotNull(jsonResponse, 'JSON response should not be null');
        DeliveryCopilotService.DeliveryResponse response =
            (DeliveryCopilotService.DeliveryResponse) JSON.deserialize(
                jsonResponse,
                DeliveryCopilotService.DeliveryResponse.class
            );
        Assert.areEqual('Create Executive Status', response.actionType, 'Should route to executive status');
    }

    @isTest
    static void testProcessRequest_RAIDLog() {
        Test.startTest();
        String jsonResponse = DeliveryCopilotService.processRequest('raid_log', 'Test request');
        Test.stopTest();

        Assert.isNotNull(jsonResponse, 'JSON response should not be null');
        DeliveryCopilotService.DeliveryResponse response =
            (DeliveryCopilotService.DeliveryResponse) JSON.deserialize(
                jsonResponse,
                DeliveryCopilotService.DeliveryResponse.class
            );
        Assert.areEqual('Generate RAID Log', response.actionType, 'Should route to RAID log');
    }

    @isTest
    static void testProcessRequest_MeetingPrep() {
        Test.startTest();
        String jsonResponse = DeliveryCopilotService.processRequest('meeting_prep', 'Test request');
        Test.stopTest();

        Assert.isNotNull(jsonResponse, 'JSON response should not be null');
        DeliveryCopilotService.DeliveryResponse response =
            (DeliveryCopilotService.DeliveryResponse) JSON.deserialize(
                jsonResponse,
                DeliveryCopilotService.DeliveryResponse.class
            );
        Assert.areEqual('Customer Meeting Prep', response.actionType, 'Should route to meeting prep');
    }

    @isTest
    static void testProcessRequest_DeploymentChecklist() {
        Test.startTest();
        String jsonResponse = DeliveryCopilotService.processRequest('deployment_checklist', 'Test request');
        Test.stopTest();

        Assert.isNotNull(jsonResponse, 'JSON response should not be null');
        DeliveryCopilotService.DeliveryResponse response =
            (DeliveryCopilotService.DeliveryResponse) JSON.deserialize(
                jsonResponse,
                DeliveryCopilotService.DeliveryResponse.class
            );
        Assert.areEqual('Deployment Checklist', response.actionType, 'Should route to deployment checklist');
    }

    @isTest
    static void testProcessRequest_InvalidActionType() {
        Test.startTest();
        String jsonResponse = DeliveryCopilotService.processRequest('invalid_action', 'Test request');
        Test.stopTest();

        Assert.isNotNull(jsonResponse, 'JSON response should not be null');
        DeliveryCopilotService.DeliveryResponse response =
            (DeliveryCopilotService.DeliveryResponse) JSON.deserialize(
                jsonResponse,
                DeliveryCopilotService.DeliveryResponse.class
            );
        Assert.areEqual('Unknown', response.actionType, 'Should handle unknown action type');
        Assert.areEqual(0, response.confidenceScore, 'Confidence should be 0 for invalid action');
    }

    @isTest
    static void testRiskItem_Constructor() {
        Test.startTest();
        DeliveryCopilotService.RiskItem risk = new DeliveryCopilotService.RiskItem(
            'Test risk description',
            'High',
            'Medium'
        );
        Test.stopTest();

        Assert.isNotNull(risk, 'Risk item should not be null');
        Assert.areEqual('Test risk description', risk.description, 'Description should match');
        Assert.areEqual('High', risk.impact, 'Impact should match');
        Assert.areEqual('Medium', risk.probability, 'Probability should match');
    }

    @isTest
    static void testActionItem_Constructor() {
        Test.startTest();
        DeliveryCopilotService.ActionItem action = new DeliveryCopilotService.ActionItem(
            'Complete task',
            'High',
            'John Doe',
            '3 days'
        );
        Test.stopTest();

        Assert.isNotNull(action, 'Action item should not be null');
        Assert.areEqual('Complete task', action.task, 'Task should match');
        Assert.areEqual('High', action.priority, 'Priority should match');
        Assert.areEqual('John Doe', action.owner, 'Owner should match');
        Assert.areEqual('3 days', action.duration, 'Duration should match');
    }

    @isTest
    static void testDeliveryResponse_Constructor() {
        Test.startTest();
        DeliveryCopilotService.DeliveryResponse response = new DeliveryCopilotService.DeliveryResponse();
        Test.stopTest();

        Assert.isNotNull(response, 'Response should not be null');
        Assert.isNotNull(response.recommendations, 'Recommendations list should be initialized');
        Assert.isNotNull(response.risks, 'Risks list should be initialized');
        Assert.isNotNull(response.actionItems, 'Action items list should be initialized');
        Assert.isNotNull(response.nextSteps, 'Next steps list should be initialized');
        Assert.areEqual(0, response.recommendations.size(), 'Recommendations should be empty');
        Assert.areEqual(0, response.risks.size(), 'Risks should be empty');
        Assert.areEqual(0, response.actionItems.size(), 'Action items should be empty');
        Assert.areEqual(0, response.nextSteps.size(), 'Next steps should be empty');
    }

    @isTest
    static void testJSONSerialization() {
        Test.startTest();
        DeliveryCopilotService.DeliveryResponse response = new DeliveryCopilotService.DeliveryResponse();
        response.actionType = 'Test Action';
        response.executiveSummary = 'Test summary';
        response.priority = 'High';
        response.confidenceScore = 85;
        response.recommendations.add('Test recommendation');
        response.nextSteps.add('Test next step');

        String jsonString = JSON.serialize(response, true);
        Test.stopTest();

        Assert.isNotNull(jsonString, 'JSON string should not be null');
        Assert.isTrue(jsonString.contains('Test Action'), 'JSON should contain action type');
        Assert.isTrue(jsonString.contains('Test summary'), 'JSON should contain summary');
        Assert.isTrue(jsonString.contains('85'), 'JSON should contain confidence score');
    }

    @isTest
    static void testJSONDeserialization() {
        Test.startTest();
        String jsonString = '{"actionType":"Test","executiveSummary":"Summary","priority":"High","confidenceScore":90}';
        DeliveryCopilotService.DeliveryResponse response =
            (DeliveryCopilotService.DeliveryResponse) JSON.deserialize(
                jsonString,
                DeliveryCopilotService.DeliveryResponse.class
            );
        Test.stopTest();

        Assert.isNotNull(response, 'Deserialized response should not be null');
        Assert.areEqual('Test', response.actionType, 'Action type should match');
        Assert.areEqual('Summary', response.executiveSummary, 'Summary should match');
        Assert.areEqual('High', response.priority, 'Priority should match');
        Assert.areEqual(90, response.confidenceScore, 'Confidence score should match');
    }

    @isTest
    static void testAllActionsHaveRequiredFields() {
        List<String> actionTypes = new List<String>{
            'user_stories', 'test_cases', 'solution_design',
            'executive_status', 'raid_log', 'meeting_prep',
            'deployment_checklist'
        };

        Test.startTest();
        for (String actionType : actionTypes) {
            String jsonResponse = DeliveryCopilotService.processRequest(actionType, 'Test');
            DeliveryCopilotService.DeliveryResponse response =
                (DeliveryCopilotService.DeliveryResponse) JSON.deserialize(
                    jsonResponse,
                    DeliveryCopilotService.DeliveryResponse.class
                );

            Assert.isNotNull(response.actionType, actionType + ' should have action type');
            Assert.isNotNull(response.executiveSummary, actionType + ' should have executive summary');
            Assert.isNotNull(response.priority, actionType + ' should have priority');
            Assert.isNotNull(response.confidenceScore, actionType + ' should have confidence score');
            Assert.isTrue(response.recommendations.size() > 0, actionType + ' should have recommendations');
            Assert.isTrue(response.risks.size() > 0, actionType + ' should have risks');
            Assert.isTrue(response.actionItems.size() > 0, actionType + ' should have action items');
            Assert.isTrue(response.nextSteps.size() > 0, actionType + ' should have next steps');
        }
        Test.stopTest();
    }
}
