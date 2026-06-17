# AI Delivery Copilot - Quick Reference Guide

## 🚀 Quick Commands

### Deploy Everything
```bash
sf project deploy start -o cdo-org
```

### Assign Permission Set
```bash
sf org assign permset -n AI_Delivery_Copilot_User -o cdo-org
```

### Run Tests
```bash
sf apex run test -n AIDeliveryCopilotControllerTest -o cdo-org -r human
```

### Open Org
```bash
sf org open -o cdo-org
```

## 📁 Key Files

| File | Purpose | Lines |
|------|---------|-------|
| `AIDeliveryCopilotController.cls` | Main Apex logic | ~190 |
| `AIDeliveryCopilotControllerTest.cls` | Test coverage | ~130 |
| `aiDeliveryCopilot.js` | LWC JavaScript | ~165 |
| `aiDeliveryCopilot.html` | LWC Template | ~200 |
| `AI_Delivery_Copilot.app-meta.xml` | Lightning App | ~20 |

## 🔑 Key API Names

| Component | API Name |
|-----------|----------|
| Lightning App | `AI_Delivery_Copilot` |
| Custom Tab | `AI_Delivery_Copilot` |
| LWC | `aiDeliveryCopilot` |
| Apex Class | `AIDeliveryCopilotController` |
| Test Class | `AIDeliveryCopilotControllerTest` |
| Permission Set | `AI_Delivery_Copilot_User` |
| FlexiPage | `AI_Delivery_Copilot_Home` |
| Utility Bar | `AI_Delivery_Copilot_UtilityBar` |

## 🎯 Component Methods

### Apex Controller

```apex
// Get AI insights for a context
AIDeliveryCopilotController.getAIInsights(String context)

// Analyze metadata
AIDeliveryCopilotController.analyzeMetadata(String metadataType)

// Get delivery suggestions
AIDeliveryCopilotController.getDeliverySuggestions(String projectPhase)
```

### LWC Component

```javascript
// Load insights
loadAIInsights()

// Load analysis
loadMetadataAnalysis()

// Load suggestions
loadDeliverySuggestions()

// Refresh current tab
handleRefresh()
```

## 📊 Mock Data Contexts

### AI Insights Contexts
- `requirement_analysis`
- `technical_design`
- `code_review`
- `architecture_review`
- `performance_optimization`

### Metadata Types
- `CustomObject`
- `ApexClass`
- `Flow`
- `ValidationRule`
- `LightningComponentBundle`

### Project Phases
- `discovery`
- `design`
- `development`
- `testing`
- `deployment`

## 🎨 SLDS Components Used

- `lightning-card`
- `lightning-tabset`
- `lightning-tab`
- `lightning-combobox`
- `lightning-button`
- `lightning-spinner`
- `lightning-badge`
- `lightning-icon`

## 🧪 Test Methods

```apex
testGetAIInsights_Success()
testGetAIInsights_DifferentContexts()
testAnalyzeMetadata_Success()
testAnalyzeMetadata_VariousTypes()
testGetDeliverySuggestions_Success()
testGetDeliverySuggestions_AllPhases()
testGetAIInsights_ErrorHandling()
testCacheableAnnotation()
```

## 🔒 Security Features

- ✅ `with sharing` keyword
- ✅ Custom Permission: `AI_Delivery_Copilot_Access`
- ✅ Permission Set: `AI_Delivery_Copilot_User`
- ✅ AuraHandledException for errors
- ✅ FLS considerations

## 📱 Responsive Breakpoints

```css
/* Desktop: default styles */
/* Tablet: medium-size classes */
@media (max-width: 768px) {
  /* Mobile: responsive adjustments */
}
```

## 🎯 Component Targets

The LWC can be added to:
- ✅ App Pages (`lightning__AppPage`)
- ✅ Home Pages (`lightning__HomePage`)
- ✅ Record Pages (`lightning__RecordPage`)
- ✅ Tabs (`lightning__Tab`)
- ✅ Communities (`lightningCommunity__Page`)

## 🛠️ Troubleshooting Quick Fixes

### Component Not Visible
```bash
sf org assign permset -n AI_Delivery_Copilot_User -o cdo-org
# Then refresh browser
```

