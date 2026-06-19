# Single-Page Application Migration Guide

## Overview

This document describes the migration of AI Delivery Copilot from a multi-tab architecture to a unified single-page application (SPA).

## What Changed

### Before: Multi-Tab Architecture
```
Users navigated between separate Lightning tabs:
├── AI Delivery Copilot (Dashboard)
├── UAT Test Generator (Separate tab)
├── Executive Status Generator (Separate tab)
├── RAID Generator (Separate tab)
├── Customer Meeting Prep (Separate tab)
└── Prompt Library (Separate tab)
```

### After: Single-Page Application
```
Users stay in ONE Lightning tab:
└── AI Delivery Copilot
    ├── Dashboard View (default)
    └── Dynamic Tool Views
        ├── UAT Test Generator (loaded on demand)
        ├── Executive Status Generator (loaded on demand)
        ├── RAID Generator (loaded on demand)
        ├── Customer Meeting Prep (loaded on demand)
        └── Prompt Library (loaded on demand)
```

## Changes Made

### 1. Component Structure Changes

#### Main Container Component (`aiDeliveryCopilot`)

**Added:**
- `currentView` state property to track active view
- View getter methods (`isDashboardView`, `isUATView`, etc.)
- Back button in header
- Dynamic header title and subtitle
- View navigation handlers (`handleFeatureLaunch`, `handleBackToDashboard`)

**Modified:**
- Removed `NavigationMixin` (no longer needed)
- Removed individual navigation methods to separate tabs
- Launch buttons now switch views instead of navigating to tabs

**HTML Template Changes:**
```html
<!-- Before -->
<lightning-button onclick={navigateToUATGenerator}>

<!-- After -->
<lightning-button onclick={handleFeatureLaunch} data-id="uat-test-generator">
```

#### Tool Components

**Metadata Changes:**
All tool components now have:
```xml
<isExposed>false</isExposed>
```

Instead of:
```xml
<isExposed>true</isExposed>
<targets>
    <target>lightning__Tab</target>
</targets>
```

**Modified Components:**
- `aiUatTestGenerator/aiUatTestGenerator.js-meta.xml`
- `aiExecutiveStatusGenerator/aiExecutiveStatusGenerator.js-meta.xml`
- `aiRaidGenerator/aiRaidGenerator.js-meta.xml`
- `aiCustomerMeetingPrep/aiCustomerMeetingPrep.js-meta.xml`
- `aiPromptLibrary/aiPromptLibrary.js-meta.xml`

### 2. Lightning Tab Removal

**Deleted Files:**
- `/force-app/main/default/tabs/UAT_Test_Generator.tab-meta.xml`
- `/force-app/main/default/tabs/Executive_Status_Generator.tab-meta.xml`
- `/force-app/main/default/tabs/RAID_Generator.tab-meta.xml`
- `/force-app/main/default/tabs/Customer_Meeting_Prep.tab-meta.xml`
- `/force-app/main/default/tabs/Prompt_Library.tab-meta.xml`

**Kept:**
- `/force-app/main/default/tabs/AI_Delivery_Copilot.tab-meta.xml` (main entry point)

### 3. CSS Updates

**Added to `aiDeliveryCopilot.css`:**
```css
.back-button {
    color: white;
    transition: all 0.2s ease;
}

.back-button:hover {
    transform: translateX(-3px);
    opacity: 0.8;
}
```

### 4. Documentation Updates

**Updated Files:**
- `README.md` - Added SPA overview section
- `docs/ARCHITECTURE.md` - Added comprehensive SPA architecture section
- `docs/SPA_MIGRATION_GUIDE.md` - This file

## Technical Implementation

### View Management Pattern

```javascript
// State management
@track currentView = 'dashboard';

// View switching
handleFeatureLaunch(event) {
    const featureId = event.currentTarget.dataset.id;
    this.currentView = featureId;
    window.scrollTo({ top: 0, behavior: 'smooth' });
}

// Back navigation
handleBackToDashboard() {
    this.currentView = 'dashboard';
    window.scrollTo({ top: 0, behavior: 'smooth' });
}

// Conditional rendering
get isDashboardView() {
    return this.currentView === 'dashboard';
}
```

### HTML Template Pattern

```html
<template>
    <div class="dashboard-container">
        <!-- Dynamic Header with Back Button -->
        <div class="dashboard-header">
            <template if:true={showBackButton}>
                <lightning-button-icon
                    icon-name="utility:back"
                    onclick={handleBackToDashboard}>
                </lightning-button-icon>
            </template>
            <h1>{headerTitle}</h1>
            <p>{headerSubtitle}</p>
        </div>

        <!-- Dashboard View -->
        <template if:true={isDashboardView}>
            <div class="content-wrapper">
                <!-- Dashboard content -->
            </div>
        </template>

        <!-- Tool Views -->
        <template if:true={isUATView}>
            <c-ai-uat-test-generator></c-ai-uat-test-generator>
        </template>
        
        <!-- Other tool views... -->
    </div>
</template>
```

