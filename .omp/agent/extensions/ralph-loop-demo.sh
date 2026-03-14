#!/usr/bin/env bash
# Ralph Loop Extension - Quick Demo

set -e

echo "🔄 Ralph Loop Extension - Demo"
echo "================================"
echo ""

# Create a simple demo prompt
DEMO_PROMPT="/tmp/ralph-demo-$(date +%s).md"

cat > "$DEMO_PROMPT" << 'EOF'
# Ralph Loop Demo Task

Create a simple counter demonstration:

1. Create a file at /tmp/ralph-demo-counter.txt
2. Read the current count (or start at 0 if file doesn't exist)
3. Increment by 1
4. Write the new count to the file
5. Report the current count

When the count reaches 3, output: <promise>COUNTING_COMPLETE</promise>

Note: Keep output brief - just report the count and whether you're done.
EOF

echo "Demo prompt created at: $DEMO_PROMPT"
echo ""
echo "Running ralph loop with omp..."
echo ""

# Clean up old counter if exists
rm -f /tmp/ralph-demo-counter.txt

# Run omp with ralph loop extension
omp -e ~/.omp/extensions/ralph-loop.ts --print \
  "Use the ralph_loop tool with these exact parameters:
  
  prompt: \"$(cat "$DEMO_PROMPT")\"
  agent: \"task\"
  maxIterations: 5
  sleepMs: 1000"

echo ""
echo "================================"
echo "Demo complete!"
echo ""

# Show final counter value
if [ -f /tmp/ralph-demo-counter.txt ]; then
  echo "Final counter value: $(cat /tmp/ralph-demo-counter.txt)"
else
  echo "Counter file not created"
fi

# Cleanup
rm -f "$DEMO_PROMPT"
echo ""
echo "Cleanup done."
