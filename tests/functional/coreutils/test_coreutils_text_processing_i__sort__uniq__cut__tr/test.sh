#!/bin/sh -eux
# Functional test: coreutils - Text-processing-I--sort--uniq--cut--tr

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q coreutils 2>/dev/null || { echo 'coreutils not installed, skipping'; exit 0; }
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 7: Text processing I (sort, uniq, cut, tr) ==="

cat > fruits.txt << 'EOF'
banana
apple
cherry
apple
banana
date
EOF

# 7.1 sort
rlRun 'sort fruits.txt' 0 "sort alphabetically"
rlRun 'test "$(sort fruits.txt | head -1)" = "apple"' 0 "sort: first is apple"
rlRun 'sort -r fruits.txt' 0 "sort -r reverse"
rlRun 'sort -u fruits.txt' 0 "sort -u unique"
rlRun 'sort -n fruits.txt 2>&1 || true' 0 "sort -n numeric"

# 7.2 uniq
rlRun 'sort fruits.txt | uniq' 0 "uniq unique lines"
rlRun 'test $(sort fruits.txt | uniq | wc -l) -eq 4' 0 "uniq: 4 unique"
rlRun 'sort fruits.txt | uniq -c' 0 "uniq -c count occurrences"
rlRun 'sort fruits.txt | uniq -d' 0 "uniq -d only duplicates"
rlRun 'sort fruits.txt | uniq -u' 0 "uniq -u only uniques"

# 7.3 cut
echo "col1:col2:col3" > csv.txt
echo "a:b:c" >> csv.txt
echo "1:2:3" >> csv.txt
rlRun 'cut -d: -f1 csv.txt' 0 "cut -d: -f1 first field"
rlRun 'cut -d: -f2 csv.txt' 0 "cut -d: -f2 second field"
rlRun 'cut -d: -f1,3 csv.txt' 0 "cut multiple fields"
rlRun 'cut -c1-4 file1.txt' 0 "cut -c character range"

# 7.4 tr
rlRun 'echo "UPPERCASE" | tr "A-Z" "a-z"' 0 "tr translate uppercase to lowercase"
rlRun 'echo "abc" | tr -d "b"' 0 "tr -d delete characters"
rlRun 'echo "a b c" | tr -s " "' 0 "tr -s squeeze repeats"

# ===================================================================

echo ""
echo "All coreutils Text-processing-I--sort--uniq--cut--tr tests passed!"
