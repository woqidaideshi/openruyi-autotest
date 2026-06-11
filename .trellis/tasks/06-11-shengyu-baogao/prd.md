# 为17个软件包生成功能测试脚本

## Goal

为 openRuyi（riscv64）平台上的 17 个软件包生成完整的功能测试脚本，要求命令/参数全覆盖，功能点全覆盖，经服务器验证后提交。

## 软件包清单

1. tmux
2. systemd
3. systemd-timesyncd
4. openssh
5. g++
6. clang
7. sddm
8. weston
9. labwc
10. podman
11. vim
12. git
13. openssh-clients
14. dnf5-plugins
15. make
16. cmake
17. cloud-utils-growpart

## 测试模式

- 框架：shell (tmt / FMF)
- 脚本风格：`#!/bin/sh -eux`，`rlRun()` wrapper
- 每个包独立目录：`tests/functional/<package>/`
- 每个目录包含 `main.fmf` + `test.sh`
- 参考现有：coreutils、wget、gcc、cmake

## 目标服务器

- IP: 10.20.237.192:12055
- OS: openRuyi Creek / riscv64
- 用户: openruyi / sudo openruyi

## 执行策略

逐包生成+验证：每个包先到服务器研究命令 → 生成脚本 → 上传验证 → 通过后下一个

## 验收标准

- [ ] 17 个包全部生成 `main.fmf` + `test.sh`
- [ ] 每个脚本在服务器上运行通过
- [ ] 全量测试一次性跑过（`tmt run` 或批量执行）
- [ ] 代码提交到远端并创建 MR

## 出界范围

- 不处理已存在的包（coreutils, gcc, cmake, wget 等）
- 非功能测试类型（性能/安全等）不在此范围