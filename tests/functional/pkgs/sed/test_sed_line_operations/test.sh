#!/bin/sh -eux
# Functional test: sed - 行操作

. "../setup.sh"

echo "=== 测试 2: 行操作 ==="
echo -e "line1\nline2\nline3" > lines.txt
rlRun 'sed -n "2p" lines.txt' 0 "sed -n: 打印指定行"
rlRun 'sed "2d" lines.txt' 0 "sed d: 删除指定行"
rlRun 'sed "2a newline" lines.txt' 0 "sed a: 追加行"
rlRun 'sed "2i insertline" lines.txt' 0 "sed i: 插入行"

. "../teardown.sh"
echo "All sed 行操作 tests passed!"
