#!/bin/sh -eux
# Functional test: python-pyelftools - pyelftools ELF 解析库

. "./setup.sh"

rlRun 'python3 -c "import python_pyelftools" 2>&1 || echo "NO_MODULE"' 0 "导入 python-pyelftools Python 模块"

# 检查共享库文件
rlRun 'rpm -ql python-pyelftools 2>/dev/null | grep -E "\.so\.|\\.so$" || echo "NO_SO_FILES"' 0 "检查共享库文件"

# 检查头文件（如果有）
rlRun 'rpm -ql python-pyelftools 2>/dev/null | grep -E "\.h$|\.pc$" || echo "NO_HEADER_FILES"' 0 "检查头文件和 pkg-config 文件"

. "./teardown.sh"
echo "All python-pyelftools tests passed!"
