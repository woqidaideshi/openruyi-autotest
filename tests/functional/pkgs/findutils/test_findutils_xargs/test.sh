#!/bin/sh -eux
# Functional test: findutils - xargs

. "../setup.sh"

echo "=== 测试 4: xargs ==="
echo -e "1\n2\n3" > nums.txt
rlRun 'cat nums.txt | xargs echo' 0 "xargs: 基本用法"
rlRun 'echo "test1 test2" | xargs -n1 echo' 0 "xargs -n1: 每次一个参数"

. "../teardown.sh"
echo "All findutils xargs tests passed!"
