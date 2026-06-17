# AI Delivery Copilot - Design Mockup

## Visual Layout Overview

```
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                         │
│  ╔═══════════════════════════════════════════════════════════════════╗ │
│  ║  🔧  AI Delivery Copilot                                          ║ │
│  ║      Accelerate your Salesforce delivery with AI-powered assistance║ │
│  ╚═══════════════════════════════════════════════════════════════════╝ │
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │ 🔍  Search Quick Actions...                                     │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │ What would you like help with today?                            │   │
│  │                                                                 │   │
│  │ ┌─────────────────────────────────────────────────────────────┐ │   │
│  │ │ Example: Generate user stories for a customer portal with   │ │   │
│  │ │ self-service case management...                             │ │   │
│  │ │                                                              │ │   │
│  │ └─────────────────────────────────────────────────────────────┘ │   │
│  │ Describe your request in detail for better results.            │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
│  Quick Actions                                                          │
│                                                                         │
│  ┌───────────────┐  ┌───────────────┐  ┌───────────────┐              │
│  │   📋          │  │    ✓          │  │    ⬚          │              │
│  │ Generate User │  │  Generate     │  │ Review        │              │
│  │    Stories    │  │  Test Cases   │  │ Solution      │              │
│  │               │  │               │  │   Design      │              │
│  │ Create comp...│  │ Build detail..│  │ Analyze and...│              │
│  │               │  │               │  │               │              │
│  │  [Generate]   │  │  [Generate]   │  │  [Generate]   │              │
│  └───────────────┘  └───────────────┘  └───────────────┘              │
│                                                                         │
│  ┌───────────────┐  ┌───────────────┐  ┌───────────────┐              │
│  │   📊          │  │    ⚠          │  │    👥         │              │
│  │ Create        │  │  Generate     │  │  Customer     │              │
│  │ Executive     │  │  RAID Log     │  │  Meeting      │              │
│  │   Status      │  │               │  │    Prep       │              │
│  │ Generate exec.│  │ Create Risks..│  │ Prepare comp..│              │
│  │               │  │               │  │               │              │
│  │  [Generate]   │  │  [Generate]   │  │  [Generate]   │              │
│  └───────────────┘  └───────────────┘  └───────────────┘              │
│                                                                         │
│  ┌───────────────┐                                                      │
│  │   ✓           │                                                      │
│  │ Deployment    │                                                      │
│  │  Checklist    │                                                      │
│  │               │                                                      │
│  │ Generate det..│                                                      │
│  │               │                                                      │
│  │  [Generate]   │                                                      │
│  └───────────────┘                                                      │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

## Header Section (Detailed)

```
╔════════════════════════════════════════════════════════════════════════╗
║                                                                        ║
║  ┌──────┐                                                             ║
║  │  🔧  │  AI Delivery Copilot                                        ║
║  │      │  Accelerate your Salesforce delivery with AI-powered        ║
║  └──────┘  assistance                                                 ║
║                                                                        ║
║  Background: Blue Gradient (#0070d2 → #005fb2)                       ║
║  Icon: White background with blur effect                              ║
║  Text: White, bold, large                                             ║
║                                                                        ║
╚════════════════════════════════════════════════════════════════════════╝
```

## Search Box (Detailed)

```
┌────────────────────────────────────────────────────────────────────────┐
│                                                                        │
│  ┌──────────────────────────────────────────────────────────────────┐ │
│  │ 🔍  Search Quick Actions...                                    [x]│ │
│  └──────────────────────────────────────────────────────────────────┘ │
│                                                                        │
│  • White background                                                   │
│  • Rounded corners (12px)                                            │
│  • Shadow: 0 2px 8px rgba(0,0,0,0.08)                               │
│  • Full width                                                         │
│  • Magnifying glass icon                                             │
│                                                                        │
└────────────────────────────────────────────────────────────────────────┘
```

## Request Text Area (Detailed)

```
┌────────────────────────────────────────────────────────────────────────┐
│                                                                        │
│  What would you like help with today?                                 │
│                                                                        │
│  ┌──────────────────────────────────────────────────────────────────┐ │
│  │ Example: Generate user stories for a customer portal with        │ │
│  │ self-service case management...                                  │ │
│  │                                                                  │ │
│  │                                                                  │ │
│  └──────────────────────────────────────────────────────────────────┘ │
│                                                                        │
│  📝 Describe your request in detail for better results.              │
│                                                                        │
│  • White background card                                              │
│  • Large label (1.5rem, bold)                                        │
│  • 4 rows textarea                                                    │
│  • Blue focus border                                                  │
│  • Helper text below                                                  │
│                                                                        │
└────────────────────────────────────────────────────────────────────────┘
```

## Individual Action Card (Detailed)

```
┌────────────────────────────────────────┐
│                                        │
│  ┌──────┐                              │
│  │  📋  │                              │
│  └──────┘                              │
│                                        │
│  Generate User Stories                 │
│                                        │
│  Create comprehensive user stories     │
│  with acceptance criteria and story    │
│  points                                │
│                                        │
│  ┌──────────────────────────────────┐ │
│  │         [ Generate ]             │ │
│  └──────────────────────────────────┘ │
│                                        │
└────────────────────────────────────────┘

Card Specifications:
• Width: 1/3 on desktop, 1/2 on tablet, full on mobile
• Background: White
• Border radius: 12px
• Shadow: 0 2px 8px (default), 0 8px 24px (hover)
• Padding: 1.5rem
• Hover: Lifts up 4px, blue border appears
• Icon wrapper: 56×56px, gradient background
• Button: Full width, brand blue
```

## Quick Action Cards Grid Layout

### Desktop (3 columns)
```
┌────────────────┐  ┌────────────────┐  ┌────────────────┐
│ User Stories   │  │ Test Cases     │  │ Solution Design│
└────────────────┘  └────────────────┘  └────────────────┘

┌────────────────┐  ┌────────────────┐  ┌────────────────┐
│ Executive      │  │ RAID Log       │  │ Meeting Prep   │
└────────────────┘  └────────────────┘  └────────────────┘

┌────────────────┐
│ Deployment     │
└────────────────┘
```

### Tablet (2 columns)
```
┌────────────────┐  ┌────────────────┐
│ User Stories   │  │ Test Cases     │
└────────────────┘  └────────────────┘

┌────────────────┐  ┌────────────────┐
│ Solution Design│  │ Executive      │
└────────────────┘  └────────────────┘

┌────────────────┐  ┌────────────────┐
│ RAID Log       │  │ Meeting Prep   │
└────────────────┘  └────────────────┘

┌────────────────┐
│ Deployment     │
└────────────────┘
```

### Mobile (1 column)
```
┌────────────────────────────────┐
│ User Stories                   │
└────────────────────────────────┘
┌────────────────────────────────┐
│ Test Cases                     │
└────────────────────────────────┘
┌────────────────────────────────┐
│ Solution Design                │
└────────────────────────────────┘
┌────────────────────────────────┐
│ Executive                      │
└────────────────────────────────┘
┌────────────────────────────────┐
│ RAID Log                       │
└────────────────────────────────┘
┌────────────────────────────────┐
│ Meeting Prep                   │
└────────────────────────────────┘
┌────────────────────────────────┐
│ Deployment                     │
└────────────────────────────────┘
```

## Loading States

### Card Loading
```
┌────────────────────────────────────┐
│         ░░░░░░░░░░░░░░░            │
│         ░░░░░░░░░░░░░░            │
│         ░░  ⟳  ░░░░░░            │
│         ░░░░░░░░░░░░░░            │
│         ░░░░░░░░░░░░░░            │
└────────────────────────────────────┘

• Semi-transparent white overlay
• Small spinner centered
• Prevents interaction
• Appears on specific card only
```

### Global Loading
```
╔══════════════════════════════════════╗
║  ███████████████████████████████    ║
║  ███████████████████████████████    ║
║  ███████████████████████████████    ║
║  █████████                          ║
║  █████████     ⟳  ⟳  ⟳            ║
║  █████████                          ║
║  █████      Processing your         ║
║  █████        request...            ║
║  ███████████████████████████████    ║
║  ███████████████████████████████    ║
╚══════════════════════════════════════╝

• Full-screen dark overlay (70% opacity)
• Large spinner
• White text message
• Blocks all interaction
```

## Results Display

```
┌────────────────────────────────────────────────────────────────────┐
│ ✓ Generated Content                                       [Clear]  │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  ┌──────────────────────────────────────────────────────────────┐ │
│  │ Generate User Stories                                        │ │
│  │                                                              │ │
│  │ Generated on: 6/17/2026, 10:30:45 AM                       │ │
│  │                                                              │ │
│  │ Your Request: Generate user stories for customer portal...  │ │
│  │                                                              │ │
│  │ --- AI-Generated Content ---                                │ │
│  │                                                              │ │
│  │ 1. Best Practice Recommendation                             │ │
│  │    Consider implementing custom metadata types for          │ │
│  │    configuration management                                 │ │
│  │    Priority: high                                           │ │
│  │                                                              │ │
│  │ 2. Performance Optimization                                 │ │
│  │    Use platform caching to reduce API calls and improve     │ │
│  │    response time                                            │ │
│  │    Priority: medium                                         │ │
│  │                                                              │ │
│  └──────────────────────────────────────────────────────────────┘ │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘

• Appears with slide-in animation
• Monospace font for content
• Light gray background
• Blue left border
• Scrollable if long
• Clear button in header
```

## Icon Color Coding

```
📋 Generate User Stories      [GREEN]   ■ Success
✓  Generate Test Cases        [ORANGE]  ■ Warning
⬚  Review Solution Design     [BLUE]    ■ Default
📊 Create Executive Status    [RED]     ■ Error
⚠  Generate RAID Log          [ORANGE]  ■ Warning
👥 Customer Meeting Prep      [GREEN]   ■ Success
✓  Deployment Checklist       [BLUE]    ■ Default
```

## Hover Effects

### Card Hover Animation
```
Normal State:                 Hover State:
┌─────────────┐              ┌─────────────┐
│   Card      │              │   Card      │  ↑ 4px
│   Content   │    ───→      │   Content   │  
│             │              │             │
│  [Button]   │              │  [Button]   │
└─────────────┘              └═════════════┘
                              Blue border
                              Larger shadow
                              Icon rotates 5°
```

## Color Palette

```
╔════════════════════════════════════════════════════════════════╗
║  PRIMARY COLORS                                                ║
║  ■ #0070d2  Primary Blue (buttons, links)                     ║
║  ■ #005fb2  Primary Dark (gradient end)                       ║
║  ■ #f3f3f3  Background Gray                                   ║
║  ■ #ffffff  White (cards)                                     ║
╠════════════════════════════════════════════════════════════════╣
║  ICON COLORS                                                   ║
║  ■ #2e844a  Success Green                                     ║
║  ■ #fe9339  Warning Orange                                    ║
║  ■ #ea001e  Error Red                                         ║
║  ■ #0070d2  Default Blue                                      ║
╠════════════════════════════════════════════════════════════════╣
║  TEXT COLORS                                                   ║
║  ■ #080707  Heading Text                                      ║
║  ■ #706e6b  Body Text                                         ║
║  ■ #c9c9c9  Disabled/Light Text                              ║
╚════════════════════════════════════════════════════════════════╝
```

## Typography Scale

```
H1 - Header Title         1.75rem (28px)  Weight: 600
H2 - Request Label        1.5rem  (24px)  Weight: 600
H3 - Card Title          1.125rem (18px)  Weight: 600
Body - Regular           1rem    (16px)  Weight: 400
Small - Helper           0.875rem (14px)  Weight: 400
```

## Spacing System

```
┌─ 2rem ─┐
│        │ ← Header padding
└────────┘

┌─ 1.5rem ─┐
│          │ ← Card padding
└──────────┘

┌─ 1rem ─┐
│        │ ← Element margin
└────────┘

┌─ 12px ─┐
│        │ ← Border radius
└────────┘
```

## Animation Timings

```
Hover Effects:     0.3s cubic-bezier(0.4, 0, 0.2, 1)
Fade In:           0.3s ease
Slide In:          0.3s ease-out
Icon Rotation:     0.3s ease
Color Changes:     0.2s ease
```

## Accessibility Features

```
✓ Focus outlines (3px blue, 2px offset)
✓ ARIA labels on all interactive elements
✓ Keyboard navigation support
✓ High contrast ratios (WCAG AA compliant)
✓ Screen reader friendly
✓ Touch targets ≥ 44px × 44px
```

## Responsive Breakpoints

```
Desktop:  > 1024px   (3 columns, full features)
Tablet:   768-1024px (2 columns, compact header)
Mobile:   < 768px    (1 column, stacked layout)
```

## Print View

```
When printed:
• Header background removed
• Search box hidden
• Action buttons hidden
• Cards have simple borders
• Content optimized for paper
• Page breaks avoided within cards
```

---

## Component Hierarchy

```
aiDeliveryCopilot (root)
├── copilot-container
│   ├── copilot-header
│   │   ├── header-content
│   │   │   ├── header-title-section
│   │   │   │   ├── header-icon (lightning-icon)
│   │   │   │   └── header-text
│   │   │   │       ├── h1 (title)
│   │   │   │       └── p (subtitle)
│   ├── copilot-main-content
│   │   └── content-wrapper
│   │       ├── search-section
│   │       │   └── lightning-input (search)
│   │       ├── request-section
│   │       │   ├── label
│   │       │   ├── lightning-textarea
│   │       │   └── helper-text
│   │       ├── results-section (conditional)
│   │       │   └── lightning-card
│   │       │       └── generated-content
│   │       └── quick-actions-section
│   │           ├── h2 (section title)
│   │           └── slds-grid
│   │               └── action-card (×7)
│   │                   ├── action-card-header
│   │                   │   ├── action-icon-wrapper
│   │                   │   │   └── lightning-icon
│   │                   │   └── action-title
│   │                   ├── action-card-body
│   │                   │   └── action-description
│   │                   ├── action-card-footer
│   │                   │   └── lightning-button
│   │                   └── card-loading-overlay (conditional)
│   │                       └── lightning-spinner
│   └── global-loading-overlay (conditional)
│       └── loading-content
│           ├── lightning-spinner
│           └── loading-message
```

---

**Mockup Version**: 2.0.0  
**Created**: 2026-06-17  
**Status**: Design Complete - Ready for Implementation
