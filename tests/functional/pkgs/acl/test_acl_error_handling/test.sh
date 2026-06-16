#!/bin/sh -eux
# Functional test: acl - 错误处理

. "../setup.sh"

echo "=== 测试 10: 错误处理 ==="

# 测试 10.1: 对不存在的文件操作
rlRun 'getfacl nonexistent_file' 1-255 "测试对不存在文件 getfacl 报错"
rlRun 'setfacl -m u:root:rwx nonexistent_file' 1-255 "测试对不存在文件 setfacl 报错"

# 测试 10.2: 无效的 ACL 规则
rlRun 'setfacl -m u:root:xyz testfile' 1-255 "测试无效权限字符报错"
rlRun 'setfacl -m x:root:rw testfile' 1-255 "测试无效类型报错"

# 测试 10.3: 权限不足
rlRun 'su -c "setfacl -m u:root:rwx /root/test" openruyi 2>&1' 1-255 "测试权限不足报错"

. "../teardown.sh"
echo "All acl 错误处理 tests passed!"
