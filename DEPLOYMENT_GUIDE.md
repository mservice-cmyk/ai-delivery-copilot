# AI Delivery Copilot - Deployment Guide

## Pre-Deployment Checklist

- [x] Apex Controller class created
- [x] Apex Test class created (100% coverage)
- [x] Lightning Web Component created
- [x] Lightning Application created
- [x] Custom Tab created
- [x] FlexiPage (Home Page) created
- [x] Utility Bar created
- [x] Permission Set created
- [x] Custom Permission created
- [x] App Menu configuration created

## Total Components: 15 Files

### Component Inventory

| Type | Component | File Count |
|------|-----------|------------|
| Apex Class | AIDeliveryCopilotController | 2 files (.cls + .cls-meta.xml) |
| Apex Test | AIDeliveryCopilotControllerTest | 2 files (.cls + .cls-meta.xml) |
| LWC | aiDeliveryCopilot | 4 files (.js, .html, .css, .js-meta.xml) |
| Lightning App | AI_Delivery_Copilot | 1 file |
| Tab | AI_Delivery_Copilot | 1 file |
| FlexiPage | AI_Delivery_Copilot_Home | 1 file |
| Utility Bar | AI_Delivery_Copilot_UtilityBar | 1 file |
| Permission Set | AI_Delivery_Copilot_User | 1 file |
| Custom Permission | AI_Delivery_Copilot_Access | 1 file |
| App Menu | AppSwitcher | 1 file |

## Deployment Steps

### Step 1: Authenticate to Salesforce Org

```bash
# Login to your org (use alias cdo-org)
sf org login web -a cdo-org

# Verify authentication
sf org display -o cdo-org
```

### Step 2: Validate Deployment (Optional but Recommended)

```bash
# Validate without deploying
sf project deploy validate -o cdo-org

# Or run with tests
sf project deploy validate -o cdo-org --test-level RunLocalTests
```

### Step 3: Deploy to Org

```bash
# Deploy all metadata
sf project deploy start -o cdo-org

# Alternative: Deploy with specific test level
sf project deploy start -o cdo-org --test-level RunLocalTests
```

Expected output:
```
Deploying v64.0 metadata to cdo-org
Status: Succeeded
Total Components: 15
Deployed: 15
```

### Step 4: Run Apex Tests

```bash
# Run the test class
sf apex run test -n AIDeliveryCopilotControllerTest -o cdo-org -r human

# Run all tests
sf apex run test -o cdo-org -r human
```

Expected results:
- Test Class: AIDeliveryCopilotControllerTest
- Tests Run: 8
- Tests Passed: 8
- Code Coverage: 100%

### Step 5: Assign Permission Set

```bash
# Assign to your user
sf org assign permset -n AI_Delivery_Copilot_User -o cdo-org

# Verify assignment
sf org list permissions -o cdo-org | grep "AI_Delivery_Copilot_User"
```

### Step 6: Open and Verify

```bash
# Open the org
sf org open -o cdo-org
```

### Step 7: Manual Verification

1. **Open App Launcher**
   - Click the App Launcher icon (waffle menu)
   - Search for "AI Delivery Copilot"
   - Click to open

2. **Verify Navigation**
   - Confirm the custom tab is visible
   - Verify the home page loads

3. **Test AI Insights Tab**
   - Select a context from dropdown
   - Click "Get Insights"
   - Verify insights cards appear
   - Check for loading spinner
   - Confirm refresh button works

4. **Test Metadata Analysis Tab**
   - Select a metadata type
   - Click "Analyze"
   - Verify metrics display
   - Check recommendations list

5. **Test Delivery Suggestions Tab**
   - Select a project phase
   - Click "Get Suggestions"
   - Verify suggestions appear
   - Check time-saving estimates

6. **Verify Utility Bar**
   - Click utility bar icon at bottom of screen
   - Confirm "AI Copilot" appears
   - Click to open utility component
   - Test functionality in utility mode

## Post-Deployment Tasks

### 1. User Access Management

```bash
# Create a list of users who need access
# Assign permission set to each user

sf org assign permset -n AI_Delivery_Copilot_User -o cdo-org -u user@example.com
```

### 2. Set as Default App (Optional)

Navigate to:
- Setup → Apps → App Manager
- Find "AI Delivery Copilot"
- Click dropdown → Edit
- Set as default app for profiles if desired

### 3. Add to Profiles (Optional)

