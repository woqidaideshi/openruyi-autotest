# openruyi-autotest

基于 BeakerLib 的自动化测试框架。

## 目录结构

```
openruyi-autotest/
├── .fmf/                        # FMF 元数据根目录（必须提交到 Git）
│   └── version                  # FMF 版本号
├── plans/                       # 测试计划
│   ├── smoke.fmf                 # 冒烟测试计划
│   ├── functional.fmf            # 功能测试计划
│   ├── security.fmf              # 安全测试计划
│   ├── compatibility.fmf         # 兼容性测试计划
│   ├── performance.fmf           # 性能测试计划
│   ├── reliability.fmf           # 可靠性测试计划
│   ├── integration.fmf           # 集成测试计划
│   └── all.fmf                   # 全量测试计划
├── tests/                       # 测试用例
│   ├── main.fmf                  # 共享配置（子目录自动继承）
│   ├── smoke/                    # 冒烟测试
│   ├── functional/               # 功能测试
│   │   ├── main.fmf               # 共享配置
│   │   ├── README.md
│   │   └── pkgs/                  # RPM 软件包功能测试（202 个包）
│   ├── security/                 # 安全测试
│   ├── compatibility/            # 兼容性测试
│   ├── performance/              # 性能测试
│   └── reliability/              # 可靠性测试
├── stories/                     # 用户故事
│   └── init.fmf
└── README.md
```

## 测试覆盖

### 全量用例统计

| 测试类型 | 测试套数 | 用例数 | 状态 |
|---------|:---:|:---:|:---:|
| Smoke | 100 | 100 | ✅ 全部通过 |
| Functional | 202 | 566 | ✅ 全部通过 |
| Security | 106 | 106 | ✅ 全部通过 (CVE + nmap) |
| Compatibility | 188 | 188 | ✅ 通过 (LTP POSIX) |
| Performance | 7 | 7 | ✅ 已执行 (UnixBench) |
| Reliability | 1 | 1 | ✅ 通过 |
| **合计** | **604** | **968** | |

### 详情文档

- [冒烟测试覆盖详情](docs/smoke-coverage.md) — 100 个用例
- [功能测试覆盖详情](docs/functional-coverage.md) — 202 个软件包，566 个用例，1,692 个功能点
- [安全测试覆盖详情](docs/security-coverage.md) — CVE + nmap 套件，106 个用例
- [兼容性测试覆盖详情](docs/compatibility-coverage.md) — LTP POSIX 套件，188 个接口用例
- [性能测试覆盖详情](docs/unixbench_results.md) — UnixBench 基准测试，7 个场景

### 主要覆盖分类

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

## 如何执行测试

参见 [执行测试脚本指南](docs/manual-execution.md) — 涵盖从克隆仓库到执行单个用例、测试套、某一类测试以及全部测试的完整步骤。
