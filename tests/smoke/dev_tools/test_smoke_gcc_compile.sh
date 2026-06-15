#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'which gcc' 0 "gcc 可用"
TmpDir=$(mktemp -d); cd $TmpDir
cat > hello.c << 'EOF'
#include <stdio.h>
int main() { printf("smoke test"); return 0; }
EOF
rlRun 'gcc hello.c -o hello' 0 "gcc 编译"
rlRun './hello' 0 "编译结果可执行"
cd /; rm -rf $TmpDir
echo "smoke test passed!"
