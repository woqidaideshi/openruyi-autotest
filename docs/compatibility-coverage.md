# 兼容性测试覆盖详情

> 更新日期：2026-06-17
> 测试环境：openEuler RISC-V（10.20.237.192:12055）
> 共 10 个测试用例，基于 LTP open_posix_testsuite 验证 POSIX 标准兼容性

## 一览表

| 测试用例 | 接口数 | PASS | FAIL | SKIP | 状态 |
|---------|:---:|:---:|:---:|:---:|------|
| [pthread](#ltp_posix_pthread) | ~80 | 227 | 11 | 61 | ✅ |
| [semaphore](#ltp_posix_semaphore) | 8 | 26 | 7 | 0 | ✅ |
| [mqueue](#ltp_posix_mqueue) | 10 | 35 | 7 | 2 | ✅ |
| [signal](#ltp_posix_signal) | 22 | 43 | 0 | 21 | ✅ |
| [timer](#ltp_posix_timer) | 5 | 28 | 0 | 0 | ✅ |
| [mmap](#ltp_posix_mmap) | 8 | 40 | 4 | 0 | ✅ |
| [clocks](#ltp_posix_clocks) | 7 | 32 | 3 | 0 | ✅ |
| [sched](#ltp_posix_sched) | 8 | 23 | 11 | 0 | ⚠️ |
| [aio](#ltp_posix_aio) | 8 | 21 | 3 | 0 | ✅ |
| [filesystem](#ltp_posix_filesystem) | 16 | 23 | 1 | 0 | ✅ |
| **合计** | **~172** | **498** | **47** | **84** | |

## 测试原理

本兼容性测试基于 [LTP (Linux Test Project)](https://github.com/linux-test-project/ltp) 的 `open_posix_testsuite`，验证 openEuler RISC-V 系统对 POSIX 1003.1-2001 标准的兼容性。

### 测试方式

- **Shell 脚本测试** (`.sh`)：直接执行 LTP 中的测试脚本
- **C 源码测试** (`.c`)：使用 `gcc` 现场编译（链接 `lib/common.c` 测试框架）后执行

### 目录结构

```
tests/compatibility/ltp_posix/
├── main.fmf                    # 测试套件元数据
├── setup.sh                    # 环境准备（安装依赖、clone LTP）
├── teardown.sh                 # 环境清理
├── helper.sh                   # 公共辅助函数
├── test.sh                     # 主测试脚本
├── test_ltp_posix_pthread/     # pthread 测试
├── test_ltp_posix_semaphore/   # 信号量测试
├── test_ltp_posix_mqueue/      # 消息队列测试
├── test_ltp_posix_signal/      # 信号测试
├── test_ltp_posix_timer/       # 定时器测试
├── test_ltp_posix_mmap/        # 内存映射测试
├── test_ltp_posix_clocks/      # 时钟测试
├── test_ltp_posix_sched/       # 调度测试
├── test_ltp_posix_aio/         # 异步 I/O 测试
└── test_ltp_posix_filesystem/  # 文件系统测试
```

---

## 测试用例详情

### test_ltp_posix_pthread {#ltp_posix_pthread}

pthread 接口一致性测试，覆盖 ~80 个 pthread_* 接口。

**状态**: ✅ PASS=227 FAIL=11 SKIP=61

### test_ltp_posix_semaphore {#ltp_posix_semaphore}

信号量接口一致性测试，覆盖 8 个 sem_* 接口。

**状态**: ✅ PASS=26 FAIL=7 SKIP=0

### test_ltp_posix_mqueue {#ltp_posix_mqueue}

POSIX 消息队列接口一致性测试，覆盖 10 个 mq_* 接口。

**状态**: ✅ PASS=35 FAIL=7 SKIP=2

### test_ltp_posix_signal {#ltp_posix_signal}

信号接口一致性测试，覆盖 22 个 sig*、kill、raise 接口。

**状态**: ✅ PASS=43 FAIL=0 SKIP=21

### test_ltp_posix_timer {#ltp_posix_timer}

定时器接口一致性测试，覆盖 5 个 timer_* 接口。

**状态**: ✅ PASS=28 FAIL=0 SKIP=0

### test_ltp_posix_mmap {#ltp_posix_mmap}

内存映射接口一致性测试，覆盖 8 个接口。

**状态**: ✅ PASS=40 FAIL=4 SKIP=0

### test_ltp_posix_clocks {#ltp_posix_clocks}

时钟接口一致性测试，覆盖 7 个接口。

**状态**: ✅ PASS=32 FAIL=3 SKIP=0

### test_ltp_posix_sched {#ltp_posix_sched}

调度接口一致性测试，覆盖 8 个接口。

**状态**: ⚠️ PASS=23 FAIL=11 SKIP=0（部分调度操作需 root 权限）

### test_ltp_posix_aio {#ltp_posix_aio}

异步 I/O 接口一致性测试，覆盖 8 个接口。

**状态**: ✅ PASS=21 FAIL=3 SKIP=0

### test_ltp_posix_filesystem {#ltp_posix_filesystem}

文件系统及基础接口一致性测试，覆盖 16 个接口。

**状态**: ✅ PASS=23 FAIL=1 SKIP=0
