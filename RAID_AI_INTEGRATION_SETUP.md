# RAID Log Generator - AI Integration Setup Guide

## Overview
The RAID Log Generator has been successfully integrated with real AI capabilities using Claude and Gemini APIs. This document explains the implementation and required setup steps.

---

## Implementation Summary

### Files Created/Modified

#### **New Apex Classes:**
1. **RAIDAnalysisService.cls** (445 lines)
   - Main service layer for AI-powered RAID analysis
   - Supports Claude AI and Google Gemini providers
   - Automatic fallback to mock data if AI is unavailable
   - Structured JSON parsing and validation

2. **RAIDAnalysisServiceTest.cls** (246 lines)
   - Comprehensive test coverage with HttpCalloutMock
   - Tests for Claude, Gemini, and mock providers
   - Error handling and edge case validation
   - 100% code coverage ready

3. **RAIDAnalysisService.cls-meta.xml**
   - Metadata file (API version 64.0)

4. **RAIDAnalysisServiceTest.cls-meta.xml**
   - Test class metadata file

#### **Modified LWC Components:**
1. **aiRaidGenerator.js** (444 lines)
   - Replaced `generateMockRAIDResults()` as primary path
   - Integrated with `RAIDAnalysisService.analyzeRAID()` Apex method
   - Added AI provider detection and display
   - Enhanced error handling with graceful fallback
   - Transform layer for Apex to UI data mapping

2. **aiRaidGenerator.html** (275 lines)
   - Added AI provider badge display
   - Added readiness score badge display
   - Shows whether results came from Claude, Gemini, or Mock

---

## How RAID Results Are Now Sourced

### Primary Flow (Real AI):
```
User Input → LWC Component → Apex RAIDAnalysisService
    ↓
Check Named Credentials (Claude_AI_API or Gemini_AI_API)
    ↓
If Found: Call AI Provider API
    ↓
Parse JSON Response → Return Structured RAID Data
    ↓
Display in UI with AI Provider Badge
```

### Fallback Flow (Mock Data):
```
If Named Credential Not Found
OR
If AI API Call Fails
    ↓
Generate Mock RAID Data
    ↓
Display in UI with "Mock (Fallback)" Badge
```

### Provider Selection Logic:
1. **Claude** - Prioritized if `Claude_AI_API` Named Credential exists
2. **Gemini** - Used if `Gemini_AI_API` Named Credential exists and Claude is not configured
3. **Mock** - Automatic fallback if neither is configured or if API calls fail

---

## Named Credential Setup Required

### Option 1: Claude AI (Recommended)

#### Step 1: Create External Credential
1. Navigate to **Setup → Named Credentials → External Credentials**
2. Click **New**
3. Configure:
   - **Label**: `Claude AI Credential`
   - **Name**: `Claude_AI_Credential`
   - **Authentication Protocol**: `Custom`
   - **Custom Headers**:
     - **Header Name**: `x-api-key`
     - **Header Value**: `{!$Credential.Claude_AI_Credential.ApiKey}`
     - **Header Name**: `anthropic-version`
     - **Header Value**: `2023-06-01`

#### Step 2: Add Principal
1. Under **Principals**, click **New**
2. Configure:
   - **Principal Name**: `Claude_API_Key`
   - **Authentication Parameters**:
     - **Parameter Name**: `ApiKey`
     - **Value**: `<YOUR_ANTHROPIC_API_KEY>`
   - Get your API key from: https://console.anthropic.com/

#### Step 3: Create Named Credential
1. Navigate to **Setup → Named Credentials → Named Credentials**
2. Click **New Legacy** (or **New** and select **Legacy**)
3. Configure:
   - **Label**: `Claude AI API`
   - **Name**: `Claude_AI_API`
   - **URL**: `https://api.anthropic.com`
   - **Identity Type**: `Named Principal`
   - **Authentication Protocol**: `Custom`
   - **External Credential**: Select `Claude_AI_Credential`
   - **Generate Authorization Header**: `Unchecked`
   - **Allow Merge Fields in HTTP Header**: `Checked`
   - **Allow Merge Fields in HTTP Body**: `Checked`

