# Automated DevDocs System

## Overview

This system automatically maintains development documentation (`tasks.md`, `context.md`) while Claude works, **without requiring manual slash commands or prompts**.

Inspired by the Reddit post "Claude Code is a Beast" by u/diet103.

---

## How It Works

### Three Automated Hooks

#### 1. **DevDocs Auto-Update** (Stop Event)
Runs **after every Claude response** to automatically:
- ✅ **Mark completed tasks** in `tasks.md` by detecting phrases like "implemented", "created", "fixed"
- 📝 **Capture object IDs** from new AL files (Tables, Pages, Codeunits, etc.)
- 📁 **Log modified files** to `context.md`
- ⏰ **Add timestamps** for tracking

**Example:**
```
Claude: "I've implemented the order import table and created the API codeunit."
Hook: [Automatically marks "Implement order import table" as [x] in tasks.md]
Hook: [Captures "Table 50100 'Order Import'" to context.md]
```

#### 2. **Context Monitor** (UserPromptSubmit Event)
Runs **before Claude sees your prompt** to:
- 📊 **Check context usage** percentage
- ⚠️ **Inject warnings** when context drops below 25%
- 🚨 **Critical alert** when context drops below 15%

**Example Output (at 18% remaining):**
```
⚠️ CRITICAL: Context at 18% remaining!

BEFORE continuing, update dev docs with current state:
1. Mark all completed tasks in tasks.md
2. Add key decisions and next steps to context.md
3. Note any pending issues or blockers

After compaction, resume with: "Continue from dev docs in .claude/active-tasks/order-import/"
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

#### 3. **AL Code Quality Check** (Stop Event)
Runs **after Claude edits AL files** to:
- ❌ **Detect deprecated** WITH statements
- ⚠️ **Check for missing** Caption/ToolTip properties
- 🔍 **Verify** ApplicationArea on pages
- 🔨 **Run AL compiler** if available

---

## Setup

### 1. Create Dev Docs Structure (One-Time)

For each new feature/task, create:
```bash
.claude/active-tasks/[feature-name]/
├── plan.md       # Your approved implementation plan
├── context.md    # Auto-populated with object IDs, decisions
└── tasks.md      # Auto-updated with completed tasks
```

**Example `tasks.md`:**
```markdown
## Tasks for Shopify Integration

### Implementation
- [ ] Create base tables (Order Header, Order Lines)
- [ ] Implement API client codeunit
- [ ] Add authentication logic
- [ ] Create import page

### Testing
- [ ] Unit tests for API client
- [ ] Integration tests for order import
- [ ] UI tests for import page

### Documentation
- [ ] Update user guide
- [ ] Add API documentation
```

**Example `context.md`:**
```markdown
## Shopify Integration Context

### Object IDs Used
- Table 50100 "Shopify Order Header"
- Table 50101 "Shopify Order Line"
- Page 50100 "Shopify Orders"
- Codeunit 50100 "Shopify API Client"

### Key Decisions
- Using OAuth 2.0 for authentication (more secure than API key)
- Storing orders in separate tables to avoid modifying base BC objects
- Implementing retry logic for API failures

### Next Steps
- Complete order line import logic
- Add error handling for API timeouts
- Write integration tests

### Blockers
- None currently
```

### 2. Enable Hooks

The hooks are automatically registered in `hooks/hooks.json` and will run:
- `devDocsAutoUpdate.js` - After every Claude response
- `contextMonitor.js` - Before every prompt (when context < 25%)
- `stopEvent.js` - After AL file edits

**No manual activation needed!**

---

## Workflow

### Starting a New Feature

1. **Plan the feature** (use planning mode or /al-plan command)
2. **Create dev docs structure:**
   ```bash
   mkdir -p .claude/active-tasks/shopify-integration
   # Copy approved plan to plan.md
   # Create empty context.md and tasks.md
   ```
3. **Start implementing** - The hooks handle the rest automatically!

### During Implementation

The system **automatically**:
- ✅ Marks tasks as completed when Claude implements them
- 📝 Captures object IDs from new AL files
- 📁 Logs file modifications
- ⚠️ Warns you when context is running low

**You don't need to do anything!**

### When Context Runs Low (< 15%)

The hook **automatically** injects this message to Claude:
```
⚠️ CRITICAL: Context at 12% remaining!

