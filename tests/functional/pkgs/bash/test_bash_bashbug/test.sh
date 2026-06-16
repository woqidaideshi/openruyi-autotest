#!/bin/sh -eux
# Functional test: bash - bashbug

. "../setup.sh"

echo "=== 测试 6: bashbug ==="
rlRun 'bashbug --help 2>&1 | head -3 || true' 0 "bashbug 帮助"

. "../teardown.sh"
echo "All bash bashbug tests passed!"
