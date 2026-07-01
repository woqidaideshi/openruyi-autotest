# openruyi-autotest

openruyi-autotest 是基于 [tmt (Test Management Tool)](https://tmt.readthedocs.io/) 框架的自动化测试项目，使用 [BeakerLib](https://github.com/beakerlib/beakerlib) 编写测试脚本，通过 [FMF](https://fmf.readthedocs.io/) 管理元数据。涵盖冒烟测试、功能测试、安全测试、兼容性测试、性能测试、可靠性测试和特性测试七大类，共 637 个测试套、3391 个测试用例（其中功能测试 235 套 / 2989 用例：202 个 RPM 包 + 32 个 LTP 模块 + 16 个 kernel；性能测试 8 套 / 60 用例：UnixBench + MMTests）。

---

## 一、openruyi-autotest 简介

### 1.1 目录结构

```
openruyi-autotest/
├── .fmf/                        # FMF 元数据根目录
│   └── version
├── plans/                       # 测试计划
│   ├── smoke.fmf                 # 冒烟测试计划
│   ├── functional.fmf            # 功能测试计划
│   ├── security.fmf              # 安全测试计划
│   ├── compatibility.fmf         # 兼容性测试计划
│   ├── performance.fmf           # 性能测试计划
│   ├── reliability.fmf           # 可靠性测试计划
│   ├── feature.fmf               # 特性测试计划
│   └── all.fmf                   # 全量测试计划
├── tests/                       # 测试用例
│   ├── main.fmf                  # 全局共享配置
│   ├── smoke/                    # 冒烟测试（100 个用例）
│   ├── functional/               # 功能测试
│   │   ├── kernel/               # 内核功能测试
│   │   │   └── realtime/         #   实时性测试（16 个用例）
│   │   ├── ltp/                  # LTP 功能测试套件（32 个子模块, 2407 个用例）
│   │   └── pkgs/                 # RPM 软件包功能测试（202 个包, 566 个用例）
│   ├── security/                 # 安全测试（106 个用例）
│   │   ├── cve/                  # CVE 漏洞测试（98 个用例, LTP 20260529）
│   │   └── nmap/                 # 网络扫描测试（8 个用例）
│   ├── compatibility/            # 兼容性测试（188 个用例）
│   ├── performance/              # 性能测试
│   │   ├── mmtests/              #   MMTests 基准测试（53 个用例）
│   │   └── unixbench/            #   UnixBench 基准测试
│   ├── feature/                  # 特性测试
│   └── reliability/              # 可靠性测试
├── docs/                        # 文档
└── README.md
```

### 1.2 测试覆盖详情

| 分类 | 代表性软件包 | 覆盖要点 |
|------|--------|---------|
| **编译工具** | gcc, g++ (gxx), clang, cmake, make, binutils, autoconf, automake, bison, flex, meson, ninja | C/C++ 编译、链接、优化选项、标准支持 |
| **系统管理** | systemd, systemd-timesyncd, dbus, dbus-broker, chkconfig, kmod, util-linux | 服务管理、日志查询、性能分析、时间同步 |
| **文件/文本工具** | coreutils, tar, grep, sed, gawk, diffutils, findutils, file, gzip, xz, zstd, bzip2, lz4, unzip, cpio, dos2unix | 文件操作、归档、搜索、文本处理 |
| **安全/加密** | openssl, gnutls, libgcrypt, nettle, libtasn1, p11-kit, cryptsetup, pam, libselinux, libseccomp, audit, keyutils, krb5 | 加密算法、TLS、ACL、审计、认证 |
| **网络工具** | iputils, curl, wget, wget2, iproute2, iptables, libpcap, libnl, nghttp2, libssh, libidn2, libpsl | 网络诊断、文件下载、流量控制 |
| **容器/虚拟化** | podman, podmansh | 镜像管理、容器运行、网络配置 |
| **SSH 工具** | openssh, openssh-clients | 密钥生成、SSH 连接、scp/sftp |
| **版本控制** | git | 仓库初始化、分支操作、远程管理 |
| **脚本/编程语言** | python, perl, lua, tcl, bash, tcsh, expect, swig | 解释器、模块、脚本执行 |
| **库/运行时** | glibc, glib, libffi, libxml2, libxslt, libpng, pcre2, expat, icu4c, libarchive, boost, json-c, sqlite, popt, readline, slang, newt, gmp, mpfr, mpc, mpdecimal, isl, libunistring, libxcrypt, libeconf, libcap, libaio, libbpf, libedit, libevent, libmnl, libnfnetlink, libnetfilter_conntrack, libnftnl, libpwquality, libtirpc, libsodium, nghttp2, libmicrohttpd, xxhash, jitterentropy, libgpg-error, libpsl, publicsuffix-list, iso-codes, brotli, lz4, zstd | 动态库验证、头文件、pkg-config |
| **构建/打包工具** | rpmbuild, rpm, pkgconf, debugedit, dwz, chrpath, patch, pyproject-rpm-macros, python-rpm-macros, python-srpm-macros, python-rpm-generators, perl-rpm-packaging, rpm-config-openruyi, setup, filesystem, config | RPM 包构建、调试信息、宏配置 |
| **显示/桌面** | sddm, weston, labwc, groff, texinfo, help2man, scdoc, xmlto, source-highlight | 显示管理器、Wayland 合成器、文档生成 |
| **测试框架** | atf, cmocka, dejagnu, kyua, lutok, beakerlib | 测试库、测试框架 |
| **其他系统工具** | tmux, cloud-utils-growpart, procps-ng, psmisc, vim, less, bc, time, which, ed, fdupes, lzip, rsync, nfs-utils, cracklib, e2fsprogs, gdb, gdbm, gpm, kbd, lvm2, ncurses, nss, nss_wrapper, pam_wrapper, socket_wrapper, uid_wrapper, perl-Error, perl-Locale-gettext, systemtap, tzdata, unbound, ca-certificates, ca-certificates-mozilla, openruyi-release, linux-headers, pciutils, attr, acl, bash-completion, authselect, cpio, cryptsetup, dbus, dbus-broker, diffutils, elfutils, file, findutils, gawk, git, nghttp2, python-flit-core, python-lxml, python-packaging, python-pip, python-pyelftools, python-setuptools, python-wheel, re2c, scdoc, source-highlight, swig, uid_wrapper, xmlto, xxhash | 终端复用、分区扩容、进程管理、编辑器、时间日期 |

### 1.3 用例运行状态统计

| 测试类型 | 测试套数 | 用例数 | 状态 |
|---------|:---:|:---:|:---:|
| Smoke | 100 | 100 | ✅ 全部通过 |
| Functional | 235 | 2989 | ✅ 全部通过 (566 pkgs + 2407 LTP + 16 kernel) |
| Security | 106 | 106 | ✅ 全部通过 (98 CVE + 8 nmap) |
| Compatibility | 188 | 188 | ✅ 通过 (LTP POSIX) |
| Performance | 8 | 60 | ✅ 已执行 (UnixBench + mmtests) |
| Reliability | 1 | 1 | ✅ 通过 |
| Feature | 0 | 0 | 🆕 |
| **合计** | **637** | **3391** | |

详情文档：
- [冒烟测试覆盖详情](docs/coverage/smoke-coverage.md)
- [功能测试覆盖详情](docs/coverage/functional-coverage.md)
- [安全测试覆盖详情](docs/coverage/security-coverage.md)
- [兼容性测试覆盖详情](docs/coverage/compatibility-coverage.md)
- [性能测试覆盖详情](docs/coverage/unixbench_results.md)

---

## 二、openruyi-autotest 用户指南

参见 [用户指南](docs/user_guide.md) — 涵盖从克隆仓库、安装依赖到执行单个用例、测试套、测试类型全量用例以及全部测试的完整步骤。

---

## 三、openruyi-autotest 开发指南

参见 [开发指南](docs/development-guide.md) — 涵盖如何添加新测试用例、目录约定、BeakerLib 生命周期、FMF 元数据规范以及命名规范。

---

## 四、openruyi-autotest 测试报告模版

参见 [测试报告模版](docs/test_reports.md) — 涵盖测试概述、各类型测试的套数/用例数/通过/失败/跳过统计表格。