BEFORE continuing, update dev docs with current state...
```

Claude will then:
1. Review what was completed
2. Update `tasks.md` and `context.md`
3. Note next steps

**Then you compact** and start new session with:
```
"Continue from dev docs in .claude/active-tasks/shopify-integration/"
```

---

## What Gets Auto-Captured

### From AL Files:
- Table definitions with IDs
- Page definitions with IDs
- Codeunit definitions with IDs
- Enum definitions with IDs
- Extension objects (tableextension, pageextension)

### From Claude Responses:
- Completion phrases: "implemented", "created", "added", "fixed", "updated", "completed"
- Task descriptions matching those phrases
- Files modified during work

### Auto-Generated Timestamps:
- Every update to dev docs includes ISO timestamp
- Tracks when objects were created
- Tracks when tasks were completed

---

## Benefits

### 1. **Zero Manual Work**
- No slash commands to remember
- No "update the docs" prompts needed
- System runs in the background

### 2. **Never Lose Context**
- Context warnings before it's too late
- All progress automatically saved
- Easy resume after compaction

### 3. **Complete Audit Trail**
- Timestamps on all changes
- Object ID allocation history
- Task completion tracking

### 4. **Prevents Scope Creep**
- Tasks.md keeps Claude focused
- Context.md reminds of decisions
- Plan.md is the source of truth

### 5. **Better Code Quality**
- Auto-checks for AL best practices
- Catches missing properties immediately
- Prevents deprecated features

---

## Advanced: Customization

### Adjust Context Thresholds

Edit `hooks/hooks.json`:
```json
{
  "settings": {
    "contextWarningThreshold": 25,  // Warning at 25% remaining
    "contextCriticalThreshold": 15  // Critical at 15% remaining
  }
}
```

### Disable Specific Hooks

Edit `hooks/hooks.json`:
```json
{
  "hooks": [
    {
      "name": "DevDocs Auto-Update",
      "enabled": false  // Disable this hook
    }
  ]
}
```

### Add Custom Patterns

Edit `hooks/src/devDocsAutoUpdate.js` to capture additional patterns:
```javascript
function extractTaskCompletions(conversationText) {
  const patterns = [
    /(?:implemented|created|added|fixed|updated|completed)\s+([^.\n]+)/gi,
    // Add your custom pattern here:
    /(?:finished|done with)\s+([^.\n]+)/gi,
  ];
  // ...
}
```

---

## Troubleshooting

### Hook Not Running

1. Check `hooks/hooks.json` - ensure `"enabled": true`
2. Check hook script path is correct
3. Check console for error messages

### Tasks Not Auto-Updating

- Ensure `tasks.md` exists in active task folder
- Check that task descriptions match Claude's completion phrases
- Review `hooks/src/devDocsAutoUpdate.js` patterns

### Context Warning Not Showing

- Context usage info may not be available in all Claude Code versions
- Hook only triggers when context < 25%
- Check console for hook execution logs

### Multiple Active Tasks

The system picks the **most recently modified** task folder in `.claude/active-tasks/`. To work on a specific task, ensure it's the most recent.

---

## Comparison: Manual vs. Automated

### Before (Manual)

```
You: "Implement the order import feature"
Claude: [Implements feature]
You: "Update the dev docs"
Claude: [Updates tasks.md and context.md]
You: "How much context do we have left?"
Claude: "About 15%"
You: "Update dev docs with current state before compaction"
Claude: [Updates docs]
You: [Compact conversation]
You: "Continue from dev docs in active-tasks/order-import"
```

### After (Automated)

```
You: "Implement the order import feature"
Claude: [Implements feature]
Hook: [Automatically updates tasks.md and context.md]
Hook: [Detects context at 18%, injects warning]
Claude: "⚠️ Context running low. I've updated the dev docs. Current state:..."
You: [Compact conversation]
You: "Continue from dev docs in active-tasks/order-import"
```

**Saves 3-4 prompts per feature!**

---

## Files

```
hooks/
├── hooks.json                      # Hook registration
├── src/
│   ├── devDocsAutoUpdate.js       # Auto-updates tasks.md and context.md
│   ├── contextMonitor.js          # Warns when context is low
│   └── stopEvent.js               # AL code quality checks
├── config/
│   └── skill-rules.json           # Skill auto-activation rules
└── README_AUTO_DEVDOCS.md         # This file
```

---

## Credits

Inspired by u/diet103's Reddit post: **"Claude Code is a Beast – Tips from 6 Months of Hardcore Use"**

Key concepts adapted:
- DevDocs three-file system (plan.md, context.md, tasks.md)
- Automatic skill activation via hooks
- Context threshold monitoring
- Progressive disclosure for managing context

Original post: https://github.com/diet103/claude-code-infrastructure-showcase

---

## Next Steps

1. ✅ Hooks are created and configured
2. 📝 Create your first dev docs structure for a feature
3. 🚀 Start implementing - watch the automation work!
4. 📊 Review auto-generated updates in tasks.md and context.md
5. 🔧 Customize thresholds and patterns as needed

**The system is ready to use!**
