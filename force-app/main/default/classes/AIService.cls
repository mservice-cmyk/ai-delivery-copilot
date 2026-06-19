/**
 * @description Service class for AI provider integration
 * Handles HTTP callouts to external AI providers using Named Credentials
 * Supports Claude (Anthropic) and Gemini (Google) APIs with Demo Mode fallback
 * @author Salesforce Technical Architect
 * @date 2026-06-19
 */
public with sharing class AIService {

    private static final String CLAUDE_NAMED_CREDENTIAL = 'callout:Claude_AI_API';
    private static final String GEMINI_NAMED_CREDENTIAL = 'callout:Gemini_AI_API';
    private static final Integer TIMEOUT_MS = 120000; // 2 minutes

    /**
     * @description AI provider types
     */
    public enum AIProvider {
        CLAUDE,
        GEMINI,
        DEMO
    }

    /**
     * @description AI mode (Live vs Demo)
     */
    public enum AIMode {
        LIVE,  // Using real AI provider
        DEMO   // Using demo/mock responses
    }

    private static AIProvider currentProvider = null; // Auto-detect by default
    private static AIMode currentMode = null; // Auto-detect by default

    /**
     * @description Set the AI provider (for testing or explicit provider selection)
     * @param provider The provider to use
     */
    public static void setProvider(AIProvider provider) {
        currentProvider = provider;
    }

    /**
     * @description Get the current AI provider (auto-detects if not set)
     * @return AIProvider The current provider
     */
    public static AIProvider getProvider() {
        if (currentProvider == null) {
            currentProvider = detectProvider();
        }
        return currentProvider;
    }

    /**
     * @description Get the current AI mode (Live or Demo)
     * @return AIMode The current mode
     */
    public static AIMode getMode() {
        if (currentMode == null) {
            AIProvider provider = getProvider();
            currentMode = (provider == AIProvider.DEMO) ? AIMode.DEMO : AIMode.LIVE;
        }
        return currentMode;
    }

    /**
     * @description Get human-readable AI source name
     * @return String The AI source name for display
     */
    public static String getAISourceName() {
        AIProvider provider = getProvider();
        switch on provider {
            when CLAUDE {
                return 'Claude';
            }
            when GEMINI {
                return 'Gemini';
            }
            when DEMO {
                return 'Demo Mode';
            }
            when else {
                return 'Unknown';
            }
        }
    }

    /**
     * @description Get badge icon for AI source
     * @return String The badge icon (emoji)
     */
    public static String getAISourceBadge() {
        AIMode mode = getMode();
        return (mode == AIMode.LIVE) ? '🟢 Live AI' : '🟡 Demo Mode';
    }

    /**
     * @description Auto-detect which AI provider is configured
     * @return AIProvider The detected provider
     */
    private static AIProvider detectProvider() {
        try {
            // Check for Claude Named Credential
            List<NamedCredential> claudeNC = [
                SELECT Id FROM NamedCredential
                WHERE DeveloperName = 'Claude_AI_API'
                LIMIT 1
            ];
            if (!claudeNC.isEmpty()) {
                System.debug('AIService: Claude Named Credential detected - Live AI Mode');
                return AIProvider.CLAUDE;
            }

            // Check for Gemini Named Credential
            List<NamedCredential> geminiNC = [
                SELECT Id FROM NamedCredential
                WHERE DeveloperName = 'Gemini_AI_API'
                LIMIT 1
            ];
            if (!geminiNC.isEmpty()) {
                System.debug('AIService: Gemini Named Credential detected - Live AI Mode');
                return AIProvider.GEMINI;
            }
        } catch (Exception e) {
            System.debug('AIService: Error detecting AI provider: ' + e.getMessage());
        }

        // Default to Demo Mode if no provider configured
        System.debug('AIService: No Named Credential configured - Demo Mode active');
        return AIProvider.DEMO;
    }

    /**
     * @description Call AI provider with a prompt and return the response
     * @param prompt The prompt to send to the AI provider
     * @param systemContext Optional system context to guide AI behavior
     * @param maxTokens Maximum tokens for the response
     * @return AIResponse Parsed AI response
     */
    public static AIResponse callAI(String prompt, String systemContext, Integer maxTokens) {
        AIProvider provider = getProvider();
        String logPrefix = 'AIService.callAI: ';

        System.debug(logPrefix + 'Provider=' + provider + ', Mode=' + getMode());

        if (provider == AIProvider.DEMO) {
            System.debug(logPrefix + 'Using Demo Mode responses');
            return createDemoResponse(prompt);
        }

        try {
            if (provider == AIProvider.CLAUDE) {
                System.debug(logPrefix + 'Calling Claude API');
                AIResponse response = callClaude(prompt, systemContext, maxTokens);
                System.debug(logPrefix + 'Claude API call ' + (response.success ? 'succeeded' : 'failed'));
                return response;
            } else if (provider == AIProvider.GEMINI) {
                System.debug(logPrefix + 'Calling Gemini API');
                AIResponse response = callGemini(prompt, systemContext, maxTokens);
                System.debug(logPrefix + 'Gemini API call ' + (response.success ? 'succeeded' : 'failed'));
                return response;
            } else {
                System.debug(logPrefix + 'Unknown provider, falling back to Demo Mode');
                return createDemoResponse(prompt);
            }
        } catch (Exception e) {
            System.debug(logPrefix + 'Exception occurred: ' + e.getMessage() + ', falling back to Demo Mode');
            // Fallback to Demo Mode on error
            return createDemoResponse(prompt);
        }
    }

    /**
     * @description Call Claude AI API
     * @param prompt The prompt
     * @param systemContext System context
     * @param maxTokens Max tokens
     * @return AIResponse The response
     */
    private static AIResponse callClaude(String prompt, String systemContext, Integer maxTokens) {
        try {
            Map<String, Object> requestBody = new Map<String, Object>{
                'model' => 'claude-3-5-sonnet-20241022',
                'max_tokens' => maxTokens != null ? maxTokens : 4000,
                'system' => systemContext != null ? systemContext : '',
                'messages' => new List<Map<String, Object>>{
                    new Map<String, Object>{
                        'role' => 'user',
                        'content' => prompt
                    }
                }
            };

            HttpRequest req = new HttpRequest();
            req.setEndpoint(CLAUDE_NAMED_CREDENTIAL + '/v1/messages');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setTimeout(TIMEOUT_MS);
            req.setBody(JSON.serialize(requestBody));

            Http http = new Http();
            HttpResponse res = http.send(req);

            if (res.getStatusCode() == 200) {
                Map<String, Object> responseBody = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                List<Object> content = (List<Object>) responseBody.get('content');
                if (content != null && !content.isEmpty()) {
                    Map<String, Object> firstContent = (Map<String, Object>) content[0];
                    String text = (String) firstContent.get('text');
                    return new AIResponse(text, true, 'Claude', null);
                }
            } else {
                System.debug('Claude API Error: ' + res.getStatusCode() + ' - ' + res.getBody());
                return createErrorResponse('Claude API returned status: ' + res.getStatusCode());
            }
        } catch (Exception e) {
            System.debug('Claude callout exception: ' + e.getMessage());
            return createErrorResponse('Claude error: ' + e.getMessage());
        }

        return createErrorResponse('Unknown Claude error');
    }

    /**
     * @description Call Gemini AI API
     * @param prompt The prompt
     * @param systemContext System context
     * @param maxTokens Max tokens
     * @return AIResponse The response
     */
    private static AIResponse callGemini(String prompt, String systemContext, Integer maxTokens) {
        try {
            // Gemini doesn't have separate system context, so merge it with prompt
            String fullPrompt = String.isNotBlank(systemContext)
                ? systemContext + '\n\n' + prompt
                : prompt;

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
                    'maxOutputTokens' => maxTokens != null ? maxTokens : 4000,
                    'temperature' => 0.7
                }
            };

            HttpRequest req = new HttpRequest();
            req.setEndpoint(GEMINI_NAMED_CREDENTIAL + '/v1beta/models/gemini-1.5-pro-latest:generateContent');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setTimeout(TIMEOUT_MS);
            req.setBody(JSON.serialize(requestBody));

            Http http = new Http();
            HttpResponse res = http.send(req);

            if (res.getStatusCode() == 200) {
                Map<String, Object> responseBody = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                List<Object> candidates = (List<Object>) responseBody.get('candidates');
                if (candidates != null && !candidates.isEmpty()) {
                    Map<String, Object> firstCandidate = (Map<String, Object>) candidates[0];
                    Map<String, Object> content = (Map<String, Object>) firstCandidate.get('content');
                    List<Object> parts = (List<Object>) content.get('parts');
                    if (parts != null && !parts.isEmpty()) {
                        Map<String, Object> firstPart = (Map<String, Object>) parts[0];
                        String text = (String) firstPart.get('text');
                        return new AIResponse(text, true, 'Gemini', null);
                    }
                }
            } else {
                System.debug('Gemini API Error: ' + res.getStatusCode() + ' - ' + res.getBody());
                return createErrorResponse('Gemini API returned status: ' + res.getStatusCode());
            }
        } catch (Exception e) {
            System.debug('Gemini callout exception: ' + e.getMessage());
            return createErrorResponse('Gemini error: ' + e.getMessage());
        }

        return createErrorResponse('Unknown Gemini error');
    }


    /**
     * @description Create a demo response for testing/demo purposes
     * @param prompt The original prompt
     * @return AIResponse Demo response
     */
    private static AIResponse createDemoResponse(String prompt) {
        String demoContent = 'Demo AI Response: This is a realistic simulated response. ' +
                           'Configure Named Credentials (Claude_AI_API or Gemini_AI_API) to enable Live AI. ' +
                           'Prompt preview: ' + prompt.left(100) + '...';
        return new AIResponse(demoContent, true, 'Demo Mode', null);
    }

    /**
     * @description Create an error response
     * @param errorMessage The error message
     * @return AIResponse Error response
     */
    private static AIResponse createErrorResponse(String errorMessage) {
        return new AIResponse(null, false, null, errorMessage);
    }

    /**
     * @description Wrapper class for AI response
     */
    public class AIResponse {
        public String content { get; set; }
        public Boolean success { get; set; }
        public String model { get; set; }
        public String error { get; set; }

        public AIResponse(String content, Boolean success, String model, String error) {
            this.content = content;
            this.success = success;
            this.model = model;
            this.error = error;
        }
    }
}
