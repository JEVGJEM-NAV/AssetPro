# Hooks Changelog

## 2025-11-01 - Skill Auto-Activation Fix

### Problem
Skills were not being automatically loaded even though the infrastructure was in place:
- `userPromptSubmit.js` existed but wasn't registered in `hooks.json`
- Claude wasn't receiving skill activation instructions
- `al-development-core` skill needed to be always loaded for BC development

### Changes Made

#### 1. Registered Skill Auto-Activation Hook
**File:** `hooks.json`
- Added "Skill Auto-Activation" hook to the hooks array
- Event: `userPromptSubmit`
- Script: `src/userPromptSubmit.js`
- Placed first in the array to run before Context Monitor

#### 2. Modified Skill Activation Logic
**File:** `hooks/src/userPromptSubmit.js`
- **ALWAYS loads `al-development-core` skill** as the base skill for all BC development
- Other skills load conditionally based on prompt keywords/patterns
- Changed activation message to be more explicit with instructions to load skills

**Old behavior:**
- Only loaded skills if keywords matched
- Passive reminder message

**New behavior:**
- `al-development-core` always loaded first
- Explicit instruction to load and use skills
- Clear separation between skill activation and user request

#### 3. Activation Message Format
```
🎯 REQUIRED SKILLS - Load and follow these skills:
  📚 AL Development Guidelines Active - Following BC standards
  [other activated skills...]

INSTRUCTION: Before proceeding, load the following skills: al-development-core, [others...]
Use the Skill tool to invoke each skill if not already loaded.

USER REQUEST:
[user's actual prompt]
```

### Testing

To verify the hooks are working:

1. Navigate to a project with the hooks symlink:
   ```bash
   cd C:\GIT\JEMEL\JML_AssetPro
   ```

2. Start a new Claude session and enter any prompt:
   ```
   create a new table
   ```

3. Expected result: You should see the skill activation message with `al-development-core` always included

### Configuration

The skill activation rules are defined in `hooks/config/skill-rules.json`:
- `al-development-core`: Now always loaded (critical priority)
- `al-testing-specialist`: Loads when testing keywords detected
- `al-symbols-navigator`: Loads when extending base objects
- `al-build-workflow`: Loads when build/deploy keywords detected
- `bc-troubleshooter`: Loads when error/problem keywords detected

### Files Modified
- `hooks/hooks.json` - Added hook registration
- `hooks/src/userPromptSubmit.js` - Always load core skill + explicit instructions
- `hooks/CHANGELOG.md` - This file
