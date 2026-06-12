#!/bin/sh -eux
# Functional test: coreutils - Text-processing-II--paste--comm--join--fmt--fold--

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q coreutils 2>/dev/null || { echo 'coreutils not installed, skipping'; exit 0; }
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 8: Text processing II (paste, comm, join, fmt, fold, pr, expand, unexpand) ==="

# 8.1 paste
echo "a" > paste1.txt; echo "b" >> paste1.txt
echo "1" > paste2.txt; echo "2" >> paste2.txt
rlRun 'paste paste1.txt paste2.txt' 0 "paste merge files side by side"
rlRun 'paste -d: paste1.txt paste2.txt' 0 "paste -d: custom delimiter"
rlRun 'paste -s paste1.txt paste2.txt' 0 "paste -s serial"

# 8.2 comm
echo "a" > comm1.txt; echo "b" >> comm1.txt; echo "c" >> comm1.txt
echo "b" > comm2.txt; echo "c" >> comm2.txt; echo "d" >> comm2.txt
rlRun 'comm comm1.txt comm2.txt' 0 "comm compare sorted files"

# 8.3 join
echo "1 a" > join1.txt; echo "2 b" >> join1.txt
echo "1 x" > join2.txt; echo "3 z" >> join2.txt
rlRun 'join join1.txt join2.txt' 0 "join files on common field"

# 8.4 fmt
rlRun 'echo "This is a long line that should be reformatted by fmt to a reasonable width" | fmt' 0 "fmt reformat text"
rlRun 'echo "short" | fmt -w 10' 0 "fmt -w set width"

# 8.5 fold
rlRun 'echo "1234567890" | fold -w 3' 0 "fold -w wrap at width"

# 8.6 pr
rlRun 'pr lines.txt' 0 "pr paginate file"
rlRun 'pr -n lines.txt' 0 "pr -n number lines"

# 8.7 expand / unexpand
rlRun 'printf "a\tb\n" | expand' 0 "expand tabs to spaces"
rlRun 'printf "a    b\n" | unexpand -a' 0 "unexpand -a spaces to tabs"

# ===================================================================

echo ""
echo "All coreutils Text-processing-II--paste--comm--join--fmt--fold-- tests passed!"
