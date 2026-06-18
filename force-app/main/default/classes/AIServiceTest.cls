/**
 * @description Test class for AIService
 * @author Salesforce Technical Architect
 * @date 2026-06-18
 */
@IsTest
private class AIServiceTest {

    /**
     * @description Test mock mode (default)
     */
    @IsTest
    static void testMockMode() {
        Test.startTest();

        // Mock mode should be default
        System.assertEquals(AIService.AIMode.MOCK, AIService.getMode(), 'Default mode should be MOCK');

        // Call AI service in mock mode
        AIService.AIResponse response = AIService.callAI(
            'Test prompt for solution design review',
            'You are a Salesforce architect',
            1000
        );

        Test.stopTest();

        // Verify mock response
        System.assertNotEquals(null, response, 'Response should not be null');
        System.assertEquals(true, response.success, 'Response should be successful');
        System.assertNotEquals(null, response.content, 'Response content should not be null');
        System.assert(response.content.contains('Mock AI Response'), 'Should contain mock identifier');
    }

    /**
     * @description Test mode switching
     */
    @IsTest
    static void testModeSwitch() {
        Test.startTest();

        // Switch to real mode
        AIService.setMode(AIService.AIMode.REAL);
        System.assertEquals(AIService.AIMode.REAL, AIService.getMode(), 'Mode should be REAL');

        // Switch back to mock mode
        AIService.setMode(AIService.AIMode.MOCK);
        System.assertEquals(AIService.AIMode.MOCK, AIService.getMode(), 'Mode should be MOCK');

        Test.stopTest();
    }

    /**
     * @description Test real mode with successful HTTP response
     */
    @IsTest
    static void testRealModeSuccess() {
        // Set up mock HTTP response
        Test.setMock(HttpCalloutMock.class, new MockAIProviderSuccess());

        Test.startTest();

        // Switch to real mode
        AIService.setMode(AIService.AIMode.REAL);

        // Call AI service
        AIService.AIResponse response = AIService.callAI(
            'Review this solution design',
            'You are a Salesforce architect',
            2000
        );

        Test.stopTest();

        // Verify response - will fall back to mock since parsing is provider-specific
        System.assertNotEquals(null, response, 'Response should not be null');
    }

    /**
     * @description Test real mode with HTTP error
     */
    @IsTest
    static void testRealModeHttpError() {
        // Set up mock HTTP error response
        Test.setMock(HttpCalloutMock.class, new MockAIProviderError());

        Test.startTest();

        // Switch to real mode
        AIService.setMode(AIService.AIMode.REAL);

        // Call AI service
        AIService.AIResponse response = AIService.callAI(
            'Test prompt',
            null,
            1000
        );

        Test.stopTest();

        // Should fall back to mock response on error
        System.assertNotEquals(null, response, 'Response should not be null');
        System.assertEquals(true, response.success, 'Should fall back to mock on error');
    }

    /**
     * @description Test with null parameters
     */
    @IsTest
    static void testNullParameters() {
        Test.startTest();

        AIService.AIResponse response = AIService.callAI(
            'Test prompt',
            null,  // null system context
            null   // null max tokens
        );

        Test.stopTest();

        System.assertNotEquals(null, response, 'Response should not be null');
        System.assertEquals(true, response.success, 'Response should be successful');
    }

    /**
     * @description Test with empty string parameters
     */
    @IsTest
    static void testEmptyParameters() {
        Test.startTest();

        AIService.AIResponse response = AIService.callAI(
            '',    // empty prompt
            '',    // empty system context
            0      // zero max tokens
        );

        Test.stopTest();

        System.assertNotEquals(null, response, 'Response should not be null');
        System.assertEquals(true, response.success, 'Response should be successful');
    }

    /**
     * @description Mock HTTP callout for successful response
     */
    private class MockAIProviderSuccess implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setHeader('Content-Type', 'application/json');

            // Generic mock response structure
            Map<String, Object> mockResponse = new Map<String, Object>{
                'content' => 'This is a test response from the AI provider',
                'model' => 'test-model-v1',
                'status' => 'success'
            };

            res.setBody(JSON.serialize(mockResponse));
            return res;
        }
    }

    /**
     * @description Mock HTTP callout for error response
     */
    private class MockAIProviderError implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(500);
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"error": "Internal server error"}');
            return res;
        }
    }
}
