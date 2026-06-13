# 功能测试覆盖详情

> 最后更新: 2026-06-13 | 自动生成
> 测试环境: openEuler (10.20.237.192)

共 **147** 个软件包，**476** 个测试用例，**1499** 个功能点

## 全部软件包一览

| 软件包 | 用例数 | 功能点 | 类型 |
|--------|:---:|:---:|:---:|
| [acl](#acl) | 10 | 81 | rlRun |
| [attr](#attr) | 1 | 6 | rlRun |
| [audit](#audit) | 2 | 15 | rlRun |
| [authselect](#authselect) | 1 | 1 | rlRun |
| [bash](#bash) | 7 | 7 | rlRun |
| [bash-completion](#bashcompletion) | 1 | 1 | rlRun |
| [bc](#bc) | 1 | 2 | rlRun |
| [beakerlib](#beakerlib) | 1 | 1 | 简单 |
| [binutils](#binutils) | 1 | 1 | 简单 |
| [brotli](#brotli) | 1 | 1 | rlRun |
| [bzip2](#bzip2) | 1 | 1 | rlRun |
| [ca-certificates](#cacertificates) | 2 | 3 | rlRun |
| [ca-certificates-mozilla](#cacertificatesmozilla) | 1 | 2 | rlRun |
| [chkconfig](#chkconfig) | 1 | 1 | rlRun |
| [clang](#clang) | 15 | 25 | rlRun |
| [cloud-utils-growpart](#cloudutilsgrowpart) | 6 | 10 | rlRun |
| [cmake](#cmake) | 6 | 6 | 分段 |
| [coreutils](#coreutils) | 24 | 234 | rlRun |
| [cpio](#cpio) | 1 | 1 | rlRun |
| [cracklib](#cracklib) | 1 | 1 | 简单 |
| [cryptsetup](#cryptsetup) | 2 | 3 | rlRun |
| [curl](#curl) | 6 | 11 | rlRun |
| [dbus](#dbus) | 1 | 1 | rlRun |
| [dbus-broker](#dbusbroker) | 1 | 1 | rlRun |
| [debugedit](#debugedit) | 2 | 5 | rlRun |
| [diffutils](#diffutils) | 1 | 4 | rlRun |
| [dnf5-plugins](#dnf5plugins) | 10 | 11 | rlRun |
| [dwz](#dwz) | 2 | 3 | rlRun |
| [e2fsprogs](#e2fsprogs) | 1 | 1 | 简单 |
| [elfutils](#elfutils) | 2 | 31 | rlRun |
| [expat](#expat) | 1 | 1 | rlRun |
| [file](#file) | 1 | 1 | rlRun |
| [filesystem](#filesystem) | 1 | 2 | rlRun |
| [findutils](#findutils) | 5 | 13 | rlRun |
| [gawk](#gawk) | 1 | 2 | rlRun |
| [gcc](#gcc) | 12 | 52 | rlRun |
| [gcc16](#gcc16) | 1 | 1 | 简单 |
| [git](#git) | 1 | 1 | rlRun |
| [glib](#glib) | 1 | 1 | 简单 |
| [glibc](#glibc) | 2 | 17 | rlRun |
| [gmp](#gmp) | 1 | 2 | rlRun |
| [gnutls](#gnutls) | 1 | 1 | 简单 |
| [grep](#grep) | 13 | 44 | rlRun |
| [gzip](#gzip) | 2 | 29 | rlRun |
| [icu4c](#icu4c) | 1 | 1 | 简单 |
| [iproute2](#iproute2) | 1 | 1 | 简单 |
| [iputils](#iputils) | 10 | 33 | 分段 |
| [isl](#isl) | 1 | 2 | rlRun |
| [iso-codes](#isocodes) | 1 | 1 | rlRun |
| [jitterentropy](#jitterentropy) | 1 | 2 | rlRun |
| [json-c](#jsonc) | 1 | 2 | rlRun |
| [kbd](#kbd) | 1 | 1 | 简单 |
| [keyutils](#keyutils) | 1 | 1 | 简单 |
| [kmod](#kmod) | 1 | 1 | 简单 |
| [krb5](#krb5) | 1 | 1 | 简单 |
| [labwc](#labwc) | 9 | 10 | rlRun |
| [less](#less) | 1 | 3 | rlRun |
| [libaio](#libaio) | 1 | 2 | rlRun |
| [libarchive](#libarchive) | 1 | 2 | rlRun |
| [libbpf](#libbpf) | 1 | 2 | rlRun |
| [libcap](#libcap) | 1 | 2 | rlRun |
| [libcap-ng](#libcapng) | 1 | 2 | rlRun |
| [libeconf](#libeconf) | 1 | 2 | rlRun |
| [libedit](#libedit) | 1 | 2 | rlRun |
| [libevent](#libevent) | 1 | 2 | rlRun |
| [libffi](#libffi) | 1 | 2 | rlRun |
| [libgcrypt](#libgcrypt) | 1 | 2 | rlRun |
| [libgpg-error](#libgpgerror) | 1 | 2 | rlRun |
| [libidn2](#libidn2) | 1 | 1 | rlRun |
| [libmnl](#libmnl) | 1 | 2 | rlRun |
| [libnetfilter_conntrack](#libnetfilter_conntrack) | 1 | 2 | rlRun |
| [libnfnetlink](#libnfnetlink) | 1 | 2 | rlRun |
| [libnftnl](#libnftnl) | 1 | 2 | rlRun |
| [libnl](#libnl) | 1 | 2 | rlRun |
| [libpng](#libpng) | 1 | 1 | rlRun |
| [libpsl](#libpsl) | 1 | 2 | rlRun |
| [libpwquality](#libpwquality) | 1 | 2 | rlRun |
| [libseccomp](#libseccomp) | 1 | 2 | rlRun |
| [libselinux](#libselinux) | 1 | 2 | rlRun |
| [libsepol](#libsepol) | 1 | 2 | rlRun |
| [libtasn1](#libtasn1) | 1 | 3 | rlRun |
| [libtirpc](#libtirpc) | 1 | 2 | rlRun |
| [libunistring](#libunistring) | 1 | 2 | rlRun |
| [libxcrypt](#libxcrypt) | 1 | 2 | rlRun |
| [libxml2](#libxml2) | 1 | 2 | rlRun |
| [libxslt](#libxslt) | 1 | 1 | rlRun |
| [linux-headers](#linuxheaders) | 1 | 2 | rlRun |
| [lua](#lua) | 2 | 5 | rlRun |
| [lvm2](#lvm2) | 1 | 1 | 简单 |
| [lz4](#lz4) | 1 | 4 | rlRun |
| [make](#make) | 9 | 21 | rlRun |
| [mpc](#mpc) | 1 | 2 | rlRun |
| [mpdecimal](#mpdecimal) | 1 | 2 | rlRun |
| [mpfr](#mpfr) | 1 | 2 | rlRun |
| [ncurses](#ncurses) | 1 | 1 | 简单 |
| [nettle](#nettle) | 2 | 11 | rlRun |
| [newt](#newt) | 2 | 3 | rlRun |
| [nghttp2](#nghttp2) | 1 | 2 | rlRun |
| [openruyi-release](#openruyirelease) | 1 | 1 | rlRun |
| [openssh](#openssh) | 1 | 1 | rlRun |
| [openssh-clients](#opensshclients) | 7 | 19 | rlRun |
| [openssl](#openssl) | 1 | 1 | rlRun |
| [p11-kit](#p11kit) | 1 | 1 | 简单 |
| [pam](#pam) | 2 | 11 | rlRun |
| [patch](#patch) | 1 | 1 | rlRun |
| [pciutils](#pciutils) | 13 | 13 | 分段 |
| [pcre2](#pcre2) | 1 | 2 | rlRun |
| [perl](#perl) | 1 | 1 | rlRun |
| [pkgconf](#pkgconf) | 2 | 5 | rlRun |
| [podman](#podman) | 7 | 16 | rlRun |
| [podmansh](#podmansh) | 11 | 11 | 分段 |
| [popt](#popt) | 1 | 2 | rlRun |
| [procps-ng](#procpsng) | 14 | 53 | 分段 |
| [psmisc](#psmisc) | 13 | 22 | 分段 |
| [publicsuffix-list](#publicsuffixlist) | 1 | 1 | rlRun |
| [pyproject-rpm-macros](#pyprojectrpmmacros) | 1 | 1 | rlRun |
| [python](#python) | 5 | 8 | rlRun |
| [python-lxml](#pythonlxml) | 1 | 2 | rlRun |
| [python-packaging](#pythonpackaging) | 1 | 1 | rlRun |
| [python-pip](#pythonpip) | 1 | 1 | rlRun |
| [python-rpm-macros](#pythonrpmmacros) | 1 | 1 | rlRun |
| [python-srpm-macros](#pythonsrpmmacros) | 1 | 1 | rlRun |
| [readline](#readline) | 1 | 2 | rlRun |
| [rpm](#rpm) | 1 | 1 | rlRun |
| [rpm-config-openruyi](#rpmconfigopenruyi) | 1 | 2 | rlRun |
| [rpmbuild](#rpmbuild) | 9 | 20 | 分段 |
| [sddm](#sddm) | 5 | 10 | rlRun |
| [sed](#sed) | 6 | 12 | rlRun |
| [setup](#setup) | 1 | 1 | rlRun |
| [slang](#slang) | 1 | 1 | rlRun |
| [sqlite](#sqlite) | 1 | 2 | rlRun |
| [systemd](#systemd) | 36 | 114 | rlRun |
| [systemd-timesyncd](#systemdtimesyncd) | 5 | 13 | rlRun |
| [tar](#tar) | 10 | 27 | 分段 |
| [tcsh](#tcsh) | 1 | 1 | rlRun |
| [time](#time) | 1 | 1 | rlRun |
| [tmux](#tmux) | 22 | 179 | rlRun |
| [tzdata](#tzdata) | 1 | 3 | rlRun |
| [unzip](#unzip) | 1 | 4 | rlRun |
| [util-linux](#utillinux) | 2 | 31 | rlRun |
| [vim](#vim) | 1 | 1 | rlRun |
| [weston](#weston) | 9 | 9 | rlRun |
| [wget](#wget) | 15 | 18 | 分段 |
| [wget2](#wget2) | 15 | 17 | 分段 |
| [which](#which) | 1 | 1 | rlRun |
| [xz](#xz) | 2 | 31 | rlRun |
| [zstd](#zstd) | 2 | 13 | rlRun |

---

## acl

<details>
<summary><b>acl — 10 个用例 / 81 个功能点</b></summary>

#### 测试 1: getfacl 基本功能

- 查看文件默认 ACL
- 查看目录默认 ACL
- 使用 -a 参数查看 access ACL
- 使用 -d 参数查看 default ACL
- 使用 -c 参数不显示注释头
- 使用 -n 参数显示数字 ID
- 使用 -t 参数表格输出

#### 测试 2: setfacl 基本功能

- 设置用户 root 的 rwx 权限
- 验证 ACL 设置
- 设置组 root 的 r-x 权限
- 验证 ACL 设置
- 设置 other 的只读权限
- 验证 ACL 设置
- 设置 mask 为 rwx
- 验证 mask 设置
- 使用 -n 参数不重新计算 mask
- 验证 ACL 设置

#### 测试 3: setfacl 高级功能

- 为目录设置 default user ACL
- 验证 default ACL 设置
- 为目录设置 default group ACL
- 验证 default group ACL
- 为目录设置 default mask
- 验证 default mask
- 为目录设置 default other
- 验证 default other
- 使用 --set 替换整个 ACL
- 验证 ACL 替换
- 创建 ACL 规则文件
- 从文件读取并应用 ACL
- 验证从文件应用的 ACL

#### 测试 4: setfacl 删除功能

- 删除用户 root 的 ACL 条目
- 验证 ACL 删除
- 删除组 root 的 ACL 条目
- 验证 ACL 删除
- 删除所有扩展 ACL
- 验证所有扩展 ACL 已删除
- 删除目录的 default ACL
- 验证 default ACL 已删除
- 创建删除规则文件
- 先添加用户 ACL
- 从文件读取并删除 ACL
- 验证从文件删除的 ACL

#### 测试 5: setfacl 递归功能

- 创建多层子目录
- 创建测试文件
- 递归设置 user ACL
- 验证递归设置 - file1
- 验证递归设置 - file2
- 递归删除所有扩展 ACL
- 验证递归删除 - file1
- 验证递归删除 - file2

#### 测试 6: setfacl 符号链接处理

- 创建符号链接
- 使用 -L 跟随符号链接设置 ACL
- 验证符号链接目标文件的 ACL
- 使用 -P 不跟随符号链接

#### 测试 7: chacl 命令功能

- 先清理 ACL
- 使用 chacl 查看 ACL
- 使用 chacl 设置基本 ACL
- 验证 chacl 设置的 ACL
- 使用 chacl 设置 default ACL
- 验证 chacl 设置的 default ACL
- 使用 chacl 递归设置 ACL
- 验证 chacl 递归设置
- 使用 chacl -b 同时设置
- 验证 chacl -b 设置

#### 测试 8: ACL 继承测试

- 设置目录 default ACL
- 在目录中创建新文件
- 验证新文件继承了 default ACL
- 在目录中创建子目录
- 验证子目录继承了 default ACL

#### 测试 9: ACL 权限验证

- 设置完整权限
- 验证权限设置
- 设置 mask 限制有效权限
- 验证 mask 限制后的有效权限

#### 测试 11: 特殊场景

- 设置多个用户和组 ACL
- 验证多个 ACL 条目
- 设置测试 ACL
- 导出 ACL 备份
- 清除 ACL
- 尝试恢复 ACL
- 使用 --test 模式不实际修改
- 验证 --test 模式未修改 ACL

</details>

---

## attr

<details>
<summary><b>attr — 1 个用例 / 6 个功能点</b></summary>

#### 主要功能点

- 获取 attr 版本信息
- 获取 getfattr 版本信息
- 获取 setfattr 版本信息
- 切换目录
- 创建文件
- 创建目录

</details>

---

## audit

<details>
<summary><b>audit — 2 个用例 / 15 个功能点</b></summary>

#### 测试 1: 版本和帮助

- auditctl 版本信息
- auditctl 帮助信息
- ausearch 版本信息
- ausearch 帮助信息
- aureport 版本信息
- aureport 帮助信息
- aulast 版本信息
- aulast 帮助信息
- aulastlog 版本信息
- aulastlog 帮助信息
- ausyscall 版本信息
- ausyscall 帮助信息
- augenrules 版本信息
- augenrules 帮助信息

#### 测试 2: 错误处理

- auditctl: 无效选项

</details>

---

## authselect

<details>
<summary><b>authselect — 1 个用例 / 1 个功能点</b></summary>

#### 主要功能点

- 锟斤拷取 authselect 锟芥本

</details>

---

## bash

<details>
<summary><b>bash — 7 个用例 / 7 个功能点</b></summary>

#### 测试 1: 基本脚本执行

- bash 执行脚本

#### 测试 2: 变量和循环

- bash -c: for循环

#### 测试 3: 条件判断

- bash: if条件

#### 测试 4: 函数

- bash: 函数定义调用

#### 测试 5: 管道和重定向

- bash: 管道

#### 测试 6: bashbug

- bashbug 帮助

#### 测试 7: 错误处理

- bash: 错误退出

</details>

---

## bash-completion

<details>
<summary><b>bash-completion — 1 个用例 / 1 个功能点</b></summary>

#### 主要功能点

- 锟叫筹拷锟斤拷锟侥硷拷

</details>

---

## bc

<details>
<summary><b>bc — 1 个用例 / 2 个功能点</b></summary>

#### 主要功能点

- 锟斤拷取 bc 锟芥本锟斤拷息
- 锟斤拷取 dc 锟芥本锟斤拷息

</details>

---

## beakerlib

<details>
<summary><b>beakerlib — 1 个用例 / 1 个功能点</b></summary>

#### 基本安装验证

- 检查 beakerlib 已安装

</details>

---

## binutils

<details>
<summary><b>binutils — 1 个用例 / 1 个功能点</b></summary>

#### 基本安装验证

- 检查 binutils 已安装

</details>

---

## brotli

<details>
<summary><b>brotli — 1 个用例 / 1 个功能点</b></summary>

#### 主要功能点

- 锟斤拷取 brotli 锟芥本锟斤拷息

</details>

---

## bzip2

<details>
<summary><b>bzip2 — 1 个用例 / 1 个功能点</b></summary>

#### 主要功能点

- 锟斤拷取 bzip2 锟芥本

</details>

---

## ca-certificates

<details>
<summary><b>ca-certificates — 2 个用例 / 3 个功能点</b></summary>

#### 测试 1: 版本和帮助

- update-ca-trust 版本信息
- update-ca-trust 帮助信息

#### 测试 2: 错误处理

- update-ca-trust: 无效选项

</details>

---

## ca-certificates-mozilla

<details>
<summary><b>ca-certificates-mozilla — 1 个用例 / 2 个功能点</b></summary>

#### 测试 1: 版本和帮助

- 列出包文件
- 库文件检查

</details>

---

## chkconfig

<details>
<summary><b>chkconfig — 1 个用例 / 1 个功能点</b></summary>

#### 主要功能点

- 获取 chkconfig 版本信息

</details>

---

## clang

<details>
<summary><b>clang — 15 个用例 / 25 个功能点</b></summary>

#### 测试 1: Basic C compilation

- Compile hello.c
- Run compiled binary
- Output is ELF binary

#### 测试 2: Basic C++ compilation

- Compile C++ from hello.c
- Run C++ binary

#### 测试 3: Compile-only

- clang -c: compile only
- Object file exists

#### 测试 4: Optimization levels

- Optimization -$lvl

#### 测试 5: Debug and warnings

- Debug symbols
- -Wall warnings
- -Wextra warnings
- -Werror

#### 测试 6: C standards

- C standard: $std

#### 测试 7: C++ standards

- C++ standard: $std

#### 测试 8: Preprocessor

- clang -E: preprocess
- clang -dM: dump macros

#### 测试 9: Static analysis

- clang --analyze: static analysis

#### 测试 10: clang-cl (MSVC compat)

- clang-cl help

#### 测试 11: clang-cpp

- clang-cpp: preprocessor

#### 测试 12: clang-scan-deps

- clang-scan-deps help

#### 测试 13: Linking options

- Compile with -fPIC
- clang -shared: shared library

#### 测试 14: Verbose mode

- clang -v: verbose

#### 测试 15: Error handling

- Compilation error
- Invalid option

</details>

---

## cloud-utils-growpart

<details>
<summary><b>cloud-utils-growpart — 6 个用例 / 10 个功能点</b></summary>

#### 测试 1: Help and version

- growpart help
- growpart -h: short help

#### 测试 2: Disk/partition info

- lsblk: list block devices
- df: disk free space

#### 测试 3: Dry-run (no actual resize)

- growpart -N: dry run

#### 测试 4: Free percent option

- growpart: has free-percent option

#### 测试 5: Fudge factor option

- growpart: has fudge option

#### 测试 6: Error handling

- growpart: no args (expected fail)
- growpart: nonexistent disk
- growpart: invalid option

</details>

---

## cmake

<details>
<summary><b>cmake — 6 个用例 / 6 个功能点</b></summary>

#### 测试 1: Basic CMake project

- include <stdio.h>

#### 测试 2: CMake configure

- 测试 2: CMake configure

#### 测试 3: CMake -E mode

- 测试 3: CMake -E mode

#### 测试 4: ctest and cpack

- 测试 4: ctest and cpack

#### 测试 5: Error handling

- 测试 5: Error handling

#### 测试 6: CMake version and help

- 测试 6: CMake version and help

</details>

---

## coreutils

<details>
<summary><b>coreutils — 24 个用例 / 234 个功能点</b></summary>

#### 测试 1: File creation and listing (echo, cat, ls, dir, vdir)

- echo create file
- echo append
- echo -n suppress newline
- echo -n: verify no trailing newline
- cat display file
- cat: verify 2 lines
- cat -n number all lines
- cat -b number non-blank lines
- ls -la list all files
- ls specific file
- ls -l: regular file check
- ls -ld: directory check
- ls -1 single column
- dir list directory
- vdir long format list

#### 测试 2: Copy, move, remove (cp, mv, rm, rmdir)

- cp copy file
- cp: verify copy exists
- cp: files identical
- cp -r recursive copy
- cp -r: verify directory copy
- mv rename file
- mv: old name gone
- mv: new name exists
- mv to subdirectory
- Create temp file
- rm remove file
- rm: file removed
- Create dir to remove
- rm -rf recursive force
- rm -rf: directory removed
- Create empty directory
- rmdir remove empty directory
- rmdir: directory removed

#### 测试 3: Directory, file creation, temp files (mkdir, touch, mktemp)

- mkdir -p nested directories
- mkdir -p: verify nested dir
- mkdir -m set mode
- touch create file
- touch: file exists
- touch -t set timestamp
- touch -a access time only

#### 测试 4: Links and path resolution (ln, link, unlink, readlink, realpath)

- Create link source
- ln create hard link
- ln: hard link same inode
- ln -s symbolic link
- ln -s: symlink exists
- ln -s: read through symlink
- ln -sf force recreate symlink
- link create hard link
- link: same inode
- unlink remove hard link
- unlink: file removed
- readlink show symlink target
- readlink: correct target
- readlink -f canonicalize
- realpath canonical path

#### 测试 5: File viewing (head, tail, tac, nl)

- head -n 5: first 5 lines
- head -n 3: verify count
- head -c 10: first 10 bytes
- tail -n 5: last 5 lines
- tail -n 3: verify count
- tail -n +18: from line 18
- tail -c 10: last 10 bytes
- tac reverse lines
- tac: first becomes last
- nl number lines

#### 测试 6: Counting and statistics (wc, du, df, stat)

- wc -l line count
- wc -l: 20 lines
- wc -c byte count
- wc -w word count
- wc -m character count
- du -sh summary human
- du -h directory usage
- df -h human readable
- df: root filesystem
- stat file status
- stat -c format output
- stat -f filesystem status

#### 测试 7: Text processing I (sort, uniq, cut, tr)

- sort alphabetically
- sort: first is apple
- sort -r reverse
- sort -u unique
- sort -n numeric
- uniq unique lines
- uniq: 4 unique
- uniq -c count occurrences
- uniq -d only duplicates
- uniq -u only uniques
- cut -d: -f1 first field
- cut -d: -f2 second field
- cut multiple fields
- cut -c character range
- tr translate uppercase to lowercase
- tr -d delete characters
- tr -s squeeze repeats

#### 测试 8: Text processing II (paste, comm, join, fmt, fold, pr, expand, unexpand)

- paste merge files side by side
- paste -d: custom delimiter
- paste -s serial
- comm compare sorted files
- join files on common field
- fmt reformat text
- fmt -w set width
- fold -w wrap at width
- pr paginate file
- pr -n number lines
- expand tabs to spaces
- unexpand -a spaces to tabs

#### 测试 9: Octal dump (od)

- od octal dump
- od -c character dump
- od -x hex dump
- od -A x hex address

#### 测试 10: Path operations (basename, dirname, pwd)

- basename extract filename
- basename strip suffix
- dirname extract directory
- dirname path extraction
- pwd print working directory

#### 测试 11: Permissions and ownership (chmod, chown, chgrp)

- Create permission test file
- chmod u+x add exec
- chmod: verify exec set
- chmod 644 numeric
- chmod: verify 644 perms
- Setup recursive chmod
- chmod -R recursive
- chown version check
- chown to self
- chgrp version check

#### 测试 12: Redirection (tee)

- tee write to file
- tee: verify output
- tee -a append mode

#### 测试 13: Checksums (cksum, md5sum, sha1sum, sha224sum, sha384sum, sha512sum, sha256sum, b2sum, sum)

- cksum CRC checksum
- md5sum compute
- md5sum save
- md5sum -c verify
- sha1sum compute
- sha1sum save
- sha1sum -c verify
- sha224sum compute
- sha256sum compute
- sha256sum save
- sha256sum -c verify
- sha384sum compute
- sha512sum compute
- b2sum BLAKE2 checksum
- sum BSD checksum

#### 测试 14: Encoding (base32, base64, basenc)

- base32 encode
- base32 -d decode
- base64 encode
- base64 -d decode
- basenc --base64 encode

#### 测试 15: System information (uname, who, whoami, id, groups, users, hostid, nproc, tty, logname, pinky)

- uname system name
- uname -a all info
- uname -r kernel release
- uname -m machine hardware
- who show logged in users
- whoami current user
- id user identity
- id -u user ID
- id -g group ID
- groups show group membership
- groups for specific user
- users list logged in users
- hostid numeric host identifier
- nproc number of CPUs
- nproc --all all processors
- tty terminal name
- logname login name
- pinky user info

#### 测试 16: Boolean and condition (true, false, test, [)

- true returns success
- false returns failure
- test -f: file exists
- test -d: directory exists
- test string equality
- test numeric comparison
- [ -f: file exists
- [ string equality

#### 测试 17: Environment and time (env, printenv, date, printf)

- env show environment
- env set variable for command
- printenv show PATH
- date current date/time
- date custom format
- date -u UTC time
- printf formatted output
- printf string output

#### 测试 18: Flow control (sleep, timeout, yes)

- sleep delay
- timeout: command finishes in time
- timeout: successful completion
- timeout: kills slow command
- yes repeated output
- yes custom string

#### 测试 19: Process control (nice, nohup, stdbuf)

- nice adjust priority
- nohup run command
- stdbuf line buffered output

#### 测试 20: File operations (dd, truncate, shred, sync, install, chroot)

- dd copy file
- truncate set size
- truncate: verify size
- Create file to shred
- shred remove file securely
- shred: file removed
- sync flush filesystem buffers
- install copy with mode
- install: destination exists
- install -d create directory
- install -d: directory exists
- chroot version check
- mkfifo create named pipe
- mkfifo: verify pipe created
- mknod version check

#### 测试 21: Numbers and expressions (seq, factor, shuf, numfmt, expr)

- seq generate sequence
- seq: 5 numbers
- seq -s custom separator
- factor prime factorization
- factor prime number
- shuf randomize lines
- shuf: same line count
- numfmt to SI units
- numfmt from SI units
- numfmt to IEC units
- expr basic arithmetic
- expr multiplication
- expr string length

#### 测试 22: Split files (split, csplit)

- split by lines
- split: multiple output files
- csplit split by pattern

#### 测试 23: Special utilities (stty, pathchk, tsort, ptx, dircolors)

- stty -a show all terminal settings
- pathchk validate path
- pathchk -p POSIX check
- tsort topological sort
- ptx permuted index
- dircolors -p print database
- dircolors output LS_COLORS

#### 测试 24: Error handling

- cp: error on nonexistent source
- ls: error on nonexistent file
- mkdir: error on existing dir
- rm: error on dir without -r
- rmdir: error on non-empty dir

</details>

---

## cpio

<details>
<summary><b>cpio — 1 个用例 / 1 个功能点</b></summary>

#### 主要功能点

- 锟斤拷取 cpio 锟芥本锟斤拷息

</details>

---

## cracklib

<details>
<summary><b>cracklib — 1 个用例 / 1 个功能点</b></summary>

#### 基本安装验证

- 检查 cracklib 已安装

</details>

---

## cryptsetup

<details>
<summary><b>cryptsetup — 2 个用例 / 3 个功能点</b></summary>

#### 测试 1: 版本和帮助

- cryptsetup 版本信息
- cryptsetup 帮助信息

#### 测试 2: 错误处理

- cryptsetup: 无效选项

</details>

---

## curl

<details>
<summary><b>curl — 6 个用例 / 11 个功能点</b></summary>

#### 测试 1: 基本下载

- curl 下载示例页面
- curl -I: 仅获取响应头

#### 测试 2: 输出选项

- curl -o: 输出到文件
- curl -O: 远程文件名

#### 测试 3: 详细模式和静默模式

- curl -v: 详细模式
- curl -s: 静默模式

#### 测试 4: 其他选项

- curl -L: 跟随重定向
- curl -k: 忽略SSL证书
- curl --connect-timeout: 连接超时

#### 测试 5: wcurl

- wcurl 帮助

#### 测试 6: 错误处理

- curl: 无效选项

</details>

---

## dbus

<details>
<summary><b>dbus — 1 个用例 / 1 个功能点</b></summary>

#### 主要功能点

- 锟斤拷取 dbus-launch 锟芥本

</details>

---

## dbus-broker

<details>
<summary><b>dbus-broker — 1 个用例 / 1 个功能点</b></summary>

#### 主要功能点

- 锟斤拷取 dbus-broker 锟芥本锟斤拷息

</details>

---

## debugedit

<details>
<summary><b>debugedit — 2 个用例 / 5 个功能点</b></summary>

#### 测试 1: 版本和帮助

- debugedit 版本信息
- debugedit 帮助信息
- debugedit-classify-ar 版本信息
- debugedit-classify-ar 帮助信息

#### 测试 2: 错误处理

- debugedit: 无效选项

</details>

---

## diffutils

<details>
<summary><b>diffutils — 1 个用例 / 4 个功能点</b></summary>

#### 主要功能点

- 锟斤拷取 cmp 锟芥本锟斤拷息
- 锟斤拷取 diff 锟芥本锟斤拷息
- 锟斤拷取 diff3 锟芥本锟斤拷息
- 锟斤拷取 sdiff 锟芥本锟斤拷息

</details>

---

## dnf5-plugins

<details>
<summary><b>dnf5-plugins — 10 个用例 / 11 个功能点</b></summary>

#### 测试 1: dnf5 version

- dnf5 version

#### 测试 2: dnf5 help

- dnf5 help

#### 测试 3: List installed plugins

- Plugin files
- Plugin directory

#### 测试 4: Available plugins

- Check plugin: $plugin

#### 测试 5: Commands with plugins

- Plugin commands in help

#### 测试 6: dnf5 repoquery

- dnf5 repoquery help

#### 测试 7: dnf5 repolist

- dnf5 repolist

#### 测试 8: dnf5 list

- dnf5 list installed

#### 测试 9: dnf5 info

- dnf5 info

#### 测试 10: Error handling

- dnf5: invalid option

</details>

---

## dwz

<details>
<summary><b>dwz — 2 个用例 / 3 个功能点</b></summary>

#### 测试 1: 版本和帮助

- dwz 版本信息
- dwz 帮助信息

#### 测试 2: 错误处理

- dwz: 无效选项

</details>

---

## e2fsprogs

<details>
<summary><b>e2fsprogs — 1 个用例 / 1 个功能点</b></summary>

#### 基本安装验证

- 检查 e2fsprogs 已安装

</details>

---

## elfutils

<details>
<summary><b>elfutils — 2 个用例 / 31 个功能点</b></summary>

#### 测试 1: 版本和帮助

- eu-addr2line 版本信息
- eu-addr2line 帮助信息
- eu-ar 版本信息
- eu-ar 帮助信息
- eu-elfclassify 版本信息
- eu-elfclassify 帮助信息
- eu-elfcmp 版本信息
- eu-elfcmp 帮助信息
- eu-elfcompress 版本信息
- eu-elfcompress 帮助信息
- eu-elflint 版本信息
- eu-elflint 帮助信息
- eu-findtextrel 版本信息
- eu-findtextrel 帮助信息
- eu-make-debug-archive 版本信息
- eu-make-debug-archive 帮助信息
- eu-nm 版本信息
- eu-nm 帮助信息
- eu-objdump 版本信息
- eu-objdump 帮助信息
- eu-ranlib 版本信息
- eu-ranlib 帮助信息
- eu-readelf 版本信息
- eu-readelf 帮助信息
- eu-size 版本信息
- eu-size 帮助信息
- eu-srcfiles 版本信息
- eu-srcfiles 帮助信息
- eu-stack 版本信息
- eu-stack 帮助信息

#### 测试 2: 错误处理

- eu-addr2line: 无效选项

</details>

---

## expat

<details>
<summary><b>expat — 1 个用例 / 1 个功能点</b></summary>

#### 主要功能点

- 锟斤拷取 xmlwf 锟芥本锟斤拷息

</details>

---

## file

<details>
<summary><b>file — 1 个用例 / 1 个功能点</b></summary>

#### 主要功能点

- 锟斤拷取 file 锟芥本锟斤拷息

</details>

---

## filesystem

<details>
<summary><b>filesystem — 1 个用例 / 2 个功能点</b></summary>

#### 测试 1: 版本和帮助

- 列出包文件
- 库文件检查

</details>

---

## findutils

<details>
<summary><b>findutils — 5 个用例 / 13 个功能点</b></summary>

#### 测试 1: find 基本查找

- find -name: 按名称查找
- find -type f: 查找文件
- find -type d: 查找目录

#### 测试 2: find 选项

- find -maxdepth: 最大深度
- find -mindepth: 最小深度
- find -empty: 空文件/目录
- find -size: 按大小

#### 测试 3: find 执行操作

- find -exec: 执行命令
- find -delete: 删除文件
- find -delete: 验证删除

#### 测试 4: xargs

- xargs: 基本用法
- xargs -n1: 每次一个参数

#### 测试 5: 错误处理

- find: 无效路径

</details>

---

## gawk

<details>
<summary><b>gawk — 1 个用例 / 2 个功能点</b></summary>

#### 主要功能点

- 锟斤拷取 awk 锟芥本锟斤拷息
- 锟斤拷取 gawk 锟芥本锟斤拷息

</details>

---

## gcc

<details>
<summary><b>gcc — 12 个用例 / 52 个功能点</b></summary>

#### 测试 1: Basic C compilation

- Compile hello.c to hello
- Run compiled hello
- Verify output is ELF binary
- Compile with -o flag
- Run myhello

#### 测试 2: C++ compilation

- Compile hello.cpp
- Compile with C++11 standard

#### 测试 3: Compiler optimization flags

- Compile with -O0
- Compile with -O2
- Compile with debug symbols -g
- Verify debug symbols present

#### 测试 4: Preprocessor

- Preprocess with -E
- Verify macro expanded in preprocessed output
- Compile preprocessed .i file
- Run from preprocessed source
- Compile with -D flag
- Run with -D defined macro

#### 测试 5: Assembly output

- Generate assembly with -S
- Check main label in assembly
- Assemble to object file

#### 测试 6: Linking and libraries

- Link with -lm
- Run math linked program
- Compile static binary

#### 测试 7: Warning flags

- Compile with -Wall warnings enabled
- Compile with -Werror
- Compile with -pedantic

#### 测试 8: Multi-file compilation

- Compile add.c to object
- Compile main.c to object
- Link multiple objects
- Run multi-file program
- Compile multiple files in one command
- Run single-command multi-file program

#### 测试 9: Code coverage (gcov)

- Compile with coverage flags
- Run coverage test program
- Run gcov
- Check gcov output file exists

#### 测试 10: Error handling

- Test type mismatch warning

#### 测试 11: Special features

- Compile with C99 standard
- Compile with __attribute__
- Run attribute test
- Compile with -I include path
- Run include path test

#### 测试 12: GCC toolchain utilities

- gcc-ar version check
- gcc-nm version check
- gcc-ranlib version check
- gcov-dump version check
- gcov-tool version check
- lto-dump version check
- cc version check
- cc equals gcc
- c++ version check
- c++ equals g++

</details>

---

## gcc16

<details>
<summary><b>gcc16 — 1 个用例 / 1 个功能点</b></summary>

#### 基本安装验证

- 检查 gcc16 已安装

</details>

---

## git

<details>
<summary><b>git — 1 个用例 / 1 个功能点</b></summary>

#### 主要功能点

- 锟叫筹拷锟斤拷锟侥硷拷

</details>

---

## glib

<details>
<summary><b>glib — 1 个用例 / 1 个功能点</b></summary>

#### 基本安装验证

- 检查 glib 已安装

</details>

---

## glibc

<details>
<summary><b>glibc — 2 个用例 / 17 个功能点</b></summary>

#### 测试 1: 版本和帮助

- gencat 版本信息
- gencat 帮助信息
- getconf 版本信息
- getconf 帮助信息
- getent 版本信息
- getent 帮助信息
- iconv 版本信息
- iconv 帮助信息
- ldconfig 版本信息
- ldconfig 帮助信息
- ldd 版本信息
- ldd 帮助信息
- locale 版本信息
- locale 帮助信息
- localedef 版本信息
- localedef 帮助信息

#### 测试 2: 错误处理

- gencat: 无效选项

</details>

---

## gmp

<details>
<summary><b>gmp — 1 个用例 / 2 个功能点</b></summary>

#### 测试 1: 版本和帮助

- 列出包文件
- 库文件检查

</details>

---

## gnutls

<details>
<summary><b>gnutls — 1 个用例 / 1 个功能点</b></summary>

#### 基本安装验证

- 检查 gnutls 已安装

</details>

---

## grep

<details>
<summary><b>grep — 13 个用例 / 44 个功能点</b></summary>

#### 测试 1: Basic pattern matching

- Basic grep for Hello
- Verify multiple matches
- Grep from pipe
- Grep across multiple files

#### 测试 2: Case insensitive (-i)

- Case insensitive grep
- Verify case insensitive matches
- Case sensitive: lowercase only matches lowercase

#### 测试 3: Invert match (-v)

- Invert match: exclude Hello
- Verify inverted output contains other lines

#### 测试 4: Word and line matching (-w, -x)

- Create word test file
- Add line with separate words
- Whole word match: hello matches only standalone
- Create line test file
- Add different line
- Whole line exact match

#### 测试 5: Count and line numbers (-c, -n)

- Count matches with -c
- Verify count >= 2
- Show line numbers with -n
- Verify line number format

#### 测试 6: Recursive search (-r)

- Recursive grep in subdirectory
- Recursive list files with matches
- Recursive with --include filter

#### 测试 7: Extended regex (-E)

- Extended regex with alternation
- Extended regex: digit quantifier
- Verify digit match count
- egrep equivalent to grep -E

#### 测试 8: Fixed strings (-F)

- Fixed string with special chars
- Fixed string: no regex meta-char interpretation
- fgrep equivalent to grep -F

#### 测试 9: Only matching and quiet (-o, -q)

- Only matching: digits only
- Quiet mode: pattern found
- Quiet mode: pattern not found

#### 测试 10: Context lines (-A, -B, -C)

- Context: 1 line after match
- Context: 1 line before match
- Context: 1 line before and after

#### 测试 11: File listing (-l, -L)

- List files with matches
- List files without matches

#### 测试 12: Multiple patterns (-e, -f)

- Multiple patterns with -e
- Patterns from file with -f
- Max count: stop after first match

#### 测试 13: Error handling

- Error on nonexistent file
- Error on invalid regex
- Error on directory without -r
- No match returns exit code 1

</details>

---

## gzip

<details>
<summary><b>gzip — 2 个用例 / 29 个功能点</b></summary>

#### 测试 1: 版本和帮助

- gzip 版本信息
- gzip 帮助信息
- gunzip 版本信息
- gunzip 帮助信息
- zcat 版本信息
- zcat 帮助信息
- zcmp 版本信息
- zcmp 帮助信息
- zdiff 版本信息
- zdiff 帮助信息
- zgrep 版本信息
- zgrep 帮助信息
- zless 版本信息
- zless 帮助信息
- zmore 版本信息
- zmore 帮助信息
- znew 版本信息
- znew 帮助信息
- gzexe 版本信息
- gzexe 帮助信息
- zforce 版本信息
- zforce 帮助信息
- zegrep 版本信息
- zegrep 帮助信息
- zfgrep 版本信息
- zfgrep 帮助信息
- uncompress 版本信息
- uncompress 帮助信息

#### 测试 2: 错误处理

- gzip: 无效选项

</details>

---

## icu4c

<details>
<summary><b>icu4c — 1 个用例 / 1 个功能点</b></summary>

#### 基本安装验证

- 检查 icu4c 已安装

</details>

---

## iproute2

<details>
<summary><b>iproute2 — 1 个用例 / 1 个功能点</b></summary>

#### 基本安装验证

- 检查 iproute2 已安装

</details>

---

## iputils

<details>
<summary><b>iputils — 10 个用例 / 33 个功能点</b></summary>

#### 测试 1: ping basic functionality

- Ping localhost
- Ping with count limit
- Ping with interval
- Ping with packet size
- Ping with timeout

#### 测试 2: ping advanced options

- Ping with flood mode (requires root)
- Ping with numeric output
- Ping with quiet mode
- Ping with verbose output
- Ping with timestamp

#### 测试 3: ping6 (IPv6)

- Ping6 localhost
- Ping6 with count

#### 测试 4: traceroute6

- Basic traceroute6 to localhost
- traceroute6 with max hops
- traceroute6 with wait time

#### 测试 5: tracepath

- Basic tracepath to localhost
- tracepath with max hops
- tracepath IPv6

#### 测试 6: arping

- ARP ping to localhost interface
- arping with count
- arping with timeout

#### 测试 7: clockdiff

- Clock difference to localhost
- clockdiff with IPv6

#### 测试 8: ping error handling

- Ping unreachable address
- Ping with invalid address
- Ping with invalid count
- Ping with negative count

#### 测试 9: ping special scenarios

- Ping broadcast address (may require special permissions)
- Ping with source address
- Ping with TTL
- Continuous ping (limited by timeout)

#### 测试 10: Network interface testing

- Ping via specific interface
- Multiple ping instances

</details>

---

## isl

<details>
<summary><b>isl — 1 个用例 / 2 个功能点</b></summary>

#### 测试 1: 版本和帮助

- 列出包文件
- 库文件检查

</details>

---

## iso-codes

<details>
<summary><b>iso-codes — 1 个用例 / 1 个功能点</b></summary>

#### 主要功能点

- 锟叫筹拷锟斤拷锟侥硷拷

</details>

---

## jitterentropy

<details>
<summary><b>jitterentropy — 1 个用例 / 2 个功能点</b></summary>

#### 主要功能点

- 查找 .so 库文件
- 检查包已安装

</details>

---

## json-c

<details>
<summary><b>json-c — 1 个用例 / 2 个功能点</b></summary>

#### 主要功能点

- 查找 .so 库文件
- 检查包已安装

</details>

---

## kbd

<details>
<summary><b>kbd — 1 个用例 / 1 个功能点</b></summary>

#### 基本安装验证

- 检查 kbd 已安装

</details>

---

## keyutils

<details>
<summary><b>keyutils — 1 个用例 / 1 个功能点</b></summary>

#### 基本安装验证

- 检查 keyutils 已安装

</details>

---

## kmod

<details>
<summary><b>kmod — 1 个用例 / 1 个功能点</b></summary>

#### 基本安装验证

- 检查 kmod 已安装

</details>

---

## krb5

<details>
<summary><b>krb5 — 1 个用例 / 1 个功能点</b></summary>

#### 基本安装验证

- 检查 krb5 已安装

</details>

---

## labwc

<details>
<summary><b>labwc — 9 个用例 / 10 个功能点</b></summary>

#### 测试 1: Help

- labwc help

#### 测试 2: Configuration

- labwc: config options

#### 测试 3: Debug mode

- labwc: debug option

#### 测试 4: Check for display (no DISPLAY)

- labwc: startup/session options

#### 测试 5: Library check

- labwc: linked libraries

#### 测试 6: labnag

- labnag help

#### 测试 7: lab-sensible-terminal

- lab-sensible-terminal help

#### 测试 8: Config dirs

- System config dir
- Data dir

#### 测试 9: Error handling

- labwc: invalid option

</details>

---

## less

<details>
<summary><b>less — 1 个用例 / 3 个功能点</b></summary>

#### 主要功能点

- 锟斤拷取 less 锟芥本锟斤拷息
- 锟斤拷取 lessecho 锟芥本锟斤拷息
- 锟斤拷取 lesskey 锟芥本锟斤拷息

</details>

---

## libaio

<details>
<summary><b>libaio — 1 个用例 / 2 个功能点</b></summary>

#### 主要功能点

- 查找 .so 库文件
- 检查包已安装

</details>

---

## libarchive

<details>
<summary><b>libarchive — 1 个用例 / 2 个功能点</b></summary>

#### 主要功能点

- 查找 .so 库文件
- 检查包已安装

</details>

---

## libbpf

<details>
<summary><b>libbpf — 1 个用例 / 2 个功能点</b></summary>

#### 主要功能点

- 查找 .so 库文件
- 检查包已安装

</details>

---

## libcap

<details>
<summary><b>libcap — 1 个用例 / 2 个功能点</b></summary>

#### 主要功能点

- 查找 .so 库文件
- 检查包已安装

</details>

---

## libcap-ng

<details>
<summary><b>libcap-ng — 1 个用例 / 2 个功能点</b></summary>

#### 主要功能点

- 查找 .so 库文件
- 检查包已安装

</details>

---

## libeconf

<details>
<summary><b>libeconf — 1 个用例 / 2 个功能点</b></summary>

#### 主要功能点

- 查找 .so 库文件
- 检查包已安装

</details>

---

## libedit

<details>
<summary><b>libedit — 1 个用例 / 2 个功能点</b></summary>

#### 主要功能点

- 查找 .so 库文件
- 检查包已安装

</details>

---

## libevent

<details>
<summary><b>libevent — 1 个用例 / 2 个功能点</b></summary>

#### 主要功能点

- 查找 .so 库文件
- 检查包已安装

</details>

---

## libffi

<details>
<summary><b>libffi — 1 个用例 / 2 个功能点</b></summary>

#### 主要功能点

- 查找 .so 库文件
- 检查包已安装

</details>

---

## libgcrypt

<details>
<summary><b>libgcrypt — 1 个用例 / 2 个功能点</b></summary>

#### 主要功能点

- 查找 .so 库文件
- 检查包已安装

</details>

---

## libgpg-error

<details>
<summary><b>libgpg-error — 1 个用例 / 2 个功能点</b></summary>

#### 主要功能点

- 查找 .so 库文件
- 检查包已安装

</details>

---

## libidn2

<details>
<summary><b>libidn2 — 1 个用例 / 1 个功能点</b></summary>

#### 主要功能点

- 锟斤拷取 idn2 锟芥本锟斤拷息

</details>

---

## libmnl

<details>
<summary><b>libmnl — 1 个用例 / 2 个功能点</b></summary>

#### 主要功能点

- 查找 .so 库文件
- 检查包已安装

</details>

---

## libnetfilter_conntrack

<details>
<summary><b>libnetfilter_conntrack — 1 个用例 / 2 个功能点</b></summary>

#### 主要功能点

- 查找 .so 库文件
- 检查包已安装

</details>

---

## libnfnetlink

<details>
<summary><b>libnfnetlink — 1 个用例 / 2 个功能点</b></summary>

#### 主要功能点

- 查找 .so 库文件
- 检查包已安装

</details>

---

## libnftnl

<details>
<summary><b>libnftnl — 1 个用例 / 2 个功能点</b></summary>

#### 主要功能点

- 查找 .so 库文件
- 检查包已安装

</details>

---

## libnl

<details>
<summary><b>libnl — 1 个用例 / 2 个功能点</b></summary>

#### 主要功能点

- 查找 .so 库文件
- 检查包已安装

</details>

---

## libpng

<details>
<summary><b>libpng — 1 个用例 / 1 个功能点</b></summary>

#### 主要功能点

- 锟斤拷取 pngfix 锟芥本锟斤拷息

</details>

---

## libpsl

<details>
<summary><b>libpsl — 1 个用例 / 2 个功能点</b></summary>

#### 主要功能点

- 查找 .so 库文件
- 检查包已安装

</details>

---

## libpwquality

<details>
<summary><b>libpwquality — 1 个用例 / 2 个功能点</b></summary>

#### 主要功能点

- 锟斤拷取 pwmake 锟芥本锟斤拷息
- 锟斤拷取 pwscore 锟芥本锟斤拷息

</details>

---

## libseccomp

<details>
<summary><b>libseccomp — 1 个用例 / 2 个功能点</b></summary>

#### 主要功能点

- 查找 .so 库文件
- 检查包已安装

</details>

---

## libselinux

<details>
<summary><b>libselinux — 1 个用例 / 2 个功能点</b></summary>

#### 测试 1: 版本和帮助

- 列出包文件
- 库文件检查

</details>

---

## libsepol

<details>
<summary><b>libsepol — 1 个用例 / 2 个功能点</b></summary>

#### 主要功能点

- 查找 .so 库文件
- 检查包已安装

</details>

---

## libtasn1

<details>
<summary><b>libtasn1 — 1 个用例 / 3 个功能点</b></summary>

#### 主要功能点

- 锟斤拷取 asn1Coding 锟芥本锟斤拷息
- 锟斤拷取 asn1Decoding 锟芥本锟斤拷息
- 锟斤拷取 asn1Parser 锟芥本锟斤拷息

</details>

---

## libtirpc

<details>
<summary><b>libtirpc — 1 个用例 / 2 个功能点</b></summary>

#### 主要功能点

- 查找 .so 库文件
- 检查包已安装

</details>

---

## libunistring

<details>
<summary><b>libunistring — 1 个用例 / 2 个功能点</b></summary>

#### 主要功能点

- 查找 .so 库文件
- 检查包已安装

</details>

---

## libxcrypt

<details>
<summary><b>libxcrypt — 1 个用例 / 2 个功能点</b></summary>

#### 主要功能点

- 查找 .so 库文件
- 检查包已安装

</details>

---

## libxml2

<details>
<summary><b>libxml2 — 1 个用例 / 2 个功能点</b></summary>

#### 主要功能点

- 锟斤拷取 xmlcatalog 锟芥本锟斤拷息
- 锟斤拷取 xmllint 锟芥本锟斤拷息

</details>

---

## libxslt

<details>
<summary><b>libxslt — 1 个用例 / 1 个功能点</b></summary>

#### 主要功能点

- 锟斤拷取 xsltproc 锟芥本锟斤拷息

</details>

---

## linux-headers

<details>
<summary><b>linux-headers — 1 个用例 / 2 个功能点</b></summary>

#### 测试 1: 版本和帮助

- 列出包文件
- 库文件检查

</details>

---

## lua

<details>
<summary><b>lua — 2 个用例 / 5 个功能点</b></summary>

#### 测试 1: 版本和帮助

- lua 版本信息
- lua 帮助信息
- luac 版本信息
- luac 帮助信息

#### 测试 2: 错误处理

- lua: 无效选项

</details>

---

## lvm2

<details>
<summary><b>lvm2 — 1 个用例 / 1 个功能点</b></summary>

#### 基本安装验证

- 检查 lvm2 已安装

</details>

---

## lz4

<details>
<summary><b>lz4 — 1 个用例 / 4 个功能点</b></summary>

#### 主要功能点

- 锟斤拷取 lz4 锟芥本锟斤拷息
- 锟斤拷取 lz4c 锟芥本锟斤拷息
- 锟斤拷取 lz4cat 锟芥本锟斤拷息
- 锟斤拷取 unlz4 锟芥本锟斤拷息

</details>

---

## make

<details>
<summary><b>make — 9 个用例 / 21 个功能点</b></summary>

#### 测试 1: Basic Makefile execution

- Run default target
- Run specific target
- Run clean target
- make -s: silent mode

#### 测试 2: Variables

- Variable expansion
- Override variable

#### 测试 3: Options

- make -n: dry run
- make -B: always make
- make --just-print
- make -d: debug output
- make --debug=b: basic debug
- make -q: question mode
- make -s: silent

#### 测试 4: Parallel execution

- make -j2: parallel 2 jobs

#### 测试 5: Environment

- make -e: environment overrides
- Environment variable in make

#### 测试 6: Directory change

- make -C: change directory

#### 测试 7: Include

- Include file

#### 测试 8: gmake alias

- gmake is GNU Make

#### 测试 9: Error handling

- make -k: continue on error
- make -i: ignore errors

</details>

---

## mpc

<details>
<summary><b>mpc — 1 个用例 / 2 个功能点</b></summary>

#### 测试 1: 版本和帮助

- 列出包文件
- 库文件检查

</details>

---

## mpdecimal

<details>
<summary><b>mpdecimal — 1 个用例 / 2 个功能点</b></summary>

#### 测试 1: 版本和帮助

- 列出包文件
- 库文件检查

</details>

---

## mpfr

<details>
<summary><b>mpfr — 1 个用例 / 2 个功能点</b></summary>

#### 测试 1: 版本和帮助

- 列出包文件
- 库文件检查

</details>

---

## ncurses

<details>
<summary><b>ncurses — 1 个用例 / 1 个功能点</b></summary>

#### 基本安装验证

- 检查 ncurses 已安装

</details>

---

## nettle

<details>
<summary><b>nettle — 2 个用例 / 11 个功能点</b></summary>

#### 测试 1: 版本和帮助

- nettle-hash 版本信息
- nettle-hash 帮助信息
- nettle-lfib-stream 版本信息
- nettle-lfib-stream 帮助信息
- nettle-pbkdf2 版本信息
- nettle-pbkdf2 帮助信息
- pkcs1-conv 版本信息
- pkcs1-conv 帮助信息
- sexp-conv 版本信息
- sexp-conv 帮助信息

#### 测试 2: 错误处理

- nettle-hash: 无效选项

</details>

---

## newt

<details>
<summary><b>newt — 2 个用例 / 3 个功能点</b></summary>

#### 测试 1: 版本和帮助

- whiptail 版本信息
- whiptail 帮助信息

#### 测试 2: 错误处理

- whiptail: 无效选项

</details>

---

## nghttp2

<details>
<summary><b>nghttp2 — 1 个用例 / 2 个功能点</b></summary>

#### 主要功能点

- 查找 .so 库文件
- 检查包已安装

</details>

---

## openruyi-release

<details>
<summary><b>openruyi-release — 1 个用例 / 1 个功能点</b></summary>

#### 主要功能点

- 锟叫筹拷锟斤拷锟侥硷拷

</details>

---

## openssh

<details>
<summary><b>openssh — 1 个用例 / 1 个功能点</b></summary>

#### 主要功能点

- 锟斤拷取 ssh 锟芥本锟斤拷息

</details>

---

## openssh-clients

<details>
<summary><b>openssh-clients — 7 个用例 / 19 个功能点</b></summary>

#### 测试 1: ssh version and help

- ssh version
- ssh -Q key: supported keys
- ssh -Q cipher: ciphers
- ssh -Q mac: MACs
- ssh -Q kex: key exchange

#### 测试 2: ssh connection (dry-run)

- ssh -G: print config
- ssh -T: disable PTY
- ssh -v: verbose

#### 测试 3: ssh-keygen via openssh

- Generate test key

#### 测试 4: ssh-agent

- ssh-add: list keys
- ssh-add: add key
- ssh-add: verify key added
- ssh-add -L: list public keys
- ssh-add -d: remove key

#### 测试 5: ssh-keyscan

- ssh-keyscan: scan localhost
- ssh-keyscan -t rsa
- ssh-keyscan -t ecdsa

#### 测试 6: sftp

- sftp: help command

#### 测试 7: scp

- scp version

</details>

---

## openssl

<details>
<summary><b>openssl — 1 个用例 / 1 个功能点</b></summary>

#### 主要功能点

- 锟斤拷取 openssl 锟芥本

</details>

---

## p11-kit

<details>
<summary><b>p11-kit — 1 个用例 / 1 个功能点</b></summary>

#### 基本安装验证

- 检查 p11-kit 已安装

</details>

---

## pam

<details>
<summary><b>pam — 2 个用例 / 11 个功能点</b></summary>

#### 测试 1: 版本和帮助

- faillock 版本信息
- faillock 帮助信息
- mkhomedir_helper 版本信息
- mkhomedir_helper 帮助信息
- pam_timestamp_check 版本信息
- pam_timestamp_check 帮助信息
- unix_chkpwd 版本信息
- unix_chkpwd 帮助信息
- unix_update 版本信息
- unix_update 帮助信息

#### 测试 2: 错误处理

- faillock: 无效选项

</details>

---

## patch

<details>
<summary><b>patch — 1 个用例 / 1 个功能点</b></summary>

#### 主要功能点

- 锟斤拷取 patch 锟芥本锟斤拷息

</details>

---

## pciutils

<details>
<summary><b>pciutils — 13 个用例 / 13 个功能点</b></summary>

#### 测试 1: lspci basic

- 测试 1: lspci basic

#### 测试 2: lspci verbose

- 测试 2: lspci verbose

#### 测试 3: lspci with filtering

- 测试 3: lspci with filtering

#### 测试 4: lspci numeric

- 测试 4: lspci numeric

#### 测试 5: lspci tree view

- 测试 5: lspci tree view

#### 测试 6: lspci kernel drivers

- 测试 6: lspci kernel drivers

#### 测试 7: lspci by device class

- 测试 7: lspci by device class

#### 测试 8: lspci with domain

- 测试 8: lspci with domain

#### 测试 9: update-pciids

- 测试 9: update-pciids

#### 测试 10: lspci format options

- 测试 10: lspci format options

#### 测试 11: setpci

- 测试 11: setpci

#### 测试 12: pcilmr

- 测试 12: pcilmr

#### 测试 13: Error handling

- 测试 13: Error handling

</details>

---

## pcre2

<details>
<summary><b>pcre2 — 1 个用例 / 2 个功能点</b></summary>

#### 主要功能点

- 锟斤拷取 pcre2grep 锟芥本锟斤拷息
- 锟斤拷取 pcre2test 锟芥本锟斤拷息

</details>

---

## perl

<details>
<summary><b>perl — 1 个用例 / 1 个功能点</b></summary>

#### 主要功能点

- 锟斤拷取 perl 锟芥本

</details>

---

## pkgconf

<details>
<summary><b>pkgconf — 2 个用例 / 5 个功能点</b></summary>

#### 测试 1: 版本和帮助

- pkgconf 版本信息
- pkgconf 帮助信息
- bomtool 版本信息
- bomtool 帮助信息

#### 测试 2: 错误处理

- pkgconf: 无效选项

</details>

---

## podman

<details>
<summary><b>podman — 7 个用例 / 16 个功能点</b></summary>

#### 测试 1: Image operations

- podman images: list images
- podman image list

#### 测试 2: Container operations

- podman ps: list containers
- podman ps -a: all containers
- podman container list

#### 测试 3: Network operations

- podman network ls
- podman network inspect

#### 测试 4: Volume operations

- podman volume ls

#### 测试 5: System operations

- podman system info
- podman system df: disk usage

#### 测试 6: Help commands

- podman manifest help
- podman healthcheck help
- podman events help
- podman pod list
- podman-remote help

#### 测试 7: Error handling

- podman: invalid command

</details>

---

## podmansh

<details>
<summary><b>podmansh — 11 个用例 / 11 个功能点</b></summary>

#### 测试 1: podmansh basic

- 测试 1: podmansh basic

#### 测试 2: podmansh help

- 测试 2: podmansh help

#### 测试 3: podmansh config

- 测试 3: podmansh config

#### 测试 4: podman basic

- 测试 4: podman basic

#### 测试 6: podman images

- 测试 6: podman images

#### 测试 7: podman network

- 测试 7: podman network

#### 测试 8: podman volume

- 测试 8: podman volume

#### 测试 9: podman stats

- 测试 9: podman stats

#### 测试 10: podman ps

- 测试 10: podman ps

#### 测试 11: Error handling

- 测试 11: Error handling

#### 测试 12: Cleanup

- 测试 12: Cleanup

</details>

---

## popt

<details>
<summary><b>popt — 1 个用例 / 2 个功能点</b></summary>

#### 主要功能点

- 查找 .so 库文件
- 检查包已安装

</details>

---

## procps-ng

<details>
<summary><b>procps-ng — 14 个用例 / 53 个功能点</b></summary>

#### 测试 1: ps command basic functionality

- Basic ps output
- ps with full format
- ps with custom format
- ps showing all processes
- ps with tree view

#### 测试 2: ps command advanced features

- Filter by user
- Filter by PID
- Show threads
- Process hierarchy
- Sort by CPU usage
- Sort by memory usage

#### 测试 3: free command

- Basic memory info
- Human-readable format
- Display in different units
- Continuous monitoring (single iteration)
- Show total column
- Show low/high memory

#### 测试 4: top command

- Basic top (batch mode, single iteration)
- Top with specific number of processes
- Top sorted by memory
- Top with delay

#### 测试 5: vmstat command

- Basic vmstat output
- vmstat with custom intervals
- vmstat with slabs info
- vmstat with disk stats
- vmstat with partitions

#### 测试 6: uptime and w commands

- System uptime
- Show users
- Show who is logged in

#### 测试 7: kill command

- Start a background process
- List signal numbers
- Send SIGTERM
- Wait for process to terminate
- Verify process terminated

#### 测试 8: pidof and pgrep

- Find PID by name
- pgrep basic usage
- pgrep with full command line

#### 测试 9: pwdx and pmap

- Show process working directory
- Show process memory map

#### 测试 10: sysctl (if available)

- List all sysctl parameters
- Read specific parameter

#### 测试 11: Error handling

- ps with invalid PID
- kill with invalid PID
- free with invalid option

#### 测试 12: Special scenarios

- ps with environment variables
- Process with real-time priority
- Show process namespaces

#### 测试 13: pkill and pidwait

- pkill version check
- pidwait version check

#### 测试 14: slabtop, tload, watch, hugetop

- slabtop display
- tload version
- watch basic usage
- hugetop

</details>

---

## psmisc

<details>
<summary><b>psmisc — 13 个用例 / 22 个功能点</b></summary>

#### 测试 1: fuser basic

- Test fuser on /tmp

#### 测试 2: fuser with processes

- Show processes using /tmp

#### 测试 3: fuser mount points

- 测试 3: fuser mount points

#### 测试 4: fuser with options

- 测试 4: fuser with options

#### 测试 5: pstree basic

- 测试 5: pstree basic

#### 测试 6: pstree with options

- Show PIDs
- Show numeric sort
- Compact tree
- Highlight current process
- Show full details
- Show only one user's processes

#### 测试 7: killall basic

- Start test process
- Try killall (may not kill itself)
- Clean up

#### 测试 8: prtstat

- 测试 8: prtstat

#### 测试 9: peekfd

- 测试 9: peekfd

#### 测试 10: pslog

- 测试 10: pslog

#### 测试 11: killall with signals

- List signal names
- Test signal send

#### 测试 12: fuser special cases

- fuser on unix socket
- fuser reset signal output

#### 测试 13: Error handling

- 测试 13: Error handling

</details>

---

## publicsuffix-list

<details>
<summary><b>publicsuffix-list — 1 个用例 / 1 个功能点</b></summary>

#### 主要功能点

- 锟叫筹拷锟斤拷锟侥硷拷

</details>

---

## pyproject-rpm-macros

<details>
<summary><b>pyproject-rpm-macros — 1 个用例 / 1 个功能点</b></summary>

#### 主要功能点

- 锟叫筹拷锟斤拷锟侥硷拷

</details>

---

## python

<details>
<summary><b>python — 5 个用例 / 8 个功能点</b></summary>

#### 测试 1: 基本执行

- Python 基本运算
- Python sys模块

#### 测试 2: 命令行选项

- python3 -h: 帮助
- python3 -V: 版本
- python3: os模块

#### 测试 3: 脚本执行

- python3 执行脚本

#### 测试 4: 模块导入

- python3: 导入标准模块

#### 测试 5: 错误处理

- python3: 导入错误

</details>

---

## python-lxml

<details>
<summary><b>python-lxml — 1 个用例 / 2 个功能点</b></summary>

#### 主要功能点

- 查找 .so 库文件
- 检查包已安装

</details>

---

## python-packaging

<details>
<summary><b>python-packaging — 1 个用例 / 1 个功能点</b></summary>

#### 主要功能点

- 锟叫筹拷锟斤拷锟侥硷拷

</details>

---

## python-pip

<details>
<summary><b>python-pip — 1 个用例 / 1 个功能点</b></summary>

#### 主要功能点

- 锟斤拷取 pip3 锟芥本

</details>

---

## python-rpm-macros

<details>
<summary><b>python-rpm-macros — 1 个用例 / 1 个功能点</b></summary>

#### 主要功能点

- 锟叫筹拷锟斤拷锟侥硷拷

</details>

---

## python-srpm-macros

<details>
<summary><b>python-srpm-macros — 1 个用例 / 1 个功能点</b></summary>

#### 主要功能点

- 锟叫筹拷锟斤拷锟侥硷拷

</details>

---

## readline

<details>
<summary><b>readline — 1 个用例 / 2 个功能点</b></summary>

#### 主要功能点

- 查找 .so 库文件
- 检查包已安装

</details>

---

## rpm

<details>
<summary><b>rpm — 1 个用例 / 1 个功能点</b></summary>

#### 主要功能点

- rpm 锟芥本

</details>

---

## rpm-config-openruyi

<details>
<summary><b>rpm-config-openruyi — 1 个用例 / 2 个功能点</b></summary>

#### 测试 1: 版本和帮助

- 列出包文件
- 库文件检查

</details>

---

## rpmbuild

<details>
<summary><b>rpmbuild — 9 个用例 / 20 个功能点</b></summary>

#### 测试 1: rpmbuild basic functionality

- Check rpmbuild version
- Setup RPM build tree

#### 测试 2: Create simple spec file

- Create minimal spec file

#### 测试 3: Create source tarball

- Create test source
- Verify source file

#### 测试 4: Build RPM package

- Build binary RPM
- Build source RPM

#### 测试 5: Verify built RPM

- Query RPM info
- Verify RPM dependencies
- Check RPM provides

#### 测试 6: Install and test RPM

- Install the RPM (test mode)
- Actually install
- Verify installation

#### 测试 7: RPM build options

- Build with --define
- Check build log

#### 测试 8: Error handling

- Build with missing spec file
- Build with missing source

#### 测试 9: RPM verification

- Verify RPM signature (may not be signed)
- Check RPM integrity
- Cleanup

</details>

---

## sddm

<details>
<summary><b>sddm — 5 个用例 / 10 个功能点</b></summary>

#### 测试 1: Version and help

- sddm help
- sddm --test-mode help

#### 测试 2: Configuration

- sddm: example config
- Config directory
- Default config dir

#### 测试 3: Service check

- sddm service unit
- sddm service status
- sddm enabled status

#### 测试 4: Theme check

- sddm themes installed

#### 测试 5: Config values

- sddm: key config values

</details>

---

## sed

<details>
<summary><b>sed — 6 个用例 / 12 个功能点</b></summary>

#### 测试 1: 基本替换

- sed s: 基本替换
- sed s: 替换hello

#### 测试 2: 行操作

- sed -n: 打印指定行
- sed d: 删除指定行
- sed a: 追加行
- sed i: 插入行

#### 测试 3: 全局和正则

- sed g: 全局替换
- sed: 正则替换

#### 测试 4: 就地编辑

- sed -i: 就地编辑
- sed -i: 验证修改

#### 测试 5: 多表达式

- sed -e: 多表达式

#### 测试 6: 错误处理

- sed: 无效选项

</details>

---

## setup

<details>
<summary><b>setup — 1 个用例 / 1 个功能点</b></summary>

#### 主要功能点

- 锟叫筹拷锟斤拷锟侥硷拷

</details>

---

## slang

<details>
<summary><b>slang — 1 个用例 / 1 个功能点</b></summary>

#### 主要功能点

- 锟斤拷取 slsh 锟芥本锟斤拷息

</details>

---

## sqlite

<details>
<summary><b>sqlite — 1 个用例 / 2 个功能点</b></summary>

#### 主要功能点

- 锟斤拷取 sqldiff 锟芥本锟斤拷息
- 锟斤拷取 sqlite3 锟芥本锟斤拷息

</details>

---

## systemd

<details>
<summary><b>systemd — 36 个用例 / 114 个功能点</b></summary>

#### 测试 1: systemctl - Service and system management

- systemctl version
- systemctl: list running services
- systemctl: list targets
- systemctl --all: all services
- systemctl: list unit files
- systemctl is-active: check service status
- systemctl is-enabled: check enabled
- systemctl is-failed: list failed units
- systemctl status: service status
- systemctl show: service properties
- systemctl cat: show unit file
- systemctl list-dependencies
- systemctl list-sockets
- systemctl list-timers
- systemctl list-machines

#### 测试 2: journalctl - Journal query

- journalctl version
- journalctl -n: last entries
- journalctl -b: current boot
- journalctl --list-boots
- journalctl -k: kernel messages
- journalctl -o short: short format
- journalctl -o json: json format
- journalctl -o verbose
- journalctl --disk-usage
- journalctl --output=cat
- journalctl -p err: error messages
- journalctl --since
- journalctl -q: quiet

#### 测试 3: systemd-analyze - System profiling

- systemd-analyze version
- systemd-analyze time: boot time
- systemd-analyze security

#### 测试 4: hostnamectl - Hostname management

- hostnamectl version
- hostnamectl status: system info
- hostnamectl hostname: current name
- hostnamectl --static
- hostnamectl --transient
- hostnamectl --pretty
- hostnamectl chassis

#### 测试 5: localectl - Locale management

- localectl version
- localectl status: locale info
- localectl list-locales

#### 测试 6: timedatectl - Time/date management

- timedatectl version
- timedatectl status: time info
- timedatectl show: all properties
- timedatectl list-timezones
- timedatectl show-timesync

#### 测试 7: loginctl - Login management

- loginctl version
- loginctl list-sessions
- loginctl list-users
- loginctl show-session
- loginctl show-user
- loginctl user-status

#### 测试 8: systemd-detect-virt

- systemd-detect-virt: detect VM
- systemd-detect-virt -q: quiet mode
- systemd-detect-virt -c: container only
- systemd-detect-virt -v: VM only
- systemd-detect-virt -r: chroot only

#### 测试 9: systemd-cgls - Cgroup listing

- systemd-cgls: cgroup tree
- systemd-cgls -k: kernel threads
- systemd-cgls --no-pager

#### 测试 10: systemd-cgtop - Cgroup top

- systemd-cgtop -b: batch mode

#### 测试 11: systemd-tmpfiles

- systemd-tmpfiles version
- systemd-tmpfiles --cat-config

#### 测试 12: busctl - D-Bus introspection

- busctl version
- busctl list: list services
- busctl status: bus status
- busctl tree: object tree
- busctl introspect

#### 测试 13: systemd-run

- systemd-run version
- systemd-run --user --scope

#### 测试 14: systemd-cat

- systemd-cat: pipe to journal
- systemd-cat version

#### 测试 15: systemd-notify

- systemd-notify version
- systemd-notify help

#### 测试 16: systemd-path

- systemd-path: all paths
- systemd-path: specific path
- systemd-path --suffix
- systemd-path help

#### 测试 17: systemd-escape

- systemd-escape: basic escape
- systemd-escape --path: path escape
- systemd-escape -u: unescape
- systemd-escape --suffix
- systemd-escape --template

#### 测试 18: systemd-machine-id-setup

- systemd-machine-id-setup help
- systemd-machine-id-setup: check machine-id

#### 测试 19: coredumpctl

- coredumpctl version
- coredumpctl list: list dumps
- coredumpctl info

#### 测试 20: systemd-delta

- systemd-delta help
- systemd-delta: show overrides

#### 测试 21: systemd-id128

- systemd-id128 show: show IDs
- systemd-id128 new: generate ID

#### 测试 22: systemd-inhibit

- systemd-inhibit help
- systemd-inhibit --list

#### 测试 23: systemd-ac-power

- systemd-ac-power: check power

#### 测试 24: systemd-ask-password

- systemd-ask-password help

#### 测试 25: systemd-creds

- systemd-creds help

#### 测试 26: systemd-socket-activate

- systemd-socket-activate help

#### 测试 27: Power management commands

- $cmd help

#### 测试 28: systemd-firstboot

- systemd-firstboot help

#### 测试 29: systemd-stdio-bridge

- systemd-stdio-bridge help

#### 测试 30: oomctl

- oomctl help
- oomctl dump

#### 测试 31: systemctl service operations

- systemctl try-restart
- systemctl reload-or-restart
- systemctl reset-failed
- systemctl daemon-reload

#### 测试 32: run0 - Privilege escalation

- run0 help

#### 测试 33: systemd-mount

- systemd-mount help

#### 测试 34: systemd-sysext

- systemd-sysext help

#### 测试 35: systemd-confext

- systemd-confext help

#### 测试 36: Error handling

- systemctl: invalid command
- journalctl: invalid option
- hostnamectl: invalid option

</details>

---

## systemd-timesyncd

<details>
<summary><b>systemd-timesyncd — 5 个用例 / 13 个功能点</b></summary>

#### 测试 1: Service status

- Service status
- Time sync status
- Timesync detail
- Is enabled

#### 测试 2: NTP management

- Fallback NTP servers
- Current NTP server
- Server address
- NTP servers list

#### 测试 3: Service control

- Restart service
- Is active

#### 测试 4: Configuration

- Config file
- Cat config

#### 测试 5: systemd-time-wait-sync

- Wait sync service

</details>

---

## tar

<details>
<summary><b>tar — 10 个用例 / 27 个功能点</b></summary>

#### 测试 1: Basic archive creation

- Create test files
- Create tar archive
- List archive contents

#### 测试 2: Archive extraction

- Extract archive
- Verify extracted files

#### 测试 3: Compression formats

- Create gzip compressed archive
- Create bzip2 compressed archive
- Create xz compressed archive
- Extract different formats

#### 测试 4: Advanced tar options

- Append files to existing archive
- Extract specific files
- Extract to different directory
- Create archive from directory

#### 测试 5: Archive verification

- Test archive integrity
- Compare archive with original files

#### 测试 6: Special attributes

- Preserve permissions
- Preserve timestamps

#### 测试 7: Error handling

- Non-existent file
- Corrupted archive
- Empty archive

#### 测试 8: Wildcard and patterns

- Extract with wildcard pattern
- Exclude patterns

#### 测试 9: Incremental backup

- Create incremental backup
- Multi-volume archive (test only)

#### 测试 10: Special file types

- Archive with symlinks
- Archive with hardlinks
- Cleanup

</details>

---

## tcsh

<details>
<summary><b>tcsh — 1 个用例 / 1 个功能点</b></summary>

#### 主要功能点

- 锟斤拷取 tcsh 锟芥本锟斤拷息

</details>

---

## time

<details>
<summary><b>time — 1 个用例 / 1 个功能点</b></summary>

#### 主要功能点

- 锟斤拷取 time 锟芥本锟斤拷息

</details>

---

## tmux

<details>
<summary><b>tmux — 22 个用例 / 179 个功能点</b></summary>

#### 测试 1: Server management

- start-server: start tmux server
- list-sessions: initial state
- has-session: check nonexistent
- list-clients: list connected clients
- list-commands: list all commands
- list-commands: filter specific command
- list-commands: format output
- server-access -l: list access

#### 测试 2: Session creation and management

- new-session -d: create detached session
- has-session: verify session exists
- new-session -d: with start directory
- has-session: verify sess2 exists
- new-session -e: set environment
- new-session -F: format output
- new-session: set dimensions
- new-session -A: attach if exists
- list-sessions: list all sessions
- list-sessions -F: formatted
- rename-session: rename sess2
- has-session: verify renamed session
- lock-session: lock session
- switch-client -t: switch to session
- attach-session -d: attach and detach others
- detach-client -P
- detach-client -a: all in session
- suspend-client: suspend client
- lock-client: lock client
- refresh-client -S: status line only
- refresh-client -L: lease

#### 测试 3: Window management

- new-window: create window
- new-window -d: detached
- new-window -c: with directory
- new-window -e: with env
- list-windows: list all windows
- list-windows -a: all sessions
- list-windows -F: formatted
- select-window: by name
- select-window: by index
- select-window -l: last window
- select-window -n: next
- select-window -p: previous
- rename-window: rename window
- next-window: next
- previous-window: prev
- last-window: last
- move-window -a: after
- move-window -b: before
- swap-window
- link-window: link window
- unlink-window: unlink
- kill-window: create temp window
- kill-window: kill window
- rotate-window: rotate
- rotate-window -D: downward
- respawn-window -k: respawn
- resize-window: set size
- resize-window -U: up
- resize-window -D: down

#### 测试 4: Pane management

- split-window: horizontal split
- split-window -h: vertical split
- split-window -v: vertical explicit
- split-window -l: with size
- split-window -d: don't focus
- split-window -f: full size
- split-window -b: before
- split-window -I: create empty pane
- list-panes: list panes
- list-panes -as: all panes
- list-panes -F: formatted
- display-panes: show pane IDs
- select-pane: by ID
- select-pane -l: last pane
- select-pane -U: up
- select-pane -D: down
- select-pane -L: left
- select-pane -R: right
- resize-pane -y: height
- resize-pane -x: width
- resize-pane -U: up
- resize-pane -D: down
- resize-pane -L: left
- resize-pane -R: right
- resize-pane -Z: zoom
- break-pane -d: break pane to new window
- join-pane: join pane back
- move-pane: move pane
- swap-pane: swap panes
- last-pane: switch to last pane
- kill-pane: create temp pane
- kill-pane: kill pane
- kill-pane -a: kill all but current
- capture-pane -p: print to stdout
- capture-pane: range capture
- capture-pane -J: join lines
- pipe-pane -o: pipe output
- respawn-pane -k: respawn

#### 测试 5: Layout management

- select-layout: even-horizontal
- select-layout: even-vertical
- select-layout: main-horizontal
- select-layout: main-vertical
- select-layout: tiled
- next-layout: cycle layouts
- previous-layout: prev layout

#### 测试 6: Buffer management

- set-buffer -b: named buffer
- set-buffer: direct data
- set-buffer -a: append
- list-buffers: list all buffers
- list-buffers -F: formatted
- show-buffer: show buffer contents
- paste-buffer: paste buffer
- paste-buffer -d: delete after paste
- delete-buffer: create temp buffer
- delete-buffer: delete buffer
- save-buffer: create buffer
- save-buffer: save to file
- load-buffer: load from file

#### 测试 7: Key bindings and input

- list-keys: list all keys
- list-keys -T: prefix table
- list-keys -T: root table
- list-keys -a: all keys
- list-keys -N: with notes
- bind-key -n: bind to key
- unbind-key -n: unbind key
- bind-key -T: bind in table
- unbind-key -T: unbind in table
- send-keys: send text
- send-keys -l: literal
- send-keys -H: hex
- send-prefix: send prefix key

#### 测试 8: Options and settings

- set-option -g: global
- set-option -a: append
- set-option: mouse on
- set-option -s: server option
- set-window-option: monitor activity
- set-window-option -g: global
- show-options -g: global options
- show-options -s: server options
- show-window-options: window options
- show-window-options -g: global window options

#### 测试 9: Environment variables

- set-environment -g: global env
- set-environment: session env
- set-environment -gur: update then remove
- show-environment -g: global env
- show-environment: session env

#### 测试 10: Hooks

- set-hook: session-created
- set-hook: client-attached
- show-hooks -g: global hooks
- set-hook -gu: remove global hook
- set-hook -gu: remove hook

#### 测试 11: Messages and display

- display-message: show message
- display-message -p: print format
- show-messages: message log
- display-popup -C: close popup
- clear-history: clear pane history

#### 测试 12: Conditional and shell execution

- if-shell: true condition
- run-shell: run shell command
- run-shell -b: background
- command-prompt: open prompt
- confirm-before: confirm dialog

#### 测试 13: Source and configuration

- source-file: source config

#### 测试 14: Copy mode

- copy-mode: enter copy mode

#### 测试 15: Find window

- find-window: search windows

#### 测试 16: Choose commands (interactive)

- choose-tree -G: tree display
- choose-client: client selection

#### 测试 17: Clock mode

- clock-mode: show clock

#### 测试 18: Lock management

- lock-server: lock server
- lock-session: lock session

#### 测试 19: Show prompt history

- show-prompt-history: prompt history
- clear-prompt-history: clear prompt history

#### 测试 20: Wait-for (event channels)

- wait-for -L: lock channel

#### 测试 21: Cleanup - kill sessions

- kill-session: kill renamed_sess
- kill-session: kill sess_fmt
- kill-session: kill sess_sz
- kill-session: kill sess_flags
- kill-session: kill sess_env
- kill-session: kill main test session
- kill-server: terminate server

#### 测试 22: Error handling

- Error: nonexistent session
- Error: invalid option

</details>

---

## tzdata

<details>
<summary><b>tzdata — 1 个用例 / 3 个功能点</b></summary>

#### 主要功能点

- 锟斤拷取 tzselect 锟芥本锟斤拷息
- 锟斤拷取 zdump 锟芥本锟斤拷息
- 锟斤拷取 zic 锟芥本锟斤拷息

</details>

---

## unzip

<details>
<summary><b>unzip — 1 个用例 / 4 个功能点</b></summary>

#### 主要功能点

- 锟斤拷取 unzip 锟芥本锟斤拷息
- 锟斤拷取 funzip 锟芥本锟斤拷息
- 锟斤拷取 zipgrep 锟芥本锟斤拷息
- 锟斤拷取 zipinfo 锟芥本锟斤拷息

</details>

---

## util-linux

<details>
<summary><b>util-linux — 2 个用例 / 31 个功能点</b></summary>

#### 测试 1: 版本和帮助

- addpart 版本信息
- addpart 帮助信息
- agetty 版本信息
- agetty 帮助信息
- blkid 版本信息
- blkid 帮助信息
- blkdiscard 版本信息
- blkdiscard 帮助信息
- blockdev 版本信息
- blockdev 帮助信息
- cal 版本信息
- cal 帮助信息
- cfdisk 版本信息
- cfdisk 帮助信息
- chcpu 版本信息
- chcpu 帮助信息
- chfn 版本信息
- chfn 帮助信息
- chmem 版本信息
- chmem 帮助信息
- choom 版本信息
- choom 帮助信息
- chrt 版本信息
- chrt 帮助信息
- bits 版本信息
- bits 帮助信息
- blkpr 版本信息
- blkpr 帮助信息
- blkzone 版本信息
- blkzone 帮助信息

#### 测试 2: 错误处理

- addpart: 无效选项

</details>

---

## vim

<details>
<summary><b>vim — 1 个用例 / 1 个功能点</b></summary>

#### 主要功能点

- 锟斤拷取 vim 锟芥本

</details>

---

## weston

<details>
<summary><b>weston — 9 个用例 / 9 个功能点</b></summary>

#### 测试 1: Version

- weston version

#### 测试 2: Help

- weston help

#### 测试 3: Weston terminal (headless)

- weston-terminal help

#### 测试 4: Weston debug

- weston-debug help

#### 测试 5: Screenshooter

- weston-screenshooter help

#### 测试 6: wcap-decode

- wcap-decode help

#### 测试 7: Backend check

- Available backends

#### 测试 8: Headless backend test

- weston: headless backend

#### 测试 9: Error handling

- weston: invalid option

</details>

---

## wget

<details>
<summary><b>wget — 15 个用例 / 18 个功能点</b></summary>

#### 测试 1: Basic download

- Test downloading a small file

#### 测试 2: Output options

- 测试 2: Output options

#### 测试 3: Verbose and quiet modes

- 测试 3: Verbose and quiet modes

#### 测试 4: Spider mode

- 测试 4: Spider mode

#### 测试 5: Header options

- 测试 5: Header options

#### 测试 6: User agent

- 测试 6: User agent

#### 测试 7: Timeout and retries

- 测试 7: Timeout and retries

#### 测试 8: Recursive download

- Test mirror mode (limited depth)

#### 测试 9: Continue and mirror

- Test continue option

#### 测试 10: Rate limiting

- 测试 10: Rate limiting

#### 测试 11: Progress indicators

- 测试 11: Progress indicators

#### 测试 12: Error handling

- Invalid URL
- 404 error
- Invalid option

#### 测试 13: Directory listing

- 测试 13: Directory listing

#### 测试 14: Timestamps

- 测试 14: Timestamps

#### 测试 15: Special features

- Follow redirects (default)
- Content disposition

</details>

---

## wget2

<details>
<summary><b>wget2 — 15 个用例 / 17 个功能点</b></summary>

#### 测试 1: Basic download

- 测试 1: Basic download

#### 测试 2: Output file options

- 测试 2: Output file options

#### 测试 3: Verbose modes

- 测试 3: Verbose modes

#### 测试 4: Spider mode

- 测试 4: Spider mode

#### 测试 5: Headers

- 测试 5: Headers

#### 测试 6: User agent

- 测试 6: User agent

#### 测试 7: Timeouts and retries

- 测试 7: Timeouts and retries

#### 测试 8: Continue download

- 测试 8: Continue download

#### 测试 9: Rate limiting

- 测试 9: Rate limiting

#### 测试 10: HTTP/2 support

- 测试 10: HTTP/2 support

#### 测试 11: TLS options

- 测试 11: TLS options

#### 测试 12: Error handling

- Invalid URL
- 404 error
- Invalid option

#### 测试 13: Follow redirects

- 测试 13: Follow redirects

#### 测试 14: Content disposition

- 测试 14: Content disposition

#### 测试 15: Plugin system

- 测试 15: Plugin system

</details>

---

## which

<details>
<summary><b>which — 1 个用例 / 1 个功能点</b></summary>

#### 主要功能点

- 锟斤拷取 which 锟芥本锟斤拷息

</details>

---

## xz

<details>
<summary><b>xz — 2 个用例 / 31 个功能点</b></summary>

#### 测试 1: 版本和帮助

- xz 版本信息
- xz 帮助信息
- unxz 版本信息
- unxz 帮助信息
- xzcat 版本信息
- xzcat 帮助信息
- lzma 版本信息
- lzma 帮助信息
- unlzma 版本信息
- unlzma 帮助信息
- lzcat 版本信息
- lzcat 帮助信息
- lzcmp 版本信息
- lzcmp 帮助信息
- lzdiff 版本信息
- lzdiff 帮助信息
- lzgrep 版本信息
- lzgrep 帮助信息
- lzless 版本信息
- lzless 帮助信息
- lzmore 版本信息
- lzmore 帮助信息
- lzmadec 版本信息
- lzmadec 帮助信息
- lzmainfo 版本信息
- lzmainfo 帮助信息
- lzegrep 版本信息
- lzegrep 帮助信息
- lzfgrep 版本信息
- lzfgrep 帮助信息

#### 测试 2: 错误处理

- xz: 无效选项

</details>

---

## zstd

<details>
<summary><b>zstd — 2 个用例 / 13 个功能点</b></summary>

#### 测试 1: 版本和帮助

- zstd 版本信息
- zstd 帮助信息
- unzstd 版本信息
- unzstd 帮助信息
- zstdcat 版本信息
- zstdcat 帮助信息
- zstdgrep 版本信息
- zstdgrep 帮助信息
- zstdless 版本信息
- zstdless 帮助信息
- zstdmt 版本信息
- zstdmt 帮助信息

#### 测试 2: 错误处理

- zstd: 无效选项

</details>
