# Architecture Guide

## Overview

AI Delivery Copilot is built on a modern, **single-page application (SPA)** architecture following Salesforce best practices and design patterns. The application provides a seamless, ChatGPT-like experience where users stay within one Lightning tab and tools are dynamically loaded without page navigation. This document provides a comprehensive technical overview of the system architecture, component interactions, and design decisions.

---

## Table of Contents

- [Single-Page Application Architecture](#single-page-application-architecture)
- [Architecture Principles](#architecture-principles)
- [System Architecture](#system-architecture)
- [Component Architecture](#component-architecture)
- [Data Model](#data-model)
- [Security Architecture](#security-architecture)
- [Integration Architecture](#integration-architecture)
- [Design Patterns](#design-patterns)
- [Performance Considerations](#performance-considerations)
- [Scalability](#scalability)

---

## Single-Page Application Architecture

### SPA Design Philosophy

The AI Delivery Copilot follows a **unified single-page experience** similar to modern AI tools like ChatGPT, Claude, and Microsoft Copilot. Users interact with one Lightning tab where all tools are dynamically loaded within the same application context.

### User Experience Flow

```
┌─────────────────────────────────────────────┐
│      AI Delivery Copilot Dashboard          │
│                                             │
│  ┌───────────┐  ┌───────────┐  ┌──────────┐│
│  │ UAT Tests │  │ Executive │  │   RAID   ││
│  │           │  │  Status   │  │   Log    ││
│  │  Launch → │  │ Launch →  │  │ Launch → ││
│  └───────────┘  └───────────┘  └──────────┘│
└─────────────────────────────────────────────┘
                    ↓ Click Launch
┌─────────────────────────────────────────────┐
│  ← Back   UAT Test Generator                │
│                                             │
│  [Tool Interface Loaded Here]               │
│                                             │
└─────────────────────────────────────────────┘
```

### Component Structure

**Main Container:** `aiDeliveryCopilot`
- Acts as the SPA shell and view manager
- **Only** component exposed as a Lightning Tab
- Manages navigation state via `currentView` property
- Dynamically loads child tool components

**Child Tool Components (not exposed as tabs):**
- `aiUatTestGenerator` - UAT Test Generator
- `aiExecutiveStatusGenerator` - Executive Status Generator
- `aiRaidGenerator` - RAID Log Generator
- `aiCustomerMeetingPrep` - Customer Meeting Prep
- `aiPromptLibrary` - Prompt Library

### View Management Implementation

```javascript
// State management
@track currentView = 'dashboard';

// View getters
get isDashboardView() { return this.currentView === 'dashboard'; }
get isUATView() { return this.currentView === 'uat-test-generator'; }

// Navigation handlers
handleFeatureLaunch(event) {
    const featureId = event.currentTarget.dataset.id;
    this.currentView = featureId;
    window.scrollTo({ top: 0, behavior: 'smooth' });
}

handleBackToDashboard() {
    this.currentView = 'dashboard';
    window.scrollTo({ top: 0, behavior: 'smooth' });
}
```

### Dynamic Header

The header updates contextually based on the current view:

```javascript
get headerTitle() {
    const titles = {
        'dashboard': 'AI Delivery Copilot',
        'uat-test-generator': 'UAT Test Generator',
        'executive-status': 'Executive Status Generator',
        // ... other views
    };
    return titles[this.currentView];
}

get showBackButton() {
    return this.currentView !== 'dashboard';
}
```

### Benefits of SPA Architecture

✅ **Seamless Experience** - No page refreshes or tab navigation  
✅ **Faster Navigation** - Instant tool switching  
✅ **Unified Interface** - Consistent header and branding  
✅ **Simplified Deployment** - Single Lightning tab to manage  
✅ **Better UX** - Similar to ChatGPT/Claude experience  
✅ **Easier Maintenance** - Centralized view management

---

## Architecture Principles

### 1. Separation of Concerns

The application follows a clear three-tier architecture:

- **Presentation Layer**: Lightning Web Components (UI)
- **Business Logic Layer**: Apex Controllers and Services
- **Data Layer**: Custom Objects and Salesforce Platform

### 2. DRY (Don't Repeat Yourself)

- Centralized service classes for business logic
- Reusable LWC components and utility functions
- Shared prompt templates via PromptTemplateService

### 3. Single Responsibility Principle

Each component has a single, well-defined purpose:

- Controllers handle HTTP requests/responses only
- Services contain business logic
- LWCs manage UI state and user interaction

### 4. Testability

- 100% Apex test coverage
- Mock data providers for testing without external dependencies
- Separation of concerns enables unit testing

### 5. Security by Design

- `with sharing` on all Apex classes
- Field-level security enforcement
- Permission-based access control
- Named Credentials for secure API keys

---

## System Architecture

### High-Level Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                         User Interface Layer                     │
├─────────────────────────────────────────────────────────────────┤
│                  Lightning Web Components (LWC)                  │
│  ┌───────────────┐  ┌──────────────┐  ┌────────────────┐       │
│  │aiDeliveryCopilot│ │aiUserStory  │  │aiUatTest       │       │
│  │   (Main Hub)   │  │  Generator  │  │  Generator     │  ...  │
│  └───────┬────────┘  └──────┬───────┘  └────────┬───────┘       │
│          │                   │                   │               │
│          └───────────────────┼───────────────────┘               │
│                              │                                   │
├──────────────────────────────┼───────────────────────────────────┤
│                    Controller Layer (Apex)                       │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │            AIDeliveryCopilotController                      │ │
│  │  @AuraEnabled getAIInsights(context, userRequest)          │ │
│  └───────────────────────────┬────────────────────────────────┘ │
│  ┌───────────────────────────┴────────────────────────────────┐ │
│  │            UserStoryController                              │ │
│  │  @AuraEnabled generateUserStories(request)                 │ │
│  └───────────────────────────┬────────────────────────────────┘ │
│  ┌───────────────────────────┴────────────────────────────────┐ │
│  │            UATTestController                                │ │
│  │  @AuraEnabled generateTestCases(request)                   │ │
│  └───────────────────────────┬────────────────────────────────┘ │
│                               │                                  │
├───────────────────────────────┼──────────────────────────────────┤
│                    Service Layer (Apex)                          │
│  ┌────────────────────────────▼────────────────────────────┐   │
│  │         DeliveryCopilotService (Main Service)            │   │
│  │  - processRequest(actionType, userRequest): String       │   │
│  │  - generateUserStories(userRequest): DeliveryResponse    │   │
│  │  - generateTestCases(userRequest): DeliveryResponse      │   │
│  │  - reviewSolutionDesign(userRequest): DeliveryResponse   │   │
│  │  - createExecutiveStatus(userRequest): DeliveryResponse  │   │
│  │  - generateRAIDLog(userRequest): DeliveryResponse        │   │
│  │  - prepareCustomerMeeting(userRequest): DeliveryResponse │   │
│  │  - generateDeploymentChecklist(): DeliveryResponse       │   │
│  └──────────────────────────┬───────────────────────────────┘   │
│                              │                                   │
│  ┌───────────────────────────┴──────────────────────┐           │
│  │              UserStoryGenerator                   │           │
│  │  - generateUserStories(request): Response         │           │
│  └───────────────────────────┬──────────────────────┘           │
│                               │                                  │
│  ┌───────────────────────────┴──────────────────────┐           │
│  │            UATTestCaseGenerator                   │           │
│  │  - generateTestCases(request): Response           │           │
│  └───────────────────────────────────────────────────┘           │
├──────────────────────────────────────────────────────────────────┤
│                   AI Integration Layer                            │
│  ┌─────────────────────┐  ┌──────────────────────────────────┐ │
│  │    AIService        │  │   PromptTemplateService          │ │
│  │ - callAI()          │  │ - getSolutionDesignPrompt()      │ │
│  │ - setMode()         │  │ - getUserStoryPrompt()           │ │
│  │ - getMode()         │  │ - getTestCasePrompt()            │ │
│  └──────┬──────────────┘  └──────────────────────────────────┘ │
│         │                                                        │
│         │ ┌───────────────────────────────────────┐             │
│         └─▶ Named Credential: AI_Provider         │             │
│           │ - Endpoint URL (configurable)         │             │
│           │ - Authentication (API Key)            │             │
│           └───────────────┬───────────────────────┘             │
├────────────────────────────┼──────────────────────────────────┤
│                  Data Layer (Salesforce Platform)               │
│  ┌──────────────────────────▼─────────────────────────────┐    │
│  │         Custom Objects                                  │    │
│  │  - AI_Delivery_Request__c (Store requests/responses)   │    │
│  └─────────────────────────────────────────────────────────┘    │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │         Static Resources                                │   │
│  │  - CustomerMeetingPrepMockResponse.json                │   │
│  └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
                               │
                               ▼
                   ┌────────────────────────┐
                   │   External AI APIs     │
                   │  - Anthropic Claude    │
                   │  - OpenAI GPT-4        │
                   │  - Azure OpenAI        │
                   └────────────────────────┘
```

---

## Component Architecture

### Lightning Web Components

#### Component Hierarchy (SPA Architecture)

```
aiDeliveryCopilot (SPA Container - Only Exposed Tab)
├── Dynamic Header Section
│   ├── Back Button (conditional)
│   ├── Title (dynamic based on view)
│   └── Subtitle (dynamic based on view)
├── Dashboard View (currentView === 'dashboard')
│   ├── Executive Metrics
│   │   ├── Total AI Requests
│   │   ├── Time Saved
│   │   └── Delivery Readiness Score
│   ├── Delivery Readiness Card
│   │   ├── Readiness Circle Chart
│   │   └── Progress Breakdown
│   ├── Recent AI Requests Card
│   ├── Feature Cards Grid
│   │   ├── UAT Test Generator (Launch Button)
│   │   ├── Executive Status Generator (Launch Button)
│   │   ├── RAID Generator (Launch Button)
│   │   ├── Customer Meeting Prep (Launch Button)
│   │   └── Prompt Library (Launch Button)
│   ├── Most Used Features Card
│   └── Quick Actions Card
├── Tool Views (loaded dynamically)
│   ├── <c-ai-uat-test-generator> (when isUATView)
│   ├── <c-ai-executive-status-generator> (when isExecutiveStatusView)
│   ├── <c-ai-raid-generator> (when isRAIDView)
│   ├── <c-ai-customer-meeting-prep> (when isMeetingPrepView)
│   └── <c-ai-prompt-library> (when isPromptLibraryView)
└── Utility Components
    └── exportUtility (Shared export functionality)
```

**Key Change:** All tool components are now rendered conditionally within the main container instead of being separate Lightning tabs. Only `aiDeliveryCopilot` is exposed as a tab.

#### Component Communication Patterns

**1. Parent-Child Communication (Props)**
```javascript
// Parent passes data down
<c-export-utility 
    content={generatedOutput}
    format="markdown">
</c-export-utility>
```

**2. Child-Parent Communication (Events)**
```javascript
// Child dispatches custom event
this.dispatchEvent(new CustomEvent('save', {
    detail: { data: this.promptData }
}));

// Parent listens
<c-ai-prompt-library onsave={handleSave}>
```

**3. Sibling Communication (Lightning Message Service)**
```javascript
// Publisher
import { publish, MessageContext } from 'lightning/messageService';
import PROMPT_SELECTED_CHANNEL from '@salesforce/messageChannel/PromptSelected__c';

publish(this.messageContext, PROMPT_SELECTED_CHANNEL, {
    promptId: this.selectedPromptId
});

// Subscriber
import { subscribe, MessageContext } from 'lightning/messageService';
subscribe(this.messageContext, PROMPT_SELECTED_CHANNEL, (message) => {
    this.handlePromptSelected(message.promptId);
});
```

### Apex Architecture

#### Controller Layer Pattern

```apex
public with sharing class UserStoryController {
    
    @AuraEnabled
    public static String generateUserStories(String requestJson) {
        try {
            // 1. Deserialize request
            UserStoryGenerator.UserStoryRequest request = 
                (UserStoryGenerator.UserStoryRequest) 
                JSON.deserialize(requestJson, UserStoryGenerator.UserStoryRequest.class);
            
            // 2. Validate input
            if (String.isBlank(request.businessRequirement)) {
                throw new AuraHandledException('Business requirement is required');
            }
            
            // 3. Call service layer
            UserStoryGenerator.UserStoryResponse response = 
                UserStoryGenerator.generateUserStories(request);
            
            // 4. Serialize and return
            return JSON.serialize(response);
            
        } catch (Exception e) {
            throw new AuraHandledException('Error: ' + e.getMessage());
        }
    }
}
```

#### Service Layer Pattern

```apex
public with sharing class DeliveryCopilotService {
    
    // Main router method
    public static String processRequest(String actionType, String userRequest) {
        DeliveryResponse response;
        
        switch on actionType {
            when 'solution_design' {
                response = reviewSolutionDesign(userRequest);
            }
            // ... other cases
        }
        
        return JSON.serialize(response, true);
    }
    
    // Feature-specific method with AI integration
    private static DeliveryResponse reviewSolutionDesign(String userRequest) {
        // Check AI mode
        if (AIService.getMode() == AIService.AIMode.REAL) {
            return reviewSolutionDesignWithAI(userRequest);
        }
        
        // Fallback to mock
        return createMockSolutionDesignResponse(userRequest);
    }
    
    // AI integration method
    private static DeliveryResponse reviewSolutionDesignWithAI(String userRequest) {
        // Get prompt template
        PromptTemplateService.PromptTemplate template = 
            PromptTemplateService.getSolutionDesignPrompt(userRequest);
        
        // Call AI service
        AIService.AIResponse aiResponse = AIService.callAI(
            template.userPrompt,
            template.systemContext,
            template.maxTokens
        );
        
        // Parse and return
        return parseAIResponse(aiResponse.content);
    }
}
```

---

## Data Model

### Custom Objects

#### AI_Delivery_Request__c

| Field API Name | Type | Description |
|----------------|------|-------------|
| `Name` | Auto Number | Auto-generated: REQ-{0000} |
| `Title__c` | Text(255) | Title of the request |
| `Action_Type__c` | Picklist | User Stories, Test Cases, Solution Design, etc. |
| `Prompt__c` | Long Text Area | User's input prompt |
| `Generated_Response__c` | Long Text Area | AI-generated response |
| `Status__c` | Picklist | Draft, In Progress, Completed, Failed |
| `Confidence_Score__c` | Number(3,0) | AI confidence score (0-100) |
| `Rating__c` | Number(1,0) | User rating (1-5 stars) |
| `Readiness_Score__c` | Number(3,0) | Readiness score for deliverable |
| `CreatedById` | Lookup(User) | Request creator |
| `CreatedDate` | DateTime | Creation timestamp |

#### Relationships

```
User (Standard Object)
  │
  └─── AI_Delivery_Request__c (Master-Detail or Lookup)
         └─── Related Lists on User record
```

### Static Resources

| Resource Name | Type | Purpose |
|---------------|------|---------|
| `CustomerMeetingPrepMockResponse` | JSON | Mock data for meeting prep feature |

---

## Security Architecture

### Permission Model

```
┌─────────────────────────────────────────────────┐
│           AI_Delivery_Copilot_User              │
│             (Permission Set)                    │
├─────────────────────────────────────────────────┤
│  Application Access                             │
│  ✓ AI Delivery Copilot App                     │
│                                                 │
│  Object Permissions                             │
│  ✓ AI_Delivery_Request__c (CRUD + View All)    │
│                                                 │
│  Apex Class Access                              │
│  ✓ AIDeliveryCopilotController                 │
│  ✓ DeliveryCopilotService                      │
│  ✓ UserStoryController                         │
│  ✓ UATTestController                           │
│  ✓ AIService                                   │
│  ✓ PromptTemplateService                       │
│                                                 │
│  Custom Permissions                             │
│  ✓ AI_Delivery_Copilot_Access                  │
│                                                 │
│  Tab Visibility                                 │
│  ✓ AI_Delivery_Copilot (Visible)               │
└─────────────────────────────────────────────────┘
```

### Data Security

**Sharing Model**: Private (controlled by `with sharing`)

```apex
// All classes enforce sharing
public with sharing class DeliveryCopilotService {
    // Users can only access their own AI_Delivery_Request__c records
}
```

**Field-Level Security**: Managed via Permission Set

**API Key Security**: Stored in Named Credentials (encrypted)

---

## Integration Architecture

### AI Provider Integration

```
┌─────────────────────────────────────────────────────┐
│              AIService.callAI()                     │
└───────────────────┬─────────────────────────────────┘
                    │
      ┌─────────────┴──────────────┐
      │ Check Mode                 │
      │ - MOCK: Return mock data   │
      │ - REAL: Make HTTP callout  │
      └─────────────┬──────────────┘
                    │
      ┌─────────────▼──────────────┐
      │ Build Request Payload      │
      │ - prompt                   │
      │ - systemContext            │
      │ - maxTokens                │
      │ - model                    │
      └─────────────┬──────────────┘
                    │
      ┌─────────────▼──────────────┐
      │ HTTP Callout               │
      │ - Named Credential         │
      │ - POST request             │
      │ - 120s timeout             │
      └─────────────┬──────────────┘
                    │
      ┌─────────────▼──────────────┐
      │ Parse Response             │
      │ - Extract content          │
      │ - Handle errors            │
      │ - Return AIResponse        │
      └────────────────────────────┘
```

### Request/Response Flow

**Example: Solution Design Review**

```
1. User enters design details in LWC
   ↓
2. LWC calls: UserStoryController.generateUserStories(requestJson)
   ↓
3. Controller deserializes request and calls: DeliveryCopilotService.reviewSolutionDesign()
   ↓
4. Service checks AI mode:
   - MOCK: Return mock response
   - REAL: Call AIService.callAI()
   ↓
5. AIService:
   a. Gets prompt template from PromptTemplateService
   b. Makes HTTP callout to Named Credential
   c. Parses AI provider response
   d. Returns AIResponse
   ↓
6. Service parses AIResponse into DeliveryResponse
   ↓
7. Controller serializes DeliveryResponse to JSON
   ↓
8. LWC receives JSON and updates UI
```

---

## Design Patterns

### 1. Service Layer Pattern

**Purpose**: Separate business logic from controllers

```apex
// Controller (thin)
@AuraEnabled
public static String getInsights(String context) {
    return DeliveryCopilotService.processRequest(context, null);
}

// Service (fat)
public static String processRequest(String actionType, String userRequest) {
    // Complex business logic here
}
```

### 2. Strategy Pattern

**Purpose**: Switch between mock and real AI modes

```apex
public enum AIMode { MOCK, REAL }

private static AIMode currentMode = AIMode.MOCK;

public static AIResponse callAI(String prompt, String context, Integer tokens) {
    if (currentMode == AIMode.MOCK) {
        return createMockResponse(prompt);
    }
    return callRealAI(prompt, context, tokens);
}
```

### 3. Factory Pattern

**Purpose**: Generate prompt templates

```apex
public static PromptTemplate getSolutionDesignPrompt(String userRequest) {
    String systemContext = buildSystemContext('architect');
    String userPrompt = buildUserPrompt('solution_design', userRequest);
    return new PromptTemplate(systemContext, userPrompt, 4000);
}
```

### 4. Builder Pattern

**Purpose**: Construct complex response objects

```apex
DeliveryResponse response = new DeliveryResponse();
response.actionType = 'Review Solution Design';
response.timestamp = DateTime.now();
response.recommendations = new List<String>();
response.risks = new List<RiskItem>();
// ... build up response
```

### 5. Template Method Pattern

**Purpose**: Define skeleton of algorithm with customizable steps

```apex
public static DeliveryResponse reviewSolutionDesign(String userRequest) {
    // Template method
    if (AIService.getMode() == AIService.AIMode.REAL) {
        return reviewWithAI(userRequest);  // Customizable step
    }
    return reviewWithMock(userRequest);     // Customizable step
}
```

---

## Performance Considerations

### Governor Limits

| Operation | Limit | Current Usage | Optimization |
|-----------|-------|---------------|--------------|
| SOQL Queries | 100 | <5 per transaction | Bulkified queries |
| DML Statements | 150 | <5 per transaction | Bulk DML |
| Heap Size | 6 MB (Sync) | <1 MB typical | Efficient data structures |
| CPU Time | 10,000 ms | <2,000 ms typical | Optimized loops |
| Callouts | 100 | 1 per AI request | Queueable for bulk |

### Optimization Techniques

**1. Lazy Loading in LWC**
```javascript
@wire(getAIInsights, { context: '$selectedContext' })
wiredInsights({ error, data }) {
    // Data loaded only when needed
}
```

**2. Caching (Future Enhancement)**
```apex
// Cache frequently used prompts
private static Map<String, PromptTemplate> promptCache = 
    new Map<String, PromptTemplate>();
```

**3. Async Processing for Large Operations**
```apex
public class AICalloutQueueable implements Queueable, Database.AllowsCallouts {
    public void execute(QueueableContext context) {
        AIService.callAI(prompt, systemContext, maxTokens);
    }
}
```

---

## Scalability

### Horizontal Scalability

- **Multi-Org Support**: Deploy to multiple orgs independently
- **User Concurrency**: Supports 100+ concurrent users per org
- **Data Volume**: Handles 100K+ AI_Delivery_Request__c records

### Vertical Scalability

- **Feature Modules**: Each feature is independent and can be enhanced separately
- **AI Provider Flexibility**: Switch providers without code changes (configuration only)
- **Extensibility**: Easy to add new action types to DeliveryCopilotService

### High Availability

- **Fallback Mechanisms**: Auto-fallback to mock mode on AI API errors
- **Error Handling**: Graceful degradation with user-friendly error messages
- **Named Credentials**: Centralized endpoint management

---

## Deployment Architecture

### Development → Production Pipeline

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Dev Org   │────▶│ Sandbox Org │────▶│   UAT Org   │────▶│ Production  │
│  (Testing)  │     │ (Integration)     │  (Validation)     │   (Live)    │
└─────────────┘     └─────────────┘     └─────────────┘     └─────────────┘
      │                     │                    │                   │
      ▼                     ▼                    ▼                   ▼
  Unit Tests          Integration Tests     UAT Tests        Smoke Tests
  (100% Coverage)     (End-to-End)         (User Acceptance) (Post-Deploy)
```

### Environment-Specific Configuration

| Configuration | Dev | Sandbox | UAT | Production |
|---------------|-----|---------|-----|------------|
| AI Mode | MOCK | MOCK | REAL | REAL |
| API Provider | N/A | Anthropic Test | Anthropic Test | Anthropic Prod |
| Logging Level | DEBUG | DEBUG | INFO | ERROR |
| Test Data | Generated | Generated | Sanitized Prod | None |

---

## Monitoring & Observability

### Logging Strategy

```apex
// Log AI service calls
System.debug('AI API Call: ' + endpoint);
System.debug('AI Response Time: ' + responseTime + 'ms');
System.debug('AI Tokens Used: ' + tokensUsed);
```

### Metrics to Track

1. **Usage Metrics**
   - Number of requests per feature
   - Average response time
   - Success/failure rate

2. **AI Metrics**
   - Token consumption per request
   - API cost per transaction
   - Confidence scores distribution

3. **Performance Metrics**
   - LWC load time
   - Apex execution time
   - Database query time

---

## Conclusion

This architecture provides:

✅ **Scalability** - Handles growing user base and feature set  
✅ **Maintainability** - Clear separation of concerns  
✅ **Testability** - 100% test coverage  
✅ **Security** - Enterprise-grade security model  
✅ **Flexibility** - Easy to extend and customize  
✅ **Performance** - Optimized for governor limits  

For questions or suggestions, contact the architecture team.
