#!/bin/sh -eux
# Functional test: acl - getfacl-基本功能

. "../setup.sh"

echo "=== 测试 1: getfacl 基本功能 ==="

# 测试 1.1: 查看文件默认 ACL
rlRun 'getfacl testfile' 0 "查看文件默认 ACL"

# 测试 1.2: 查看目录默认 ACL  
rlRun 'getfacl testdir' 0 "查看目录默认 ACL"

# 测试 1.3: 使用 -a 参数只显示 access ACL
rlRun 'getfacl -a testfile' 0 "使用 -a 参数查看 access ACL"

# 测试 1.4: 使用 -d 参数只显示 default ACL
rlRun 'getfacl -d testfile' 0 "使用 -d 参数查看 default ACL"

# 测试 1.5: 使用 -c 参数不显示注释头
rlRun 'getfacl -c testfile' 0 "使用 -c 参数不显示注释头"

# 测试 1.6: 使用 -n 参数显示数字用户/组 ID
rlRun 'getfacl -n testfile' 0 "使用 -n 参数显示数字 ID"

# 测试 1.7: 使用 -t 参数使用表格输出格式
rlRun 'getfacl -t testfile' 0 "使用 -t 参数表格输出"

. "../teardown.sh"
echo "All acl getfacl-基本功能 tests passed!"
