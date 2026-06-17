# DeliveryCopilotService - Quick Reference

## 🚀 Quick Start

### Import and Use
```apex
// In Apex
String json = DeliveryCopilotService.processRequest('user_stories', 'My request');

// In LWC
import getAIInsights from '@salesforce/apex/AIDeliveryCopilotController.getAIInsights';
getAIInsights({ context: 'user_stories', userRequest: 'My request' });
```

---

## 📋 Action Types (Context Values)

| Action | Context Value | Priority | Confidence |
|--------|--------------|----------|------------|
| User Stories | `user_stories` | High | 85% |
| Test Cases | `test_cases` | High | 90% |
| Solution Design | `solution_design` | High | 88% |
| Executive Status | `executive_status` | Critical | 82% |
| RAID Log | `raid_log` | Critical | 75% |
| Meeting Prep | `meeting_prep` | High | 88% |
| Deployment | `deployment_checklist` | Critical | 92% |

---

## 📦 Response Structure

### All Actions Return
```json
{
  "actionType": "string",
  "timestamp": "datetime",
  "userRequest": "string",
  "executiveSummary": "string",
  "recommendations": ["string"],
  "risks": [
    {"description": "string", "impact": "High", "probability": "Medium"}
  ],
  "actionItems": [
    {"task": "string", "priority": "High", "owner": "string", "duration": "3 days"}
  ],
  "priority": "Critical|High|Medium|Low",
  "confidenceScore": 85,
  "nextSteps": ["string"]
}
```

---

## 💻 Code Examples

### Apex - Direct Call
```apex
DeliveryCopilotService.DeliveryResponse response = 
    DeliveryCopilotService.generateUserStories('Create portal stories');

System.debug(response.executiveSummary);
System.debug(response.confidenceScore);
```

### Apex - Via Router
```apex
String json = DeliveryCopilotService.processRequest(
    'user_stories',
    'Customer portal with self-service'
);

DeliveryCopilotService.DeliveryResponse response = 
    (DeliveryCopilotService.DeliveryResponse) JSON.deserialize(
        json,
        DeliveryCopilotService.DeliveryResponse.class
    );
```

### LWC - Full Example
```javascript
import getAIInsights from '@salesforce/apex/AIDeliveryCopilotController.getAIInsights';

handleGenerate() {
    this.isLoading = true;
    
    getAIInsights({ 
        context: 'user_stories',
        userRequest: this.userInput 
    })
    .then(result => {
        const response = JSON.parse(result);
        
        console.log('Summary:', response.executiveSummary);
        console.log('Priority:', response.priority);
        console.log('Confidence:', response.confidenceScore + '%');
        
        response.recommendations.forEach(rec => {
            console.log('- ' + rec);
        });
    })
    .catch(error => {
        console.error('Error:', error);
    })
    .finally(() => {
        this.isLoading = false;
    });
}
```

---

## 🧪 Testing

### Run All Tests
```bash
sf apex run test -n DeliveryCopilotServiceTest -o cdo-org -r human
```

### Expected Output
```
Tests Run: 23
Passing: 23
Failing: 0
Code Coverage: 100%
Status: ✅ PASSED
```

---

## 🚀 Deployment

### Deploy Service
```bash
sf project deploy start -m ApexClass:DeliveryCopilotService,DeliveryCopilotServiceTest -o cdo-org
```

### Deploy All
```bash
sf project deploy start -m ApexClass -o cdo-org
```

---

## 📊 Response Fields Reference

### DeliveryResponse
| Field | Type | Description |
|-------|------|-------------|
| actionType | String | Name of action performed |
| timestamp | DateTime | When generated |
| userRequest | String | User's input |
| executiveSummary | String | High-level overview |
| recommendations | List<String> | 5+ recommendations |
| risks | List<RiskItem> | 4+ risks |
| actionItems | List<ActionItem> | 5+ tasks |
| priority | String | Critical/High/Medium/Low |
| confidenceScore | Integer | 0-100 |
| nextSteps | List<String> | 5+ next steps |

### RiskItem
| Field | Type | Values |
|-------|------|--------|
| description | String | Risk description |
| impact | String | High/Medium/Low |
| probability | String | High/Medium/Low |

### ActionItem
| Field | Type | Description |
|-------|------|-------------|
| task | String | Task description |
| priority | String | High/Medium/Low |
| owner | String | Person responsible |
| duration | String | Time estimate |

---

## 🎯 Usage Patterns

### Pattern 1: Simple Generation
```apex
String json = DeliveryCopilotService.processRequest('test_cases', 'Auth module');
```

### Pattern 2: With Parsing
```apex
String json = DeliveryCopilotService.processRequest('user_stories', 'Portal');
DeliveryCopilotService.DeliveryResponse resp = 
    (DeliveryCopilotService.DeliveryResponse) JSON.deserialize(
        json, DeliveryCopilotService.DeliveryResponse.class
    );
```

### Pattern 3: Error Handling
```apex
try {
    String json = DeliveryCopilotService.processRequest(actionType, request);
    return json;
} catch (Exception e) {
    System.debug('Error: ' + e.getMessage());
    throw new AuraHandledException('Failed: ' + e.getMessage());
}
```

