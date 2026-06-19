/**
 * @description Service class for RAID (Risks, Assumptions, Issues, Dependencies) Analysis using AI
 * @author Salesforce Technical Architect
 * @date 2026-06-19
 */
public with sharing class RAIDAnalysisService {

    /**
     * @description RAID Analysis Request wrapper
     */
    public class RAIDRequest {
        @AuraEnabled public String meetingNotes { get; set; }
        @AuraEnabled public String statusUpdate { get; set; }
        @AuraEnabled public String emailContent { get; set; }

        public RAIDRequest() {
            // No provider field needed - AIService handles auto-detection
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
        @AuraEnabled public String aiSourceBadge { get; set; }
        @AuraEnabled public Boolean success { get; set; }
        @AuraEnabled public String errorMessage { get; set; }

        public RAIDResponse() {
            this.risks = new List<RAIDItem>();
            this.assumptions = new List<RAIDItem>();
            this.issues = new List<RAIDItem>();
            this.dependencies = new List<RAIDItem>();
            this.recommendedNextActions = new List<String>();
            this.success = false;
            this.aiProvider = 'Demo Mode';
            this.aiSourceBadge = '🟡 Demo Mode';
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
            // Build the AI prompt
            String prompt = buildRAIDPrompt(request);
            String systemContext = buildSystemContext();

            // Call AIService (it handles Live AI vs Demo Mode automatically)
            AIService.AIResponse aiResponse = AIService.callAI(prompt, systemContext, 4000);

            // Set AI source info
            response.aiProvider = AIService.getAISourceName();
            response.aiSourceBadge = AIService.getAISourceBadge();

            // Parse AI response
            if (aiResponse.success && String.isNotBlank(aiResponse.content)) {
                response = parseAIResponse(aiResponse.content, response.aiProvider);
                response.aiProvider = AIService.getAISourceName();
                response.aiSourceBadge = AIService.getAISourceBadge();
                response.success = true;
            } else {
                // Fallback to demo data if AI response is empty
                response = parseDemoResponse(generateDemoRAIDJSON(request));
                response.aiProvider = 'Demo Mode (Fallback)';
                response.aiSourceBadge = '🟡 Demo Mode';
                response.success = true;
            }

        } catch (Exception e) {
            System.debug('RAID Analysis error: ' + e.getMessage());
            response = parseDemoResponse(generateDemoRAIDJSON(request));
            response.aiProvider = 'Demo Mode (Exception)';
            response.aiSourceBadge = '🟡 Demo Mode';
            response.errorMessage = e.getMessage();
            response.success = true; // Still return data, but note it's demo
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
            // Fallback to demo data if parsing fails
            RAIDRequest demoRequest = new RAIDRequest();
            return parseDemoResponse(generateDemoRAIDJSON(demoRequest));
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
     * @description Generate demo RAID JSON for demo mode
     */
    private static String generateDemoRAIDJSON(RAIDRequest request) {
        Boolean hasHighPriority = false;
        if (request != null) {
            String allContent = (request.meetingNotes + request.statusUpdate + request.emailContent).toLowerCase();
            hasHighPriority = allContent.contains('critical') || allContent.contains('urgent') || allContent.contains('blocker');
        }

        String severity = hasHighPriority ? 'High' : 'Medium';

        return '{\n' +
               '  "risks": [\n' +
               '    {"description": "Integration timeline with external systems requires close monitoring", "severity": "' + severity + '", "impact": "Schedule", "owner": "Technical Lead", "dueDate": "2026-07-15", "mitigation": "Weekly sync with vendor, parallel mock development", "status": "Active"},\n' +
               '    {"description": "Data migration complexity from legacy system may require additional validation", "severity": "Medium", "impact": "Quality", "owner": "Data Architect", "dueDate": "2026-07-20", "mitigation": "Implement comprehensive validation framework", "status": "Active"}\n' +
               '  ],\n' +
               '  "assumptions": [\n' +
               '    {"description": "Stakeholders will provide timely UAT feedback within 48-72 hours", "severity": "Medium", "impact": "Schedule", "owner": "Project Manager", "dueDate": "2026-07-01", "mitigation": "Establish clear SLA, build buffer time", "status": "Valid"},\n' +
               '    {"description": "All required Salesforce licenses available prior to UAT", "severity": "High", "impact": "Resource", "owner": "License Manager", "dueDate": "2026-06-25", "mitigation": "Submit requests with 3-week lead time", "status": "Valid"}\n' +
               '  ],\n' +
               '  "issues": [\n' +
               '    {"description": "Sandbox environment refresh delayed impacting development timeline", "severity": "' + severity + '", "impact": "Development", "owner": "DevOps Lead", "dueDate": "2026-06-25", "mitigation": "Expedite refresh request, utilize partial sandbox", "status": "In Progress"},\n' +
               '    {"description": "Key team members scheduled for overlapping PTO during critical phase", "severity": "Medium", "impact": "Resource", "owner": "Resource Manager", "dueDate": "2026-06-30", "mitigation": "Cross-train backup resources", "status": "In Progress"}\n' +
               '  ],\n' +
               '  "dependencies": [\n' +
               '    {"description": "Marketing Cloud integration requires Sales Cloud configuration first", "severity": "High", "impact": "Sequential", "owner": "Integration Lead", "dueDate": "2026-07-15", "mitigation": "Defined interface contracts, weekly checks", "status": "On Track"},\n' +
               '    {"description": "Production deployment requires successful security compliance scans", "severity": "High", "impact": "Go-Live", "owner": "Compliance Officer", "dueDate": "2026-08-01", "mitigation": "Schedule scans 2 weeks prior, maintain audit trail", "status": "Pending"}\n' +
               '  ],\n' +
               '  "summary": "Demo RAID analysis - comprehensive analysis identified key areas requiring attention for project success",\n' +
               '  "readinessScore": 78,\n' +
               '  "recommendedNextActions": ["Establish weekly vendor sync meetings", "Complete security review requirements", "Schedule UAT kickoff session"]\n' +
               '}';
    }

    /**
     * @description Parse demo response
     */
    private static RAIDResponse parseDemoResponse(String demoJSON) {
        RAIDResponse response = parseAIResponse(demoJSON, 'Demo Mode');
        response.aiProvider = 'Demo Mode';
        response.aiSourceBadge = '🟡 Demo Mode';
        return response;
    }

}
