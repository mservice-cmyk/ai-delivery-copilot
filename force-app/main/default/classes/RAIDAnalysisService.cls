/**
 * @description Service class for RAID (Risks, Assumptions, Issues, Dependencies) Analysis using AI
 * @author Salesforce Technical Architect
 * @date 2026-06-19
 */
public with sharing class RAIDAnalysisService {

    /**
     * @description AI Provider configuration
     */
    public enum AIProvider {
        CLAUDE,
        GEMINI,
        MOCK
    }

    /**
     * @description RAID Analysis Request wrapper
     */
    public class RAIDRequest {
        @AuraEnabled public String meetingNotes { get; set; }
        @AuraEnabled public String statusUpdate { get; set; }
        @AuraEnabled public String emailContent { get; set; }
        @AuraEnabled public AIProvider provider { get; set; }

        public RAIDRequest() {
            this.provider = AIProvider.MOCK;
        }
    }

    /**
     * @description RAID Analysis Response wrapper
     */
    public class RAIDResponse {
        @AuraEnabled public List<RAIDItem> risks { get; set; }
        @AuraEnabled public List<RAIDItem> assumptions { get; set; }
        @AuraEnabled public List<RAIDItem> issues { get; set; }
        @AuraEnabled public List<RAIDItem> dependencies { get; set; }
        @AuraEnabled public String summary { get; set; }
        @AuraEnabled public Integer readinessScore { get; set; }
        @AuraEnabled public List<String> recommendedNextActions { get; set; }
        @AuraEnabled public String aiProvider { get; set; }
        @AuraEnabled public Boolean success { get; set; }
        @AuraEnabled public String errorMessage { get; set; }

        public RAIDResponse() {
            this.risks = new List<RAIDItem>();
            this.assumptions = new List<RAIDItem>();
            this.issues = new List<RAIDItem>();
            this.dependencies = new List<RAIDItem>();
            this.recommendedNextActions = new List<String>();
            this.success = false;
            this.aiProvider = 'Mock';
        }
    }

    /**
     * @description RAID Item structure
     */
    public class RAIDItem {
        @AuraEnabled public String id { get; set; }
        @AuraEnabled public String description { get; set; }
        @AuraEnabled public String severity { get; set; }
        @AuraEnabled public String impact { get; set; }
        @AuraEnabled public String owner { get; set; }
        @AuraEnabled public String dueDate { get; set; }
        @AuraEnabled public String mitigation { get; set; }
        @AuraEnabled public String status { get; set; }

        public RAIDItem() {
            this.id = generateId();
        }

        private String generateId() {
            return 'raid_' + String.valueOf(Math.abs(Crypto.getRandomLong()));
        }
    }

    /**
     * @description Main method to analyze RAID from user inputs
     * @param request RAIDRequest containing meeting notes, status, and email
     * @return RAIDResponse Analyzed RAID log
     */
    @AuraEnabled
    public static String analyzeRAID(String requestJson) {
        try {
            RAIDRequest request = (RAIDRequest) JSON.deserialize(requestJson, RAIDRequest.class);
            RAIDResponse response = performRAIDAnalysis(request);
            return JSON.serialize(response);
        } catch (Exception e) {
            System.debug('Error in analyzeRAID: ' + e.getMessage());
            RAIDResponse errorResponse = new RAIDResponse();
            errorResponse.errorMessage = 'Failed to analyze RAID: ' + e.getMessage();
            errorResponse.aiProvider = 'Error';
            return JSON.serialize(errorResponse);
        }
    }

    /**
     * @description Perform RAID analysis using configured AI provider
     */
    private static RAIDResponse performRAIDAnalysis(RAIDRequest request) {
        RAIDResponse response = new RAIDResponse();

        try {
            // Determine which provider to use
            AIProvider provider = getConfiguredProvider();

            // Build the AI prompt
            String prompt = buildRAIDPrompt(request);
            String systemContext = buildSystemContext();

            // Call appropriate AI provider
            String aiResponseContent;
            Boolean callSuccess = false;

            if (provider == AIProvider.CLAUDE) {
                aiResponseContent = callClaudeForRAID(prompt, systemContext);
                callSuccess = String.isNotBlank(aiResponseContent);
                response.aiProvider = 'Claude';
            } else if (provider == AIProvider.GEMINI) {
                aiResponseContent = callGeminiForRAID(prompt, systemContext);
                callSuccess = String.isNotBlank(aiResponseContent);
                response.aiProvider = 'Gemini';
            } else {
                // Fallback to mock
                aiResponseContent = generateMockRAIDJSON(request);
                callSuccess = true;
                response.aiProvider = 'Mock (Fallback)';
            }

            // Parse AI response
            if (callSuccess && String.isNotBlank(aiResponseContent)) {
                response = parseAIResponse(aiResponseContent, response.aiProvider);
                response.success = true;
            } else {
                // Fallback to mock if AI call failed
                response = parseMockResponse(generateMockRAIDJSON(request));
                response.aiProvider = 'Mock (AI Failed)';
                response.success = true;
            }

        } catch (Exception e) {
            System.debug('RAID Analysis error: ' + e.getMessage());
            response = parseMockResponse(generateMockRAIDJSON(request));
            response.aiProvider = 'Mock (Exception)';
            response.errorMessage = e.getMessage();
            response.success = true; // Still return data, but note it's mock
        }

        return response;
    }

    /**
     * @description Build the AI prompt for RAID analysis
     */
    private static String buildRAIDPrompt(RAIDRequest request) {
        String prompt = 'Analyze the following project information and generate a comprehensive RAID (Risks, Assumptions, Issues, Dependencies) log.\n\n';

        if (String.isNotBlank(request.meetingNotes)) {
            prompt += '**Meeting Notes:**\n' + request.meetingNotes + '\n\n';
        }

        if (String.isNotBlank(request.statusUpdate)) {
            prompt += '**Status Update:**\n' + request.statusUpdate + '\n\n';
        }

        if (String.isNotBlank(request.emailContent)) {
            prompt += '**Email Content:**\n' + request.emailContent + '\n\n';
        }

        prompt += 'Please analyze the above information and return a JSON object with the following structure:\n\n';
        prompt += getExpectedJSONStructure();
        prompt += '\n\nIMPORTANT: Return ONLY valid JSON. Do not include any markdown formatting, code blocks, or explanatory text. The response must start with { and end with }.';

        return prompt;
    }

    /**
     * @description Build system context for AI
     */
    private static String buildSystemContext() {
        return 'You are an expert Salesforce project manager and technical architect specialized in risk management and project planning. ' +
               'Your task is to analyze project information (meeting notes, status updates, emails) and identify potential ' +
               'Risks, Assumptions, Issues, and Dependencies (RAID). ' +
               'For each RAID item, provide: description, severity (High/Medium/Low), impact, owner role, due date (YYYY-MM-DD format), ' +
               'mitigation strategy, and status. ' +
               'Also provide an overall readiness score (0-100) and recommended next actions. ' +
               'Focus on Salesforce-specific concerns like: data migration, integration complexity, governor limits, security, ' +
               'user adoption, change management, and technical debt. ' +
               'Return ONLY valid JSON matching the requested structure.';
    }

    /**
     * @description Get expected JSON structure documentation
     */
    private static String getExpectedJSONStructure() {
        return '{\n' +
               '  "risks": [{"description": "", "severity": "", "impact": "", "owner": "", "dueDate": "YYYY-MM-DD", "mitigation": "", "status": ""}],\n' +
               '  "assumptions": [{"description": "", "severity": "", "impact": "", "owner": "", "dueDate": "YYYY-MM-DD", "mitigation": "", "status": ""}],\n' +
               '  "issues": [{"description": "", "severity": "", "impact": "", "owner": "", "dueDate": "YYYY-MM-DD", "mitigation": "", "status": ""}],\n' +
               '  "dependencies": [{"description": "", "severity": "", "impact": "", "owner": "", "dueDate": "YYYY-MM-DD", "mitigation": "", "status": ""}],\n' +
               '  "summary": "",\n' +
               '  "readinessScore": 85,\n' +
               '  "recommendedNextActions": []\n' +
               '}';
    }

    /**
     * @description Call Claude AI for RAID analysis
     */
    private static String callClaudeForRAID(String prompt, String systemContext) {
        try {
            // TODO: Configure Named Credential 'Claude_AI_API' in Salesforce
            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:Claude_AI_API/v1/messages');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');

            Map<String, Object> requestBody = new Map<String, Object>{
                'model' => 'claude-3-5-sonnet-20241022',
                'max_tokens' => 4000,
                'system' => systemContext,
                'messages' => new List<Map<String, String>>{
                    new Map<String, String>{
                        'role' => 'user',
                        'content' => prompt
                    }
                }
            };

            req.setBody(JSON.serialize(requestBody));
            req.setTimeout(120000);

            Http http = new Http();
            HttpResponse res = http.send(req);

            if (res.getStatusCode() == 200) {
                Map<String, Object> responseBody = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                List<Object> content = (List<Object>) responseBody.get('content');

                if (content != null && !content.isEmpty()) {
                    Map<String, Object> firstContent = (Map<String, Object>) content[0];
                    return (String) firstContent.get('text');
                }
            } else {
                System.debug('Claude API Error: ' + res.getStatusCode() + ' - ' + res.getBody());
            }

        } catch (Exception e) {
            System.debug('Claude callout exception: ' + e.getMessage());
        }

        return null;
    }

    /**
     * @description Call Gemini AI for RAID analysis
     */
    private static String callGeminiForRAID(String prompt, String systemContext) {
        try {
            // TODO: Configure Named Credential 'Gemini_AI_API' in Salesforce
            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:Gemini_AI_API/v1beta/models/gemini-1.5-pro-latest:generateContent');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');

            String fullPrompt = systemContext + '\n\n' + prompt;

            Map<String, Object> requestBody = new Map<String, Object>{
                'contents' => new List<Map<String, Object>>{
                    new Map<String, Object>{
                        'parts' => new List<Map<String, String>>{
                            new Map<String, String>{
                                'text' => fullPrompt
                            }
                        }
                    }
                },
                'generationConfig' => new Map<String, Object>{
                    'maxOutputTokens' => 4000,
                    'temperature' => 0.7
                }
            };

            req.setBody(JSON.serialize(requestBody));
            req.setTimeout(120000);

            Http http = new Http();
            HttpResponse res = http.send(req);

            if (res.getStatusCode() == 200) {
                Map<String, Object> responseBody = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                List<Object> candidates = (List<Object>) responseBody.get('candidates');

                if (candidates != null && !candidates.isEmpty()) {
                    Map<String, Object> firstCandidate = (Map<String, Object>) candidates[0];
                    Map<String, Object> content = (Map<String, Object>) firstCandidate.get('content');
                    List<Object> parts = (List<Object>) content.get('parts');
                    Map<String, Object> firstPart = (Map<String, Object>) parts[0];

                    return (String) firstPart.get('text');
                }
            } else {
                System.debug('Gemini API Error: ' + res.getStatusCode() + ' - ' + res.getBody());
            }

        } catch (Exception e) {
            System.debug('Gemini callout exception: ' + e.getMessage());
        }

        return null;
    }

    /**
     * @description Parse AI response (could be from Claude or Gemini)
     */
    private static RAIDResponse parseAIResponse(String aiContent, String providerName) {
        try {
            // Clean up response - remove markdown code blocks if present
            String cleanedContent = aiContent.trim();
            if (cleanedContent.startsWith('```json')) {
                cleanedContent = cleanedContent.substring(7);
            }
            if (cleanedContent.startsWith('```')) {
                cleanedContent = cleanedContent.substring(3);
            }
            if (cleanedContent.endsWith('```')) {
                cleanedContent = cleanedContent.substring(0, cleanedContent.length() - 3);
            }
            cleanedContent = cleanedContent.trim();

            // Parse JSON
            Map<String, Object> jsonData = (Map<String, Object>) JSON.deserializeUntyped(cleanedContent);

            RAIDResponse response = new RAIDResponse();
            response.aiProvider = providerName;
            response.success = true;

            // Parse each RAID section
            response.risks = parseRAIDItems((List<Object>) jsonData.get('risks'), 'risk');
            response.assumptions = parseRAIDItems((List<Object>) jsonData.get('assumptions'), 'assume');
            response.issues = parseRAIDItems((List<Object>) jsonData.get('issues'), 'issue');
            response.dependencies = parseRAIDItems((List<Object>) jsonData.get('dependencies'), 'dep');

            // Parse summary and score
            response.summary = (String) jsonData.get('summary');
            Object scoreObj = jsonData.get('readinessScore');
            response.readinessScore = scoreObj != null ? Integer.valueOf(String.valueOf(scoreObj)) : 75;

            // Parse recommended actions
            List<Object> actions = (List<Object>) jsonData.get('recommendedNextActions');
            if (actions != null) {
                for (Object action : actions) {
                    response.recommendedNextActions.add(String.valueOf(action));
                }
            }

            return response;

        } catch (Exception e) {
            System.debug('Error parsing AI response: ' + e.getMessage());
            // Fallback to mock if parsing fails
            RAIDRequest mockRequest = new RAIDRequest();
            return parseMockResponse(generateMockRAIDJSON(mockRequest));
        }
    }

    /**
     * @description Parse RAID items from JSON array
     */
    private static List<RAIDItem> parseRAIDItems(List<Object> items, String prefix) {
        List<RAIDItem> raidItems = new List<RAIDItem>();

        if (items != null) {
            Integer counter = 1;
            for (Object itemObj : items) {
                Map<String, Object> itemMap = (Map<String, Object>) itemObj;
                RAIDItem item = new RAIDItem();
                item.id = prefix + counter++;
                item.description = (String) itemMap.get('description');
                item.severity = (String) itemMap.get('severity');
                item.impact = (String) itemMap.get('impact');
                item.owner = (String) itemMap.get('owner');
                item.dueDate = (String) itemMap.get('dueDate');
                item.mitigation = (String) itemMap.get('mitigation');
                item.status = (String) itemMap.get('status');
                raidItems.add(item);
            }
        }

        return raidItems;
    }

    /**
     * @description Generate mock RAID JSON for fallback
     */
    private static String generateMockRAIDJSON(RAIDRequest request) {
        Boolean hasHighPriority = false;
        if (request != null) {
            String allContent = (request.meetingNotes + request.statusUpdate + request.emailContent).toLowerCase();
            hasHighPriority = allContent.contains('critical') || allContent.contains('urgent') || allContent.contains('blocker');
        }

        String severity = hasHighPriority ? 'High' : 'Medium';

        return '{\n' +
               '  "risks": [\n' +
               '    {"description": "Integration timeline with external systems requires monitoring", "severity": "' + severity + '", "impact": "Schedule", "owner": "Technical Lead", "dueDate": "2026-07-15", "mitigation": "Weekly sync with vendor, parallel mock development", "status": "Active"}\n' +
               '  ],\n' +
               '  "assumptions": [\n' +
               '    {"description": "Stakeholders will provide timely UAT feedback within 48-72 hours", "severity": "Medium", "impact": "Schedule", "owner": "Project Manager", "dueDate": "2026-07-01", "mitigation": "Establish clear SLA, build buffer time", "status": "Valid"}\n' +
               '  ],\n' +
               '  "issues": [\n' +
               '    {"description": "Sandbox environment refresh delayed impacting development", "severity": "' + severity + '", "impact": "Development", "owner": "DevOps Lead", "dueDate": "2026-06-25", "mitigation": "Expedite refresh request, utilize partial sandbox", "status": "In Progress"}\n' +
               '  ],\n' +
               '  "dependencies": [\n' +
               '    {"description": "Marketing Cloud integration requires Sales Cloud configuration first", "severity": "High", "impact": "Sequential", "owner": "Integration Lead", "dueDate": "2026-07-15", "mitigation": "Defined interface contracts, weekly checks", "status": "On Track"}\n' +
               '  ],\n' +
               '  "summary": "Mock RAID analysis - comprehensive analysis identified key areas requiring attention",\n' +
               '  "readinessScore": 78,\n' +
               '  "recommendedNextActions": ["Establish weekly vendor sync meetings", "Complete security review requirements", "Schedule UAT kickoff session"]\n' +
               '}';
    }

    /**
     * @description Parse mock response
     */
    private static RAIDResponse parseMockResponse(String mockJSON) {
        RAIDResponse response = parseAIResponse(mockJSON, 'Mock');
        response.aiProvider = 'Mock (Fallback)';
        return response;
    }

    /**
     * @description Get configured AI provider
     */
    private static AIProvider getConfiguredProvider() {
        // Check if Named Credentials are configured
        // Query NamedCredential to see which providers are available
        try {
            // Try to find Claude Named Credential
            List<NamedCredential> claudeCredentials = [
                SELECT Id, MasterLabel
                FROM NamedCredential
                WHERE DeveloperName = 'Claude_AI_API'
                LIMIT 1
            ];

            if (!claudeCredentials.isEmpty()) {
                return AIProvider.CLAUDE;
            }

            // Try to find Gemini Named Credential
            List<NamedCredential> geminiCredentials = [
                SELECT Id, MasterLabel
                FROM NamedCredential
                WHERE DeveloperName = 'Gemini_AI_API'
                LIMIT 1
            ];

            if (!geminiCredentials.isEmpty()) {
                return AIProvider.GEMINI;
            }

        } catch (Exception e) {
            System.debug('Error checking Named Credentials: ' + e.getMessage());
        }

        // Default to MOCK if no Named Credentials are configured
        return AIProvider.MOCK;
    }
}
