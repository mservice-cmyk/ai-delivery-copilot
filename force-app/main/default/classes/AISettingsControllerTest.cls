/**
 * @description Test class for AISettingsController
 * @author Salesforce Technical Architect
 * @date 2026-06-19
 */
@IsTest
private class AISettingsControllerTest {

    /**
     * @description Test getting AI provider settings
     */
    @IsTest
    static void testGetAIProviderSettings() {
        Test.startTest();

        String settingsJson = AISettingsController.getAIProviderSettings();

        Test.stopTest();

        // Verify settings returned
        System.assertNotEquals(null, settingsJson, 'Settings JSON should not be null');

        // Parse JSON
        Map<String, Object> settings = (Map<String, Object>) JSON.deserializeUntyped(settingsJson);

        System.assert(settings.containsKey('currentProvider'), 'Should have currentProvider');
        System.assert(settings.containsKey('currentMode'), 'Should have currentMode');
        System.assert(settings.containsKey('aiSourceName'), 'Should have aiSourceName');
        System.assert(settings.containsKey('aiSourceBadge'), 'Should have aiSourceBadge');
        System.assert(settings.containsKey('availableProviders'), 'Should have availableProviders');

        // Verify available providers list
        List<Object> providers = (List<Object>) settings.get('availableProviders');
        System.assertEquals(3, providers.size(), 'Should have 3 providers (DEMO, CLAUDE, GEMINI)');
    }

    /**
     * @description Test connection to Demo Mode
     */
    @IsTest
    static void testConnectionDemo() {
        Test.startTest();

        String resultJson = AISettingsController.testConnection('DEMO');

        Test.stopTest();

        // Parse result
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(resultJson);

        System.assertEquals(true, result.get('success'), 'Demo connection should succeed');
        System.assertEquals('DEMO', result.get('provider'), 'Provider should be DEMO');
        System.assertNotEquals(null, result.get('timestamp'), 'Should have timestamp');
    }

    /**
     * @description Test connection to Claude (will use demo mode in test)
     */
    @IsTest
    static void testConnectionClaude() {
        Test.startTest();

        // In test context, no Named Credential exists, so will fallback to demo
        String resultJson = AISettingsController.testConnection('CLAUDE');

        Test.stopTest();

        // Parse result
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(resultJson);

        // Should succeed (fallback to demo)
        System.assertEquals(true, result.get('success'), 'Should succeed with demo fallback');
        System.assertNotEquals(null, result.get('timestamp'), 'Should have timestamp');
    }

    /**
     * @description Test connection to Gemini (will use demo mode in test)
     */
    @IsTest
    static void testConnectionGemini() {
        Test.startTest();

        // In test context, no Named Credential exists, so will fallback to demo
        String resultJson = AISettingsController.testConnection('GEMINI');

        Test.stopTest();

        // Parse result
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(resultJson);

        // Should succeed (fallback to demo)
        System.assertEquals(true, result.get('success'), 'Should succeed with demo fallback');
        System.assertNotEquals(null, result.get('timestamp'), 'Should have timestamp');
    }

    /**
     * @description Test connection with invalid provider
     */
    @IsTest
    static void testConnectionInvalid() {
        Test.startTest();

        String resultJson = AISettingsController.testConnection('INVALID');

        Test.stopTest();

        // Parse result
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(resultJson);

        System.assertEquals(false, result.get('success'), 'Should fail with invalid provider');
        System.assertNotEquals(null, result.get('error'), 'Should have error message');
    }

    /**
     * @description Test setting preferred provider
     */
    @IsTest
    static void testSetPreferredProvider() {
        Test.startTest();

        // Set to Demo
        String demoResult = AISettingsController.setPreferredProvider('DEMO');
        System.assert(demoResult.contains('DEMO'), 'Should confirm DEMO provider');

        // Set to Claude
        String claudeResult = AISettingsController.setPreferredProvider('CLAUDE');
        System.assert(claudeResult.contains('CLAUDE'), 'Should confirm CLAUDE provider');

        // Set to Gemini
        String geminiResult = AISettingsController.setPreferredProvider('GEMINI');
        System.assert(geminiResult.contains('GEMINI'), 'Should confirm GEMINI provider');

        Test.stopTest();
    }

