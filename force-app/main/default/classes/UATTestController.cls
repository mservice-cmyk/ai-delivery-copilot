/**
 * @description Lightning Web Component controller for UAT Test Case Generator
 * @author Salesforce Technical Architect
 * @date 2026-06-17
 */
public with sharing class UATTestController {

    /**
     * @description Generate UAT test cases from user story and acceptance criteria
     * @param userStory The user story text
     * @param acceptanceCriteria Comma or newline separated acceptance criteria
     * @return String JSON-serialized UATTestResponse
     */
    @AuraEnabled
    public static String generateTestCases(String userStory, String acceptanceCriteria) {
        try {
            // Validate required inputs
            if (String.isBlank(userStory)) {
                throw new AuraHandledException('User Story is required');
            }

            // Build request
            UATTestCaseGenerator.UATTestRequest request =
                new UATTestCaseGenerator.UATTestRequest();
            request.userStory = userStory;
            request.acceptanceCriteria = parseAcceptanceCriteria(acceptanceCriteria);

            // Generate test cases
            UATTestCaseGenerator.UATTestResponse response =
                UATTestCaseGenerator.generateTestCases(request);

            // Return JSON
            return JSON.serialize(response, true);

        } catch (Exception e) {
            throw new AuraHandledException('Error generating UAT test cases: ' + e.getMessage());
        }
    }

    /**
     * @description Parse acceptance criteria from string to list
     */
    private static List<String> parseAcceptanceCriteria(String criteria) {
        if (String.isBlank(criteria)) {
            return new List<String>();
        }

        List<String> result = new List<String>();

        // Split by newline or pipe character
        String[] lines = criteria.split('[\n|]');

        for (String line : lines) {
            String trimmed = line.trim();
            if (String.isNotBlank(trimmed)) {
                result.add(trimmed);
            }
        }

        return result;
    }
}
