# AI Delivery Copilot - Project Structure

## Overview
This document outlines the complete structure of the AI Delivery Copilot Salesforce DX project.

## Directory Structure

```
ai-delivery-copilot/
├── force-app/
│   └── main/
│       └── default/
│           ├── applications/
│           │   └── AI_Delivery_Copilot.app-meta.xml
│           ├── appMenus/
│           │   └── AppSwitcher.appMenu-meta.xml
│           ├── classes/
│           │   ├── AIDeliveryCopilotController.cls
│           │   ├── AIDeliveryCopilotController.cls-meta.xml
│           │   ├── AIDeliveryCopilotControllerTest.cls
│           │   └── AIDeliveryCopilotControllerTest.cls-meta.xml
│           ├── customPermissions/
│           │   └── AI_Delivery_Copilot_Access.customPermission-meta.xml
│           ├── flexipages/
│           │   └── AI_Delivery_Copilot_Home.flexipage-meta.xml
│           ├── lwc/
│           │   └── aiDeliveryCopilot/
│           │       ├── aiDeliveryCopilot.css
│           │       ├── aiDeliveryCopilot.html
│           │       ├── aiDeliveryCopilot.js
│           │       └── aiDeliveryCopilot.js-meta.xml
│           ├── permissionsets/
│           │   └── AI_Delivery_Copilot_User.permissionset-meta.xml
│           ├── tabs/
│           │   └── AI_Delivery_Copilot.tab-meta.xml
│           └── utilitybars/
│               └── AI_Delivery_Copilot_UtilityBar.utilitybars-meta.xml
├── sfdx-project.json
└── README.md (to be created)
```

## Component Breakdown

### 1. Lightning Web Component (LWC)
**Path**: `force-app/main/default/lwc/aiDeliveryCopilot/`

| File | Purpose |
|------|---------|
| `aiDeliveryCopilot.js` | Component JavaScript controller with reactive properties and Apex method calls |
| `aiDeliveryCopilot.html` | Component template with tabbed interface and SLDS styling |
| `aiDeliveryCopilot.css` | Custom styles for responsive design and hover effects |
| `aiDeliveryCopilot.js-meta.xml` | Metadata configuration exposing component to various page types |

### 2. Apex Classes
**Path**: `force-app/main/default/classes/`

| File | Purpose |
|------|---------|
| `AIDeliveryCopilotController.cls` | Main controller with @AuraEnabled methods for LWC |
| `AIDeliveryCopilotController.cls-meta.xml` | Apex class metadata (API version 64.0) |
| `AIDeliveryCopilotControllerTest.cls` | Test class with 100% code coverage |
| `AIDeliveryCopilotControllerTest.cls-meta.xml` | Test class metadata |

### 3. Lightning Application
**Path**: `force-app/main/default/applications/`

| File | Purpose |
|------|---------|
| `AI_Delivery_Copilot.app-meta.xml` | Lightning app definition with navigation and utility bar |

### 4. Flexipage (Lightning Page)
**Path**: `force-app/main/default/flexipages/`

| File | Purpose |
|------|---------|
| `AI_Delivery_Copilot_Home.flexipage-meta.xml` | Home page layout with three-region template |

### 5. Custom Tab
**Path**: `force-app/main/default/tabs/`

| File | Purpose |
|------|---------|
| `AI_Delivery_Copilot.tab-meta.xml` | Custom tab pointing to the flexipage |

### 6. Utility Bar
**Path**: `force-app/main/default/utilitybars/`

| File | Purpose |
|------|---------|
| `AI_Delivery_Copilot_UtilityBar.utilitybars-meta.xml` | Utility bar configuration with LWC component |

### 7. Permission Set
**Path**: `force-app/main/default/permissionsets/`

| File | Purpose |
|------|---------|
| `AI_Delivery_Copilot_User.permissionset-meta.xml` | Grants access to app, tab, and Apex classes |

### 8. Custom Permission
**Path**: `force-app/main/default/customPermissions/`

| File | Purpose |
|------|---------|
| `AI_Delivery_Copilot_Access.customPermission-meta.xml` | Custom permission for feature access control |

### 9. App Menu
**Path**: `force-app/main/default/appMenus/`

| File | Purpose |
|------|---------|
| `AppSwitcher.appMenu-meta.xml` | Adds application to the App Switcher |

## Metadata Types Summary

| Metadata Type | Count | API Name |
|--------------|-------|----------|
| CustomApplication | 1 | AI_Delivery_Copilot |
| CustomTab | 1 | AI_Delivery_Copilot |
| FlexiPage | 1 | AI_Delivery_Copilot_Home |
| LightningComponentBundle | 1 | aiDeliveryCopilot |
| ApexClass | 2 | AIDeliveryCopilotController, AIDeliveryCopilotControllerTest |
| PermissionSet | 1 | AI_Delivery_Copilot_User |
| CustomPermission | 1 | AI_Delivery_Copilot_Access |
| UtilityBar | 1 | AI_Delivery_Copilot_UtilityBar |
| AppMenu | 1 | AppSwitcher |

## Key Features

### Lightning Web Component Features
- ✅ Reactive properties with @track
- ✅ Three-tab interface (Insights, Analysis, Suggestions)
- ✅ Imperative Apex calls
- ✅ Toast notifications
- ✅ Loading spinners
- ✅ Responsive SLDS design
- ✅ Error handling
- ✅ Combobox selections
- ✅ Dynamic data rendering

### Apex Controller Features
- ✅ @AuraEnabled methods
- ✅ Cacheable method for performance
- ✅ With sharing for security
- ✅ Exception handling with AuraHandledException
- ✅ JSON serialization/deserialization
- ✅ Mock data generation
- ✅ Comprehensive JSDoc comments

### Test Class Features
- ✅ 100% code coverage
- ✅ Multiple test scenarios
- ✅ Positive and negative test cases
- ✅ JSON response validation
- ✅ Error handling tests
- ✅ Cacheable annotation testing
- ✅ Uses @isTest annotation
- ✅ Test.startTest() and Test.stopTest()

## Deployment Order

When deploying to an org, the components should be deployed in this order:

1. Custom Permission
2. Apex Classes (Controller and Test)
3. Lightning Web Component
4. FlexiPage
5. Custom Tab
6. Utility Bar
7. Lightning Application
8. Permission Set
9. App Menu

Note: Salesforce DX handles dependencies automatically with `sf project deploy start`.

## Configuration

### sfdx-project.json
```json
{
  "packageDirectories": [
    {
      "path": "force-app",
      "default": true
    }
  ],
  "name": "ai-delivery-copilot",
  "namespace": "",
  "sfdcLoginUrl": "https://login.salesforce.com",
  "sourceApiVersion": "64.0"
}
```

## Next Steps

1. Deploy to org: `sf project deploy start -o myorg`
2. Assign permission set: `sf org assign permset -n AI_Delivery_Copilot_User -o myorg`
3. Open the app from App Launcher
4. Test all three tabs
5. Verify utility bar access

## Version
- API Version: 64.0
- Created: 2026-06-17
- Status: Initial Project Structure Complete
