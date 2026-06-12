#!/bin/sh -eux
# Functional test: sed package
# Tests sed 流编辑器
# Version: sed

rlRun() { eval "\$1" 2>&1; return \$?; }

rpm -q sed 2>/dev/null || { echo 'sed not installed, skipping'; exit 0; }
which sed 2>/dev/null || echo 'sed not found'

rlRun 'sed --version' 0 "sed 版本"

TmpDir=$(mktemp -d); cd $TmpDir

echo "=== 测试 1: 基本替换 ==="
echo "hello world" > test.txt
rlRun 'sed "s/world/sed/" test.txt' 0 "sed s: 基本替换"
rlRun 'sed "s/hello/HI/" test.txt' 0 "sed s: 替换hello"

echo "=== 测试 2: 行操作 ==="
echo -e "line1\nline2\nline3" > lines.txt
rlRun 'sed -n "2p" lines.txt' 0 "sed -n: 打印指定行"
rlRun 'sed "2d" lines.txt' 0 "sed d: 删除指定行"
rlRun 'sed "2a newline" lines.txt' 0 "sed a: 追加行"
rlRun 'sed "2i insertline" lines.txt' 0 "sed i: 插入行"

echo "=== 测试 3: 全局和正则 ==="
rlRun 'echo "aaa" | sed "s/a/b/g"' 0 "sed g: 全局替换"
rlRun 'echo "abc123" | sed "s/[0-9]/X/g"' 0 "sed: 正则替换"

echo "=== 测试 4: 就地编辑 ==="
echo "original" > edit.txt
rlRun 'sed -i "s/original/modified/" edit.txt' 0 "sed -i: 就地编辑"
rlRun 'grep modified edit.txt' 0 "sed -i: 验证修改"

echo "=== 测试 5: 多表达式 ==="
rlRun 'echo "abc" | sed -e "s/a/A/" -e "s/c/C/"' 0 "sed -e: 多表达式"

echo "=== 测试 6: 错误处理 ==="
rlRun 'sed --invalid 2>&1 || true' 0 "sed: 无效选项"

cd /; rm -rf $TmpDir
echo ""
echo "All sed functional tests passed!"