## Deployment Instructions

### Step 1: Deploy Updated Components

Deploy all modified files to your org:

```bash
sf project deploy start --source-dir force-app/main/default/lwc/aiDeliveryCopilot
sf project deploy start --source-dir force-app/main/default/lwc/aiUatTestGenerator
sf project deploy start --source-dir force-app/main/default/lwc/aiExecutiveStatusGenerator
sf project deploy start --source-dir force-app/main/default/lwc/aiRaidGenerator
sf project deploy start --source-dir force-app/main/default/lwc/aiCustomerMeetingPrep
sf project deploy start --source-dir force-app/main/default/lwc/aiPromptLibrary
```

### Step 2: Remove Old Lightning Tabs

The old tabs are already deleted from the source. Deploy the deletion:

```bash
sf project deploy start --metadata CustomTab
```

Or manually delete the tabs from Setup:
1. Navigate to Setup > Tabs
2. Delete the following custom tabs:
   - UAT Test Generator
   - Executive Status Generator
   - RAID Generator
   - Customer Meeting Prep
   - Prompt Library

### Step 3: Update Lightning Apps

Update your Lightning App navigation to remove the old tabs:

1. Go to Setup > App Manager
2. Edit your Lightning App (e.g., "AI Delivery Copilot")
3. Go to Navigation Items
4. Remove the following tabs:
   - UAT Test Generator
   - Executive Status Generator
   - RAID Generator
   - Customer Meeting Prep
   - Prompt Library
5. Keep only: **AI Delivery Copilot**

### Step 4: Test the Application

1. Navigate to the **AI Delivery Copilot** tab
2. Verify the dashboard loads correctly
3. Click Launch on each feature card
4. Verify tools load within the same page
5. Test the Back button returns to dashboard
6. Verify smooth transitions between views

## User Communication

### Announcement Template

**Subject:** New Unified Experience for AI Delivery Copilot

Hi Team,

We've upgraded the AI Delivery Copilot to provide a faster, more seamless experience!

**What's New:**
- All tools now load within a single tab - no more navigating between pages
- Faster tool switching with instant loading
- Back button to easily return to the dashboard
- Consistent interface similar to ChatGPT and Claude

**How to Access:**
1. Click on the "AI Delivery Copilot" tab (same as before)
2. On the dashboard, click "Launch" on any tool card
3. The tool opens in the same tab
4. Click the back arrow to return to the dashboard

All functionality remains the same - just faster and easier to use!

Let us know if you have any questions.

Thanks,
[Your Team]

## Benefits Summary

### For Users
✅ Faster navigation between tools  
✅ No page refreshes or loading delays  
✅ Intuitive back navigation  
✅ Consistent, modern interface  
✅ Stay in context while working  

### For Administrators
✅ Simplified Lightning App configuration  
✅ Fewer tabs to manage  
✅ Easier permission management  
✅ Single deployment point  
✅ Reduced maintenance overhead  

### For Developers
✅ Centralized view management  
✅ Cleaner component architecture  
✅ Easier to add new tools  
✅ Better code organization  
✅ Follows LWC best practices  

## Rollback Plan

If you need to rollback to the multi-tab architecture:

1. Restore the deleted tab metadata files from version control
2. Update component metadata to re-expose tool components:
   ```xml
   <isExposed>true</isExposed>
   <targets>
       <target>lightning__Tab</target>
   </targets>
   ```
3. Restore the original `aiDeliveryCopilot.js` without view management
4. Re-add tabs to Lightning App navigation
5. Deploy changes

## Future Enhancements

Now that we have SPA architecture, these enhancements become easier:

- **Browser History Support** - Deep linking to specific tools
- **Breadcrumb Navigation** - Visual navigation path
- **View State Persistence** - Remember last viewed tool
- **Keyboard Shortcuts** - Navigate without mouse
- **Split-Screen Mode** - Compare outputs side-by-side
- **Recent Tools** - Quick access to frequently used tools
- **Favorites** - Pin your most-used tools to dashboard

## Questions & Support

For questions about this migration:
- Check the [ARCHITECTURE.md](./ARCHITECTURE.md) documentation
- Review the code changes in `aiDeliveryCopilot` component
- Contact the development team

## Conclusion

The migration to a single-page application architecture significantly improves the user experience while maintaining all existing functionality. The implementation is clean, follows LWC best practices, and positions the application for future enhancements.

---

**Migration Date:** June 2026  
**Version:** 2.1.0  
**Breaking Changes:** None (transparent to end users)