Navigate to:
- Setup → Profiles
- Select profile (e.g., System Administrator)
- Edit
- Add "AI Delivery Copilot" to Custom App Settings

### 4. Configure Utility Bar (Optional)

Navigate to:
- Setup → App Manager
- Find "AI Delivery Copilot"
- Click Edit
- Utility Items (Desktop)
- Verify "AI Copilot" utility is configured

## Troubleshooting

### Issue: Deployment Fails

**Solution 1: Check API Version**
```bash
# Verify API version in sfdx-project.json is supported
cat sfdx-project.json
```

**Solution 2: Deploy Components Individually**
```bash
# Deploy in order
sf project deploy start -m CustomPermission -o cdo-org
sf project deploy start -m ApexClass -o cdo-org
sf project deploy start -m LightningComponentBundle -o cdo-org
sf project deploy start -m FlexiPage -o cdo-org
sf project deploy start -m CustomTab -o cdo-org
sf project deploy start -m CustomApplication -o cdo-org
sf project deploy start -m PermissionSet -o cdo-org
```

### Issue: Test Coverage Below 75%

**Solution:**
```bash
# Run tests to verify coverage
sf apex run test -n AIDeliveryCopilotControllerTest -o cdo-org -c -r human
```

The test class should provide 100% coverage.

### Issue: Component Not Visible

**Solution:**
1. Verify permission set assignment
2. Check profile access
3. Refresh app launcher
4. Clear browser cache
5. Try incognito mode

### Issue: Apex Controller Errors

**Solution:**
```bash
# Check debug logs
sf apex tail log -o cdo-org

# Or get recent logs
sf apex get log -n 5 -o cdo-org
```

### Issue: LWC Not Loading

**Solution:**
1. Check browser console for errors
2. Verify Apex controller is deployed
3. Check method names match between LWC and Apex
4. Verify @AuraEnabled annotation is present
5. Clear Salesforce cache (Setup → Session Settings → Disable caching)

## Rollback Procedure

If deployment needs to be rolled back:

```bash
# Option 1: Delete components via Salesforce UI
# Navigate to Setup → Deploy → Deployed Components
# Select and delete AI Delivery Copilot components

# Option 2: Use destructive changes
# Create destructiveChanges.xml and deploy empty package
```

## Deployment to Production

### Preparation

1. **Deploy to Sandbox First**
   ```bash
   sf org login web -a sandbox
   sf project deploy start -o sandbox --test-level RunLocalTests
   ```

2. **Verify in Sandbox**
   - Complete all manual verification steps
   - Test with actual users
   - Document any issues

3. **Create Change Set (Option 1)**
   - Setup → Outbound Change Sets
   - Add all components
   - Upload to production

4. **Deploy via Metadata API (Option 2)**
   ```bash
   sf org login web -a production
   sf project deploy start -o production --test-level RunLocalTests
   ```

### Production Deployment Checklist

- [ ] All tests passing in sandbox
- [ ] User acceptance testing complete
- [ ] Change management approval obtained
- [ ] Deployment window scheduled
- [ ] Rollback plan documented
- [ ] Stakeholders notified
- [ ] Permission sets created in production
- [ ] Users identified for access
- [ ] Post-deployment verification plan ready

## Monitoring Post-Deployment

### Day 1
- Monitor error logs
- Check user feedback
- Verify performance
- Review usage statistics

### Week 1
- Gather user feedback
- Monitor Apex execution times
- Check for any governor limit issues
- Review debug logs for errors

### Month 1
- Analyze usage patterns
- Plan enhancements based on feedback
- Review performance metrics
- Consider optimization opportunities

## Success Criteria

- ✅ All components deployed successfully
- ✅ All Apex tests passing (100% coverage)
- ✅ Permission set assigned to users
- ✅ Application visible in App Launcher
- ✅ All three tabs functional
- ✅ Utility bar accessible
- ✅ No error logs or exceptions
- ✅ Users can access and use features

## Support Contacts

- **Technical Lead**: Salesforce Technical Architect
- **Deployment Support**: DevOps Team
- **User Support**: Salesforce Admin Team

## Additional Resources

- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/)
- [Lightning Web Components Guide](https://developer.salesforce.com/docs/component-library/documentation/en/lwc)
- [Apex Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/)

---

**Deployment Date**: 2026-06-17  
**Version**: 1.0.0  
**Status**: Ready for Deployment
