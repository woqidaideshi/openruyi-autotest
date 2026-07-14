# unittests - 测试框架质量单元测试

本目录包含针对测试框架本身的单元测试，确保后续对测试用例的修改符合规范。

## 运行方式

```bash
# 运行所有单元测试
python -m unittest discover -s unittests -p "test_*.py" -v

# 运行单个测试文件
python -m unittest unittests.test_tests_quality -v
```

## 测试用例说明

| 用例 | 描述 |
|------|------|
| `test_no_chinese` | 检查 tests/ 目录下所有文件不含中文字符 |
| `test_no_mojibake` | 检查 tests/ 目录下所有文件无乱码 |
| `test_sh_tmt_compliance` | 检查 tests/ 目录下所有 .sh 文件符合 tmt 测试框架规范 |
| `test_sh_executable` | 检查 tests/ 目录下所有 .sh 文件具有可执行权限 |
