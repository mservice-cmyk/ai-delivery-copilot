# AI Integration Setup Guide

## Overview

The AI Delivery Copilot now supports real AI provider integration through HTTP callouts using Named Credentials. The system maintains mock mode as a fallback for testing and development.

## Architecture

### Components Created

1. **AIService.cls** - Core HTTP callout service
   - Manages AI provider communication
   - Supports mock/real mode switching
   - Handles request/response processing
   - Includes error handling and fallback logic

2. **AIServiceTest.cls** - Comprehensive test coverage
   - Tests mock and real modes
   - Tests HTTP success and error scenarios
   - Tests mode switching and fallback logic

3. **PromptTemplateService.cls** - Prompt management
   - Pre-built prompts for each feature
   - System context definitions
   - Structured output formatting
   - Token limit management

4. **PromptTemplateServiceTest.cls** - Template testing
   - Tests all prompt templates
   - Validates prompt structure
   - Tests edge cases

5. **Named Credential** - `AI_Provider`
   - Secure credential storage
   - No hardcoded API keys
   - Environment-specific configuration

### Updated Components

- **DeliveryCopilotService.cls** - Solution Design Review feature now supports real AI
  - Checks AI mode before processing
  - Calls AIService with proper prompts
  - Parses structured JSON responses
  - Falls back to mock on error

## Setup Instructions

### Step 1: Choose Your AI Provider

Select one of the supported providers:

- **Anthropic Claude** (Recommended for complex reasoning)
- **OpenAI GPT-4** (Popular, well-documented)
- **Azure OpenAI** (Enterprise option with Microsoft SLA)
- Other compatible API providers

### Step 2: Obtain API Credentials

1. Sign up for an account with your chosen provider
2. Generate an API key
3. Note the API endpoint URL
4. Review pricing and rate limits

### Step 3: Configure Named Credential

#### Option A: Using Setup UI (Recommended)

1. Navigate to **Setup → Named Credentials**
2. Click **New Named Credential**
3. Configure:
   - **Label**: AI Provider
   - **Name**: AI_Provider
   - **URL**: Your provider's API endpoint
     - Anthropic: `https://api.anthropic.com`
     - OpenAI: `https://api.openai.com`
     - Azure: `https://YOUR_RESOURCE.openai.azure.com`
   - **Identity Type**: Named Principal
   - **Authentication Protocol**: Custom (with custom headers)
   - **Generate Authorization Header**: Unchecked

4. Create an **External Credential** for the API key:
   - Setup → Named Credentials → External Credentials → New
   - Add custom header: `x-api-key` or `Authorization: Bearer <token>`
   - Store your API key securely

#### Option B: Deploy Metadata

1. Edit `force-app/main/default/namedCredentials/AI_Provider.namedCredential-meta.xml`
2. Update the endpoint URL
3. Configure authentication per your provider's requirements
4. Deploy using Salesforce CLI:
   ```bash
   sf project deploy start --source-dir force-app/main/default/namedCredentials
   ```

### Step 4: Customize AIService.cls

Update the AIService class to match your provider's API format:

#### For Anthropic Claude:

```apex
// In buildRequestPayload():
return new Map<String, Object>{
    'model' => 'claude-3-5-sonnet-20241022',
    'max_tokens' => maxTokens != null ? maxTokens : 4000,
    'messages' => new List<Map<String, Object>>{
        new Map<String, Object>{
            'role' => 'user',
            'content' => prompt
        }
    },
    'system' => systemContext != null ? systemContext : ''
};

// In parseResponse():
List<Object> contentArray = (List<Object>) jsonResponse.get('content');
if (contentArray != null && !contentArray.isEmpty()) {
    Map<String, Object> firstContent = (Map<String, Object>) contentArray[0];
    String text = (String) firstContent.get('text');
    return new AIResponse(text, true, (String) jsonResponse.get('model'), null);
}

// Update endpoint in callAI():
req.setEndpoint(NAMED_CREDENTIAL + '/v1/messages');
req.setHeader('anthropic-version', '2023-06-01');
```

#### For OpenAI:

