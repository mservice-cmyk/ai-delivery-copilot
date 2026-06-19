# Deployment Checklist - SPA Architecture

## Pre-Deployment

- [ ] Review all code changes in the PR/branch
- [ ] Ensure all tests pass locally
- [ ] Backup current Lightning App configuration
- [ ] Document current tab structure for rollback reference

## Deployment Steps

### 1. Deploy Component Changes

- [ ] Deploy `aiDeliveryCopilot` component (HTML, JS, CSS)
- [ ] Deploy all tool component metadata files
  - [ ] `aiUatTestGenerator.js-meta.xml`
  - [ ] `aiExecutiveStatusGenerator.js-meta.xml`
  - [ ] `aiRaidGenerator.js-meta.xml`
  - [ ] `aiCustomerMeetingPrep.js-meta.xml`
  - [ ] `aiPromptLibrary.js-meta.xml`

### 2. Remove Old Tabs

- [ ] Delete UAT Test Generator tab
- [ ] Delete Executive Status Generator tab
- [ ] Delete RAID Generator tab
- [ ] Delete Customer Meeting Prep tab
- [ ] Delete Prompt Library tab

### 3. Update Lightning App

- [ ] Open App Manager in Setup
- [ ] Edit AI Delivery Copilot app
- [ ] Remove deleted tabs from navigation
- [ ] Verify only "AI Delivery Copilot" tab remains
- [ ] Save changes

## Testing

### Functional Testing

- [ ] Navigate to AI Delivery Copilot tab
- [ ] Dashboard loads successfully
- [ ] All metrics display correctly
- [ ] Feature cards render properly

### Navigation Testing

- [ ] Click Launch on UAT Test Generator
  - [ ] Tool loads correctly
  - [ ] Back button appears
  - [ ] Header updates with tool name
- [ ] Click Back button
  - [ ] Returns to dashboard
  - [ ] Dashboard content intact
- [ ] Repeat for all tools:
  - [ ] Executive Status Generator
  - [ ] RAID Generator
  - [ ] Customer Meeting Prep
  - [ ] Prompt Library

### User Experience Testing

- [ ] Transitions are smooth
- [ ] No page refreshes occur
- [ ] Scroll position resets on view change
- [ ] Loading states work correctly
- [ ] No JavaScript errors in console

### Permission Testing

- [ ] Test with different user profiles
- [ ] Verify permissions still work correctly
- [ ] Ensure no tab access errors

## Post-Deployment

### Validation

- [ ] Monitor debug logs for errors
- [ ] Check with pilot users for feedback
- [ ] Verify no performance degradation

### Communication

- [ ] Send announcement email to users
- [ ] Update internal documentation
- [ ] Notify support team of changes

### Documentation

- [ ] Update ARCHITECTURE.md (already done)
- [ ] Update README.md (already done)
- [ ] Create SPA_MIGRATION_GUIDE.md (already done)
- [ ] Update user training materials if applicable

## Rollback Plan (If Needed)

If critical issues are found:

- [ ] Restore deleted tab metadata files
- [ ] Update component metadata to re-expose tools
- [ ] Restore original `aiDeliveryCopilot` component
- [ ] Re-add tabs to Lightning App
- [ ] Deploy changes
- [ ] Notify users of rollback

## Success Criteria

✅ All tools accessible from single dashboard  
✅ No navigation to separate tabs  
✅ Back button works correctly  
✅ All existing functionality preserved  
✅ No JavaScript errors  
✅ Positive user feedback  

## Sign-Off

- [ ] Developer: Verified all changes
- [ ] QA: Tested all scenarios
- [ ] Admin: Configured Lightning App
- [ ] Product Owner: Approved deployment

---

**Deployment Date:** ___________  
**Deployed By:** ___________  
**Deployment Status:** ___________  
**Issues Found:** ___________  
**Resolution:** ___________
