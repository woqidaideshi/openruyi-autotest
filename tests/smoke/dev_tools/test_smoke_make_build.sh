#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'make --version' 0 "make 版本"
TmpDir=$(mktemp -d); cd $TmpDir
cat > Makefile << 'EOF'
hello: hello.c
	$(CC) -o hello hello.c
EOF
echo 'int main(){return 0;}' > hello.c
rlRun 'make CC=gcc hello' 0 "make 构建"
rlRun 'test -f hello' 0 "make 输出存在"
cd /; rm -rf $TmpDir
echo "smoke test passed!"
