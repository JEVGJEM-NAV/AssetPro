// hooks/src/devDocsAutoUpdate.js
// Automatically updates dev docs (tasks.md, context.md) during development

const fs = require('fs');
const path = require('path');

/**
 * Finds the active task folder in .claude/active-tasks/
 */
function findActiveTaskFolder() {
  const activeTasksPath = path.join(process.cwd(), '.claude', 'active-tasks');

  if (!fs.existsSync(activeTasksPath)) {
    return null;
  }

  const taskFolders = fs.readdirSync(activeTasksPath)
    .filter(f => fs.statSync(path.join(activeTasksPath, f)).isDirectory());

  if (taskFolders.length === 0) {
    return null;
  }

  // Return the most recently modified folder
  const folders = taskFolders.map(f => ({
    name: f,
    path: path.join(activeTasksPath, f),
    mtime: fs.statSync(path.join(activeTasksPath, f)).mtime
  }));

  folders.sort((a, b) => b.mtime - a.mtime);
  return folders[0].path;
}

/**
 * Extracts object IDs from AL files
 */
function extractObjectIds(content) {
  const ids = [];

  // Match: table 50100 "Name"
  const tableMatch = content.match(/table\s+(\d+)\s+"([^"]+)"/i);
  if (tableMatch) ids.push(`Table ${tableMatch[1]} "${tableMatch[2]}"`);

  // Match: page 50100 "Name"
  const pageMatch = content.match(/page\s+(\d+)\s+"([^"]+)"/i);
  if (pageMatch) ids.push(`Page ${pageMatch[1]} "${pageMatch[2]}"`);

  // Match: codeunit 50100 "Name"
  const codeunitMatch = content.match(/codeunit\s+(\d+)\s+"([^"]+)"/i);
  if (codeunitMatch) ids.push(`Codeunit ${codeunitMatch[1]} "${codeunitMatch[2]}"`);

  // Match: enum 50100 "Name"
  const enumMatch = content.match(/enum\s+(\d+)\s+"([^"]+)"/i);
  if (enumMatch) ids.push(`Enum ${enumMatch[1]} "${enumMatch[2]}"`);

  // Match: tableextension 50100 "Name" extends "Base"
  const tableExtMatch = content.match(/tableextension\s+(\d+)\s+"([^"]+)"\s+extends\s+"([^"]+)"/i);
  if (tableExtMatch) ids.push(`TableExtension ${tableExtMatch[1]} "${tableExtMatch[2]}" extends "${tableExtMatch[3]}"`);

  // Match: pageextension 50100 "Name" extends "Base"
  const pageExtMatch = content.match(/pageextension\s+(\d+)\s+"([^"]+)"\s+extends\s+"([^"]+)"/i);
  if (pageExtMatch) ids.push(`PageExtension ${pageExtMatch[1]} "${pageExtMatch[2]}" extends "${pageExtMatch[3]}"`);

  return ids;
}

/**
 * Extracts potential task completions from Claude's response
 */
function extractTaskCompletions(conversationText) {
  const completions = [];

  // Look for completion indicators
  const patterns = [
    /(?:implemented|created|added|fixed|updated|completed)\s+([^.\n]+)/gi,
    /(?:successfully|now)\s+(?:implemented|created|added|fixed|updated)\s+([^.\n]+)/gi,
  ];

  for (const pattern of patterns) {
    let match;
    while ((match = pattern.exec(conversationText)) !== null) {
      completions.push(match[1].trim());
    }
  }

  return completions;
}

/**
 * Updates tasks.md with completed items
 */
function updateTasksFile(taskFolder, completions) {
  const tasksPath = path.join(taskFolder, 'tasks.md');

  if (!fs.existsSync(tasksPath)) {
    return;
  }

  let content = fs.readFileSync(tasksPath, 'utf-8');
  let updated = false;

  // Try to match completions with pending tasks
  for (const completion of completions) {
    const lines = content.split('\n');

    for (let i = 0; i < lines.length; i++) {
      const line = lines[i];

      // Check if line is a pending task that matches completion
      if (line.includes('[ ]') &&
          (line.toLowerCase().includes(completion.toLowerCase().substring(0, 20)) ||
           completion.toLowerCase().includes(line.substring(line.indexOf('[ ]') + 4, line.indexOf('[ ]') + 24).trim().toLowerCase()))) {
        lines[i] = line.replace('[ ]', '[x]');
        updated = true;
      }
    }

    if (updated) {
      content = lines.join('\n');
    }
  }

  if (updated) {
    // Add timestamp
    const timestamp = new Date().toISOString();
    content += `\n\n_Last auto-updated: ${timestamp}_`;

    fs.writeFileSync(tasksPath, content, 'utf-8');
    console.log(`✅ Auto-updated tasks.md with completed items`);
  }
}

/**
 * Updates context.md with new object IDs and decisions
 */
function updateContextFile(taskFolder, objectIds, editedFiles) {
  const contextPath = path.join(taskFolder, 'context.md');

  if (!fs.existsSync(contextPath)) {
    return;
  }

  let updates = [];

  // Add object IDs if not already present
  if (objectIds.length > 0) {
    let contextContent = fs.readFileSync(contextPath, 'utf-8');

    for (const id of objectIds) {
      if (!contextContent.includes(id)) {
        updates.push(`- ${id}`);
      }
    }
  }

  if (updates.length > 0) {
    const timestamp = new Date().toISOString();
    const newSection = `\n\n## Auto-Captured Context (${timestamp})\n\n**Object IDs:**\n${updates.join('\n')}\n\n**Files Modified:**\n${editedFiles.map(f => `- ${path.basename(f)}`).join('\n')}`;

    fs.appendFileSync(contextPath, newSection, 'utf-8');
    console.log(`✅ Auto-updated context.md with ${updates.length} new object(s)`);
  }
}

/**
 * Stop event hook - runs after Claude finishes responding
 */
async function stopEvent(params) {
  const { editedFiles = [], conversationText = '' } = params;

  // Find active task folder
  const taskFolder = findActiveTaskFolder();
  if (!taskFolder) {
    return; // No active task, skip
  }

  console.log(`\n📝 DevDocs Auto-Update Active`);

  // Extract object IDs from AL files
  const alFiles = editedFiles.filter(f => f.endsWith('.al'));
  const objectIds = [];

  for (const file of alFiles) {
    if (fs.existsSync(file)) {
      const content = fs.readFileSync(file, 'utf-8');
      objectIds.push(...extractObjectIds(content));
    }
  }

  // Extract potential task completions
  const completions = extractTaskCompletions(conversationText || '');

  // Update files
  if (completions.length > 0) {
    updateTasksFile(taskFolder, completions);
  }

  if (objectIds.length > 0 || editedFiles.length > 0) {
    updateContextFile(taskFolder, objectIds, editedFiles);
  }

  // Log summary
  if (objectIds.length > 0 || completions.length > 0) {
    console.log(`   Objects captured: ${objectIds.length}`);
    console.log(`   Tasks updated: ${completions.length}`);
    console.log(`   📁 Location: ${path.basename(taskFolder)}/`);
  }
}

module.exports = { stopEvent };
