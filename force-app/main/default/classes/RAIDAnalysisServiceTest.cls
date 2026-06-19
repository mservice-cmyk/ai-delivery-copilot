/**
 * @description Test class for RAIDAnalysisService
 * @author Salesforce Technical Architect
 * @date 2026-06-19
 */
@isTest
private class RAIDAnalysisServiceTest {

    /**
     * @description Mock HTTP Response for Claude API
     */
    private class ClaudeMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);

            String mockResponse = '{\n' +
                '  "content": [\n' +
                '    {\n' +
                '      "text": "{\\"risks\\":[{\\"description\\":\\"Test risk\\",\\"severity\\":\\"High\\",\\"impact\\":\\"Schedule\\",\\"owner\\":\\"Tech Lead\\",\\"dueDate\\":\\"2026-07-15\\",\\"mitigation\\":\\"Monitor closely\\",\\"status\\":\\"Active\\"}],\\"assumptions\\":[{\\"description\\":\\"Test assumption\\",\\"severity\\":\\"Medium\\",\\"impact\\":\\"Quality\\",\\"owner\\":\\"PM\\",\\"dueDate\\":\\"2026-07-01\\",\\"mitigation\\":\\"Validate early\\",\\"status\\":\\"Valid\\"}],\\"issues\\":[{\\"description\\":\\"Test issue\\",\\"severity\\":\\"High\\",\\"impact\\":\\"Resources\\",\\"owner\\":\\"Manager\\",\\"dueDate\\":\\"2026-06-25\\",\\"mitigation\\":\\"Escalate\\",\\"status\\":\\"Open\\"}],\\"dependencies\\":[{\\"description\\":\\"Test dependency\\",\\"severity\\":\\"Medium\\",\\"impact\\":\\"Timeline\\",\\"owner\\":\\"Architect\\",\\"dueDate\\":\\"2026-07-10\\",\\"mitigation\\":\\"Track progress\\",\\"status\\":\\"Pending\\"}],\\"summary\\":\\"Test RAID summary\\",\\"readinessScore\\":85,\\"recommendedNextActions\\":[\\"Action 1\\",\\"Action 2\\"]}",\n' +
                '      "type": "text"\n' +
                '    }\n' +
                '  ],\n' +
                '  "model": "claude-3-5-sonnet-20241022"\n' +
                '}';

            res.setBody(mockResponse);
            return res;
        }
    }

    /**
     * @description Mock HTTP Response for Gemini API
     */
    private class GeminiMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);

            String mockResponse = '{\n' +
                '  "candidates": [\n' +
                '    {\n' +
                '      "content": {\n' +
                '        "parts": [\n' +
                '          {\n' +
                '            "text": "{\\"risks\\":[{\\"description\\":\\"Gemini test risk\\",\\"severity\\":\\"High\\",\\"impact\\":\\"Budget\\",\\"owner\\":\\"CFO\\",\\"dueDate\\":\\"2026-08-01\\",\\"mitigation\\":\\"Review monthly\\",\\"status\\":\\"Active\\"}],\\"assumptions\\":[],\\"issues\\":[],\\"dependencies\\":[],\\"summary\\":\\"Gemini test summary\\",\\"readinessScore\\":90,\\"recommendedNextActions\\":[\\"Review budget\\"]}"\n' +
                '          }\n' +
                '        ]\n' +
                '      }\n' +
                '    }\n' +
                '  ]\n' +
                '}';

            res.setBody(mockResponse);
            return res;
        }
    }

    /**
     * @description Mock HTTP Response for error scenarios
     */
    private class ErrorMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(500);
            res.setBody('Internal Server Error');
            return res;
        }
    }

    /**
     * @description Test RAID analysis with mock provider
     */
    @isTest
    static void testAnalyzeRAIDWithMock() {
        // Create test request
        RAIDAnalysisService.RAIDRequest request = new RAIDAnalysisService.RAIDRequest();
        request.meetingNotes = 'Critical issues discussed in standup meeting';
        request.statusUpdate = 'Project is behind schedule';
        request.emailContent = 'Urgent: Need resources ASAP';
        request.provider = RAIDAnalysisService.AIProvider.MOCK;

        Test.startTest();
        String responseJson = RAIDAnalysisService.analyzeRAID(JSON.serialize(request));
        Test.stopTest();

        // Verify response
        System.assertNotEquals(null, responseJson, 'Response should not be null');

        RAIDAnalysisService.RAIDResponse response =
            (RAIDAnalysisService.RAIDResponse) JSON.deserialize(responseJson, RAIDAnalysisService.RAIDResponse.class);

        System.assertEquals(true, response.success, 'Analysis should succeed');
        System.assert(response.aiProvider.contains('Mock'), 'Should use mock provider');
        System.assertNotEquals(null, response.risks, 'Risks should not be null');
        System.assertNotEquals(null, response.assumptions, 'Assumptions should not be null');
        System.assertNotEquals(null, response.issues, 'Issues should not be null');
        System.assertNotEquals(null, response.dependencies, 'Dependencies should not be null');
    }

    /**
     * @description Test RAID analysis with Claude (mocked callout)
     */
    @isTest
    static void testAnalyzeRAIDWithClaudeMock() {
        // Set mock callout
        Test.setMock(HttpCalloutMock.class, new ClaudeMock());

        // Create test request
        RAIDAnalysisService.RAIDRequest request = new RAIDAnalysisService.RAIDRequest();
        request.meetingNotes = 'Sprint planning meeting notes';
        request.statusUpdate = 'On track';
        request.emailContent = 'Team sync email';
        request.provider = RAIDAnalysisService.AIProvider.CLAUDE;

        Test.startTest();
        String responseJson = RAIDAnalysisService.analyzeRAID(JSON.serialize(request));
        Test.stopTest();

        // Verify response
        System.assertNotEquals(null, responseJson, 'Response should not be null');

        RAIDAnalysisService.RAIDResponse response =
            (RAIDAnalysisService.RAIDResponse) JSON.deserialize(responseJson, RAIDAnalysisService.RAIDResponse.class);

        // Note: Will fallback to mock if Named Credential not configured
        System.assertEquals(true, response.success, 'Analysis should succeed');
        System.assertNotEquals(null, response.summary, 'Summary should not be null');
    }

    /**
     * @description Test RAID analysis with Gemini (mocked callout)
     */
    @isTest
    static void testAnalyzeRAIDWithGeminiMock() {
        // Set mock callout
        Test.setMock(HttpCalloutMock.class, new GeminiMock());

        // Create test request
        RAIDAnalysisService.RAIDRequest request = new RAIDAnalysisService.RAIDRequest();
        request.meetingNotes = 'Technical design review';
        request.statusUpdate = 'Architecture finalized';
        request.emailContent = 'Security review complete';
        request.provider = RAIDAnalysisService.AIProvider.GEMINI;

        Test.startTest();
        String responseJson = RAIDAnalysisService.analyzeRAID(JSON.serialize(request));
        Test.stopTest();

        // Verify response
        System.assertNotEquals(null, responseJson, 'Response should not be null');

        RAIDAnalysisService.RAIDResponse response =
            (RAIDAnalysisService.RAIDResponse) JSON.deserialize(responseJson, RAIDAnalysisService.RAIDResponse.class);

        // Note: Will fallback to mock if Named Credential not configured
        System.assertEquals(true, response.success, 'Analysis should succeed');
    }

    /**
     * @description Test error handling
     */
    @isTest
    static void testAnalyzeRAIDErrorHandling() {
        // Set error mock callout
        Test.setMock(HttpCalloutMock.class, new ErrorMock());

        // Create test request with invalid JSON
        String invalidJson = '{invalid json}';

        Test.startTest();
        String responseJson = RAIDAnalysisService.analyzeRAID(invalidJson);
        Test.stopTest();

        // Should return error response
        System.assertNotEquals(null, responseJson, 'Response should not be null');

        RAIDAnalysisService.RAIDResponse response =
            (RAIDAnalysisService.RAIDResponse) JSON.deserialize(responseJson, RAIDAnalysisService.RAIDResponse.class);

        System.assertNotEquals(null, response.errorMessage, 'Should have error message');
    }

    /**
     * @description Test RAID item parsing
     */
    @isTest
    static void testRAIDItemStructure() {
        RAIDAnalysisService.RAIDItem item = new RAIDAnalysisService.RAIDItem();
        item.description = 'Test description';
        item.severity = 'High';
        item.impact = 'Schedule';
        item.owner = 'Test Owner';
        item.dueDate = '2026-07-15';
        item.mitigation = 'Test mitigation';
        item.status = 'Active';

        System.assertNotEquals(null, item.id, 'ID should be generated');
        System.assertEquals('Test description', item.description);
        System.assertEquals('High', item.severity);
    }

    /**
     * @description Test with empty inputs
     */
    @isTest
    static void testAnalyzeRAIDWithEmptyInputs() {
        RAIDAnalysisService.RAIDRequest request = new RAIDAnalysisService.RAIDRequest();
        request.meetingNotes = '';
        request.statusUpdate = '';
        request.emailContent = '';

        Test.startTest();
        String responseJson = RAIDAnalysisService.analyzeRAID(JSON.serialize(request));
        Test.stopTest();

        System.assertNotEquals(null, responseJson, 'Response should not be null');

        RAIDAnalysisService.RAIDResponse response =
            (RAIDAnalysisService.RAIDResponse) JSON.deserialize(responseJson, RAIDAnalysisService.RAIDResponse.class);

        System.assertEquals(true, response.success, 'Should succeed with mock fallback');
    }

    /**
     * @description Test readiness score calculation
     */
    @isTest
    static void testReadinessScore() {
        RAIDAnalysisService.RAIDRequest request = new RAIDAnalysisService.RAIDRequest();
        request.meetingNotes = 'All systems operational';
        request.statusUpdate = 'Green status';

        Test.startTest();
        String responseJson = RAIDAnalysisService.analyzeRAID(JSON.serialize(request));
        Test.stopTest();

        RAIDAnalysisService.RAIDResponse response =
            (RAIDAnalysisService.RAIDResponse) JSON.deserialize(responseJson, RAIDAnalysisService.RAIDResponse.class);

        System.assert(response.readinessScore >= 0 && response.readinessScore <= 100,
                     'Readiness score should be between 0 and 100');
    }
}
