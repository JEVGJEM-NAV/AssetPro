#!/usr/bin/env node
// hooks/src/contextMonitor.js
// NOTE: Context monitoring not available in Claude Code native hooks
// This is a pass-through placeholder for future enhancement

/**
 * Process prompt - currently just passes through
 * Context usage info is not available in Claude Code hooks
 */
async function processPrompt(prompt) {
  // TODO: Context monitoring requires Claude Code API access
  // For now, just pass through the prompt unchanged
  return prompt;
}

// Main execution: Read from stdin, process, write to stdout
if (require.main === module) {
  let inputData = '';

  process.stdin.on('data', (chunk) => {
    inputData += chunk;
  });

  process.stdin.on('end', async () => {
    try {
      const modifiedPrompt = await processPrompt(inputData.trim());
      process.stdout.write(modifiedPrompt);
      process.exit(0);
    } catch (error) {
      console.error('Hook error:', error.message);
      process.stdout.write(inputData); // Pass through original on error
      process.exit(0);
    }
  });
}