```apex
// In buildRequestPayload():
List<Map<String, Object>> messages = new List<Map<String, Object>>();
if (String.isNotBlank(systemContext)) {
    messages.add(new Map<String, Object>{
        'role' => 'system',
        'content' => systemContext
    });
}
messages.add(new Map<String, Object>{
    'role' => 'user',
    'content' => prompt
});

return new Map<String, Object>{
    'model' => 'gpt-4',
    'messages' => messages,
    'max_tokens' => maxTokens != null ? maxTokens : 4000
};

// In parseResponse():
List<Object> choices = (List<Object>) jsonResponse.get('choices');
if (choices != null && !choices.isEmpty()) {
    Map<String, Object> firstChoice = (Map<String, Object>) choices[0];
    Map<String, Object> message = (Map<String, Object>) firstChoice.get('message');
    String content = (String) message.get('content');
    return new AIResponse(content, true, (String) jsonResponse.get('model'), null);
}

// Update endpoint in callAI():
req.setEndpoint(NAMED_CREDENTIAL + '/v1/chat/completions');
```

### Step 5: Configure Remote Site Settings

1. Navigate to **Setup → Remote Site Settings**
2. Click **New Remote Site**
3. Add your AI provider's base URL:
   - Name: `AI_Provider_API`
   - URL: `https://api.anthropic.com` (or your provider's URL)
   - Active: ✓

### Step 6: Test the Integration

#### Test in Anonymous Apex:

```apex
// Test mock mode (default)
AIService.AIResponse mockResponse = AIService.callAI(
    'Review this solution design',
    'You are a Salesforce architect',
    1000
);
System.debug('Mock Response: ' + mockResponse.content);

// Switch to real mode
AIService.setMode(AIService.AIMode.REAL);

// Test real API call
AIService.AIResponse realResponse = AIService.callAI(
    'Review this solution design: Lightning Web Components with Platform Events',
    'You are a Salesforce architect',
    2000
);
System.debug('Real Response: ' + realResponse.content);
System.debug('Success: ' + realResponse.success);
System.debug('Model: ' + realResponse.model);
```

#### Test Solution Design Review:

```apex
// Set to real mode
AIService.setMode(AIService.AIMode.REAL);

// Call the feature
String result = DeliveryCopilotService.processRequest(
    'solution_design',
    'Review a Lightning Web Component architecture using Platform Events for real-time updates and Apex for business logic'
);

System.debug('Result: ' + result);
```

### Step 7: Deploy to Org

```bash
# Deploy all components
sf project deploy start --source-dir force-app/main/default/classes

# Run tests
sf apex run test --test-level RunLocalTests --wait 10

# Check code coverage
sf apex get test --test-run-id <test-run-id>
```

## Usage Guidelines

### Mode Management

By default, the system operates in **MOCK mode** for safety and testing. To enable real AI:

```apex
AIService.setMode(AIService.AIMode.REAL);
```

Consider creating a Custom Setting or Custom Metadata Type to control this globally:

```apex
public static AIMode getCurrentMode() {
    // Example: Read from Custom Metadata
    AI_Configuration__mdt config = [
        SELECT Use_Real_AI__c 
        FROM AI_Configuration__mdt 
        WHERE DeveloperName = 'Default' 
        LIMIT 1
    ];
    return config.Use_Real_AI__c ? AIMode.REAL : AIMode.MOCK;
}
```

### Cost Management

AI API calls have associated costs. Monitor usage:

1. Track API calls in a custom object
2. Implement daily/monthly limits
3. Log token usage
4. Set up alerts for unusual usage

Example logging:

```apex
public static void logAIUsage(String feature, Integer tokensUsed, Decimal cost) {
    AI_Usage_Log__c log = new AI_Usage_Log__c(
        Feature__c = feature,
        Tokens_Used__c = tokensUsed,
        Estimated_Cost__c = cost,
        Timestamp__c = DateTime.now()
    );
    insert log;
}
```

### Error Handling

The system automatically falls back to mock mode on errors:

- Network failures
- Invalid API keys
- Rate limit exceeded
- Parsing errors

Monitor debug logs to detect issues:

```apex
System.debug('AI API Error: ' + res.getStatusCode() + ' - ' + res.getBody());
```

## Features Integration Roadmap

### ✅ Phase 1: Solution Design Review (Current)

The Solution Design Review feature is now integrated with real AI.

### 🔄 Phase 2: Remaining Features (Future)

To integrate AI into other features, follow this pattern:

1. Create a method like `reviewSolutionDesignWithAI()`
2. Use the appropriate prompt template from `PromptTemplateService`
3. Call `AIService.callAI()` with the template
4. Parse the JSON response into the `DeliveryResponse` format
5. Add try/catch with fallback to mock response

Example for User Story Generation:

```apex
private static DeliveryResponse generateUserStoriesWithAI(String userRequest) {
    PromptTemplateService.PromptTemplate template =
        PromptTemplateService.getUserStoryPrompt(userRequest);
    
    AIService.AIResponse aiResponse = AIService.callAI(
        template.userPrompt,
        template.systemContext,
        template.maxTokens
    );
    
    if (aiResponse.success) {
        return parseAIUserStoryResponse(aiResponse.content, userRequest);
    } else {
        throw new CalloutException('AI service failed');
    }
}
```

## Security Best Practices

1. **Never commit API keys** to version control
2. **Use Named Credentials** for credential management
3. **Implement field-level security** on any custom objects storing AI responses
4. **Audit API usage** regularly
5. **Rotate credentials** periodically
6. **Monitor for anomalous usage** patterns
7. **Validate AI responses** before displaying to users
8. **Implement rate limiting** to prevent abuse

## Troubleshooting

### Common Issues

#### Issue: "Unauthorized endpoint" error

**Solution**: Add Remote Site Setting for your AI provider's URL

#### Issue: "Invalid API key" error

**Solution**: Verify Named Credential configuration and API key validity

#### Issue: JSON parsing errors

**Solution**: Update `parseResponse()` method to match your provider's exact response format

#### Issue: Timeout errors

**Solution**: Increase timeout in AIService.cls or use async processing for long-running requests

#### Issue: Rate limit exceeded

**Solution**: Implement request throttling or upgrade your API plan

### Debug Checklist

- [ ] Remote Site Setting configured
- [ ] Named Credential deployed
- [ ] API key is valid and active
- [ ] AIService.cls customized for your provider
- [ ] Mode set to AIMode.REAL
- [ ] Debug logs show outbound HTTP request
- [ ] Response parsing matches provider's format
- [ ] Test in sandbox before production

## Monitoring and Maintenance

### Recommended Custom Objects

1. **AI_Usage_Log__c**
   - Feature__c (Text)
   - Tokens_Used__c (Number)
   - Cost__c (Currency)
   - Response_Time__c (Number)
   - Success__c (Checkbox)
   - Error_Message__c (Long Text)

2. **AI_Configuration__mdt** (Custom Metadata)
   - Use_Real_AI__c (Checkbox)
   - Provider__c (Text)
   - Max_Tokens__c (Number)
   - Rate_Limit_Per_Hour__c (Number)

### Dashboard Metrics

Create a Lightning Dashboard to monitor:

- Total API calls per day/week/month
- Success vs. error rate
- Average response time
- Cost tracking
- Most-used features

## Next Steps

1. ✅ Deploy AIService and PromptTemplateService
2. ✅ Configure Named Credential
3. ✅ Test Solution Design Review with real AI
4. ⏭️ Integrate remaining features (User Stories, Test Cases, etc.)
5. ⏭️ Implement usage tracking and cost monitoring
6. ⏭️ Create admin configuration UI
7. ⏭️ Set up alerts and monitoring dashboards

## Support

For issues or questions:

1. Check debug logs in Developer Console
2. Review the TODO comments in AIService.cls
3. Consult your AI provider's API documentation
4. Test in sandbox environment first

## References

- [Anthropic Claude API Documentation](https://docs.anthropic.com/)
- [OpenAI API Documentation](https://platform.openai.com/docs/)
- [Salesforce Named Credentials](https://help.salesforce.com/s/articleView?id=sf.named_credentials_about.htm)
- [Salesforce HTTP Callouts](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_classes_restful_http_httprequest.htm)
