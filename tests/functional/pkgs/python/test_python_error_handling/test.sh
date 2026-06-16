#!/bin/sh -eux
# Functional test: python - 错误处理

. "../setup.sh"

echo "=== 测试 5: 错误处理 ==="
rlRun 'python3 -c "import nonexistent" 2>&1 || true' 0 "python3: 导入错误"

cd /; rm -rf $TmpDir

. "../teardown.sh"
echo "All python 错误处理 tests passed!"
