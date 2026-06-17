/**
 * @description Test class for CustomerMeetingPrepController
 */
@isTest
private class CustomerMeetingPrepControllerTest {

    /**
     * @description Test saveMeetingPrep method with valid data
     */
    @isTest
    static void testSaveMeetingPrep_Success() {
        // Given
        Map<String, Object> meetingData = new Map<String, Object>{
            'meetingType' => 'Discovery',
            'customerName' => 'Acme Corporation',
            'prompt' => 'Test prompt',
            'generatedResponse' => '{"test": "data"}',
            'requestDate' => Datetime.now().formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''),
            'status' => 'Completed'
        };

        // When
        Test.startTest();
        String result = CustomerMeetingPrepController.saveMeetingPrep(meetingData);
        Test.stopTest();

        // Then
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assert(result.contains('Meeting preparation data'), 'Result should contain success message');
    }

    /**
     * @description Test saveMeetingPrep method with null data
     */
    @isTest
    static void testSaveMeetingPrep_NullData() {
        // Given
        Map<String, Object> meetingData = null;

        // When / Then
        Test.startTest();
        try {
            CustomerMeetingPrepController.saveMeetingPrep(meetingData);
            System.assert(false, 'Expected exception was not thrown');
        } catch (Exception e) {
            System.assert(e instanceof AuraHandledException, 'Should throw AuraHandledException');
        }
        Test.stopTest();
    }

    /**
     * @description Test generateMeetingBrief with complete data
     */
    @isTest
    static void testGenerateMeetingBrief_CompleteData() {
        // Given
        String customerName = 'Acme Corporation';
        String industry = 'Manufacturing';
        String meetingType = 'Discovery';
        List<String> products = new List<String>{'Sales Cloud', 'Service Cloud', 'Data Cloud'};
        String goals = 'Improve customer engagement and increase sales productivity through digital transformation.';
        String challenges = 'Legacy systems integration, data migration complexity, and user adoption concerns.';

        // When
        Test.startTest();
        String result = CustomerMeetingPrepController.generateMeetingBrief(
            customerName, industry, meetingType, products, goals, challenges
        );
        Test.stopTest();

        // Then
        System.assertNotEquals(null, result, 'Result should not be null');
        Map<String, Object> parsedResult = (Map<String, Object>) JSON.deserializeUntyped(result);

        System.assertEquals(customerName, parsedResult.get('customerName'), 'Customer name should match');
        System.assertEquals(industry, parsedResult.get('industry'), 'Industry should match');
        System.assertEquals(meetingType, parsedResult.get('meetingType'), 'Meeting type should match');
        System.assertNotEquals(null, parsedResult.get('readinessScore'), 'Readiness score should be present');
        System.assertNotEquals(null, parsedResult.get('executiveSummary'), 'Executive summary should be present');
        System.assertNotEquals(null, parsedResult.get('businessObjectives'), 'Business objectives should be present');
        System.assertNotEquals(null, parsedResult.get('discoveryQuestions'), 'Discovery questions should be present');
    }

    /**
     * @description Test generateMeetingBrief with minimal data
     */
    @isTest
    static void testGenerateMeetingBrief_MinimalData() {
        // Given
        String customerName = 'Test Corp';
        String industry = 'Technology';
        String meetingType = 'Executive Status';
        List<String> products = new List<String>{'Sales Cloud'};
        String goals = 'Short goal';
        String challenges = 'Short challenge';

        // When
        Test.startTest();
        String result = CustomerMeetingPrepController.generateMeetingBrief(
            customerName, industry, meetingType, products, goals, challenges
        );
        Test.stopTest();

        // Then
        System.assertNotEquals(null, result, 'Result should not be null');
        Map<String, Object> parsedResult = (Map<String, Object>) JSON.deserializeUntyped(result);

        // Verify readiness score is lower for minimal data
        Integer readinessScore = (Integer) parsedResult.get('readinessScore');
        System.assert(readinessScore >= 60, 'Readiness score should be at least base score');
        System.assert(readinessScore <= 80, 'Readiness score should be lower for minimal data');
    }

    /**
     * @description Test generateMeetingBrief with multiple products
     */
    @isTest
    static void testGenerateMeetingBrief_MultipleProducts() {
        // Given
        String customerName = 'Global Industries';
        String industry = 'Financial Services';
        String meetingType = 'Solution Workshop';
        List<String> products = new List<String>{
            'Sales Cloud', 'Service Cloud', 'Agentforce', 'Data Cloud', 'MuleSoft'
        };
        String goals = 'Enhance customer experience and streamline operations across multiple business units.';
        String challenges = 'Complex integration requirements and need for real-time data synchronization.';

        // When
        Test.startTest();
        String result = CustomerMeetingPrepController.generateMeetingBrief(
            customerName, industry, meetingType, products, goals, challenges
        );
        Test.stopTest();

        // Then
        System.assertNotEquals(null, result, 'Result should not be null');
        Map<String, Object> parsedResult = (Map<String, Object>) JSON.deserializeUntyped(result);

        List<Object> productRecommendations = (List<Object>) parsedResult.get('productRecommendations');
        System.assertEquals(products.size(), productRecommendations.size(),
            'Should have recommendation for each product');
    }

    /**
     * @description Test generateMeetingBrief with all industries
     */
    @isTest
    static void testGenerateMeetingBrief_AllIndustries() {
        // Given
        List<String> industries = new List<String>{
            'Construction', 'Manufacturing', 'Healthcare', 'Retail',
            'Financial Services', 'Technology', 'Public Sector'
        };
        List<String> products = new List<String>{'Sales Cloud'};

        // When / Then
        Test.startTest();
        for (String industry : industries) {
            String result = CustomerMeetingPrepController.generateMeetingBrief(
                'Test Company',
                industry,
                'Discovery',
                products,
                'Test goals for ' + industry,
                'Test challenges for ' + industry
            );

            System.assertNotEquals(null, result, 'Result should not be null for industry: ' + industry);
            Map<String, Object> parsedResult = (Map<String, Object>) JSON.deserializeUntyped(result);
            System.assertEquals(industry, parsedResult.get('industry'),
                'Industry should match for: ' + industry);

            // Verify executive summary contains industry
            String executiveSummary = (String) parsedResult.get('executiveSummary');
            System.assert(executiveSummary.contains(industry),
                'Executive summary should mention industry: ' + industry);
        }
        Test.stopTest();
    }

    /**
     * @description Test generateMeetingBrief with all meeting types
     */
    @isTest
    static void testGenerateMeetingBrief_AllMeetingTypes() {
        // Given
        List<String> meetingTypes = new List<String>{
            'Discovery', 'Executive Status', 'Solution Workshop',
            'Architecture Review', 'UAT Planning', 'Steering Committee', 'Go-Live Readiness'
        };
        List<String> products = new List<String>{'Service Cloud'};

        // When / Then
        Test.startTest();
        for (String meetingType : meetingTypes) {
            String result = CustomerMeetingPrepController.generateMeetingBrief(
                'Test Company',
                'Technology',
                meetingType,
                products,
                'Test goals',
                'Test challenges'
            );

            System.assertNotEquals(null, result, 'Result should not be null for meeting type: ' + meetingType);
            Map<String, Object> parsedResult = (Map<String, Object>) JSON.deserializeUntyped(result);
            System.assertEquals(meetingType, parsedResult.get('meetingType'),
                'Meeting type should match for: ' + meetingType);
        }
        Test.stopTest();
    }

    /**
     * @description Test generateMeetingBrief with all Salesforce products
     */
    @isTest
    static void testGenerateMeetingBrief_AllProducts() {
        // Given
        List<String> allProducts = new List<String>{
            'Sales Cloud', 'Service Cloud', 'Agentforce', 'Data Cloud',
            'Experience Cloud', 'Revenue Cloud', 'MuleSoft', 'Slack'
        };

        // When / Then
        Test.startTest();
        for (String product : allProducts) {
            String result = CustomerMeetingPrepController.generateMeetingBrief(
                'Test Company',
                'Technology',
                'Discovery',
                new List<String>{product},
                'Test goals',
                'Test challenges'
            );

            System.assertNotEquals(null, result, 'Result should not be null for product: ' + product);
            Map<String, Object> parsedResult = (Map<String, Object>) JSON.deserializeUntyped(result);

            List<Object> productRecommendations = (List<Object>) parsedResult.get('productRecommendations');
            System.assertEquals(1, productRecommendations.size(),
                'Should have one recommendation for: ' + product);

            Map<String, Object> recommendation = (Map<String, Object>) productRecommendations[0];
            System.assertEquals(product, recommendation.get('name'),
                'Product name should match: ' + product);
            System.assertNotEquals(null, recommendation.get('description'),
                'Product should have description: ' + product);
        }
        Test.stopTest();
    }

    /**
     * @description Test generateMeetingBrief error handling
     */
    @isTest
    static void testGenerateMeetingBrief_ErrorHandling() {
        // Given - null required parameter
        String customerName = null;
        String industry = 'Technology';
        String meetingType = 'Discovery';
        List<String> products = new List<String>{'Sales Cloud'};
        String goals = 'Test goals';
        String challenges = 'Test challenges';

        // When / Then
        Test.startTest();
        try {
            CustomerMeetingPrepController.generateMeetingBrief(
                customerName, industry, meetingType, products, goals, challenges
            );
            System.assert(false, 'Expected exception was not thrown');
        } catch (Exception e) {
            System.assert(e instanceof AuraHandledException, 'Should throw AuraHandledException');
        }
        Test.stopTest();
    }

    /**
     * @description Test readiness score calculation
     */
    @isTest
    static void testReadinessScoreCalculation() {
        // Given
        List<String> products = new List<String>{'Sales Cloud'};

        // Test with detailed input (should have higher score)
        String detailedGoals = 'This is a very detailed description of customer goals that exceeds fifty characters to trigger higher readiness score.';
        String detailedChallenges = 'This is a very detailed description of challenges that exceeds fifty characters to trigger higher readiness score.';

        // Test with minimal input (should have lower score)
        String minimalGoals = 'Short';
        String minimalChallenges = 'Brief';

        // When
        Test.startTest();
        String detailedResult = CustomerMeetingPrepController.generateMeetingBrief(
            'Test Company', 'Technology', 'Discovery', products, detailedGoals, detailedChallenges
        );
        String minimalResult = CustomerMeetingPrepController.generateMeetingBrief(
            'Test Company', 'Technology', 'Discovery', products, minimalGoals, minimalChallenges
        );
        Test.stopTest();

        // Then
        Map<String, Object> detailedParsed = (Map<String, Object>) JSON.deserializeUntyped(detailedResult);
        Map<String, Object> minimalParsed = (Map<String, Object>) JSON.deserializeUntyped(minimalResult);

        Integer detailedScore = (Integer) detailedParsed.get('readinessScore');
        Integer minimalScore = (Integer) minimalParsed.get('readinessScore');

        System.assert(detailedScore > minimalScore,
            'Detailed input should result in higher readiness score');
        System.assertEquals(80, detailedScore, 'Detailed input should achieve expected score');
        System.assertEquals(60, minimalScore, 'Minimal input should have base score');
    }
}
