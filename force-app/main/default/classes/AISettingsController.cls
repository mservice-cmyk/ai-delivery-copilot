/**
 * @description Controller for AI Settings component
 * Manages AI provider configuration and connection testing
 * @author Salesforce Technical Architect
 * @date 2026-06-19
 */
public with sharing class AISettingsController {

    /**
     * @description Get current AI provider settings
     * @return String JSON with provider info
     */
    @AuraEnabled(cacheable=true)
    public static String getAIProviderSettings() {
        try {
            AIService.AIProvider currentProvider = AIService.getProvider();
            AIService.AIMode currentMode = AIService.getMode();

            Map<String, Object> settings = new Map<String, Object>{
                'currentProvider' => currentProvider.name(),
                'currentMode' => currentMode.name(),
                'aiSourceName' => AIService.getAISourceName(),
                'aiSourceBadge' => AIService.getAISourceBadge(),
                'availableProviders' => getAvailableProviders()
            };

            return JSON.serialize(settings);
        } catch (Exception e) {
            throw new AuraHandledException('Error getting AI settings: ' + e.getMessage());
        }
    }

    /**
     * @description Get list of available AI providers with their status
     * @return List<Map<String, Object>> Provider details
     */
    private static List<Map<String, Object>> getAvailableProviders() {
        List<Map<String, Object>> providers = new List<Map<String, Object>>();

        // Demo Mode - always available
        providers.add(new Map<String, Object>{
            'name' => 'DEMO',
            'displayName' => 'Demo Mode',
            'description' => 'Realistic demo responses without AI API costs',
            'status' => 'AVAILABLE',
            'statusIcon' => '🟡',
            'requiresCredential' => false
        });

        // Claude - check for Named Credential
        Boolean claudeAvailable = checkNamedCredential('Claude_AI_API');
        providers.add(new Map<String, Object>{
            'name' => 'CLAUDE',
            'displayName' => 'Claude (Anthropic)',
            'description' => 'Advanced AI powered by Claude 3.5 Sonnet',
            'status' => claudeAvailable ? 'CONNECTED' : 'NOT_CONFIGURED',
            'statusIcon' => claudeAvailable ? '🟢' : '⚪',
            'requiresCredential' => true,
            'credentialName' => 'Claude_AI_API'
        });

        // Gemini - check for Named Credential
        Boolean geminiAvailable = checkNamedCredential('Gemini_AI_API');
        providers.add(new Map<String, Object>{
            'name' => 'GEMINI',
            'displayName' => 'Gemini (Google)',
            'description' => 'Google\'s advanced AI model Gemini 1.5 Pro',
            'status' => geminiAvailable ? 'CONNECTED' : 'NOT_CONFIGURED',
            'statusIcon' => geminiAvailable ? '🟢' : '⚪',
            'requiresCredential' => true,
            'credentialName' => 'Gemini_AI_API'
        });

        return providers;
    }

    /**
     * @description Check if a Named Credential exists
     * @param developerName The Named Credential developer name
     * @return Boolean True if exists
     */
    private static Boolean checkNamedCredential(String developerName) {
        try {
            List<NamedCredential> credentials = [
                SELECT Id
                FROM NamedCredential
                WHERE DeveloperName = :developerName
                LIMIT 1
            ];
            return !credentials.isEmpty();
        } catch (Exception e) {
            System.debug('Error checking Named Credential: ' + e.getMessage());
            return false;
        }
    }

    /**
     * @description Test connection to selected AI provider
     * @param providerName The provider to test (DEMO, CLAUDE, GEMINI)
     * @return String JSON with test results
     */
    @AuraEnabled
    public static String testConnection(String providerName) {
        try {
            AIService.AIProvider provider;

            // Parse provider name
            if (providerName == 'DEMO') {
                provider = AIService.AIProvider.DEMO;
            } else if (providerName == 'CLAUDE') {
                provider = AIService.AIProvider.CLAUDE;
            } else if (providerName == 'GEMINI') {
                provider = AIService.AIProvider.GEMINI;
            } else {
                throw new IllegalArgumentException('Invalid provider: ' + providerName);
            }

            // Temporarily set provider for test
            AIService.AIProvider originalProvider = AIService.getProvider();
            AIService.setProvider(provider);

            // Perform test call
            AIService.AIResponse response = AIService.callAI(
                'Test connection - respond with "OK"',
                'You are testing connectivity. Respond with exactly "OK".',
                100
            );

            // Restore original provider
            AIService.setProvider(originalProvider);

            // Build result
            Map<String, Object> result = new Map<String, Object>{
                'success' => response.success,
                'provider' => provider.name(),
                'model' => response.model,
                'responsePreview' => response.content != null ? response.content.left(100) : null,
                'error' => response.error,
                'timestamp' => DateTime.now().format('yyyy-MM-dd HH:mm:ss')
            };

            return JSON.serialize(result);

        } catch (Exception e) {
            Map<String, Object> errorResult = new Map<String, Object>{
                'success' => false,
                'error' => e.getMessage(),
                'timestamp' => DateTime.now().format('yyyy-MM-dd HH:mm:ss')
            };
            return JSON.serialize(errorResult);
        }
    }

    /**
     * @description Set user's preferred AI provider
     * @param providerName The provider to use (DEMO, CLAUDE, GEMINI)
     * @return String Success message
     */
    @AuraEnabled
    public static String setPreferredProvider(String providerName) {
        try {
            AIService.AIProvider provider;

            if (providerName == 'DEMO') {
                provider = AIService.AIProvider.DEMO;
            } else if (providerName == 'CLAUDE') {
                provider = AIService.AIProvider.CLAUDE;
            } else if (providerName == 'GEMINI') {
                provider = AIService.AIProvider.GEMINI;
            } else {
                throw new IllegalArgumentException('Invalid provider: ' + providerName);
            }

            // Set the provider
            AIService.setProvider(provider);

            // Note: In a production implementation, you would store this preference
            // in Custom Metadata or Custom Settings for persistence
            // For now, it's only set for the current session

            return 'AI Provider set to ' + provider.name() + ' successfully';

        } catch (Exception e) {
            throw new AuraHandledException('Error setting provider: ' + e.getMessage());
        }
    }

    /**
     * @description Get setup instructions for configuring Named Credentials
     * @return String JSON with setup instructions
     */
    @AuraEnabled(cacheable=true)
    public static String getSetupInstructions() {
        Map<String, Object> instructions = new Map<String, Object>{
            'claude' => new Map<String, Object>{
                'title' => 'Configure Claude AI',
                'steps' => new List<String>{
                    'Go to Setup → Named Credentials',
                    'Create new Named Credential: Claude_AI_API',
                    'URL: https://api.anthropic.com',
                    'Add custom header: x-api-key with your Anthropic API key',
                    'Authentication Protocol: No Authentication (API key in header)',
                    'Test the connection',
                    'Refresh this page to see Connected status'
                },
                'docsUrl' => 'https://docs.anthropic.com/claude/reference/getting-started-with-the-api'
            },
            'gemini' => new Map<String, Object>{
                'title' => 'Configure Gemini AI',
                'steps' => new List<String>{
                    'Go to Setup → Named Credentials',
                    'Create new Named Credential: Gemini_AI_API',
                    'URL: https://generativelanguage.googleapis.com',
                    'Add API key as query parameter or in header',
                    'Authentication Protocol: Configure based on Google requirements',
                    'Test the connection',
                    'Refresh this page to see Connected status'
                },
                'docsUrl' => 'https://ai.google.dev/gemini-api/docs'
            }
        };

        return JSON.serialize(instructions);
    }
}
