/**
 * @description Controller for AI Delivery Request persistence
 * Handles saving generated AI outputs to AI_Delivery_Request__c object
 * @author Salesforce Technical Architect
 * @date 2026-06-18
 */
public with sharing class AIDeliveryRequestController {

    /**
     * @description Wrapper class for save request
     */
    public class SaveRequest {
        @AuraEnabled public String title { get; set; }
        @AuraEnabled public String category { get; set; }
        @AuraEnabled public String prompt { get; set; }
        @AuraEnabled public String generatedResponse { get; set; }
        @AuraEnabled public String status { get; set; }
        @AuraEnabled public Decimal confidenceScore { get; set; }
        @AuraEnabled public Decimal readinessScore { get; set; }
        @AuraEnabled public String rating { get; set; }
    }

    /**
     * @description Saves AI delivery request to database
     * @param request SaveRequest containing all fields
     * @return String Record Id of created record
     */
    @AuraEnabled
    public static String saveDeliveryRequest(SaveRequest request) {
        try {
            // Validate required fields
            if (String.isBlank(request.title)) {
                throw new IllegalArgumentException('Title is required');
            }
            if (String.isBlank(request.category)) {
                throw new IllegalArgumentException('Category is required');
            }

            // Create new record
            AI_Delivery_Request__c record = new AI_Delivery_Request__c();
            record.Title__c = request.title;
            record.Category__c = request.category;
            record.Prompt__c = request.prompt;
            record.Generated_Response__c = request.generatedResponse;
            record.Status__c = String.isNotBlank(request.status) ? request.status : 'Generated';
            record.Confidence_Score__c = request.confidenceScore;
            record.Readiness_Score__c = request.readinessScore;
            record.Rating__c = request.rating;

            insert record;

            return record.Id;

        } catch (Exception e) {
            throw new AuraHandledException('Error saving AI Delivery Request: ' + e.getMessage());
        }
    }

    /**
     * @description Retrieves AI delivery request by Id
     * @param recordId Record Id
     * @return AI_Delivery_Request__c record
     */
    @AuraEnabled(cacheable=true)
    public static AI_Delivery_Request__c getDeliveryRequest(String recordId) {
        try {
            return [
                SELECT Id, Name, Title__c, Category__c, Prompt__c, Generated_Response__c,
                       Status__c, Confidence_Score__c, Readiness_Score__c, Rating__c,
                       CreatedDate, LastModifiedDate
                FROM AI_Delivery_Request__c
                WHERE Id = :recordId
                LIMIT 1
            ];
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving AI Delivery Request: ' + e.getMessage());
        }
    }

    /**
     * @description Retrieves recent AI delivery requests by category
     * @param category Category filter (optional)
     * @param limitCount Number of records to return
     * @return List of AI_Delivery_Request__c records
     */
    @AuraEnabled(cacheable=true)
    public static List<AI_Delivery_Request__c> getRecentRequests(String category, Integer limitCount) {
        try {
            Integer queryLimit = (limitCount != null && limitCount > 0) ? limitCount : 10;

            if (String.isNotBlank(category)) {
                return [
                    SELECT Id, Name, Title__c, Category__c, Status__c,
                           Confidence_Score__c, Readiness_Score__c, CreatedDate
                    FROM AI_Delivery_Request__c
                    WHERE Category__c = :category
                    ORDER BY CreatedDate DESC
                    LIMIT :queryLimit
                ];
            } else {
                return [
                    SELECT Id, Name, Title__c, Category__c, Status__c,
                           Confidence_Score__c, Readiness_Score__c, CreatedDate
                    FROM AI_Delivery_Request__c
                    ORDER BY CreatedDate DESC
                    LIMIT :queryLimit
                ];
            }
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving recent requests: ' + e.getMessage());
        }
    }
}