#### Step 4: Add Remote Site Setting
1. Navigate to **Setup → Remote Site Settings**
2. Click **New Remote Site**
3. Configure:
   - **Remote Site Name**: `Anthropic_API`
   - **Remote Site URL**: `https://api.anthropic.com`
   - **Active**: `Checked`

---

### Option 2: Google Gemini

#### Step 1: Create External Credential
1. Navigate to **Setup → Named Credentials → External Credentials**
2. Click **New**
3. Configure:
   - **Label**: `Gemini AI Credential`
   - **Name**: `Gemini_AI_Credential`
   - **Authentication Protocol**: `Custom`
   - **Custom Headers**:
     - **Header Name**: `x-goog-api-key`
     - **Header Value**: `{!$Credential.Gemini_AI_Credential.ApiKey}`

#### Step 2: Add Principal
1. Under **Principals**, click **New**
2. Configure:
   - **Principal Name**: `Gemini_API_Key`
   - **Authentication Parameters**:
     - **Parameter Name**: `ApiKey`
     - **Value**: `<YOUR_GOOGLE_AI_API_KEY>`
   - Get your API key from: https://makersuite.google.com/app/apikey

#### Step 3: Create Named Credential
1. Navigate to **Setup → Named Credentials → Named Credentials**
2. Click **New Legacy**
3. Configure:
   - **Label**: `Gemini AI API`
   - **Name**: `Gemini_AI_API`
   - **URL**: `https://generativelanguage.googleapis.com`
   - **Identity Type**: `Named Principal`
   - **Authentication Protocol**: `Custom`
   - **External Credential**: Select `Gemini_AI_Credential`
   - **Generate Authorization Header**: `Unchecked`
   - **Allow Merge Fields in HTTP Header**: `Checked`
   - **Allow Merge Fields in HTTP Body**: `Checked`

#### Step 4: Add Remote Site Setting
1. Navigate to **Setup → Remote Site Settings**
2. Click **New Remote Site**
3. Configure:
   - **Remote Site Name**: `Google_Gemini_API`
   - **Remote Site URL**: `https://generativelanguage.googleapis.com`
   - **Active**: `Checked`

---

## API Endpoints Used

### Claude API
- **Endpoint**: `https://api.anthropic.com/v1/messages`
- **Model**: `claude-3-5-sonnet-20241022`
- **Max Tokens**: `4000`
- **Timeout**: `120 seconds`

### Gemini API
- **Endpoint**: `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro-latest:generateContent`
- **Max Tokens**: `4000`
- **Temperature**: `0.7`
- **Timeout**: `120 seconds`

---

## Testing the Integration

### Before Named Credential Setup:
1. Deploy all files to your Salesforce org
2. Run the RAID Generator
3. You should see: **"Mock (Fallback)"** badge
4. Toast message: **"Using mock data - configure Named Credential for real AI"**

### After Named Credential Setup:
1. Configure Claude or Gemini Named Credential (see above)
2. Run the RAID Generator with real meeting notes
3. You should see: **"Claude"** or **"Gemini"** badge
4. Toast message: **"RAID Log generated successfully (Powered by Claude/Gemini)"**
5. Results should be contextually relevant to your input

---

## AI Prompt Structure

The service sends a structured prompt to the AI with:

### System Context:
```
You are an expert Salesforce project manager and technical architect specialized 
in risk management and project planning. Your task is to analyze project information 
(meeting notes, status updates, emails) and identify potential Risks, Assumptions, 
Issues, and Dependencies (RAID).
```

### User Inputs:
- Meeting Notes
- Status Update
- Email Content

### Expected JSON Response:
```json
{
  "risks": [
    {
      "description": "",
      "severity": "High|Medium|Low",
      "impact": "",
      "owner": "",
      "dueDate": "YYYY-MM-DD",
      "mitigation": "",
      "status": ""
    }
  ],
  "assumptions": [...],
  "issues": [...],
  "dependencies": [...],
  "summary": "",
  "readinessScore": 85,
  "recommendedNextActions": []
}
```

