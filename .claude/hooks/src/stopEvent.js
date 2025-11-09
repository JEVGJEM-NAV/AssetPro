// .claude/hooks/src/stopEvent.js
const fs = require('fs');
const path = require('path');
const { exec } = require('child_process');
const { promisify } = require('util');

const execAsync = promisify(exec);

async function stopEvent(editedFiles) {
  const alFiles = editedFiles.filter(f => f.endsWith('.al'));

  if (alFiles.length === 0) return;

  console.log(`
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 AL CODE QUALITY CHECK
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Checking ${alFiles.length} AL file(s)...
`);

  const issues = [];

  for (const file of alFiles) {
    const content = fs.readFileSync(file, 'utf-8');

    // Check for WITH statements
    if (/\bwith\s+\w+\s+do\b/i.test(content)) {
      issues.push(`❌ ${path.basename(file)}: Contains deprecated WITH statement`);
    }

    // Check for missing Caption/ToolTip
    const fieldMatches = content.match(/field\([^)]+\)\s*{[^}]*}/g) || [];
    for (const fieldBlock of fieldMatches) {
      if (!fieldBlock.includes('Caption')) {
        issues.push(`⚠️ ${path.basename(file)}: Field missing Caption property`);
      }
      if (!fieldBlock.includes('ToolTip') && fieldBlock.includes('Page')) {
        issues.push(`⚠️ ${path.basename(file)}: Page field missing ToolTip`);
      }
    }

    // Check for missing ApplicationArea
    if (content.includes('page ') && !content.includes('ApplicationArea')) {
      issues.push(`⚠️ ${path.basename(file)}: Page missing ApplicationArea`);
    }
  }

  // Try to run AL compiler
  try {
    const projectPath = path.dirname(alFiles[0]);
    const { stdout, stderr } = await execAsync(
      `alc /project:"${projectPath}" /packagecachepath:".alpackages"`,
      { cwd: projectPath }
    );

    if (stderr) {
      console.log('❌ Compilation Errors Found:');
      console.log(stderr);
      console.log('\n💡 Please fix these errors before continuing.');
    } else {
      console.log('✅ AL Compilation Successful');
    }
  } catch (error) {
    // AL compiler not available, skip
  }

  if (issues.length > 0) {
    console.log('\n⚠️ Quality Issues Detected:');
    issues.forEach(issue => console.log(issue));
    console.log('\n💡 Self-Check Questions:');
    console.log('   • Are all UI elements properly captioned?');
    console.log('   • Did you avoid deprecated features?');
    console.log('   • Are test scenarios comprehensive?');
  } else {
    console.log('✅ All quality checks passed');
  }

  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
}

module.exports = { stopEvent };
