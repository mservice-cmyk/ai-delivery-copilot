/**
 * @description Test class for AIService
 * Tests Claude and Gemini AI provider integrations
 * @author Salesforce Technical Architect
 * @date 2026-06-19
 */
@IsTest
private class AIServiceTest {

    /**
     * @description Test mock mode (when no providers configured)
     */
    @IsTest
    static void testMockMode() {
        Test.startTest();

        // Force mock mode
        AIService.setProvider(AIService.AIProvider.MOCK);
        System.assertEquals(AIService.AIProvider.MOCK, AIService.getProvider(), 'Provider should be MOCK');

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
     * @description Test provider switching
     */
    @IsTest
    static void testProviderSwitch() {
        Test.startTest();

        // Switch to Claude
        AIService.setProvider(AIService.AIProvider.CLAUDE);
        System.assertEquals(AIService.AIProvider.CLAUDE, AIService.getProvider(), 'Provider should be CLAUDE');

        // Switch to Gemini
        AIService.setProvider(AIService.AIProvider.GEMINI);
        System.assertEquals(AIService.AIProvider.GEMINI, AIService.getProvider(), 'Provider should be GEMINI');

        // Switch to Mock
        AIService.setProvider(AIService.AIProvider.MOCK);
        System.assertEquals(AIService.AIProvider.MOCK, AIService.getProvider(), 'Provider should be MOCK');

        Test.stopTest();
    }

    /**
     * @description Test Claude AI with successful HTTP response
     */
    @IsTest
    static void testClaudeSuccess() {
        // Set up mock HTTP response for Claude
        Test.setMock(HttpCalloutMock.class, new MockClaudeSuccess());

        Test.startTest();

        // Force Claude provider
        AIService.setProvider(AIService.AIProvider.CLAUDE);

        // Call AI service
        AIService.AIResponse response = AIService.callAI(
            'Review this solution design',
            'You are a Salesforce architect',
            2000
        );

        Test.stopTest();

        // Verify response
        System.assertNotEquals(null, response, 'Response should not be null');
        System.assertEquals(true, response.success, 'Response should be successful');
        System.assertNotEquals(null, response.content, 'Content should not be null');
        System.assertEquals('Claude', response.model, 'Model should be Claude');
    }

    /**
     * @description Test Gemini AI with successful HTTP response
     */
    @IsTest
    static void testGeminiSuccess() {
        // Set up mock HTTP response for Gemini
        Test.setMock(HttpCalloutMock.class, new MockGeminiSuccess());

        Test.startTest();

        // Force Gemini provider
        AIService.setProvider(AIService.AIProvider.GEMINI);

        // Call AI service
        AIService.AIResponse response = AIService.callAI(
            'Analyze this RAID log',
            'You are a project manager',
            3000
        );

        Test.stopTest();

        // Verify response
        System.assertNotEquals(null, response, 'Response should not be null');
        System.assertEquals(true, response.success, 'Response should be successful');
        System.assertNotEquals(null, response.content, 'Content should not be null');
        System.assertEquals('Gemini', response.model, 'Model should be Gemini');
    }

    /**
     * @description Test Claude with HTTP error
     */
    @IsTest
    static void testClaudeHttpError() {
        // Set up mock HTTP error response
        Test.setMock(HttpCalloutMock.class, new MockAIProviderError());

        Test.startTest();

        // Force Claude provider
        AIService.setProvider(AIService.AIProvider.CLAUDE);

        // Call AI service
        AIService.AIResponse response = AIService.callAI(
            'Test prompt',
            null,
            1000
        );

        Test.stopTest();

        // Should return error response
        System.assertNotEquals(null, response, 'Response should not be null');
        System.assertEquals(false, response.success, 'Should indicate failure');
        System.assertNotEquals(null, response.error, 'Error message should be present');
    }

    /**
     * @description Test Gemini with HTTP error
     */
    @IsTest
    static void testGeminiHttpError() {
        // Set up mock HTTP error response
        Test.setMock(HttpCalloutMock.class, new MockAIProviderError());

        Test.startTest();

        // Force Gemini provider
        AIService.setProvider(AIService.AIProvider.GEMINI);

        // Call AI service
        AIService.AIResponse response = AIService.callAI(
            'Test prompt',
            null,
            1000
        );

        Test.stopTest();

        // Should return error response
        System.assertNotEquals(null, response, 'Response should not be null');
        System.assertEquals(false, response.success, 'Should indicate failure');
        System.assertNotEquals(null, response.error, 'Error message should be present');
    }

    /**
     * @description Test with null parameters
     */
    @IsTest
    static void testNullParameters() {
        Test.startTest();

        AIService.setProvider(AIService.AIProvider.MOCK);
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

        AIService.setProvider(AIService.AIProvider.MOCK);
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
     * @description Test provider auto-detection (will default to MOCK in test)
     */
    @IsTest
    static void testAutoDetectProvider() {
        Test.startTest();

        // Reset to auto-detect
        AIService.setProvider(null);
        AIService.AIProvider detected = AIService.getProvider();

        Test.stopTest();

        // Should default to MOCK since no Named Credentials in test
        System.assertEquals(AIService.AIProvider.MOCK, detected, 'Should default to MOCK');
    }

    /**
     * @description Mock HTTP callout for Claude success
     */
    private class MockClaudeSuccess implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setHeader('Content-Type', 'application/json');

            // Claude API response format
            Map<String, Object> mockResponse = new Map<String, Object>{
                'content' => new List<Map<String, String>>{
                    new Map<String, String>{
                        'text' => 'This is a test response from Claude',
                        'type' => 'text'
                    }
                },
                'model' => 'claude-3-5-sonnet-20241022',
                'role' => 'assistant'
            };

            res.setBody(JSON.serialize(mockResponse));
            return res;
        }
    }

    /**
     * @description Mock HTTP callout for Gemini success
     */
    private class MockGeminiSuccess implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setHeader('Content-Type', 'application/json');

            // Gemini API response format
            Map<String, Object> mockResponse = new Map<String, Object>{
                'candidates' => new List<Map<String, Object>>{
                    new Map<String, Object>{
                        'content' => new Map<String, Object>{
                            'parts' => new List<Map<String, String>>{
                                new Map<String, String>{
                                    'text' => 'This is a test response from Gemini'
                                }
                            }
                        }
                    }
                }
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
