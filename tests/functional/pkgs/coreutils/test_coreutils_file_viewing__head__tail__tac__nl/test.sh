#!/bin/sh -eux
# Functional test: coreutils - File-viewing--head--tail--tac--nl

. "../setup.sh"

echo "=== Test 5: File viewing (head, tail, tac, nl) ==="

for i in $(seq 1 20); do
    echo "line $i" >> lines.txt
done

# 5.1 head
rlRun 'head -n 5 lines.txt' 0 "head -n 5: first 5 lines"
rlRun 'test $(head -n 3 lines.txt | wc -l) -eq 3' 0 "head -n 3: verify count"
rlRun 'head -c 10 lines.txt' 0 "head -c 10: first 10 bytes"

# 5.2 tail
rlRun 'tail -n 5 lines.txt' 0 "tail -n 5: last 5 lines"
rlRun 'test $(tail -n 3 lines.txt | wc -l) -eq 3' 0 "tail -n 3: verify count"
rlRun 'test $(tail -n +18 lines.txt | wc -l) -eq 3' 0 "tail -n +18: from line 18"
rlRun 'tail -c 10 lines.txt' 0 "tail -c 10: last 10 bytes"

# 5.3 tac (reverse cat)
rlRun 'tac lines.txt' 0 "tac reverse lines"
rlRun 'test "$(head -1 lines.txt)" = "$(tac lines.txt | tail -1)"' 0 "tac: first becomes last"

# 5.4 nl (number lines)
rlRun 'nl lines.txt' 0 "nl number lines"

# ===================================================================

. "../teardown.sh"
echo "All coreutils File-viewing--head--tail--tac--nl tests passed!"