### Tests Failing
```bash
sf apex run test -n AIDeliveryCopilotControllerTest -o cdo-org -r human -d ./test-results
# Check ./test-results for details
```

### Deployment Issues
```bash
# Deploy step by step
sf project deploy start -m CustomPermission -o cdo-org
sf project deploy start -m ApexClass -o cdo-org
sf project deploy start -m LightningComponentBundle -o cdo-org
```

### View Logs
```bash
sf apex tail log -o cdo-org
```

## 📦 Package Contents

```
15 Total Files
├── 4 Apex files (.cls + metadata)
├── 4 LWC files (.js, .html, .css, .xml)
├── 7 Metadata files (app, tab, page, etc.)
```

## 🎬 User Flow

1. **Open App** → App Launcher → "AI Delivery Copilot"
2. **Select Tab** → Insights / Analysis / Suggestions
3. **Choose Context** → Select from dropdown
4. **Click Button** → Get Insights / Analyze / Get Suggestions
5. **Review Results** → Read cards, metrics, recommendations

## 🔄 Development Workflow

```bash
# 1. Make changes
vim force-app/main/default/lwc/aiDeliveryCopilot/aiDeliveryCopilot.js

# 2. Deploy changes
sf project deploy start -o cdo-org

# 3. Run tests
sf apex run test -n AIDeliveryCopilotControllerTest -o cdo-org -r human

# 4. Open and verify
sf org open -o cdo-org
```

## 📈 Performance Tips

- ✅ Use `@AuraEnabled(cacheable=true)` for read-only methods
- ✅ Minimize Apex callouts
- ✅ Use reactive properties `@track` sparingly
- ✅ Implement loading states
- ✅ Cache data in component when possible

## 🎨 Customization Points

### Add New Context
```javascript
// In aiDeliveryCopilot.js
contextOptions = [
    ...
    { label: 'New Context', value: 'new_context' }
];
```

### Add New Insight
```apex
// In AIDeliveryCopilotController.cls
insights.add(new Map<String, Object>{
    'id' => 'insight-004',
    'title' => 'New Insight',
    'description' => 'Description here',
    'priority' => 'high',
    'category' => context
});
```

### Customize Styling
```css
/* In aiDeliveryCopilot.css */
.slds-card {
    /* Add custom styles */
}
```

## 📚 Related Documentation

- [README.md](./README.md) - Full documentation
- [PROJECT_STRUCTURE.md](./PROJECT_STRUCTURE.md) - File structure
- [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md) - Deployment steps
- [IMPLEMENTATION_SUMMARY.md](./IMPLEMENTATION_SUMMARY.md) - What's built

## 🆘 Common Issues

| Issue | Solution |
|-------|----------|
| Permission denied | Assign permission set |
| Component not loading | Clear cache, check console |
| Tests failing | Run with `-r human` flag |
| Deployment error | Check API version |
| Utility bar missing | Edit app, verify utility items |

## 🔗 Important Links

- **App Launcher**: Search "AI Delivery Copilot"
- **Setup Path**: Setup → Apps → App Manager → AI Delivery Copilot
- **Permission Path**: Setup → Permission Sets → AI Delivery Copilot User
- **Debug Logs**: Setup → Debug Logs

## ⚡ Power User Tips

1. **Quick Deploy**: Use `sf project deploy start` without flags
2. **Watch Logs**: Use `sf apex tail log` in separate terminal
3. **Test Coverage**: Always run with `-c` flag to see coverage
4. **Quick Test**: Use `-n` flag to run specific test class
5. **Open Quick**: Use `sf org open -p lightning/n/AI_Delivery_Copilot`

## 🎓 Learning Resources

- [LWC Documentation](https://developer.salesforce.com/docs/component-library/documentation/en/lwc)
- [Apex Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/)
- [SLDS Components](https://www.lightningdesignsystem.com/components/)
- [Salesforce DX Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/)

---

**Quick Start**: `sf project deploy start -o cdo-org && sf org assign permset -n AI_Delivery_Copilot_User -o cdo-org && sf org open -o cdo-org` 🚀