### Pattern 4: Conditional Logic
```apex
DeliveryCopilotService.DeliveryResponse response = 
    DeliveryCopilotService.generateUserStories('Request');

if (response.confidenceScore >= 80) {
    // High confidence - proceed
    System.debug('High confidence: ' + response.confidenceScore + '%');
} else {
    // Low confidence - review needed
    System.debug('Review needed');
}

if (response.priority == 'Critical') {
    // Handle critical priority
    sendNotification(response);
}
```

---

## 🔧 Common Tasks

### Get Executive Summary
```apex
DeliveryCopilotService.DeliveryResponse r = 
    DeliveryCopilotService.generateUserStories('Request');
String summary = r.executiveSummary;
```

### Iterate Recommendations
```apex
DeliveryCopilotService.DeliveryResponse r = 
    DeliveryCopilotService.generateUserStories('Request');
for (String rec : r.recommendations) {
    System.debug('Recommendation: ' + rec);
}
```

### Process Risks
```apex
DeliveryCopilotService.DeliveryResponse r = 
    DeliveryCopilotService.generateUserStories('Request');
for (DeliveryCopilotService.RiskItem risk : r.risks) {
    System.debug('Risk: ' + risk.description);
    System.debug('Impact: ' + risk.impact);
    System.debug('Probability: ' + risk.probability);
}
```

### Handle Action Items
```apex
DeliveryCopilotService.DeliveryResponse r = 
    DeliveryCopilotService.generateUserStories('Request');
for (DeliveryCopilotService.ActionItem item : r.actionItems) {
    System.debug('Task: ' + item.task);
    System.debug('Owner: ' + item.owner);
    System.debug('Duration: ' + item.duration);
}
```

---

## ⚡ Performance Tips

1. **Cache results** - Store frequently used responses
2. **Async processing** - Use @future for bulk operations
3. **Batch requests** - Group multiple actions if possible
4. **Monitor heap** - Each response ~5-10KB

---

## 🔒 Security Notes

- Uses `with sharing` - respects sharing rules
- No SOQL/DML - no database operations
- No callouts - pure computation
- Input sanitization - recommended for future AI integration

---

## 🐛 Troubleshooting

### Issue: Empty Response
```apex
// Check action type spelling
'user_stories' ✅ Correct
'userStories' ❌ Wrong
'user-stories' ❌ Wrong
```

### Issue: JSON Parse Error
```javascript
// Always use try-catch
try {
    const response = JSON.parse(result);
} catch (e) {
    console.error('Parse failed:', e);
}
```

### Issue: Null Fields
```apex
// Wrapper initializes lists in constructor
DeliveryResponse r = new DeliveryResponse();
// r.recommendations is already initialized as empty list
```

---

## 📈 Confidence Score Guide

| Score | Meaning | Action |
|-------|---------|--------|
| 90-100 | Very High | Use directly |
| 80-89 | High | Review recommended |
| 70-79 | Medium | Validate carefully |
| 60-69 | Low | Manual review required |
| < 60 | Very Low | Do not use |

---

## 🎨 Priority Levels

| Level | Use For | Example |
|-------|---------|---------|
| Critical | Immediate action | Executive Status, RAID, Deployment |
| High | Important items | User Stories, Test Cases, Meeting |
| Medium | Standard work | Regular recommendations |
| Low | Optional | Future enhancements |

---

## 📞 Quick Help

### Get All Action Types
```apex
List<String> actionTypes = new List<String>{
    'user_stories', 'test_cases', 'solution_design',
    'executive_status', 'raid_log', 'meeting_prep',
    'deployment_checklist'
};
```

### Test All Actions
```apex
for (String actionType : actionTypes) {
    String json = DeliveryCopilotService.processRequest(actionType, 'Test');
    System.debug(actionType + ': ' + json);
}
```

### Validate Response
```apex
DeliveryCopilotService.DeliveryResponse r = 
    DeliveryCopilotService.generateUserStories('Test');

System.assert(r.actionType != null, 'ActionType required');
System.assert(r.executiveSummary != null, 'Summary required');
System.assert(r.priority != null, 'Priority required');
System.assert(r.confidenceScore != null, 'Score required');
System.assert(r.recommendations.size() > 0, 'Recommendations required');
```

---

## 📚 Documentation Links

- **Full Documentation**: `SERVICE_DOCUMENTATION.md`
- **Implementation Summary**: `SERVICE_SUMMARY.md`
- **This Quick Reference**: `SERVICE_QUICK_REFERENCE.md`

---

## ✅ Checklist

### Before Using
- [ ] Service deployed to org
- [ ] Tests passing (100% coverage)
- [ ] Controller updated
- [ ] LWC integrated

### When Calling
- [ ] Action type spelled correctly
- [ ] User request provided (optional but recommended)
- [ ] Error handling in place
- [ ] JSON parsing with try-catch

### After Response
- [ ] Check confidence score
- [ ] Review priority level
- [ ] Parse all relevant fields
- [ ] Display formatted results

---

**Quick Ref Version**: 1.0.0  
**Last Updated**: 2026-06-17  
**Status**: ✅ Production Ready
