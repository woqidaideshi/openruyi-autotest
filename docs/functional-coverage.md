# 功能测试覆盖详情

> 最后更新: 2026-06-13 | 自动生成
> 测试环境: openEuler (10.20.237.192)

共 **147** 个软件包，**1424** 个测试用例（1292 rlRun + 132 分段 + 0 简单检查）

## 全部软件包一览

| 软件包 | 用例数 | 类型 |
|--------|:---:|:---:|
| [acl](#acl) | 89 | rlRun |
| [attr](#attr) | 7 | rlRun |
| [audit](#audit) | 15 | rlRun |
| [authselect](#authselect) | 1 | rlRun |
| [bash](#bash) | 9 | rlRun |
| [bash-completion](#bashcompletion) | 1 | rlRun |
| [bc](#bc) | 2 | rlRun |
| [beakerlib](#beakerlib) | 1 | 分段 |
| [binutils](#binutils) | 1 | 分段 |
| [brotli](#brotli) | 1 | rlRun |
| [bzip2](#bzip2) | 1 | rlRun |
| [ca-certificates](#cacertificates) | 3 | rlRun |
| [ca-certificates-mozilla](#cacertificatesmozilla) | 2 | rlRun |
| [chkconfig](#chkconfig) | 1 | rlRun |
| [clang](#clang) | 26 | rlRun |
| [cloud-utils-growpart](#cloudutilsgrowpart) | 10 | rlRun |
| [cmake](#cmake) | 6 | 分段 |
| [coreutils](#coreutils) | 237 | rlRun |
| [cpio](#cpio) | 1 | rlRun |
| [cracklib](#cracklib) | 1 | 分段 |
| [cryptsetup](#cryptsetup) | 3 | rlRun |
| [curl](#curl) | 12 | rlRun |
| [dbus](#dbus) | 1 | rlRun |
| [dbus-broker](#dbusbroker) | 1 | rlRun |
| [debugedit](#debugedit) | 5 | rlRun |
| [diffutils](#diffutils) | 4 | rlRun |
| [dnf5-plugins](#dnf5plugins) | 11 | rlRun |
| [dwz](#dwz) | 3 | rlRun |
| [e2fsprogs](#e2fsprogs) | 1 | 分段 |
| [elfutils](#elfutils) | 31 | rlRun |
| [expat](#expat) | 1 | rlRun |
| [file](#file) | 1 | rlRun |
| [filesystem](#filesystem) | 2 | rlRun |
| [findutils](#findutils) | 15 | rlRun |
| [gawk](#gawk) | 2 | rlRun |
| [gcc](#gcc) | 54 | rlRun |
| [gcc16](#gcc16) | 1 | 分段 |
| [git](#git) | 1 | rlRun |
| [glib](#glib) | 1 | 分段 |
| [glibc](#glibc) | 17 | rlRun |
| [gmp](#gmp) | 2 | rlRun |
| [gnutls](#gnutls) | 1 | 分段 |
| [grep](#grep) | 45 | rlRun |
| [gzip](#gzip) | 29 | rlRun |
| [icu4c](#icu4c) | 1 | 分段 |
| [iproute2](#iproute2) | 1 | 分段 |
| [iputils](#iputils) | 10 | 分段 |
| [isl](#isl) | 2 | rlRun |
| [iso-codes](#isocodes) | 1 | rlRun |
| [jitterentropy](#jitterentropy) | 2 | rlRun |
| [json-c](#jsonc) | 2 | rlRun |
| [kbd](#kbd) | 1 | 分段 |
| [keyutils](#keyutils) | 1 | 分段 |
| [kmod](#kmod) | 1 | 分段 |
| [krb5](#krb5) | 1 | 分段 |
| [labwc](#labwc) | 10 | rlRun |
| [less](#less) | 3 | rlRun |
| [libaio](#libaio) | 2 | rlRun |
| [libarchive](#libarchive) | 2 | rlRun |
| [libbpf](#libbpf) | 2 | rlRun |
| [libcap](#libcap) | 2 | rlRun |
| [libcap-ng](#libcapng) | 2 | rlRun |
| [libeconf](#libeconf) | 2 | rlRun |
| [libedit](#libedit) | 2 | rlRun |
| [libevent](#libevent) | 2 | rlRun |
| [libffi](#libffi) | 2 | rlRun |
| [libgcrypt](#libgcrypt) | 2 | rlRun |
| [libgpg-error](#libgpgerror) | 2 | rlRun |
| [libidn2](#libidn2) | 1 | rlRun |
| [libmnl](#libmnl) | 2 | rlRun |
| [libnetfilter_conntrack](#libnetfilter_conntrack) | 2 | rlRun |
| [libnfnetlink](#libnfnetlink) | 2 | rlRun |
| [libnftnl](#libnftnl) | 2 | rlRun |
| [libnl](#libnl) | 2 | rlRun |
| [libpng](#libpng) | 1 | rlRun |
| [libpsl](#libpsl) | 2 | rlRun |
| [libpwquality](#libpwquality) | 2 | rlRun |
| [libseccomp](#libseccomp) | 2 | rlRun |
| [libselinux](#libselinux) | 2 | rlRun |
| [libsepol](#libsepol) | 2 | rlRun |
| [libtasn1](#libtasn1) | 3 | rlRun |
| [libtirpc](#libtirpc) | 2 | rlRun |
| [libunistring](#libunistring) | 2 | rlRun |
| [libxcrypt](#libxcrypt) | 2 | rlRun |
| [libxml2](#libxml2) | 2 | rlRun |
| [libxslt](#libxslt) | 1 | rlRun |
| [linux-headers](#linuxheaders) | 2 | rlRun |
| [lua](#lua) | 5 | rlRun |
| [lvm2](#lvm2) | 1 | 分段 |
| [lz4](#lz4) | 4 | rlRun |
| [make](#make) | 23 | rlRun |
| [mpc](#mpc) | 2 | rlRun |
| [mpdecimal](#mpdecimal) | 2 | rlRun |
| [mpfr](#mpfr) | 2 | rlRun |
| [ncurses](#ncurses) | 1 | 分段 |
| [nettle](#nettle) | 11 | rlRun |
| [newt](#newt) | 3 | rlRun |
| [nghttp2](#nghttp2) | 2 | rlRun |
| [openruyi-release](#openruyirelease) | 1 | rlRun |
| [openssh](#openssh) | 1 | rlRun |
| [openssh-clients](#opensshclients) | 19 | rlRun |
| [openssl](#openssl) | 1 | rlRun |
| [p11-kit](#p11kit) | 1 | 分段 |
| [pam](#pam) | 11 | rlRun |
| [patch](#patch) | 1 | rlRun |
| [pciutils](#pciutils) | 13 | 分段 |
| [pcre2](#pcre2) | 2 | rlRun |
| [perl](#perl) | 1 | rlRun |
| [pkgconf](#pkgconf) | 5 | rlRun |
| [podman](#podman) | 18 | rlRun |
| [podmansh](#podmansh) | 11 | 分段 |
| [popt](#popt) | 2 | rlRun |
| [procps-ng](#procpsng) | 14 | 分段 |
| [psmisc](#psmisc) | 13 | 分段 |
| [publicsuffix-list](#publicsuffixlist) | 1 | rlRun |
| [pyproject-rpm-macros](#pyprojectrpmmacros) | 1 | rlRun |
| [python](#python) | 9 | rlRun |
| [python-lxml](#pythonlxml) | 2 | rlRun |
| [python-packaging](#pythonpackaging) | 1 | rlRun |
| [python-pip](#pythonpip) | 1 | rlRun |
| [python-rpm-macros](#pythonrpmmacros) | 1 | rlRun |
| [python-srpm-macros](#pythonsrpmmacros) | 1 | rlRun |
| [readline](#readline) | 2 | rlRun |
| [rpm](#rpm) | 1 | rlRun |
| [rpm-config-openruyi](#rpmconfigopenruyi) | 2 | rlRun |
| [rpmbuild](#rpmbuild) | 9 | 分段 |
| [sddm](#sddm) | 11 | rlRun |
| [sed](#sed) | 13 | rlRun |
| [setup](#setup) | 1 | rlRun |
| [slang](#slang) | 1 | rlRun |
| [sqlite](#sqlite) | 2 | rlRun |
| [systemd](#systemd) | 114 | rlRun |
| [systemd-timesyncd](#systemdtimesyncd) | 13 | rlRun |
| [tar](#tar) | 10 | 分段 |
| [tcsh](#tcsh) | 1 | rlRun |
| [time](#time) | 1 | rlRun |
| [tmux](#tmux) | 180 | rlRun |
| [tzdata](#tzdata) | 3 | rlRun |
| [unzip](#unzip) | 4 | rlRun |
| [util-linux](#utillinux) | 31 | rlRun |
| [vim](#vim) | 1 | rlRun |
| [weston](#weston) | 9 | rlRun |
| [wget](#wget) | 15 | 分段 |
| [wget2](#wget2) | 15 | 分段 |
| [which](#which) | 1 | rlRun |
| [xz](#xz) | 31 | rlRun |
| [zstd](#zstd) | 13 | rlRun |

---

## acl

<details>
<summary><b>acl — 89 个测试点</b></summary>

- 获取 getfacl 版本信息
- 获取 setfacl 版本信息
- 创建临时测试目录
- 进入测试目录
- 创建测试文件
- 创建测试目录
- 查看文件默认 ACL
- 查看目录默认 ACL
- 使用 -a 参数查看 access ACL
- 使用 -d 参数查看 default ACL
- 使用 -c 参数不显示注释头
- 使用 -n 参数显示数字 ID
- 使用 -t 参数表格输出
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
- 创建多层子目录
- 创建测试文件
- 递归设置 user ACL
- 验证递归设置 - file1
- 验证递归设置 - file2
- 递归删除所有扩展 ACL
- 验证递归删除 - file1
- 验证递归删除 - file2
- 创建符号链接
- 使用 -L 跟随符号链接设置 ACL
- 验证符号链接目标文件的 ACL
- 使用 -P 不跟随符号链接
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
- 设置目录 default ACL
- 在目录中创建新文件
- 验证新文件继承了 default ACL
- 在目录中创建子目录
- 验证子目录继承了 default ACL
- 设置完整权限
- 验证权限设置
- 设置 mask 限制有效权限
- 验证 mask 限制后的有效权限
- 设置多个用户和组 ACL
- 验证多个 ACL 条目
- 设置测试 ACL
- 导出 ACL 备份
- 清除 ACL
- 尝试恢复 ACL
- 使用 --test 模式不实际修改
- 验证 --test 模式未修改 ACL
- 离开测试目录
- 清理临时测试目录

</details>

---

## attr

<details>
<summary><b>attr — 7 个测试点</b></summary>

- 获取 attr 版本信息
- 获取 getfattr 版本信息
- 获取 setfattr 版本信息
- 创建临时目录/文件
- 切换工作目录
- 创建文件
- 创建目录

</details>

---

## audit

<details>
<summary><b>audit — 15 个测试点</b></summary>

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
- auditctl: 无效选项

</details>

---

## authselect

<details>
<summary><b>authselect — 1 个测试点</b></summary>

- 锟斤拷取 authselect 锟芥本

</details>

---

## bash

<details>
<summary><b>bash — 9 个测试点</b></summary>

- bash 版本
- sh 版本
- bash 执行脚本
- bash -c: for循环
- bash: if条件
- bash: 函数定义调用
- bash: 管道
- bashbug 帮助
- bash: 错误退出

</details>

---

## bash-completion

<details>
<summary><b>bash-completion — 1 个测试点</b></summary>

- 锟叫筹拷锟斤拷锟侥硷拷

</details>

---

## bc

<details>
<summary><b>bc — 2 个测试点</b></summary>

- 锟斤拷取 bc 锟芥本锟斤拷息
- 锟斤拷取 dc 锟芥本锟斤拷息

</details>

---

## beakerlib

<details>
<summary><b>beakerlib — 1 个测试点</b></summary>

- 基本安装验证: beakerlib

</details>

---

## binutils

<details>
<summary><b>binutils — 1 个测试点</b></summary>

- 基本安装验证: binutils

</details>

---

## brotli

<details>
<summary><b>brotli — 1 个测试点</b></summary>

- 锟斤拷取 brotli 锟芥本锟斤拷息

</details>

---

## bzip2

<details>
<summary><b>bzip2 — 1 个测试点</b></summary>

- 锟斤拷取 bzip2 锟芥本

</details>

---

## ca-certificates

<details>
<summary><b>ca-certificates — 3 个测试点</b></summary>

- update-ca-trust 版本信息
- update-ca-trust 帮助信息
- update-ca-trust: 无效选项

</details>

---

## ca-certificates-mozilla

<details>
<summary><b>ca-certificates-mozilla — 2 个测试点</b></summary>

- 列出包文件
- 库文件检查

</details>

---

## chkconfig

<details>
<summary><b>chkconfig — 1 个测试点</b></summary>

- 获取 chkconfig 版本信息

</details>

---

## clang

<details>
<summary><b>clang — 26 个测试点</b></summary>

- clang version
- Compile hello.c
- Run compiled binary
- Output is ELF binary
- Compile C++ from hello.c
- Run C++ binary
- clang -c: compile only
- Object file exists
- Optimization -$lvl
- Debug symbols
- -Wall warnings
- -Wextra warnings
- -Werror
- C standard: $std
- C++ standard: $std
- clang -E: preprocess
- clang -dM: dump macros
- clang --analyze: static analysis
- clang-cl help
- clang-cpp: preprocessor
- clang-scan-deps help
- Compile with -fPIC
- clang -shared: shared library
- clang -v: verbose
- Compilation error
- Invalid option

</details>

---

## cloud-utils-growpart

<details>
<summary><b>cloud-utils-growpart — 10 个测试点</b></summary>

- growpart help
- growpart -h: short help
- lsblk: list block devices
- df: disk free space
- growpart -N: dry run
- growpart: has free-percent option
- growpart: has fudge option
- growpart: no args (expected fail)
- growpart: nonexistent disk
- growpart: invalid option

</details>

---

## cmake

<details>
<summary><b>cmake — 6 个测试点</b></summary>

- 测试 1: Basic CMake project
- 测试 2: CMake configure
- 测试 3: CMake -E mode
- 测试 4: ctest and cpack
- 测试 5: Error handling
- 测试 6: CMake version and help

</details>

---

## coreutils

<details>
<summary><b>coreutils — 237 个测试点</b></summary>

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
- mkdir -p nested directories
- mkdir -p: verify nested dir
- mkdir -m set mode
- touch create file
- touch: file exists
- touch -t set timestamp
- touch -a access time only
- mktemp create temp file
- mktemp: temp file exists
- mktemp -d create temp directory
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
- od octal dump
- od -c character dump
- od -x hex dump
- od -A x hex address
- basename extract filename
- basename strip suffix
- dirname extract directory
- dirname path extraction
- pwd print working directory
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
- tee write to file
- tee: verify output
- tee -a append mode
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
- base32 encode
- base32 -d decode
- base64 encode
- base64 -d decode
- basenc --base64 encode
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
- true returns success
- false returns failure
- test -f: file exists
- test -d: directory exists
- test string equality
- test numeric comparison
- [ -f: file exists
- [ string equality
- env show environment
- env set variable for command
- printenv show PATH
- date current date/time
- date custom format
- date -u UTC time
- printf formatted output
- printf string output
- sleep delay
- timeout: command finishes in time
- timeout: successful completion
- timeout: kills slow command
- yes repeated output
- yes custom string
- nice adjust priority
- nohup run command
- stdbuf line buffered output
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
- split by lines
- split: multiple output files
- csplit split by pattern
- stty -a show all terminal settings
- pathchk validate path
- pathchk -p POSIX check
- tsort topological sort
- ptx permuted index
- dircolors -p print database
- dircolors output LS_COLORS
- cp: error on nonexistent source
- ls: error on nonexistent file
- mkdir: error on existing dir
- rm: error on dir without -r
- rmdir: error on non-empty dir

</details>

---

## cpio

<details>
<summary><b>cpio — 1 个测试点</b></summary>

- 锟斤拷取 cpio 锟芥本锟斤拷息

</details>

---

## cracklib

<details>
<summary><b>cracklib — 1 个测试点</b></summary>

- 基本安装验证: cracklib

</details>

---

## cryptsetup

<details>
<summary><b>cryptsetup — 3 个测试点</b></summary>

- cryptsetup 版本信息
- cryptsetup 帮助信息
- cryptsetup: 无效选项

</details>

---

## curl

<details>
<summary><b>curl — 12 个测试点</b></summary>

- curl 版本信息
- curl 下载示例页面
- curl -I: 仅获取响应头
- curl -o: 输出到文件
- curl -O: 远程文件名
- curl -v: 详细模式
- curl -s: 静默模式
- curl -L: 跟随重定向
- curl -k: 忽略SSL证书
- curl --connect-timeout: 连接超时
- wcurl 帮助
- curl: 无效选项

</details>

---

## dbus

<details>
<summary><b>dbus — 1 个测试点</b></summary>

- 锟斤拷取 dbus-launch 锟芥本

</details>

---

## dbus-broker

<details>
<summary><b>dbus-broker — 1 个测试点</b></summary>

- 锟斤拷取 dbus-broker 锟芥本锟斤拷息

</details>

---

## debugedit

<details>
<summary><b>debugedit — 5 个测试点</b></summary>

- debugedit 版本信息
- debugedit 帮助信息
- debugedit-classify-ar 版本信息
- debugedit-classify-ar 帮助信息
- debugedit: 无效选项

</details>

---

## diffutils

<details>
<summary><b>diffutils — 4 个测试点</b></summary>

- 锟斤拷取 cmp 锟芥本锟斤拷息
- 锟斤拷取 diff 锟芥本锟斤拷息
- 锟斤拷取 diff3 锟芥本锟斤拷息
- 锟斤拷取 sdiff 锟芥本锟斤拷息

</details>

---

## dnf5-plugins

<details>
<summary><b>dnf5-plugins — 11 个测试点</b></summary>

- dnf5 version
- dnf5 help
- Plugin files
- Plugin directory
- Check plugin: $plugin
- Plugin commands in help
- dnf5 repoquery help
- dnf5 repolist
- dnf5 list installed
- dnf5 info
- dnf5: invalid option

</details>

---

## dwz

<details>
<summary><b>dwz — 3 个测试点</b></summary>

- dwz 版本信息
- dwz 帮助信息
- dwz: 无效选项

</details>

---

## e2fsprogs

<details>
<summary><b>e2fsprogs — 1 个测试点</b></summary>

- 基本安装验证: e2fsprogs

</details>

---

## elfutils

<details>
<summary><b>elfutils — 31 个测试点</b></summary>

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
- eu-addr2line: 无效选项

</details>

---

## expat

<details>
<summary><b>expat — 1 个测试点</b></summary>

- 锟斤拷取 xmlwf 锟芥本锟斤拷息

</details>

---

## file

<details>
<summary><b>file — 1 个测试点</b></summary>

- 锟斤拷取 file 锟芥本锟斤拷息

</details>

---

## filesystem

<details>
<summary><b>filesystem — 2 个测试点</b></summary>

- 列出包文件
- 库文件检查

</details>

---

## findutils

<details>
<summary><b>findutils — 15 个测试点</b></summary>

- find 版本
- xargs 版本
- find -name: 按名称查找
- find -type f: 查找文件
- find -type d: 查找目录
- find -maxdepth: 最大深度
- find -mindepth: 最小深度
- find -empty: 空文件/目录
- find -size: 按大小
- find -exec: 执行命令
- find -delete: 删除文件
- find -delete: 验证删除
- xargs: 基本用法
- xargs -n1: 每次一个参数
- find: 无效路径

</details>

---

## gawk

<details>
<summary><b>gawk — 2 个测试点</b></summary>

- 锟斤拷取 awk 锟芥本锟斤拷息
- 锟斤拷取 gawk 锟芥本锟斤拷息

</details>

---

## gcc

<details>
<summary><b>gcc — 54 个测试点</b></summary>

- Get gcc version info
- Get g++ version info
- Compile hello.c to hello
- Run compiled hello
- Verify output is ELF binary
- Compile with -o flag
- Run myhello
- Compile hello.cpp
- Compile with C++11 standard
- Compile with -O0
- Compile with -O2
- Compile with debug symbols -g
- Verify debug symbols present
- Preprocess with -E
- Verify macro expanded in preprocessed output
- Compile preprocessed .i file
- Run from preprocessed source
- Compile with -D flag
- Run with -D defined macro
- Generate assembly with -S
- Check main label in assembly
- Assemble to object file
- Link with -lm
- Run math linked program
- Compile static binary
- Compile with -Wall warnings enabled
- Compile with -Werror
- Compile with -pedantic
- Compile add.c to object
- Compile main.c to object
- Link multiple objects
- Run multi-file program
- Compile multiple files in one command
- Run single-command multi-file program
- Compile with coverage flags
- Run coverage test program
- Run gcov
- Check gcov output file exists
- Test type mismatch warning
- Compile with C99 standard
- Compile with __attribute__
- Run attribute test
- Compile with -I include path
- Run include path test
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
<summary><b>gcc16 — 1 个测试点</b></summary>

- 基本安装验证: gcc16

</details>

---

## git

<details>
<summary><b>git — 1 个测试点</b></summary>

- 锟叫筹拷锟斤拷锟侥硷拷

</details>

---

## glib

<details>
<summary><b>glib — 1 个测试点</b></summary>

- 基本安装验证: glib

</details>

---

## glibc

<details>
<summary><b>glibc — 17 个测试点</b></summary>

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
- gencat: 无效选项

</details>

---

## gmp

<details>
<summary><b>gmp — 2 个测试点</b></summary>

- 列出包文件
- 库文件检查

</details>

---

## gnutls

<details>
<summary><b>gnutls — 1 个测试点</b></summary>

- 基本安装验证: gnutls

</details>

---

## grep

<details>
<summary><b>grep — 45 个测试点</b></summary>

- Get grep version info
- Basic grep for Hello
- Verify multiple matches
- Grep from pipe
- Grep across multiple files
- Case insensitive grep
- Verify case insensitive matches
- Case sensitive: lowercase only matches lowercase
- Invert match: exclude Hello
- Verify inverted output contains other lines
- Create word test file
- Add line with separate words
- Whole word match: hello matches only standalone
- Create line test file
- Add different line
- Whole line exact match
- Count matches with -c
- Verify count >= 2
- Show line numbers with -n
- Verify line number format
- Recursive grep in subdirectory
- Recursive list files with matches
- Recursive with --include filter
- Extended regex with alternation
- Extended regex: digit quantifier
- Verify digit match count
- egrep equivalent to grep -E
- Fixed string with special chars
- Fixed string: no regex meta-char interpretation
- fgrep equivalent to grep -F
- Only matching: digits only
- Quiet mode: pattern found
- Quiet mode: pattern not found
- Context: 1 line after match
- Context: 1 line before match
- Context: 1 line before and after
- List files with matches
- List files without matches
- Multiple patterns with -e
- Patterns from file with -f
- Max count: stop after first match
- Error on nonexistent file
- Error on invalid regex
- Error on directory without -r
- No match returns exit code 1

</details>

---

## gzip

<details>
<summary><b>gzip — 29 个测试点</b></summary>

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
- gzip: 无效选项

</details>

---

## icu4c

<details>
<summary><b>icu4c — 1 个测试点</b></summary>

- 基本安装验证: icu4c

</details>

---

## iproute2

<details>
<summary><b>iproute2 — 1 个测试点</b></summary>

- 基本安装验证: iproute2

</details>

---

## iputils

<details>
<summary><b>iputils — 10 个测试点</b></summary>

- 测试 1: ping basic functionality
- 测试 2: ping advanced options
- 测试 3: ping6 (IPv6)
- 测试 4: traceroute6
- 测试 5: tracepath
- 测试 6: arping
- 测试 7: clockdiff
- 测试 8: ping error handling
- 测试 9: ping special scenarios
- 测试 10: Network interface testing

</details>

---

## isl

<details>
<summary><b>isl — 2 个测试点</b></summary>

- 列出包文件
- 库文件检查

</details>

---

## iso-codes

<details>
<summary><b>iso-codes — 1 个测试点</b></summary>

- 锟叫筹拷锟斤拷锟侥硷拷

</details>

---

## jitterentropy

<details>
<summary><b>jitterentropy — 2 个测试点</b></summary>

- ldconfig 查找库文件
- 检查包已安装

</details>

---

## json-c

<details>
<summary><b>json-c — 2 个测试点</b></summary>

- ldconfig 查找库文件
- 检查包已安装

</details>

---

## kbd

<details>
<summary><b>kbd — 1 个测试点</b></summary>

- 基本安装验证: kbd

</details>

---

## keyutils

<details>
<summary><b>keyutils — 1 个测试点</b></summary>

- 基本安装验证: keyutils

</details>

---

## kmod

<details>
<summary><b>kmod — 1 个测试点</b></summary>

- 基本安装验证: kmod

</details>

---

## krb5

<details>
<summary><b>krb5 — 1 个测试点</b></summary>

- 基本安装验证: krb5

</details>

---

## labwc

<details>
<summary><b>labwc — 10 个测试点</b></summary>

- labwc help
- labwc: config options
- labwc: debug option
- labwc: startup/session options
- labwc: linked libraries
- labnag help
- lab-sensible-terminal help
- System config dir
- Data dir
- labwc: invalid option

</details>

---

## less

<details>
<summary><b>less — 3 个测试点</b></summary>

- 锟斤拷取 less 锟芥本锟斤拷息
- 锟斤拷取 lessecho 锟芥本锟斤拷息
- 锟斤拷取 lesskey 锟芥本锟斤拷息

</details>

---

## libaio

<details>
<summary><b>libaio — 2 个测试点</b></summary>

- ldconfig 查找库文件
- 检查包已安装

</details>

---

## libarchive

<details>
<summary><b>libarchive — 2 个测试点</b></summary>

- ldconfig 查找库文件
- 检查包已安装

</details>

---

## libbpf

<details>
<summary><b>libbpf — 2 个测试点</b></summary>

- ldconfig 查找库文件
- 检查包已安装

</details>

---

## libcap

<details>
<summary><b>libcap — 2 个测试点</b></summary>

- ldconfig 查找库文件
- 检查包已安装

</details>

---

## libcap-ng

<details>
<summary><b>libcap-ng — 2 个测试点</b></summary>

- ldconfig 查找库文件
- 检查包已安装

</details>

---

## libeconf

<details>
<summary><b>libeconf — 2 个测试点</b></summary>

- ldconfig 查找库文件
- 检查包已安装

</details>

---

## libedit

<details>
<summary><b>libedit — 2 个测试点</b></summary>

- ldconfig 查找库文件
- 检查包已安装

</details>

---

## libevent

<details>
<summary><b>libevent — 2 个测试点</b></summary>

- ldconfig 查找库文件
- 检查包已安装

</details>

---

## libffi

<details>
<summary><b>libffi — 2 个测试点</b></summary>

- ldconfig 查找库文件
- 检查包已安装

</details>

---

## libgcrypt

<details>
<summary><b>libgcrypt — 2 个测试点</b></summary>

- ldconfig 查找库文件
- 检查包已安装

</details>

---

## libgpg-error

<details>
<summary><b>libgpg-error — 2 个测试点</b></summary>

- ldconfig 查找库文件
- 检查包已安装

</details>

---

## libidn2

<details>
<summary><b>libidn2 — 1 个测试点</b></summary>

- 锟斤拷取 idn2 锟芥本锟斤拷息

</details>

---

## libmnl

<details>
<summary><b>libmnl — 2 个测试点</b></summary>

- ldconfig 查找库文件
- 检查包已安装

</details>

---

## libnetfilter_conntrack

<details>
<summary><b>libnetfilter_conntrack — 2 个测试点</b></summary>

- ldconfig 查找库文件
- 检查包已安装

</details>

---

## libnfnetlink

<details>
<summary><b>libnfnetlink — 2 个测试点</b></summary>

- ldconfig 查找库文件
- 检查包已安装

</details>

---

## libnftnl

<details>
<summary><b>libnftnl — 2 个测试点</b></summary>

- ldconfig 查找库文件
- 检查包已安装

</details>

---

## libnl

<details>
<summary><b>libnl — 2 个测试点</b></summary>

- ldconfig 查找库文件
- 检查包已安装

</details>

---

## libpng

<details>
<summary><b>libpng — 1 个测试点</b></summary>

- 锟斤拷取 pngfix 锟芥本锟斤拷息

</details>

---

## libpsl

<details>
<summary><b>libpsl — 2 个测试点</b></summary>

- ldconfig 查找库文件
- 检查包已安装

</details>

---

## libpwquality

<details>
<summary><b>libpwquality — 2 个测试点</b></summary>

- 锟斤拷取 pwmake 锟芥本锟斤拷息
- 锟斤拷取 pwscore 锟芥本锟斤拷息

</details>

---

## libseccomp

<details>
<summary><b>libseccomp — 2 个测试点</b></summary>

- ldconfig 查找库文件
- 检查包已安装

</details>

---

## libselinux

<details>
<summary><b>libselinux — 2 个测试点</b></summary>

- 列出包文件
- 库文件检查

</details>

---

## libsepol

<details>
<summary><b>libsepol — 2 个测试点</b></summary>

- ldconfig 查找库文件
- 检查包已安装

</details>

---

## libtasn1

<details>
<summary><b>libtasn1 — 3 个测试点</b></summary>

- 锟斤拷取 asn1Coding 锟芥本锟斤拷息
- 锟斤拷取 asn1Decoding 锟芥本锟斤拷息
- 锟斤拷取 asn1Parser 锟芥本锟斤拷息

</details>

---

## libtirpc

<details>
<summary><b>libtirpc — 2 个测试点</b></summary>

- ldconfig 查找库文件
- 检查包已安装

</details>

---

## libunistring

<details>
<summary><b>libunistring — 2 个测试点</b></summary>

- ldconfig 查找库文件
- 检查包已安装

</details>

---

## libxcrypt

<details>
<summary><b>libxcrypt — 2 个测试点</b></summary>

- ldconfig 查找库文件
- 检查包已安装

</details>

---

## libxml2

<details>
<summary><b>libxml2 — 2 个测试点</b></summary>

- 锟斤拷取 xmlcatalog 锟芥本锟斤拷息
- 锟斤拷取 xmllint 锟芥本锟斤拷息

</details>

---

## libxslt

<details>
<summary><b>libxslt — 1 个测试点</b></summary>

- 锟斤拷取 xsltproc 锟芥本锟斤拷息

</details>

---

## linux-headers

<details>
<summary><b>linux-headers — 2 个测试点</b></summary>

- 列出包文件
- 库文件检查

</details>

---

## lua

<details>
<summary><b>lua — 5 个测试点</b></summary>

- lua 版本信息
- lua 帮助信息
- luac 版本信息
- luac 帮助信息
- lua: 无效选项

</details>

---

## lvm2

<details>
<summary><b>lvm2 — 1 个测试点</b></summary>

- 基本安装验证: lvm2

</details>

---

## lz4

<details>
<summary><b>lz4 — 4 个测试点</b></summary>

- 锟斤拷取 lz4 锟芥本锟斤拷息
- 锟斤拷取 lz4c 锟芥本锟斤拷息
- 锟斤拷取 lz4cat 锟芥本锟斤拷息
- 锟斤拷取 unlz4 锟芥本锟斤拷息

</details>

---

## make

<details>
<summary><b>make — 23 个测试点</b></summary>

- make version
- gmake version
- Run default target
- Run specific target
- Run clean target
- make -s: silent mode
- Variable expansion
- Override variable
- make -n: dry run
- make -B: always make
- make --just-print
- make -d: debug output
- make --debug=b: basic debug
- make -q: question mode
- make -s: silent
- make -j2: parallel 2 jobs
- make -e: environment overrides
- Environment variable in make
- make -C: change directory
- Include file
- gmake is GNU Make
- make -k: continue on error
- make -i: ignore errors

</details>

---

## mpc

<details>
<summary><b>mpc — 2 个测试点</b></summary>

- 列出包文件
- 库文件检查

</details>

---

## mpdecimal

<details>
<summary><b>mpdecimal — 2 个测试点</b></summary>

- 列出包文件
- 库文件检查

</details>

---

## mpfr

<details>
<summary><b>mpfr — 2 个测试点</b></summary>

- 列出包文件
- 库文件检查

</details>

---

## ncurses

<details>
<summary><b>ncurses — 1 个测试点</b></summary>

- 基本安装验证: ncurses

</details>

---

## nettle

<details>
<summary><b>nettle — 11 个测试点</b></summary>

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
- nettle-hash: 无效选项

</details>

---

## newt

<details>
<summary><b>newt — 3 个测试点</b></summary>

- whiptail 版本信息
- whiptail 帮助信息
- whiptail: 无效选项

</details>

---

## nghttp2

<details>
<summary><b>nghttp2 — 2 个测试点</b></summary>

- ldconfig 查找库文件
- 检查包已安装

</details>

---

## openruyi-release

<details>
<summary><b>openruyi-release — 1 个测试点</b></summary>

- 锟叫筹拷锟斤拷锟侥硷拷

</details>

---

## openssh

<details>
<summary><b>openssh — 1 个测试点</b></summary>

- 锟斤拷取 ssh 锟芥本锟斤拷息

</details>

---

## openssh-clients

<details>
<summary><b>openssh-clients — 19 个测试点</b></summary>

- ssh version
- ssh -Q key: supported keys
- ssh -Q cipher: ciphers
- ssh -Q mac: MACs
- ssh -Q kex: key exchange
- ssh -G: print config
- ssh -T: disable PTY
- ssh -v: verbose
- Generate test key
- ssh-add: list keys
- ssh-add: add key
- ssh-add: verify key added
- ssh-add -L: list public keys
- ssh-add -d: remove key
- ssh-keyscan: scan localhost
- ssh-keyscan -t rsa
- ssh-keyscan -t ecdsa
- sftp: help command
- scp version

</details>

---

## openssl

<details>
<summary><b>openssl — 1 个测试点</b></summary>

- 锟斤拷取 openssl 锟芥本

</details>

---

## p11-kit

<details>
<summary><b>p11-kit — 1 个测试点</b></summary>

- 基本安装验证: p11-kit

</details>

---

## pam

<details>
<summary><b>pam — 11 个测试点</b></summary>

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
- faillock: 无效选项

</details>

---

## patch

<details>
<summary><b>patch — 1 个测试点</b></summary>

- 锟斤拷取 patch 锟芥本锟斤拷息

</details>

---

## pciutils

<details>
<summary><b>pciutils — 13 个测试点</b></summary>

- 测试 1: lspci basic
- 测试 2: lspci verbose
- 测试 3: lspci with filtering
- 测试 4: lspci numeric
- 测试 5: lspci tree view
- 测试 6: lspci kernel drivers
- 测试 7: lspci by device class
- 测试 8: lspci with domain
- 测试 9: update-pciids
- 测试 10: lspci format options
- 测试 11: setpci
- 测试 12: pcilmr
- 测试 13: Error handling

</details>

---

## pcre2

<details>
<summary><b>pcre2 — 2 个测试点</b></summary>

- 锟斤拷取 pcre2grep 锟芥本锟斤拷息
- 锟斤拷取 pcre2test 锟芥本锟斤拷息

</details>

---

## perl

<details>
<summary><b>perl — 1 个测试点</b></summary>

- 锟斤拷取 perl 锟芥本

</details>

---

## pkgconf

<details>
<summary><b>pkgconf — 5 个测试点</b></summary>

- pkgconf 版本信息
- pkgconf 帮助信息
- bomtool 版本信息
- bomtool 帮助信息
- pkgconf: 无效选项

</details>

---

## podman

<details>
<summary><b>podman — 18 个测试点</b></summary>

- podman version
- podman info
- podman images: list images
- podman image list
- podman ps: list containers
- podman ps -a: all containers
- podman container list
- podman network ls
- podman network inspect
- podman volume ls
- podman system info
- podman system df: disk usage
- podman manifest help
- podman healthcheck help
- podman events help
- podman pod list
- podman-remote help
- podman: invalid command

</details>

---

## podmansh

<details>
<summary><b>podmansh — 11 个测试点</b></summary>

- 测试 1: podmansh basic
- 测试 2: podmansh help
- 测试 3: podmansh config
- 测试 4: podman basic
- 测试 6: podman images
- 测试 7: podman network
- 测试 8: podman volume
- 测试 9: podman stats
- 测试 10: podman ps
- 测试 11: Error handling
- 测试 12: Cleanup

</details>

---

## popt

<details>
<summary><b>popt — 2 个测试点</b></summary>

- ldconfig 查找库文件
- 检查包已安装

</details>

---

## procps-ng

<details>
<summary><b>procps-ng — 14 个测试点</b></summary>

- 测试 1: ps command basic functionality
- 测试 2: ps command advanced features
- 测试 3: free command
- 测试 4: top command
- 测试 5: vmstat command
- 测试 6: uptime and w commands
- 测试 7: kill command
- 测试 8: pidof and pgrep
- 测试 9: pwdx and pmap
- 测试 10: sysctl (if available)
- 测试 11: Error handling
- 测试 12: Special scenarios
- 测试 13: pkill and pidwait
- 测试 14: slabtop, tload, watch, hugetop

</details>

---

## psmisc

<details>
<summary><b>psmisc — 13 个测试点</b></summary>

- 测试 1: fuser basic
- 测试 2: fuser with processes
- 测试 3: fuser mount points
- 测试 4: fuser with options
- 测试 5: pstree basic
- 测试 6: pstree with options
- 测试 7: killall basic
- 测试 8: prtstat
- 测试 9: peekfd
- 测试 10: pslog
- 测试 11: killall with signals
- 测试 12: fuser special cases
- 测试 13: Error handling

</details>

---

## publicsuffix-list

<details>
<summary><b>publicsuffix-list — 1 个测试点</b></summary>

- 锟叫筹拷锟斤拷锟侥硷拷

</details>

---

## pyproject-rpm-macros

<details>
<summary><b>pyproject-rpm-macros — 1 个测试点</b></summary>

- 锟叫筹拷锟斤拷锟侥硷拷

</details>

---

## python

<details>
<summary><b>python — 9 个测试点</b></summary>

- Python 版本
- Python 基本运算
- Python sys模块
- python3 -h: 帮助
- python3 -V: 版本
- python3: os模块
- python3 执行脚本
- python3: 导入标准模块
- python3: 导入错误

</details>

---

## python-lxml

<details>
<summary><b>python-lxml — 2 个测试点</b></summary>

- ldconfig 查找库文件
- 检查包已安装

</details>

---

## python-packaging

<details>
<summary><b>python-packaging — 1 个测试点</b></summary>

- 锟叫筹拷锟斤拷锟侥硷拷

</details>

---

## python-pip

<details>
<summary><b>python-pip — 1 个测试点</b></summary>

- 锟斤拷取 pip3 锟芥本

</details>

---

## python-rpm-macros

<details>
<summary><b>python-rpm-macros — 1 个测试点</b></summary>

- 锟叫筹拷锟斤拷锟侥硷拷

</details>

---

## python-srpm-macros

<details>
<summary><b>python-srpm-macros — 1 个测试点</b></summary>

- 锟叫筹拷锟斤拷锟侥硷拷

</details>

---

## readline

<details>
<summary><b>readline — 2 个测试点</b></summary>

- ldconfig 查找库文件
- 检查包已安装

</details>

---

## rpm

<details>
<summary><b>rpm — 1 个测试点</b></summary>

- rpm 锟芥本

</details>

---

## rpm-config-openruyi

<details>
<summary><b>rpm-config-openruyi — 2 个测试点</b></summary>

- 列出包文件
- 库文件检查

</details>

---

## rpmbuild

<details>
<summary><b>rpmbuild — 9 个测试点</b></summary>

- 测试 1: rpmbuild basic functionality
- 测试 2: Create simple spec file
- 测试 3: Create source tarball
- 测试 4: Build RPM package
- 测试 5: Verify built RPM
- 测试 6: Install and test RPM
- 测试 7: RPM build options
- 测试 8: Error handling
- 测试 9: RPM verification

</details>

---

## sddm

<details>
<summary><b>sddm — 11 个测试点</b></summary>

- Check sddm-greeter available
- sddm help
- sddm --test-mode help
- sddm: example config
- Config directory
- Default config dir
- sddm service unit
- sddm service status
- sddm enabled status
- sddm themes installed
- sddm: key config values

</details>

---

## sed

<details>
<summary><b>sed — 13 个测试点</b></summary>

- sed 版本
- sed s: 基本替换
- sed s: 替换hello
- sed -n: 打印指定行
- sed d: 删除指定行
- sed a: 追加行
- sed i: 插入行
- sed g: 全局替换
- sed: 正则替换
- sed -i: 就地编辑
- sed -i: 验证修改
- sed -e: 多表达式
- sed: 无效选项

</details>

---

## setup

<details>
<summary><b>setup — 1 个测试点</b></summary>

- 锟叫筹拷锟斤拷锟侥硷拷

</details>

---

## slang

<details>
<summary><b>slang — 1 个测试点</b></summary>

- 锟斤拷取 slsh 锟芥本锟斤拷息

</details>

---

## sqlite

<details>
<summary><b>sqlite — 2 个测试点</b></summary>

- 锟斤拷取 sqldiff 锟芥本锟斤拷息
- 锟斤拷取 sqlite3 锟芥本锟斤拷息

</details>

---

## systemd

<details>
<summary><b>systemd — 114 个测试点</b></summary>

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
- systemd-analyze version
- systemd-analyze time: boot time
- systemd-analyze security
- hostnamectl version
- hostnamectl status: system info
- hostnamectl hostname: current name
- hostnamectl --static
- hostnamectl --transient
- hostnamectl --pretty
- hostnamectl chassis
- localectl version
- localectl status: locale info
- localectl list-locales
- timedatectl version
- timedatectl status: time info
- timedatectl show: all properties
- timedatectl list-timezones
- timedatectl show-timesync
- loginctl version
- loginctl list-sessions
- loginctl list-users
- loginctl show-session
- loginctl show-user
- loginctl user-status
- systemd-detect-virt: detect VM
- systemd-detect-virt -q: quiet mode
- systemd-detect-virt -c: container only
- systemd-detect-virt -v: VM only
- systemd-detect-virt -r: chroot only
- systemd-cgls: cgroup tree
- systemd-cgls -k: kernel threads
- systemd-cgls --no-pager
- systemd-cgtop -b: batch mode
- systemd-tmpfiles version
- systemd-tmpfiles --cat-config
- busctl version
- busctl list: list services
- busctl status: bus status
- busctl tree: object tree
- busctl introspect
- systemd-run version
- systemd-run --user --scope
- systemd-cat: pipe to journal
- systemd-cat version
- systemd-notify version
- systemd-notify help
- systemd-path: all paths
- systemd-path: specific path
- systemd-path --suffix
- systemd-path help
- systemd-escape: basic escape
- systemd-escape --path: path escape
- systemd-escape -u: unescape
- systemd-escape --suffix
- systemd-escape --template
- systemd-machine-id-setup help
- systemd-machine-id-setup: check machine-id
- coredumpctl version
- coredumpctl list: list dumps
- coredumpctl info
- systemd-delta help
- systemd-delta: show overrides
- systemd-id128 show: show IDs
- systemd-id128 new: generate ID
- systemd-inhibit help
- systemd-inhibit --list
- systemd-ac-power: check power
- systemd-ask-password help
- systemd-creds help
- systemd-socket-activate help
- $cmd help
- systemd-firstboot help
- systemd-stdio-bridge help
- oomctl help
- oomctl dump
- systemctl try-restart
- systemctl reload-or-restart
- systemctl reset-failed
- systemctl daemon-reload
- run0 help
- systemd-mount help
- systemd-sysext help
- systemd-confext help
- systemctl: invalid command
- journalctl: invalid option
- hostnamectl: invalid option

</details>

---

## systemd-timesyncd

<details>
<summary><b>systemd-timesyncd — 13 个测试点</b></summary>

- Service status
- Time sync status
- Timesync detail
- Is enabled
- Fallback NTP servers
- Current NTP server
- Server address
- NTP servers list
- Restart service
- Is active
- Config file
- Cat config
- Wait sync service

</details>

---

## tar

<details>
<summary><b>tar — 10 个测试点</b></summary>

- 测试 1: Basic archive creation
- 测试 2: Archive extraction
- 测试 3: Compression formats
- 测试 4: Advanced tar options
- 测试 5: Archive verification
- 测试 6: Special attributes
- 测试 7: Error handling
- 测试 8: Wildcard and patterns
- 测试 9: Incremental backup
- 测试 10: Special file types

</details>

---

## tcsh

<details>
<summary><b>tcsh — 1 个测试点</b></summary>

- 锟斤拷取 tcsh 锟芥本锟斤拷息

</details>

---

## time

<details>
<summary><b>time — 1 个测试点</b></summary>

- 锟斤拷取 time 锟芥本锟斤拷息

</details>

---

## tmux

<details>
<summary><b>tmux — 180 个测试点</b></summary>

- tmux version
- start-server: start tmux server
- list-sessions: initial state
- has-session: check nonexistent
- list-clients: list connected clients
- list-commands: list all commands
- list-commands: filter specific command
- list-commands: format output
- server-access -l: list access
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
- select-layout: even-horizontal
- select-layout: even-vertical
- select-layout: main-horizontal
- select-layout: main-vertical
- select-layout: tiled
- next-layout: cycle layouts
- previous-layout: prev layout
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
- set-environment -g: global env
- set-environment: session env
- set-environment -gur: update then remove
- show-environment -g: global env
- show-environment: session env
- set-hook: session-created
- set-hook: client-attached
- show-hooks -g: global hooks
- set-hook -gu: remove global hook
- set-hook -gu: remove hook
- display-message: show message
- display-message -p: print format
- show-messages: message log
- display-popup -C: close popup
- clear-history: clear pane history
- if-shell: true condition
- run-shell: run shell command
- run-shell -b: background
- command-prompt: open prompt
- confirm-before: confirm dialog
- source-file: source config
- copy-mode: enter copy mode
- find-window: search windows
- choose-tree -G: tree display
- choose-client: client selection
- clock-mode: show clock
- lock-server: lock server
- lock-session: lock session
- show-prompt-history: prompt history
- clear-prompt-history: clear prompt history
- wait-for -L: lock channel
- kill-session: kill renamed_sess
- kill-session: kill sess_fmt
- kill-session: kill sess_sz
- kill-session: kill sess_flags
- kill-session: kill sess_env
- kill-session: kill main test session
- kill-server: terminate server
- Error: nonexistent session
- Error: invalid option

</details>

---

## tzdata

<details>
<summary><b>tzdata — 3 个测试点</b></summary>

- 锟斤拷取 tzselect 锟芥本锟斤拷息
- 锟斤拷取 zdump 锟芥本锟斤拷息
- 锟斤拷取 zic 锟芥本锟斤拷息

</details>

---

## unzip

<details>
<summary><b>unzip — 4 个测试点</b></summary>

- 锟斤拷取 unzip 锟芥本锟斤拷息
- 锟斤拷取 funzip 锟芥本锟斤拷息
- 锟斤拷取 zipgrep 锟芥本锟斤拷息
- 锟斤拷取 zipinfo 锟芥本锟斤拷息

</details>

---

## util-linux

<details>
<summary><b>util-linux — 31 个测试点</b></summary>

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
- addpart: 无效选项

</details>

---

## vim

<details>
<summary><b>vim — 1 个测试点</b></summary>

- 锟斤拷取 vim 锟芥本

</details>

---

## weston

<details>
<summary><b>weston — 9 个测试点</b></summary>

- weston version
- weston help
- weston-terminal help
- weston-debug help
- weston-screenshooter help
- wcap-decode help
- Available backends
- weston: headless backend
- weston: invalid option

</details>

---

## wget

<details>
<summary><b>wget — 15 个测试点</b></summary>

- 测试 1: Basic download
- 测试 2: Output options
- 测试 3: Verbose and quiet modes
- 测试 4: Spider mode
- 测试 5: Header options
- 测试 6: User agent
- 测试 7: Timeout and retries
- 测试 8: Recursive download
- 测试 9: Continue and mirror
- 测试 10: Rate limiting
- 测试 11: Progress indicators
- 测试 12: Error handling
- 测试 13: Directory listing
- 测试 14: Timestamps
- 测试 15: Special features

</details>

---

## wget2

<details>
<summary><b>wget2 — 15 个测试点</b></summary>

- 测试 1: Basic download
- 测试 2: Output file options
- 测试 3: Verbose modes
- 测试 4: Spider mode
- 测试 5: Headers
- 测试 6: User agent
- 测试 7: Timeouts and retries
- 测试 8: Continue download
- 测试 9: Rate limiting
- 测试 10: HTTP/2 support
- 测试 11: TLS options
- 测试 12: Error handling
- 测试 13: Follow redirects
- 测试 14: Content disposition
- 测试 15: Plugin system

</details>

---

## which

<details>
<summary><b>which — 1 个测试点</b></summary>

- 锟斤拷取 which 锟芥本锟斤拷息

</details>

---

## xz

<details>
<summary><b>xz — 31 个测试点</b></summary>

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
- xz: 无效选项

</details>

---

## zstd

<details>
<summary><b>zstd — 13 个测试点</b></summary>

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
- zstd: 无效选项

</details>
