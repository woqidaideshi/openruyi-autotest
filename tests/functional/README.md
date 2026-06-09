# 功能测试 - 软件包测试

本目录包含各个软件包的功能测试用例。

## 目录结构

```
tests/functional/
├── main.fmf              # 共享配置（所有子目录继承）
├── README.md             # 本文件
├── acl/                  # acl 软件包测试
│   ├── main.fmf         # acl 测试元数据
│   └── test.sh          # acl 测试脚本
├── coreutils/           # coreutils 软件包测试（示例）
│   ├── main.fmf
│   └── test.sh
└── ...                  # 更多软件包测试
```

## 添加新软件包测试

### 1. 创建软件包目录

```bash
mkdir -p tests/functional/<package_name>
```

### 2. 创建元数据文件 (main.fmf)

```yaml
summary: 功能测试 - <package_name> 软件包功能验证
test: ./test.sh
tag:
  - functional
  - <package_name>
duration: 5m
tier: 1
path: /tests/functional/<package_name>
require:
  - <package_name>
  - <其他依赖>
```

### 3. 创建测试脚本 (test.sh)

参考 `.trellis/tasks/06-09-acl/package-test-guide.md` 中的编写指南。

### 4. 验证测试

在服务器上运行测试：

```bash
tmt run plan --name /plans/functional test --name /tests/functional/<package_name>
```

## 命名规范

- 软件包目录名使用小写，与软件包名称一致
- 多个单词使用连字符分隔（如 `net-tools`）
- 测试脚本统一命名为 `test.sh`
- 元数据文件统一命名为 `main.fmf`

## 测试覆盖进度

| 软件包 | 状态 | 测试用例数 | 备注 |
|--------|------|-----------|------|
| acl | ✅ 完成 | 27+ | 首个示例软件包 |
| ... | 待添加 | - | - |

## 参考文档

- 软件包测试编写指南：`.trellis/tasks/06-09-acl/package-test-guide.md`
- tmt 官方文档：https://tmt.readthedocs.io/