    /**
     * @description Test setting invalid provider
     */
    @IsTest
    static void testSetInvalidProvider() {
        Test.startTest();

        try {
            AISettingsController.setPreferredProvider('INVALID');
            System.assert(false, 'Should have thrown exception');
        } catch (AuraHandledException e) {
            System.assert(e.getMessage().contains('Invalid provider'), 'Should indicate invalid provider');
        }

        Test.stopTest();
    }

    /**
     * @description Test getting setup instructions
     */
    @IsTest
    static void testGetSetupInstructions() {
        Test.startTest();

        String instructionsJson = AISettingsController.getSetupInstructions();

        Test.stopTest();

        // Verify instructions returned
        System.assertNotEquals(null, instructionsJson, 'Instructions should not be null');

        // Parse JSON
        Map<String, Object> instructions = (Map<String, Object>) JSON.deserializeUntyped(instructionsJson);

        System.assert(instructions.containsKey('claude'), 'Should have Claude instructions');
        System.assert(instructions.containsKey('gemini'), 'Should have Gemini instructions');

        // Verify Claude instructions structure
        Map<String, Object> claudeInstructions = (Map<String, Object>) instructions.get('claude');
        System.assert(claudeInstructions.containsKey('title'), 'Claude should have title');
        System.assert(claudeInstructions.containsKey('steps'), 'Claude should have steps');
        System.assert(claudeInstructions.containsKey('docsUrl'), 'Claude should have docs URL');

        // Verify Gemini instructions structure
        Map<String, Object> geminiInstructions = (Map<String, Object>) instructions.get('gemini');
        System.assert(geminiInstructions.containsKey('title'), 'Gemini should have title');
        System.assert(geminiInstructions.containsKey('steps'), 'Gemini should have steps');
        System.assert(geminiInstructions.containsKey('docsUrl'), 'Gemini should have docs URL');
    }

    /**
     * @description Test provider status detection
     */
    @IsTest
    static void testProviderStatusDetection() {
        Test.startTest();

        String settingsJson = AISettingsController.getAIProviderSettings();
        Map<String, Object> settings = (Map<String, Object>) JSON.deserializeUntyped(settingsJson);
        List<Object> providers = (List<Object>) settings.get('availableProviders');

        Test.stopTest();

        // Find Demo provider
        Map<String, Object> demoProvider = null;
        for (Object providerObj : providers) {
            Map<String, Object> provider = (Map<String, Object>) providerObj;
            if (provider.get('name') == 'DEMO') {
                demoProvider = provider;
                break;
            }
        }

        // Demo should always be available
        System.assertNotEquals(null, demoProvider, 'Demo provider should exist');
        System.assertEquals('AVAILABLE', demoProvider.get('status'), 'Demo should be available');
        System.assertEquals(false, demoProvider.get('requiresCredential'), 'Demo should not require credential');
    }

    /**
     * @description Test multiple provider switches
     */
    @IsTest
    static void testMultipleProviderSwitches() {
        Test.startTest();

        // Switch between providers
        AISettingsController.setPreferredProvider('DEMO');
        String settings1 = AISettingsController.getAIProviderSettings();

        AISettingsController.setPreferredProvider('CLAUDE');
        String settings2 = AISettingsController.getAIProviderSettings();

        AISettingsController.setPreferredProvider('GEMINI');
        String settings3 = AISettingsController.getAIProviderSettings();

        Test.stopTest();

        // All operations should succeed without errors
        System.assertNotEquals(null, settings1, 'Settings 1 should not be null');
        System.assertNotEquals(null, settings2, 'Settings 2 should not be null');
        System.assertNotEquals(null, settings3, 'Settings 3 should not be null');
    }
}
