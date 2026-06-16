# 功能测试 - 软件包测试

本目录包含各个软件包的功能测试用例，采用 ACL 子目录结构标准。

## 测试覆盖概览

- **202 个软件包**，**561 个测试用例**，**1,692 个功能点**
- 所有测试脚本均已在 openEuler RISC-V 服务器上验证通过
- 详见 [功能测试覆盖详情](../../docs/functional-coverage.md)

## 目录结构

```
tests/functional/
├── main.fmf                  # 共享配置（所有子目录继承）
├── README.md                 # 本文件
└── pkgs/                     # RPM 软件包功能测试
    ├── main.fmf              # 共享配置
    ├── acl/                  # acl 软件包测试（参考标准）
    │   ├── main.fmf
    │   ├── test.sh
    │   └── test_acl_*/       # 子测试目录
    ├── attr/                 # attr 软件包测试
    │   ├── main.fmf
    │   ├── test.sh
    │   └── test_attr_*/      # 子测试目录
    └── ...                   # 更多软件包测试
```

## 测试结构规范（参照 ACL）

每个软件包测试目录包含：
- `main.fmf` — 包级元数据配置
- `test.sh` — 包级主测试脚本
- `test_<pkg>_<feature>/` — 按功能点拆分的子测试目录
  - `main.fmf` — 子测试元数据
  - `test.sh` — 子测试脚本

## 添加新软件包测试

1. 创建目录 `tests/functional/pkgs/<package_name>/`
2. 创建 `main.fmf`（参照 `pkgs/acl/main.fmf`）
3. 创建 `test.sh`（参照模板）
4. 按功能点创建子测试目录

## 运行测试

```bash
tmt run plan --name /plans/functional test --name /tests/functional/<package_name>
```
- 元数据文件统一命名为 `main.fmf`

## 测试覆盖进度

| 软件包 | 状态 | 测试用例数 | 备注 |
|--------|------|-----------|------|
| acl | ✅ 完成 | 27+ | 首个示例软件包 |
| ... | 待添加 | - | - |

## 参考文档

- 软件包测试编写指南：`.trellis/tasks/06-09-acl/package-test-guide.md`
- tmt 官方文档：https://tmt.readthedocs.io/
