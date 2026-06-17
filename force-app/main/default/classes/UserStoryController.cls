/**
 * @description Lightning Web Component controller for User Story Generator
 * @author Salesforce Technical Architect
 * @date 2026-06-17
 */
public with sharing class UserStoryController {

    /**
     * @description Generate user stories from business requirements
     * @param businessRequirement The business requirement description
     * @param persona The user persona (e.g., "Sales Manager")
     * @param businessProcess The business process (e.g., "sales pipeline")
     * @param objects Comma-separated list of Salesforce objects (e.g., "Account,Contact,Opportunity")
     * @return String JSON-serialized UserStoryResponse
     */
    @AuraEnabled
    public static String generateUserStories(
        String businessRequirement,
        String persona,
        String businessProcess,
        String objects
    ) {
        try {
            // Build request
            UserStoryGenerator.UserStoryRequest request = new UserStoryGenerator.UserStoryRequest();
            request.businessRequirement = businessRequirement;
            request.persona = persona;
            request.businessProcess = businessProcess;
            request.objects = parseObjects(objects);

            // Generate stories
            UserStoryGenerator.UserStoryResponse response =
                UserStoryGenerator.generateUserStories(request);

            // Return JSON
            return JSON.serialize(response, true);

        } catch (Exception e) {
            throw new AuraHandledException('Error generating user stories: ' + e.getMessage());
        }
    }

    /**
     * @description Get sample/example inputs to help users
     * @return String JSON with example inputs
     */
    @AuraEnabled(cacheable=true)
    public static String getExampleInputs() {
        Map<String, Object> examples = new Map<String, Object>{
            'businessRequirements' => new List<String>{
                'customer self-service portal',
                'automated lead assignment',
                'real-time inventory tracking',
                'customer feedback management',
                'employee onboarding automation'
            },
            'personas' => new List<String>{
                'Sales Manager',
                'Customer Support Agent',
                'System Administrator',
                'Marketing Manager',
                'Operations Manager',
                'Customer',
                'Executive'
            },
            'businessProcesses' => new List<String>{
                'sales pipeline',
                'case management',
                'order fulfillment',
                'customer onboarding',
                'employee training',
                'inventory management',
                'billing and invoicing'
            },
            'objectSuggestions' => new Map<String, List<String>>{
                'Sales' => new List<String>{'Account', 'Contact', 'Lead', 'Opportunity'},
                'Service' => new List<String>{'Case', 'Contact', 'Account', 'Knowledge'},
                'Marketing' => new List<String>{'Campaign', 'Lead', 'Contact', 'Account'},
                'Custom' => new List<String>{'Custom_Object__c'}
            }
        };

        return JSON.serialize(examples);
    }

    /**
     * @description Validate inputs before generating stories
     * @param businessRequirement Business requirement
     * @param persona User persona
     * @param businessProcess Business process
     * @param objects Comma-separated objects
     * @return String JSON with validation results
     */
    @AuraEnabled
    public static String validateInputs(
        String businessRequirement,
        String persona,
        String businessProcess,
        String objects
    ) {
        List<String> errors = new List<String>();
        List<String> warnings = new List<String>();

        // Validate required fields
        if (String.isBlank(businessRequirement)) {
            errors.add('Business Requirement is required');
        } else if (businessRequirement.length() < 10) {
            warnings.add('Business Requirement is very short - consider adding more detail');
        }

        if (String.isBlank(persona)) {
            errors.add('Persona is required');
        }

        if (String.isBlank(businessProcess)) {
            errors.add('Business Process is required');
        }

        if (String.isBlank(objects)) {
            warnings.add('No Salesforce objects specified - stories will be more generic');
        } else {
            List<String> objectList = parseObjects(objects);
            if (objectList.size() > 5) {
                warnings.add('Many objects specified - consider focusing on core objects');
            }
        }

        Map<String, Object> result = new Map<String, Object>{
            'isValid' => errors.isEmpty(),
            'errors' => errors,
            'warnings' => warnings
        };

        return JSON.serialize(result);
    }

    /**
     * @description Parse comma-separated objects into list
     */
    private static List<String> parseObjects(String objects) {
        if (String.isBlank(objects)) {
            return new List<String>();
        }

        List<String> result = new List<String>();
        for (String obj : objects.split(',')) {
            String trimmed = obj.trim();
            if (String.isNotBlank(trimmed)) {
                result.add(trimmed);
            }
        }
        return result;
    }
}
