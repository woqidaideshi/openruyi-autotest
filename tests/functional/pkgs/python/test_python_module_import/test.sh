#!/bin/sh -eux
# Functional test: python - 模块导入

. "../setup.sh"

echo "=== 测试 4: 模块导入 ==="
rlRun 'python3 -c "import json, math, re, hashlib"' 0 "python3: 导入标准模块"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All python 模块导入 tests passed!"
