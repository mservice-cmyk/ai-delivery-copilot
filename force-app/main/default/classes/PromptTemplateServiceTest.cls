/**
 * @description Test class for PromptTemplateService
 * @author Salesforce Technical Architect
 * @date 2026-06-18
 */
@IsTest
private class PromptTemplateServiceTest {

    /**
     * @description Test solution design prompt generation
     */
    @IsTest
    static void testGetSolutionDesignPrompt() {
        Test.startTest();

        PromptTemplateService.PromptTemplate template =
            PromptTemplateService.getSolutionDesignPrompt('Review my Lightning Web Component architecture');

        Test.stopTest();

        System.assertNotEquals(null, template, 'Template should not be null');
        System.assertNotEquals(null, template.systemContext, 'System context should not be null');
        System.assertNotEquals(null, template.userPrompt, 'User prompt should not be null');
        System.assert(template.systemContext.contains('Salesforce'), 'Should contain Salesforce context');
        System.assert(template.userPrompt.contains('Lightning Web Component'), 'Should contain user request');
        System.assertEquals(4000, template.maxTokens, 'Max tokens should be 4000');
    }

    /**
     * @description Test solution design prompt with null request
     */
    @IsTest
    static void testGetSolutionDesignPromptNull() {
        Test.startTest();

        PromptTemplateService.PromptTemplate template =
            PromptTemplateService.getSolutionDesignPrompt(null);

        Test.stopTest();

        System.assertNotEquals(null, template, 'Template should not be null');
        System.assertNotEquals(null, template.systemContext, 'System context should not be null');
        System.assertNotEquals(null, template.userPrompt, 'User prompt should not be null');
        System.assert(template.userPrompt.contains('general'), 'Should handle null request gracefully');
    }

    /**
     * @description Test user story prompt generation
     */
    @IsTest
    static void testGetUserStoryPrompt() {
        Test.startTest();

        PromptTemplateService.PromptTemplate template =
            PromptTemplateService.getUserStoryPrompt('Build a customer portal');

        Test.stopTest();

        System.assertNotEquals(null, template, 'Template should not be null');
        System.assert(template.systemContext.contains('Business Analyst'), 'Should have BA context');
        System.assert(template.userPrompt.contains('customer portal'), 'Should contain user request');
        System.assertEquals(3000, template.maxTokens, 'Max tokens should be 3000');
    }

    /**
     * @description Test test case prompt generation
     */
    @IsTest
    static void testGetTestCasePrompt() {
        Test.startTest();

        PromptTemplateService.PromptTemplate template =
            PromptTemplateService.getTestCasePrompt('Login functionality');

        Test.stopTest();

        System.assertNotEquals(null, template, 'Template should not be null');
        System.assert(template.systemContext.contains('QA'), 'Should have QA context');
        System.assert(template.userPrompt.contains('Login functionality'), 'Should contain feature');
        System.assertEquals(3500, template.maxTokens, 'Max tokens should be 3500');
    }

    /**
     * @description Test executive status prompt generation
     */
    @IsTest
    static void testGetExecutiveStatusPrompt() {
        Test.startTest();

        PromptTemplateService.PromptTemplate template =
            PromptTemplateService.getExecutiveStatusPrompt('Q2 Implementation Status');

        Test.stopTest();

        System.assertNotEquals(null, template, 'Template should not be null');
        System.assert(template.systemContext.contains('Program Manager'), 'Should have PM context');
        System.assert(template.userPrompt.contains('Q2 Implementation'), 'Should contain context');
        System.assertEquals(2500, template.maxTokens, 'Max tokens should be 2500');
    }

    /**
     * @description Test RAID log prompt generation
     */
    @IsTest
    static void testGetRAIDLogPrompt() {
        Test.startTest();

        PromptTemplateService.PromptTemplate template =
            PromptTemplateService.getRAIDLogPrompt('Integration project');

        Test.stopTest();

        System.assertNotEquals(null, template, 'Template should not be null');
        System.assert(template.systemContext.contains('Risk Manager'), 'Should have risk manager context');
        System.assert(template.userPrompt.contains('Integration project'), 'Should contain context');
        System.assertEquals(3000, template.maxTokens, 'Max tokens should be 3000');
    }

    /**
     * @description Test meeting prep prompt generation
     */
    @IsTest
    static void testGetMeetingPrepPrompt() {
        Test.startTest();

        PromptTemplateService.PromptTemplate template =
            PromptTemplateService.getMeetingPrepPrompt('Executive Steering Committee Meeting');

        Test.stopTest();

        System.assertNotEquals(null, template, 'Template should not be null');
        System.assert(template.systemContext.contains('Client Engagement'), 'Should have engagement context');
        System.assert(template.userPrompt.contains('Executive Steering'), 'Should contain meeting context');
        System.assertEquals(2500, template.maxTokens, 'Max tokens should be 2500');
    }

    /**
     * @description Test deployment checklist prompt generation
     */
    @IsTest
    static void testGetDeploymentChecklistPrompt() {
        Test.startTest();

        PromptTemplateService.PromptTemplate template =
            PromptTemplateService.getDeploymentChecklistPrompt('Production deployment');

        Test.stopTest();

        System.assertNotEquals(null, template, 'Template should not be null');
        System.assert(template.systemContext.contains('Release Manager'), 'Should have release manager context');
        System.assert(template.userPrompt.contains('Production deployment'), 'Should contain deployment context');
        System.assertEquals(3000, template.maxTokens, 'Max tokens should be 3000');
    }

    /**
     * @description Test getFullPrompt method
     */
    @IsTest
    static void testGetFullPrompt() {
        Test.startTest();

        PromptTemplateService.PromptTemplate template =
            PromptTemplateService.getSolutionDesignPrompt('Test design');

        String fullPrompt = template.getFullPrompt();

        Test.stopTest();

        System.assertNotEquals(null, fullPrompt, 'Full prompt should not be null');
        System.assert(fullPrompt.contains('Salesforce'), 'Should contain system context');
        System.assert(fullPrompt.contains('Test design'), 'Should contain user prompt');
    }

    /**
     * @description Test all prompts with empty string
     */
    @IsTest
    static void testAllPromptsWithEmptyString() {
        Test.startTest();

        List<PromptTemplateService.PromptTemplate> templates = new List<PromptTemplateService.PromptTemplate>{
            PromptTemplateService.getSolutionDesignPrompt(''),
            PromptTemplateService.getUserStoryPrompt(''),
            PromptTemplateService.getTestCasePrompt(''),
            PromptTemplateService.getExecutiveStatusPrompt(''),
            PromptTemplateService.getRAIDLogPrompt(''),
            PromptTemplateService.getMeetingPrepPrompt(''),
            PromptTemplateService.getDeploymentChecklistPrompt('')
        };

        Test.stopTest();

        for (PromptTemplateService.PromptTemplate template : templates) {
            System.assertNotEquals(null, template, 'Template should not be null');
            System.assertNotEquals(null, template.systemContext, 'System context should not be null');
            System.assertNotEquals(null, template.userPrompt, 'User prompt should not be null');
            System.assert(template.maxTokens > 0, 'Max tokens should be positive');
        }
    }
}
