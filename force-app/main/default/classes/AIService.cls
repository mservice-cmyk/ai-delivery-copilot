/**
 * @description Service class for AI provider integration
 * Handles HTTP callouts to external AI providers using Named Credentials
 * Supports Claude (Anthropic) and Gemini (Google) APIs
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
        MOCK
    }

    private static AIProvider currentProvider = null; // Auto-detect by default

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
                return AIProvider.CLAUDE;
            }

            // Check for Gemini Named Credential
            List<NamedCredential> geminiNC = [
                SELECT Id FROM NamedCredential
                WHERE DeveloperName = 'Gemini_AI_API'
                LIMIT 1
            ];
            if (!geminiNC.isEmpty()) {
                return AIProvider.GEMINI;
            }
        } catch (Exception e) {
            System.debug('Error detecting AI provider: ' + e.getMessage());
        }

        // Default to mock if no provider configured
        return AIProvider.MOCK;
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

        if (provider == AIProvider.MOCK) {
            return createMockResponse(prompt);
        }

        try {
            if (provider == AIProvider.CLAUDE) {
                return callClaude(prompt, systemContext, maxTokens);
            } else if (provider == AIProvider.GEMINI) {
                return callGemini(prompt, systemContext, maxTokens);
            } else {
                return createMockResponse(prompt);
            }
        } catch (Exception e) {
            System.debug('AI Service Exception: ' + e.getMessage());
            // Fallback to mock mode on error
            return createMockResponse(prompt);
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
     * @description Create a mock response for testing
     * @param prompt The original prompt
     * @return AIResponse Mock response
     */
    private static AIResponse createMockResponse(String prompt) {
        String mockContent = 'Mock AI Response: This is a simulated response for prompt: ' +
                           prompt.left(100) + '...';
        return new AIResponse(mockContent, true, 'mock-model', null);
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
