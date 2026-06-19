# RAID AI Integration - Quick Start Guide

## ⚡ Quick Summary
RAID Log Generator now supports **real AI** via Claude or Gemini APIs with automatic fallback to mock data.

---

## 🚀 Files Created/Modified

### New Files (4)
- `RAIDAnalysisService.cls` - Main AI service
- `RAIDAnalysisServiceTest.cls` - Test coverage
- `RAIDAnalysisService.cls-meta.xml` - Metadata
- `RAIDAnalysisServiceTest.cls-meta.xml` - Test metadata

### Modified Files (2)
- `aiRaidGenerator.js` - Calls Apex instead of mock
- `aiRaidGenerator.html` - Shows AI provider badge

---

## 🔧 Named Credential Setup (Choose One)

### Option A: Claude AI
```
Setup → Named Credentials → External Credentials
  → New: Claude_AI_Credential
  → Principal: ApiKey = YOUR_ANTHROPIC_API_KEY
  → Get key: https://console.anthropic.com/

Setup → Named Credentials → Named Credentials (Legacy)
  → New: Claude_AI_API
  → URL: https://api.anthropic.com

Setup → Remote Site Settings
  → New: Anthropic_API (https://api.anthropic.com)
```

### Option B: Google Gemini
```
Setup → Named Credentials → External Credentials
  → New: Gemini_AI_Credential
  → Principal: ApiKey = YOUR_GOOGLE_AI_API_KEY
  → Get key: https://makersuite.google.com/app/apikey

Setup → Named Credentials → Named Credentials (Legacy)
  → New: Gemini_AI_API
  → URL: https://generativelanguage.googleapis.com

Setup → Remote Site Settings
  → New: Google_Gemini_API
```

---

## 📊 How It Works

```
User Input → LWC → Apex → Check Named Credential
                            ↓
                    Claude/Gemini/Mock
                            ↓
                      Parse JSON
                            ↓
                     Display with Badge
```

**Provider Priority:**
1. Claude (if configured)
2. Gemini (if configured)
3. Mock (always available)

---

## ✅ Testing

### Before Setup
- Badge shows: **"Mock (Fallback)"**
- Toast: "Using mock data - configure Named Credential"

### After Setup
- Badge shows: **"Claude"** or **"Gemini"**
- Toast: "Powered by Claude/Gemini"
- Results contextually match your input

---

## 💰 Costs

| Provider | Cost/Request | Quality | Speed |
|----------|--------------|---------|-------|
| Claude   | $0.01-$0.05  | ⭐⭐⭐⭐⭐ | 3-5s  |
| Gemini   | $0.001-$0.005| ⭐⭐⭐⭐   | 2-4s  |
| Mock     | Free         | ⭐⭐⭐    | 0s    |

---

## 🐛 Troubleshooting

**"Unauthorized endpoint"**
→ Add Remote Site Setting

**Named Credential not detected**
→ Check DeveloperName exactly matches `Claude_AI_API` or `Gemini_AI_API`

**Timeout errors**
→ Check API key validity and API status

**Still seeing Mock**
→ Verify Named Credential is Active and Principal is configured

---

## 📝 Git Commit Message

```
feat: integrate real AI (Claude/Gemini) for RAID Log Generator

- Add RAIDAnalysisService.cls with Claude and Gemini API integration
- Add comprehensive test coverage with HttpCalloutMock
- Update aiRaidGenerator LWC to call Apex service instead of mock
- Add AI provider badge display in UI (Claude/Gemini/Mock)
- Implement graceful fallback to mock data if AI unavailable
- Support Named Credentials for secure API key management

Breaking Changes: None - mock fallback ensures backward compatibility

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```

---

## 📚 Full Documentation

See `RAID_AI_INTEGRATION_SETUP.md` for complete details.

---

## 🎯 Next Steps

1. ✓ Code complete (no commit yet)
2. → Configure Named Credential (your choice: Claude or Gemini)
3. → Deploy files to Salesforce org
4. → Run tests
5. → Test with real meeting notes
6. → Monitor costs and adjust

**Status:** ✅ Ready for deployment (not committed yet as requested)