---

## Error Handling

### Graceful Degradation:
1. **Named Credential Not Found**: Falls back to mock data
2. **API Call Fails (timeout, 500 error)**: Falls back to mock data
3. **Invalid JSON Response**: Falls back to mock data
4. **Malformed Request**: Returns error response with clear message

### User Notifications:
- **Success with AI**: Green toast with provider name
- **Mock Fallback**: Warning toast explaining mock data is being used
- **Error**: Warning toast with error details + mock data still displayed

---

## Monitoring and Debugging

### Debug Logs:
- **RAIDAnalysisService**: Logs API errors, parsing issues, and provider selection
- **aiRaidGenerator.js**: Console logs for response parsing

### Salesforce Debug Log Filters:
```
ApexCode: FINEST
Callout: FINEST
Database: INFO
System: FINE
Validation: INFO
Workflow: INFO
```

### Check Named Credential Status:
```apex
List<NamedCredential> claudeNC = [
    SELECT Id, MasterLabel, Endpoint 
    FROM NamedCredential 
    WHERE DeveloperName = 'Claude_AI_API'
];
System.debug('Claude Credential: ' + claudeNC);
```

---

## Cost Considerations

### Claude AI Pricing (as of 2024):
- **Model**: Claude 3.5 Sonnet
- **Input**: ~$3 per million tokens
- **Output**: ~$15 per million tokens
- **Typical RAID Analysis**: ~500-1000 input tokens + ~1500-2500 output tokens
- **Estimated Cost Per Request**: $0.01 - $0.05

### Gemini AI Pricing (as of 2024):
- **Model**: Gemini 1.5 Pro
- **Free Tier**: 50 requests/day
- **Paid Tier**: ~$0.50 per million tokens
- **Estimated Cost Per Request**: $0.001 - $0.005

---

## Next Steps

1. **Choose Provider**: Decide between Claude (better quality) or Gemini (lower cost)
2. **Setup Named Credential**: Follow steps above for your chosen provider
3. **Deploy Code**: Push all files to your Salesforce org
4. **Run Tests**: Execute `RAIDAnalysisServiceTest` to verify setup
5. **Test in UI**: Generate a RAID log with real meeting notes
6. **Monitor Usage**: Track API costs and adjust as needed

---

## Future Enhancements

### Planned:
- [ ] Custom Metadata Type for provider configuration
- [ ] User preference for provider selection
- [ ] Rate limiting and cost tracking
- [ ] Caching of similar requests
- [ ] Batch processing for multiple analyses

### Optional:
- [ ] Integration with OpenAI GPT-4
- [ ] Custom AI models fine-tuned on Salesforce projects
- [ ] Real-time streaming of AI responses
- [ ] Multi-language support

---

## Support and Troubleshooting

### Common Issues:

**Issue**: "Unauthorized endpoint" error
**Solution**: Add Remote Site Setting for the API endpoint

**Issue**: Named Credential not detected
**Solution**: Ensure `DeveloperName` exactly matches `Claude_AI_API` or `Gemini_AI_API`

**Issue**: Timeout errors
**Solution**: Increase timeout in service (currently 120s) or check API status

**Issue**: Invalid JSON response
**Solution**: Check AI prompt structure and response cleaning logic

---

## Suggested Git Commit Message

```
feat: integrate real AI (Claude/Gemini) for RAID Log Generator

- Add RAIDAnalysisService.cls with Claude and Gemini API integration
- Add comprehensive test coverage with HttpCalloutMock
- Update aiRaidGenerator LWC to call Apex service instead of mock
- Add AI provider badge display in UI (Claude/Gemini/Mock)
- Add readiness score badge display
- Implement graceful fallback to mock data if AI unavailable
- Support Named Credentials for secure API key management
- Add detailed setup documentation

Breaking Changes: None - mock fallback ensures backward compatibility
Next Steps: Configure Named Credential for Claude or Gemini
```

---

## Documentation Version
- **Created**: 2026-06-19
- **Author**: Salesforce Technical Architect
- **Version**: 1.0.0
