#!/usr/bin/env bash
# Ralph Loop Extension - Quick Test

echo "Testing Ralph Loop Extension for omp"
echo "===================================="
echo ""

# Test 1: Simple counter loop with condition
echo "Test 1: Counter loop with completion promise"
echo "This will count to 3 and output a completion promise"
echo ""

cat > /tmp/ralph-test-prompt.md << 'EOF'
Count the current iteration number. When you reach iteration 3, output <promise>COMPLETE</promise>.

In each iteration:
1. Read /tmp/ralph-counter.txt (or create it with 0 if it doesn't exist)
2. Increment the number by 1
3. Write the new number back to /tmp/ralph-counter.txt
4. Output the current count
5. If count is 3, output <promise>COMPLETE</promise>
EOF

# Initialize counter
echo "0" > /tmp/ralph-counter.txt

echo "Running: omp -e ~/.omp/extensions/ralph-loop.ts"
echo ""
echo 'You can test with:'
echo ''
echo 'omp -e ~/.omp/extensions/ralph-loop.ts "Use ralph_loop tool with these parameters: prompt=\"@/tmp/ralph-test-prompt.md\", agent=\"task\", maxIterations=5"'
echo ""

# Test 2: Condition command example
echo "Test 2: Condition-based loop"
echo "This will run until a file contains 'DONE'"
echo ""

cat > /tmp/ralph-condition-test.md << 'EOF'
Create or update /tmp/ralph-status.txt. 

If iteration is 1: write "STARTED"
If iteration is 2: write "IN_PROGRESS"  
If iteration is 3: write "DONE"

Check the file content after writing.
EOF

rm -f /tmp/ralph-status.txt

echo 'Test command:'
echo ''
echo 'omp -e ~/.omp/extensions/ralph-loop.ts "Use ralph_loop tool: prompt=\"@/tmp/ralph-condition-test.md\", conditionCommand=\"grep -q DONE /tmp/ralph-status.txt && echo true || echo false\", maxIterations=5"'
echo ""

# Test 3: Interactive controls
echo "Test 3: Interactive controls"
echo "Start an omp session and test ralph commands:"
echo ""
echo "1. Start session: omp -e ~/.omp/extensions/ralph-loop.ts"
echo "2. Run a long task with ralph_loop tool"
echo "3. While running, try:"
echo "   /ralph-status"
echo "   /ralph-steer Add more detail to the output"
echo "   /ralph-pause"
echo "   /ralph-resume"
echo "   /ralph-stop"
echo ""

echo "Documentation: ~/.omp/extensions/ralph-loop.md"
