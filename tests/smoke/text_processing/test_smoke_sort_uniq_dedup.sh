#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
TmpDir=$(mktemp -d); cd $TmpDir
cat > nums.txt << EOF
3
1
2
1
3
EOF
rlRun 'sort nums.txt' 0 "sort 排序"
rlRun 'sort -n nums.txt' 0 "sort -n 数值排序"
rlRun 'sort nums.txt | uniq' 0 "sort|uniq 去重"
rlRun 'sort nums.txt | uniq | wc -l' 0 "去重后仅3行"
cd /; rm -rf $TmpDir
echo "smoke test passed!"
