# 功能测试覆盖详情

> 点击展开查看各软件包详情，每个用例下列出测试功能点

共 **1** 个软件包，**447** 个测试用例

## 目录

- [acl](#acl) (11 cases)
- [audit](#audit) (2 cases)
- [bash](#bash) (7 cases)
- [ca-certificates](#ca-certificates) (2 cases)
- [ca-certificates-mozilla](#ca-certificates-mozilla) (2 cases)
- [clang](#clang) (15 cases)
- [cloud-utils-growpart](#cloud-utils-growpart) (6 cases)
- [cmake](#cmake) (6 cases)
- [coreutils](#coreutils) (24 cases)
- [cryptsetup](#cryptsetup) (2 cases)
- [curl](#curl) (6 cases)
- [debugedit](#debugedit) (2 cases)
- [dnf5-plugins](#dnf5-plugins) (10 cases)
- [dwz](#dwz) (2 cases)
- [elfutils](#elfutils) (2 cases)
- [filesystem](#filesystem) (2 cases)
- [findutils](#findutils) (5 cases)
- [gcc](#gcc) (12 cases)
- [git](#git) (15 cases)
- [glibc](#glibc) (2 cases)
- [gmp](#gmp) (2 cases)
- [grep](#grep) (13 cases)
- [gxx](#gxx) (9 cases)
- [gzip](#gzip) (2 cases)
- [iputils](#iputils) (10 cases)
- [isl](#isl) (2 cases)
- [labwc](#labwc) (9 cases)
- [libselinux](#libselinux) (2 cases)
- [linux-headers](#linux-headers) (2 cases)
- [lua](#lua) (2 cases)
- [make](#make) (9 cases)
- [mpc](#mpc) (2 cases)
- [mpdecimal](#mpdecimal) (2 cases)
- [mpfr](#mpfr) (2 cases)
- [nettle](#nettle) (2 cases)
- [newt](#newt) (2 cases)
- [openssh](#openssh) (12 cases)
- [openssh-clients](#openssh-clients) (9 cases)
- [pam](#pam) (2 cases)
- [pciutils](#pciutils) (13 cases)
- [pkgconf](#pkgconf) (2 cases)
- [podman](#podman) (7 cases)
- [podmansh](#podmansh) (11 cases)
- [procps-ng](#procps-ng) (14 cases)
- [psmisc](#psmisc) (13 cases)
- [python](#python) (5 cases)
- [rpm-config-openruyi](#rpm-config-openruyi) (2 cases)
- [rpmbuild](#rpmbuild) (9 cases)
- [sddm](#sddm) (7 cases)
- [sed](#sed) (6 cases)
- [systemd](#systemd) (36 cases)
- [systemd-timesyncd](#systemd-timesyncd) (5 cases)
- [tar](#tar) (10 cases)
- [tmux](#tmux) (22 cases)
- [util-linux](#util-linux) (2 cases)
- [vim](#vim) (10 cases)
- [weston](#weston) (9 cases)
- [wget](#wget) (15 cases)
- [wget2](#wget2) (15 cases)
- [xz](#xz) (2 cases)
- [zstd](#zstd) (2 cases)

---

## acl

<details open>
<summary><b>acl — 11 个测试用例</b></summary>

#### `test_acl_acl_inheritance`

> 功能测试 - acl - ACL 继承测试

**功能点：**

- 获取 getfacl 版本信息
- 获取 setfacl 版本信息
- 设置目录 default ACL
- 在目录中创建新文件
- 验证新文件继承了 default ACL
- 在目录中创建子目录
- 验证子目录继承了 default ACL

#### `test_acl_acl_permission_verify`

> 功能测试 - acl - ACL 权限验证

**功能点：**

- 获取 getfacl 版本信息
- 获取 setfacl 版本信息
- 设置完整权限
- 验证权限设置
- 设置 mask 限制有效权限
- 验证 mask 限制后的有效权限

#### `test_acl_chacl_command`

> 功能测试 - acl - chacl 命令功能

**功能点：**

- 获取 getfacl 版本信息
- 获取 setfacl 版本信息
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

#### `test_acl_error_handling`

> 功能测试 - acl - 错误处理

**功能点：**

- 获取 getfacl 版本信息
- 获取 setfacl 版本信息
- 测试对不存在文件 getfacl 报错
- 测试对不存在文件 setfacl 报错
- 测试无效权限字符报错
- 测试无效类型报错
- 测试权限不足报错

#### `test_acl_getfacl_basic`

> 功能测试 - acl - getfacl 基本功能

**功能点：**

- 获取 getfacl 版本信息
- 获取 setfacl 版本信息
- 查看文件默认 ACL
- 查看目录默认 ACL
- 使用 -a 参数查看 access ACL
- 使用 -d 参数查看 default ACL
- 使用 -c 参数不显示注释头
- 使用 -n 参数显示数字 ID
- 使用 -t 参数表格输出

#### `test_acl_setfacl_advanced`

> 功能测试 - acl - setfacl 高级功能

**功能点：**

- 获取 getfacl 版本信息
- 获取 setfacl 版本信息
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

#### `test_acl_setfacl_basic`

> 功能测试 - acl - setfacl 基本功能

**功能点：**

- 获取 getfacl 版本信息
- 获取 setfacl 版本信息
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

#### `test_acl_setfacl_recursive`

> 功能测试 - acl - setfacl 递归功能

**功能点：**

- 获取 getfacl 版本信息
- 获取 setfacl 版本信息
- 创建多层子目录
- 递归设置 user ACL
- 验证递归设置 - file1
- 验证递归设置 - file2
- 递归删除所有扩展 ACL
- 验证递归删除 - file1
- 验证递归删除 - file2

#### `test_acl_setfacl_remove`

> 功能测试 - acl - setfacl 删除功能

**功能点：**

- 获取 getfacl 版本信息
- 获取 setfacl 版本信息
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

#### `test_acl_setfacl_symlink`

> 功能测试 - acl - setfacl 符号链接处理

**功能点：**

- 获取 getfacl 版本信息
- 获取 setfacl 版本信息
- 创建符号链接
- 使用 -L 跟随符号链接设置 ACL
- 验证符号链接目标文件的 ACL
- 使用 -P 不跟随符号链接

#### `test_acl_special_cases`

> 功能测试 - acl - 特殊场景

**功能点：**

- 获取 getfacl 版本信息
- 获取 setfacl 版本信息
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

## audit

<details open>
<summary><b>audit — 2 个测试用例</b></summary>

#### `test_audit_error_handling`

> 功能测试 - audit - 错误处理

**功能点：**

- auditctl: 无效选项

#### `test_audit_version_help`

> 功能测试 - audit - 版本和帮助

**功能点：**

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

</details>

---

## bash

<details open>
<summary><b>bash — 7 个测试用例</b></summary>

#### `test_bash_bashbug`

> 功能测试 - bash - bashbug

**功能点：**

- bash 版本
- sh 版本
- bashbug 帮助

#### `test_bash_basic_script`

> 功能测试 - bash - 基本脚本执行

**功能点：**

- bash 版本
- sh 版本
- bash 执行脚本

#### `test_bash_conditionals`

> 功能测试 - bash - 条件判断

**功能点：**

- bash 版本
- sh 版本
- bash: if条件

#### `test_bash_error_handling`

> 功能测试 - bash - 错误处理

**功能点：**

- bash 版本
- sh 版本
- bash: 错误退出

#### `test_bash_functions`

> 功能测试 - bash - 函数

**功能点：**

- bash 版本
- sh 版本
- bash: 函数定义调用

#### `test_bash_pipe_redirect`

> 功能测试 - bash - 管道和重定向

**功能点：**

- bash 版本
- sh 版本
- bash: 管道

#### `test_bash_variables_loops`

> 功能测试 - bash - 变量和循环

**功能点：**

- bash 版本
- sh 版本
- bash -c: for循环

</details>

---

## ca-certificates

<details open>
<summary><b>ca-certificates — 2 个测试用例</b></summary>

#### `test_ca_certificates_error_handling`

> 功能测试 - ca-certificates - 错误处理

**功能点：**

- update-ca-trust: 无效选项

#### `test_ca_certificates_version_help`

> 功能测试 - ca-certificates - 版本和帮助

**功能点：**

- update-ca-trust 版本信息
- update-ca-trust 帮助信息

</details>

---

## ca-certificates-mozilla

<details open>
<summary><b>ca-certificates-mozilla — 2 个测试用例</b></summary>

#### `test_ca_certificates_mozilla_error_handling`

> 功能测试 - ca-certificates-mozilla - 错误处理

**测试段：**
- 错误处理

#### `test_ca_certificates_mozilla_version_help`

> 功能测试 - ca-certificates-mozilla - 版本和帮助

**功能点：**

- 列出包文件
- 库文件检查

</details>

---

## clang

<details open>
<summary><b>clang — 15 个测试用例</b></summary>

#### `test_clang_basic_c___compilation`

> 功能测试 - clang - Basic C++ compilation

**功能点：**

- Check clang installed
- Check clang available
- Check clang++ available
- Check clang-cl available
- Check clang-cpp available
- Check clang-scan-deps available
- Compile C++ from hello.c
- Run C++ binary

#### `test_clang_basic_c_compilation`

> 功能测试 - clang - Basic C compilation

**功能点：**

- Check clang installed
- Check clang available
- Check clang++ available
- Check clang-cl available
- Check clang-cpp available
- Check clang-scan-deps available
- Compile hello.c
- Run compiled binary
- Output is ELF binary

#### `test_clang_c___standards`

> 功能测试 - clang - C++ standards

**功能点：**

- Check clang installed
- Check clang available
- Check clang++ available
- Check clang-cl available
- Check clang-cpp available
- Check clang-scan-deps available
- C++ standard: $std

#### `test_clang_c_standards`

> 功能测试 - clang - C standards

**功能点：**

- Check clang installed
- Check clang available
- Check clang++ available
- Check clang-cl available
- Check clang-cpp available
- Check clang-scan-deps available
- C standard: $std

#### `test_clang_clang_cl__msvc_compat`

> 功能测试 - clang - clang-cl (MSVC compat)

**功能点：**

- Check clang installed
- Check clang available
- Check clang++ available
- Check clang-cl available
- Check clang-cpp available
- Check clang-scan-deps available
- clang-cl help

#### `test_clang_clang_cpp`

> 功能测试 - clang - clang-cpp

**功能点：**

- Check clang installed
- Check clang available
- Check clang++ available
- Check clang-cl available
- Check clang-cpp available
- Check clang-scan-deps available
- clang-cpp: preprocessor

#### `test_clang_clang_scan_deps`

> 功能测试 - clang - clang-scan-deps

**功能点：**

- Check clang installed
- Check clang available
- Check clang++ available
- Check clang-cl available
- Check clang-cpp available
- Check clang-scan-deps available
- clang-scan-deps help

#### `test_clang_compile_only`

> 功能测试 - clang - Compile-only

**功能点：**

- Check clang installed
- Check clang available
- Check clang++ available
- Check clang-cl available
- Check clang-cpp available
- Check clang-scan-deps available
- clang -c: compile only
- Object file exists

#### `test_clang_debug_and_warnings`

> 功能测试 - clang - Debug and warnings

**功能点：**

- Check clang installed
- Check clang available
- Check clang++ available
- Check clang-cl available
- Check clang-cpp available
- Check clang-scan-deps available
- Debug symbols
- -Wall warnings
- -Wextra warnings
- -Werror

#### `test_clang_error_handling`

> 功能测试 - clang - Error handling

**功能点：**

- Check clang installed
- Check clang available
- Check clang++ available
- Check clang-cl available
- Check clang-cpp available
- Check clang-scan-deps available
- Compilation error
- Invalid option

#### `test_clang_linking_options`

> 功能测试 - clang - Linking options

**功能点：**

- Check clang installed
- Check clang available
- Check clang++ available
- Check clang-cl available
- Check clang-cpp available
- Check clang-scan-deps available
- Compile with -fPIC
- clang -shared: shared library

#### `test_clang_optimization_levels`

> 功能测试 - clang - Optimization levels

**功能点：**

- Check clang installed
- Check clang available
- Check clang++ available
- Check clang-cl available
- Check clang-cpp available
- Check clang-scan-deps available
- Optimization -$lvl

#### `test_clang_preprocessor`

> 功能测试 - clang - Preprocessor

**功能点：**

- Check clang installed
- Check clang available
- Check clang++ available
- Check clang-cl available
- Check clang-cpp available
- Check clang-scan-deps available
- clang -E: preprocess
- clang -dM: dump macros

#### `test_clang_static_analysis`

> 功能测试 - clang - Static analysis

**功能点：**

- Check clang installed
- Check clang available
- Check clang++ available
- Check clang-cl available
- Check clang-cpp available
- Check clang-scan-deps available
- clang --analyze: static analysis

#### `test_clang_verbose_mode`

> 功能测试 - clang - Verbose mode

**功能点：**

- Check clang installed
- Check clang available
- Check clang++ available
- Check clang-cl available
- Check clang-cpp available
- Check clang-scan-deps available
- clang -v: verbose

</details>

---

## cloud-utils-growpart

<details open>
<summary><b>cloud-utils-growpart — 6 个测试用例</b></summary>

#### `test_cloud_utils_growpart_disk_partition_info`

> 功能测试 - cloud-utils-growpart - Disk/partition info

**功能点：**

- Check cloud-utils-growpart installed
- Check growpart command available
- lsblk: list block devices
- df: disk free space

#### `test_cloud_utils_growpart_dry_run__no_actual_resize`

> 功能测试 - cloud-utils-growpart - Dry-run (no actual resize)

**功能点：**

- Check cloud-utils-growpart installed
- Check growpart command available
- growpart -N: dry run

#### `test_cloud_utils_growpart_error_handling`

> 功能测试 - cloud-utils-growpart - Error handling

**功能点：**

- Check cloud-utils-growpart installed
- Check growpart command available
- growpart: no args (expected fail)
- growpart: nonexistent disk
- growpart: invalid option

#### `test_cloud_utils_growpart_free_percent_option`

> 功能测试 - cloud-utils-growpart - Free percent option

**功能点：**

- Check cloud-utils-growpart installed
- Check growpart command available
- growpart: has free-percent option

#### `test_cloud_utils_growpart_fudge_factor_option`

> 功能测试 - cloud-utils-growpart - Fudge factor option

**功能点：**

- Check cloud-utils-growpart installed
- Check growpart command available
- growpart: has fudge option

#### `test_cloud_utils_growpart_help_and_version`

> 功能测试 - cloud-utils-growpart - Help and version

**功能点：**

- Check cloud-utils-growpart installed
- Check growpart command available
- growpart help
- growpart -h: short help

</details>

---

## cmake

<details open>
<summary><b>cmake — 6 个测试用例</b></summary>

#### `test_cmake_basic_cmake_project`

> 功能测试 - cmake - Basic CMake project

**测试段：**
- Basic CMake project

#### `test_cmake_cmake__e_mode`

> 功能测试 - cmake - CMake -E mode

**测试段：**
- CMake -E mode

#### `test_cmake_cmake_configure`

> 功能测试 - cmake - CMake configure

**测试段：**
- CMake configure

#### `test_cmake_cmake_version_and_help`

> 功能测试 - cmake - CMake version and help

**测试段：**
- CMake version and help

#### `test_cmake_ctest_and_cpack`

> 功能测试 - cmake - ctest and cpack

**测试段：**
- ctest and cpack

#### `test_cmake_error_handling`

> 功能测试 - cmake - Error handling

**测试段：**
- Error handling

</details>

---

## coreutils

<details open>
<summary><b>coreutils — 24 个测试用例</b></summary>

#### `test_coreutils_boolean_and_condition__true__false__test`

> 功能测试 - coreutils - Boolean and condition (true, false, test, [)

**功能点：**

- Check coreutils package is installed
- true returns success
- false returns failure
- test -f: file exists
- test -d: directory exists
- test string equality
- test numeric comparison
- [ -f: file exists
- [ string equality

#### `test_coreutils_checksums__cksum__md5sum__sha1sum__sha224sum__sha3`

> 功能测试 - coreutils - Checksums (cksum, md5sum, sha1sum, sha224sum, sha384sum, sha512sum, sha256sum, b2sum, sum)

**功能点：**

- Check coreutils package is installed
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

#### `test_coreutils_copy__move__remove__cp__mv__rm__rmdir`

> 功能测试 - coreutils - Copy, move, remove (cp, mv, rm, rmdir)

**功能点：**

- Check coreutils package is installed
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

#### `test_coreutils_counting_and_statistics__wc__du__df__stat`

> 功能测试 - coreutils - Counting and statistics (wc, du, df, stat)

**功能点：**

- Check coreutils package is installed
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

#### `test_coreutils_directory__file_creation__temp_files__mkdir__touch`

> 功能测试 - coreutils - Directory, file creation, temp files (mkdir, touch, mktemp)

**功能点：**

- Check coreutils package is installed
- mkdir -p nested directories
- mkdir -p: verify nested dir
- mkdir -m set mode
- touch create file
- touch: file exists
- touch -t set timestamp
- touch -a access time only

#### `test_coreutils_encoding__base32__base64__basenc`

> 功能测试 - coreutils - Encoding (base32, base64, basenc)

**功能点：**

- Check coreutils package is installed
- base32 encode
- base32 -d decode
- base64 encode
- base64 -d decode
- basenc --base64 encode

#### `test_coreutils_environment_and_time__env__printenv__date__printf`

> 功能测试 - coreutils - Environment and time (env, printenv, date, printf)

**功能点：**

- Check coreutils package is installed
- env show environment
- env set variable for command
- printenv show PATH
- date current date/time
- date custom format
- date -u UTC time
- printf formatted output
- printf string output

#### `test_coreutils_error_handling`

> 功能测试 - coreutils - Error handling

**功能点：**

- Check coreutils package is installed
- cp: error on nonexistent source
- ls: error on nonexistent file
- mkdir: error on existing dir
- rm: error on dir without -r
- rmdir: error on non-empty dir

#### `test_coreutils_file_creation_and_listing__echo__cat__ls__dir__vdi`

> 功能测试 - coreutils - File creation and listing (echo, cat, ls, dir, vdir)

**功能点：**

- Check coreutils package is installed
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

#### `test_coreutils_file_operations__dd__truncate__shred__sync__instal`

> 功能测试 - coreutils - File operations (dd, truncate, shred, sync, install, chroot)

**功能点：**

- Check coreutils package is installed
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
- mkfifo create named pipe
- mkfifo: verify pipe created

#### `test_coreutils_file_viewing__head__tail__tac__nl`

> 功能测试 - coreutils - File viewing (head, tail, tac, nl)

**功能点：**

- Check coreutils package is installed
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

#### `test_coreutils_flow_control__sleep__timeout__yes`

> 功能测试 - coreutils - Flow control (sleep, timeout, yes)

**功能点：**

- Check coreutils package is installed
- sleep delay
- timeout: command finishes in time
- timeout: successful completion
- timeout: kills slow command
- yes repeated output
- yes custom string

#### `test_coreutils_links_and_path_resolution__ln__link__unlink__readl`

> 功能测试 - coreutils - Links and path resolution (ln, link, unlink, readlink, realpath)

**功能点：**

- Check coreutils package is installed
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

#### `test_coreutils_numbers_and_expressions__seq__factor__shuf__numfmt`

> 功能测试 - coreutils - Numbers and expressions (seq, factor, shuf, numfmt, expr)

**功能点：**

- Check coreutils package is installed
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

#### `test_coreutils_octal_dump__od`

> 功能测试 - coreutils - Octal dump (od)

**功能点：**

- Check coreutils package is installed
- od octal dump
- od -c character dump
- od -x hex dump
- od -A x hex address

#### `test_coreutils_path_operations__basename__dirname__pwd`

> 功能测试 - coreutils - Path operations (basename, dirname, pwd)

**功能点：**

- Check coreutils package is installed
- basename extract filename
- basename strip suffix
- dirname extract directory
- dirname path extraction
- pwd print working directory

#### `test_coreutils_permissions_and_ownership__chmod__chown__chgrp`

> 功能测试 - coreutils - Permissions and ownership (chmod, chown, chgrp)

**功能点：**

- Check coreutils package is installed
- Create permission test file
- chmod u+x add exec
- chmod: verify exec set
- chmod 644 numeric
- chmod: verify 644 perms
- Setup recursive chmod
- chmod -R recursive
- chown to self

#### `test_coreutils_process_control__nice__nohup__stdbuf`

> 功能测试 - coreutils - Process control (nice, nohup, stdbuf)

**功能点：**

- Check coreutils package is installed
- nice adjust priority
- nohup run command
- stdbuf line buffered output

#### `test_coreutils_redirection__tee`

> 功能测试 - coreutils - Redirection (tee)

**功能点：**

- Check coreutils package is installed
- tee write to file
- tee: verify output
- tee -a append mode

#### `test_coreutils_special_utilities__stty__pathchk__tsort__ptx__dirc`

> 功能测试 - coreutils - Special utilities (stty, pathchk, tsort, ptx, dircolors)

**功能点：**

- Check coreutils package is installed
- stty -a show all terminal settings
- pathchk validate path
- pathchk -p POSIX check
- tsort topological sort
- ptx permuted index
- dircolors -p print database
- dircolors output LS_COLORS

#### `test_coreutils_split_files__split__csplit`

> 功能测试 - coreutils - Split files (split, csplit)

**功能点：**

- Check coreutils package is installed
- split by lines
- split: multiple output files
- csplit split by pattern

#### `test_coreutils_system_information__uname__who__whoami__id__groups`

> 功能测试 - coreutils - System information (uname, who, whoami, id, groups, users, hostid, nproc, tty, logname, pinky)

**功能点：**

- Check coreutils package is installed
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

#### `test_coreutils_text_processing_i__sort__uniq__cut__tr`

> 功能测试 - coreutils - Text processing I (sort, uniq, cut, tr)

**功能点：**

- Check coreutils package is installed
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

#### `test_coreutils_text_processing_ii__paste__comm__join__fmt__fold__`

> 功能测试 - coreutils - Text processing II (paste, comm, join, fmt, fold, pr, expand, unexpand)

**功能点：**

- Check coreutils package is installed
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

</details>

---

## cryptsetup

<details open>
<summary><b>cryptsetup — 2 个测试用例</b></summary>

#### `test_cryptsetup_error_handling`

> 功能测试 - cryptsetup - 错误处理

**功能点：**

- cryptsetup: 无效选项

#### `test_cryptsetup_version_help`

> 功能测试 - cryptsetup - 版本和帮助

**功能点：**

- cryptsetup 版本信息
- cryptsetup 帮助信息

</details>

---

## curl

<details open>
<summary><b>curl — 6 个测试用例</b></summary>

#### `test_curl_basic_download`

> 功能测试 - curl - 基本下载

**功能点：**

- curl 版本信息
- curl 下载示例页面
- curl -I: 仅获取响应头

#### `test_curl_error_handling`

> 功能测试 - curl - 错误处理

**功能点：**

- curl 版本信息
- curl: 无效选项

#### `test_curl_other_options`

> 功能测试 - curl - 其他选项

**功能点：**

- curl 版本信息
- curl -L: 跟随重定向
- curl -k: 忽略SSL证书
- curl --connect-timeout: 连接超时

#### `test_curl_output_options`

> 功能测试 - curl - 输出选项

**功能点：**

- curl 版本信息
- curl -o: 输出到文件
- curl -O: 远程文件名

#### `test_curl_verbose_quiet`

> 功能测试 - curl - 详细模式和静默模式

**功能点：**

- curl 版本信息
- curl -v: 详细模式
- curl -s: 静默模式

#### `test_curl_wcurl`

> 功能测试 - curl - wcurl

**功能点：**

- curl 版本信息
- wcurl 帮助

</details>

---

## debugedit

<details open>
<summary><b>debugedit — 2 个测试用例</b></summary>

#### `test_debugedit_error_handling`

> 功能测试 - debugedit - 错误处理

**功能点：**

- debugedit: 无效选项

#### `test_debugedit_version_help`

> 功能测试 - debugedit - 版本和帮助

**功能点：**

- debugedit 版本信息
- debugedit 帮助信息
- debugedit-classify-ar 版本信息
- debugedit-classify-ar 帮助信息

</details>

---

## dnf5-plugins

<details open>
<summary><b>dnf5-plugins — 10 个测试用例</b></summary>

#### `test_dnf5_plugins_available_plugins`

> 功能测试 - dnf5-plugins - Available plugins

**功能点：**

- Check dnf5-plugins installed
- Check dnf5 available
- Check plugin: $plugin

#### `test_dnf5_plugins_commands_with_plugins`

> 功能测试 - dnf5-plugins - Commands with plugins

**功能点：**

- Check dnf5-plugins installed
- Check dnf5 available
- Plugin commands in help

#### `test_dnf5_plugins_dnf5_help`

> 功能测试 - dnf5-plugins - dnf5 help

**功能点：**

- Check dnf5-plugins installed
- Check dnf5 available
- dnf5 help

#### `test_dnf5_plugins_dnf5_info`

> 功能测试 - dnf5-plugins - dnf5 info

**功能点：**

- Check dnf5-plugins installed
- Check dnf5 available
- dnf5 info

#### `test_dnf5_plugins_dnf5_list`

> 功能测试 - dnf5-plugins - dnf5 list

**功能点：**

- Check dnf5-plugins installed
- Check dnf5 available
- dnf5 list installed

#### `test_dnf5_plugins_dnf5_repolist`

> 功能测试 - dnf5-plugins - dnf5 repolist

**功能点：**

- Check dnf5-plugins installed
- Check dnf5 available
- dnf5 repolist

#### `test_dnf5_plugins_dnf5_repoquery`

> 功能测试 - dnf5-plugins - dnf5 repoquery

**功能点：**

- Check dnf5-plugins installed
- Check dnf5 available
- dnf5 repoquery help

#### `test_dnf5_plugins_dnf5_version`

> 功能测试 - dnf5-plugins - dnf5 version

**功能点：**

- Check dnf5-plugins installed
- Check dnf5 available

#### `test_dnf5_plugins_error_handling`

> 功能测试 - dnf5-plugins - Error handling

**功能点：**

- Check dnf5-plugins installed
- Check dnf5 available
- dnf5: invalid option

#### `test_dnf5_plugins_list_installed_plugins`

> 功能测试 - dnf5-plugins - List installed plugins

**功能点：**

- Check dnf5-plugins installed
- Check dnf5 available
- Plugin files
- Plugin directory

</details>

---

## dwz

<details open>
<summary><b>dwz — 2 个测试用例</b></summary>

#### `test_dwz_error_handling`

> 功能测试 - dwz - 错误处理

**功能点：**

- dwz: 无效选项

#### `test_dwz_version_help`

> 功能测试 - dwz - 版本和帮助

**功能点：**

- dwz 版本信息
- dwz 帮助信息

</details>

---

## elfutils

<details open>
<summary><b>elfutils — 2 个测试用例</b></summary>

#### `test_elfutils_error_handling`

> 功能测试 - elfutils - 错误处理

**功能点：**

- eu-addr2line: 无效选项

#### `test_elfutils_version_help`

> 功能测试 - elfutils - 版本和帮助

**功能点：**

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
- ... 等共 30 个测试点

</details>

---

## filesystem

<details open>
<summary><b>filesystem — 2 个测试用例</b></summary>

#### `test_filesystem_error_handling`

> 功能测试 - filesystem - 错误处理

**测试段：**
- 错误处理

#### `test_filesystem_version_help`

> 功能测试 - filesystem - 版本和帮助

**功能点：**

- 列出包文件
- 库文件检查

</details>

---

## findutils

<details open>
<summary><b>findutils — 5 个测试用例</b></summary>

#### `test_findutils_error_handling`

> 功能测试 - findutils - 错误处理

**功能点：**

- find 版本
- xargs 版本
- find: 无效路径

#### `test_findutils_find`

> 功能测试 - findutils - find 基本查找

**功能点：**

- find 版本
- xargs 版本
- find -name: 按名称查找
- find -type f: 查找文件
- find -type d: 查找目录

#### `test_findutils_find_1`

> 功能测试 - findutils - find 选项

**功能点：**

- find 版本
- xargs 版本
- find -maxdepth: 最大深度
- find -mindepth: 最小深度
- find -empty: 空文件/目录
- find -size: 按大小

#### `test_findutils_find_line_operations`

> 功能测试 - findutils - find 执行操作

**功能点：**

- find 版本
- xargs 版本
- find -exec: 执行命令
- find -delete: 删除文件
- find -delete: 验证删除

#### `test_findutils_xargs`

> 功能测试 - findutils - xargs

**功能点：**

- find 版本
- xargs 版本
- xargs: 基本用法
- xargs -n1: 每次一个参数

</details>

---

## gcc

<details open>
<summary><b>gcc — 12 个测试用例</b></summary>

#### `test_gcc_assembly_output`

> 功能测试 - gcc - Assembly output

**功能点：**

- Check gcc package is installed
- Check gcc-c++ package is installed
- Check gcc command is available
- Check g++ command is available
- Check cpp command is available
- Generate assembly with -S
- Check main label in assembly
- Assemble to object file

#### `test_gcc_basic_c_compilation`

> 功能测试 - gcc - Basic C compilation

**功能点：**

- Check gcc package is installed
- Check gcc-c++ package is installed
- Check gcc command is available
- Check g++ command is available
- Check cpp command is available
- Compile hello.c to hello
- Run compiled hello
- Verify output is ELF binary
- Compile with -o flag
- Run myhello

#### `test_gcc_c___compilation`

> 功能测试 - gcc - C++ compilation

**功能点：**

- Check gcc package is installed
- Check gcc-c++ package is installed
- Check gcc command is available
- Check g++ command is available
- Check cpp command is available
- Compile hello.cpp
- Compile with C++11 standard

#### `test_gcc_code_coverage__gcov`

> 功能测试 - gcc - Code coverage (gcov)

**功能点：**

- Check gcc package is installed
- Check gcc-c++ package is installed
- Check gcc command is available
- Check g++ command is available
- Check cpp command is available
- Compile with coverage flags
- Run coverage test program
- Run gcov
- Check gcov output file exists

#### `test_gcc_compiler_optimization_flags`

> 功能测试 - gcc - Compiler optimization flags

**功能点：**

- Check gcc package is installed
- Check gcc-c++ package is installed
- Check gcc command is available
- Check g++ command is available
- Check cpp command is available
- Compile with -O0
- Compile with -O2
- Compile with debug symbols -g
- Verify debug symbols present

#### `test_gcc_error_handling`

> 功能测试 - gcc - Error handling

**功能点：**

- Check gcc package is installed
- Check gcc-c++ package is installed
- Check gcc command is available
- Check g++ command is available
- Check cpp command is available
- Test syntax error detection
- Test missing file error
- Test undefined function error
- Test type mismatch warning

#### `test_gcc_gcc_toolchain_utilities`

> 功能测试 - gcc - GCC toolchain utilities

**功能点：**

- Check gcc package is installed
- Check gcc-c++ package is installed
- Check gcc command is available
- Check g++ command is available
- Check cpp command is available
- cc equals gcc
- c++ equals g++

#### `test_gcc_linking_and_libraries`

> 功能测试 - gcc - Linking and libraries

**功能点：**

- Check gcc package is installed
- Check gcc-c++ package is installed
- Check gcc command is available
- Check g++ command is available
- Check cpp command is available
- Link with -lm
- Run math linked program
- Compile static binary

#### `test_gcc_multi_file_compilation`

> 功能测试 - gcc - Multi-file compilation

**功能点：**

- Check gcc package is installed
- Check gcc-c++ package is installed
- Check gcc command is available
- Check g++ command is available
- Check cpp command is available
- Compile add.c to object
- Compile main.c to object
- Link multiple objects
- Run multi-file program
- Compile multiple files in one command
- Run single-command multi-file program

#### `test_gcc_preprocessor`

> 功能测试 - gcc - Preprocessor

**功能点：**

- Check gcc package is installed
- Check gcc-c++ package is installed
- Check gcc command is available
- Check g++ command is available
- Check cpp command is available
- Preprocess with -E
- Verify macro expanded in preprocessed output
- Compile preprocessed .i file
- Run from preprocessed source
- Compile with -D flag
- Run with -D defined macro

#### `test_gcc_special_features`

> 功能测试 - gcc - Special features

**功能点：**

- Check gcc package is installed
- Check gcc-c++ package is installed
- Check gcc command is available
- Check g++ command is available
- Check cpp command is available
- Compile with C99 standard
- Compile with __attribute__
- Run attribute test
- Compile with -I include path
- Run include path test

#### `test_gcc_warning_flags`

> 功能测试 - gcc - Warning flags

**功能点：**

- Check gcc package is installed
- Check gcc-c++ package is installed
- Check gcc command is available
- Check g++ command is available
- Check cpp command is available
- Compile with -Wall warnings enabled
- Compile with -Werror
- Compile with -pedantic

</details>

---

## git

<details open>
<summary><b>git — 15 个测试用例</b></summary>

#### `test_git_branch_operations`

> 功能测试 - git - Branch operations

**功能点：**

- Check git-core installed
- Check git available
- git branch: create branch
- git branch: list branches
- git branch -a: all branches
- git switch: switch branch
- git switch -: previous branch
- git branch -d: delete branch

#### `test_git_clean_and_gc`

> 功能测试 - git - Clean and gc

**功能点：**

- Check git-core installed
- Check git available
- git clean -n: dry run
- git gc: garbage collect

#### `test_git_error_handling`

> 功能测试 - git - Error handling

**功能点：**

- Check git-core installed
- Check git available
- git: invalid command
- git: invalid option

#### `test_git_file_modifications`

> 功能测试 - git - File modifications

**功能点：**

- Check git-core installed
- Check git available
- git add: second file
- git commit: second commit
- git diff: show changes
- git diff --cached: staged changes
- git commit: modify

#### `test_git_file_operations`

> 功能测试 - git - File operations

**功能点：**

- Check git-core installed
- Check git available
- git add: stage file
- git status --short
- git commit: first commit
- git log: show commits

#### `test_git_git_shell`

> 功能测试 - git - git-shell

**功能点：**

- Check git-core installed
- Check git available
- git-shell available

#### `test_git_grep_and_blame`

> 功能测试 - git - grep and blame

**功能点：**

- Check git-core installed
- Check git available
- git grep: search
- git blame: annotate

#### `test_git_log_and_show`

> 功能测试 - git - Log and show

**功能点：**

- Check git-core installed
- Check git available
- git log: last 3 commits
- git log --graph
- git show: latest commit
- git show: previous commit

#### `test_git_remote_operations`

> 功能测试 - git - Remote operations

**功能点：**

- Check git-core installed
- Check git available
- git remote: list remotes
- git remote add

#### `test_git_repository_initialization`

> 功能测试 - git - Repository initialization

**功能点：**

- Check git-core installed
- Check git available
- git init: create repo
- git status: check status
- git init: .git directory exists

#### `test_git_reset_and_restore`

> 功能测试 - git - Reset and restore

**功能点：**

- Check git-core installed
- Check git available
- git add: temp file
- git reset: unstage
- git restore --staged
- Cleanup temp

#### `test_git_scalar`

> 功能测试 - git - scalar

**功能点：**

- Check git-core installed
- Check git available
- scalar available
- scalar help

#### `test_git_stash`

> 功能测试 - git - Stash

**功能点：**

- Check git-core installed
- Check git available
- git stash: push
- git stash list
- git stash pop

#### `test_git_tag_operations`

> 功能测试 - git - Tag operations

**功能点：**

- Check git-core installed
- Check git available
- git tag: create tag
- git tag: list tags
- git tag -d: delete tag

#### `test_git_user_configuration`

> 功能测试 - git - User configuration

**功能点：**

- Check git-core installed
- Check git available
- git config: set user name
- git config: set email
- git config: get user name
- git config --list

</details>

---

## glibc

<details open>
<summary><b>glibc — 2 个测试用例</b></summary>

#### `test_glibc_error_handling`

> 功能测试 - glibc - 错误处理

**功能点：**

- gencat: 无效选项

#### `test_glibc_version_help`

> 功能测试 - glibc - 版本和帮助

**功能点：**

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

</details>

---

## gmp

<details open>
<summary><b>gmp — 2 个测试用例</b></summary>

#### `test_gmp_error_handling`

> 功能测试 - gmp - 错误处理

**测试段：**
- 错误处理

#### `test_gmp_version_help`

> 功能测试 - gmp - 版本和帮助

**功能点：**

- 列出包文件
- 库文件检查

</details>

---

## grep

<details open>
<summary><b>grep — 13 个测试用例</b></summary>

#### `test_grep_basic_pattern_matching`

> 功能测试 - grep - Basic pattern matching

**功能点：**

- Check grep package is installed
- Check grep command is available
- Check egrep command is available
- Check fgrep command is available
- Basic grep for Hello
- Verify multiple matches
- Grep from pipe
- Grep across multiple files

#### `test_grep_case_insensitive___i`

> 功能测试 - grep - Case insensitive (-i)

**功能点：**

- Check grep package is installed
- Check grep command is available
- Check egrep command is available
- Check fgrep command is available
- Case insensitive grep
- Verify case insensitive matches
- Case sensitive: lowercase only matches lowercase

#### `test_grep_context_lines___a___b___c`

> 功能测试 - grep - Context lines (-A, -B, -C)

**功能点：**

- Check grep package is installed
- Check grep command is available
- Check egrep command is available
- Check fgrep command is available
- Hello World
- Hello Linux
- Hello World

#### `test_grep_count_and_line_numbers___c___n`

> 功能测试 - grep - Count and line numbers (-c, -n)

**功能点：**

- Check grep package is installed
- Check grep command is available
- Check egrep command is available
- Check fgrep command is available
- Count matches with -c
- Verify count >= 2
- Show line numbers with -n
- Verify line number format

#### `test_grep_error_handling`

> 功能测试 - grep - Error handling

**功能点：**

- Check grep package is installed
- Check grep command is available
- Check egrep command is available
- Check fgrep command is available
- Error on nonexistent file
- Error on invalid regex
- Error on directory without -r
- No match returns exit code 1

#### `test_grep_extended_regex___e`

> 功能测试 - grep - Extended regex (-E)

**功能点：**

- Check grep package is installed
- Check grep command is available
- Check egrep command is available
- Check fgrep command is available
- Extended regex with alternation
- Extended regex: digit quantifier
- Verify digit match count
- egrep equivalent to grep -E

#### `test_grep_file_listing___l___l`

> 功能测试 - grep - File listing (-l, -L)

**功能点：**

- Check grep package is installed
- Check grep command is available
- Check egrep command is available
- Check fgrep command is available
- List files with matches
- List files without matches

#### `test_grep_fixed_strings___f`

> 功能测试 - grep - Fixed strings (-F)

**功能点：**

- Check grep package is installed
- Check grep command is available
- Check egrep command is available
- Check fgrep command is available
- Fixed string with special chars
- Fixed string: no regex meta-char interpretation
- fgrep equivalent to grep -F

#### `test_grep_invert_match___v`

> 功能测试 - grep - Invert match (-v)

**功能点：**

- Check grep package is installed
- Check grep command is available
- Check egrep command is available
- Check fgrep command is available
- Invert match: exclude Hello
- Verify inverted output contains other lines

#### `test_grep_multiple_patterns___e___f`

> 功能测试 - grep - Multiple patterns (-e, -f)

**功能点：**

- Check grep package is installed
- Check grep command is available
- Check egrep command is available
- Check fgrep command is available
- Multiple patterns with -e
- Patterns from file with -f
- Max count: stop after first match

#### `test_grep_only_matching_and_quiet___o___q`

> 功能测试 - grep - Only matching and quiet (-o, -q)

**功能点：**

- Check grep package is installed
- Check grep command is available
- Check egrep command is available
- Check fgrep command is available
- Only matching: digits only
- Quiet mode: pattern found
- Quiet mode: pattern not found

#### `test_grep_recursive_search___r`

> 功能测试 - grep - Recursive search (-r)

**功能点：**

- Check grep package is installed
- Check grep command is available
- Check egrep command is available
- Check fgrep command is available
- Recursive grep in subdirectory
- Recursive list files with matches
- Recursive with --include filter

#### `test_grep_word_and_line_matching___w___x`

> 功能测试 - grep - Word and line matching (-w, -x)

**功能点：**

- Check grep package is installed
- Check grep command is available
- Check egrep command is available
- Check fgrep command is available
- Create word test file
- Add line with separate words
- Whole word match: hello matches only standalone
- Create line test file
- Add different line
- Whole line exact match

</details>

---

## gxx

<details open>
<summary><b>gxx — 9 个测试用例</b></summary>

#### `test_gxx_basic_c___compilation`

> 功能测试 - gxx - Basic C++ compilation

**功能点：**

- Check gcc-c++ is installed
- Check g++ command available
- Check c++ command available
- Compile hello.cpp
- Run compiled binary
- Output is ELF binary

#### `test_gxx_c___alias`

> 功能测试 - gxx - c++ alias

**功能点：**

- Check gcc-c++ is installed
- Check g++ command available
- Check c++ command available
- c++ alias works

#### `test_gxx_compile_only`

> 功能测试 - gxx - Compile-only

**功能点：**

- Check gcc-c++ is installed
- Check g++ command available
- Check c++ command available
- g++ -c: compile only
- Object file exists

#### `test_gxx_debug_and_warnings`

> 功能测试 - gxx - Debug and warnings

**功能点：**

- Check gcc-c++ is installed
- Check g++ command available
- Check c++ command available
- Debug symbols
- -Wall warnings
- -Wextra warnings

#### `test_gxx_error_handling`

> 功能测试 - gxx - Error handling

**功能点：**

- Check gcc-c++ is installed
- Check g++ command available
- Check c++ command available
- Compilation error
- Invalid option

#### `test_gxx_include_paths`

> 功能测试 - gxx - Include paths

**功能点：**

- Check gcc-c++ is installed
- Check g++ command available
- Check c++ command available
- g++ -I: include path

#### `test_gxx_linking`

> 功能测试 - gxx - Linking

**功能点：**

- Check gcc-c++ is installed
- Check g++ command available
- Check c++ command available
- Link from object
- g++ -shared: shared library

#### `test_gxx_optimization`

> 功能测试 - gxx - Optimization

**功能点：**

- Check gcc-c++ is installed
- Check g++ command available
- Check c++ command available
- Optimization -$lvl

#### `test_gxx_preprocessor`

> 功能测试 - gxx - Preprocessor

**功能点：**

- Check gcc-c++ is installed
- Check g++ command available
- Check c++ command available
- g++ -E: preprocess

</details>

---

## gzip

<details open>
<summary><b>gzip — 2 个测试用例</b></summary>

#### `test_gzip_error_handling`

> 功能测试 - gzip - 错误处理

**功能点：**

- gzip: 无效选项

#### `test_gzip_version_help`

> 功能测试 - gzip - 版本和帮助

**功能点：**

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
- ... 等共 28 个测试点

</details>

---

## iputils

<details open>
<summary><b>iputils — 10 个测试用例</b></summary>

#### `test_iputils_arping`

> 功能测试 - iputils - arping

**测试段：**
- arping

#### `test_iputils_clockdiff`

> 功能测试 - iputils - clockdiff

**测试段：**
- clockdiff

#### `test_iputils_network_interface_testing`

> 功能测试 - iputils - Network interface testing

**测试段：**
- Network interface testing

#### `test_iputils_ping6__ipv6`

> 功能测试 - iputils - ping6 (IPv6)

**测试段：**
- ping6 (IPv6)

#### `test_iputils_ping_advanced_options`

> 功能测试 - iputils - ping advanced options

**测试段：**
- ping advanced options

#### `test_iputils_ping_basic_functionality`

> 功能测试 - iputils - ping basic functionality

**测试段：**
- ping basic functionality

#### `test_iputils_ping_error_handling`

> 功能测试 - iputils - ping error handling

**测试段：**
- ping error handling

#### `test_iputils_ping_special_scenarios`

> 功能测试 - iputils - ping special scenarios

**测试段：**
- ping special scenarios

#### `test_iputils_tracepath`

> 功能测试 - iputils - tracepath

**测试段：**
- tracepath

#### `test_iputils_traceroute6`

> 功能测试 - iputils - traceroute6

**测试段：**
- traceroute6

</details>

---

## isl

<details open>
<summary><b>isl — 2 个测试用例</b></summary>

#### `test_isl_error_handling`

> 功能测试 - isl - 错误处理

**测试段：**
- 错误处理

#### `test_isl_version_help`

> 功能测试 - isl - 版本和帮助

**功能点：**

- 列出包文件
- 库文件检查

</details>

---

## labwc

<details open>
<summary><b>labwc — 9 个测试用例</b></summary>

#### `test_labwc_check_for_display__no_display`

> 功能测试 - labwc - Check for display (no DISPLAY)

**功能点：**

- Check labwc installed
- Check labwc available
- Check labnag available
- Check lab-sensible-terminal available
- labwc: startup/session options

#### `test_labwc_config_dirs`

> 功能测试 - labwc - Config dirs

**功能点：**

- Check labwc installed
- Check labwc available
- Check labnag available
- Check lab-sensible-terminal available
- System config dir
- Data dir

#### `test_labwc_configuration`

> 功能测试 - labwc - Configuration

**功能点：**

- Check labwc installed
- Check labwc available
- Check labnag available
- Check lab-sensible-terminal available
- labwc: config options

#### `test_labwc_debug_mode`

> 功能测试 - labwc - Debug mode

**功能点：**

- Check labwc installed
- Check labwc available
- Check labnag available
- Check lab-sensible-terminal available
- labwc: debug option

#### `test_labwc_error_handling`

> 功能测试 - labwc - Error handling

**功能点：**

- Check labwc installed
- Check labwc available
- Check labnag available
- Check lab-sensible-terminal available
- labwc: invalid option

#### `test_labwc_help`

> 功能测试 - labwc - Help

**功能点：**

- Check labwc installed
- Check labwc available
- Check labnag available
- Check lab-sensible-terminal available
- labwc help

#### `test_labwc_lab_sensible_terminal`

> 功能测试 - labwc - lab-sensible-terminal

**功能点：**

- Check labwc installed
- Check labwc available
- Check labnag available
- Check lab-sensible-terminal available
- lab-sensible-terminal help

#### `test_labwc_labnag`

> 功能测试 - labwc - labnag

**功能点：**

- Check labwc installed
- Check labwc available
- Check labnag available
- Check lab-sensible-terminal available
- labnag help

#### `test_labwc_library_check`

> 功能测试 - labwc - Library check

**功能点：**

- Check labwc installed
- Check labwc available
- Check labnag available
- Check lab-sensible-terminal available
- labwc: linked libraries

</details>

---

## libselinux

<details open>
<summary><b>libselinux — 2 个测试用例</b></summary>

#### `test_libselinux_error_handling`

> 功能测试 - libselinux - 错误处理

**测试段：**
- 错误处理

#### `test_libselinux_version_help`

> 功能测试 - libselinux - 版本和帮助

**功能点：**

- 列出包文件
- 库文件检查

</details>

---

## linux-headers

<details open>
<summary><b>linux-headers — 2 个测试用例</b></summary>

#### `test_linux_headers_error_handling`

> 功能测试 - linux-headers - 错误处理

**测试段：**
- 错误处理

#### `test_linux_headers_version_help`

> 功能测试 - linux-headers - 版本和帮助

**功能点：**

- 列出包文件
- 库文件检查

</details>

---

## lua

<details open>
<summary><b>lua — 2 个测试用例</b></summary>

#### `test_lua_error_handling`

> 功能测试 - lua - 错误处理

**功能点：**

- lua: 无效选项

#### `test_lua_version_help`

> 功能测试 - lua - 版本和帮助

**功能点：**

- lua 版本信息
- lua 帮助信息
- luac 版本信息
- luac 帮助信息

</details>

---

## make

<details open>
<summary><b>make — 9 个测试用例</b></summary>

#### `test_make_basic_makefile_execution`

> 功能测试 - make - Basic Makefile execution

**功能点：**

- Check make is installed
- Check make command available
- Check gmake command available
- Run default target
- Run specific target
- Run clean target
- make -s: silent mode

#### `test_make_directory_change`

> 功能测试 - make - Directory change

**功能点：**

- Check make is installed
- Check make command available
- Check gmake command available
- make -C: change directory

#### `test_make_environment`

> 功能测试 - make - Environment

**功能点：**

- Check make is installed
- Check make command available
- Check gmake command available
- make -e: environment overrides
- Environment variable in make

#### `test_make_error_handling`

> 功能测试 - make - Error handling

**功能点：**

- Check make is installed
- Check make command available
- Check gmake command available
- make -k: continue on error
- make -i: ignore errors

#### `test_make_gmake_alias`

> 功能测试 - make - gmake alias

**功能点：**

- Check make is installed
- Check make command available
- Check gmake command available
- gmake is GNU Make

#### `test_make_include`

> 功能测试 - make - Include

**功能点：**

- Check make is installed
- Check make command available
- Check gmake command available
- Include file

#### `test_make_options`

> 功能测试 - make - Options

**功能点：**

- Check make is installed
- Check make command available
- Check gmake command available
- make -n: dry run
- make -B: always make
- make --just-print
- make -d: debug output
- make --debug=b: basic debug
- make -q: question mode
- make -s: silent

#### `test_make_parallel_execution`

> 功能测试 - make - Parallel execution

**功能点：**

- Check make is installed
- Check make command available
- Check gmake command available
- make -j2: parallel 2 jobs

#### `test_make_variables`

> 功能测试 - make - Variables

**功能点：**

- Check make is installed
- Check make command available
- Check gmake command available
- Variable expansion
- Override variable

</details>

---

## mpc

<details open>
<summary><b>mpc — 2 个测试用例</b></summary>

#### `test_mpc_error_handling`

> 功能测试 - mpc - 错误处理

**测试段：**
- 错误处理

#### `test_mpc_version_help`

> 功能测试 - mpc - 版本和帮助

**功能点：**

- 列出包文件
- 库文件检查

</details>

---

## mpdecimal

<details open>
<summary><b>mpdecimal — 2 个测试用例</b></summary>

#### `test_mpdecimal_error_handling`

> 功能测试 - mpdecimal - 错误处理

**测试段：**
- 错误处理

#### `test_mpdecimal_version_help`

> 功能测试 - mpdecimal - 版本和帮助

**功能点：**

- 列出包文件
- 库文件检查

</details>

---

## mpfr

<details open>
<summary><b>mpfr — 2 个测试用例</b></summary>

#### `test_mpfr_error_handling`

> 功能测试 - mpfr - 错误处理

**测试段：**
- 错误处理

#### `test_mpfr_version_help`

> 功能测试 - mpfr - 版本和帮助

**功能点：**

- 列出包文件
- 库文件检查

</details>

---

## nettle

<details open>
<summary><b>nettle — 2 个测试用例</b></summary>

#### `test_nettle_error_handling`

> 功能测试 - nettle - 错误处理

**功能点：**

- nettle-hash: 无效选项

#### `test_nettle_version_help`

> 功能测试 - nettle - 版本和帮助

**功能点：**

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

</details>

---

## newt

<details open>
<summary><b>newt — 2 个测试用例</b></summary>

#### `test_newt_error_handling`

> 功能测试 - newt - 错误处理

**功能点：**

- whiptail: 无效选项

#### `test_newt_version_help`

> 功能测试 - newt - 版本和帮助

**功能点：**

- whiptail 版本信息
- whiptail 帮助信息

</details>

---

## openssh

<details open>
<summary><b>openssh — 12 个测试用例</b></summary>

#### `test_openssh_change_comment`

> 功能测试 - openssh - Change comment

**功能点：**

- Check openssh is installed
- Check ssh-keygen available
- ssh-keygen help
- Change key comment

#### `test_openssh_ecdsa_key_generation`

> 功能测试 - openssh - ECDSA key generation

**功能点：**

- Check openssh is installed
- Check ssh-keygen available
- ssh-keygen help
- Generate ECDSA 256 key
- Show ECDSA fingerprint

#### `test_openssh_ed25519_key_generation`

> 功能测试 - openssh - Ed25519 key generation

**功能点：**

- Check openssh is installed
- Check ssh-keygen available
- ssh-keygen help
- Generate Ed25519 key
- Show Ed25519 fingerprint
- Verbose fingerprint

#### `test_openssh_error_handling`

> 功能测试 - openssh - Error handling

**功能点：**

- Check openssh is installed
- Check ssh-keygen available
- ssh-keygen help
- Invalid key type
- Invalid path

#### `test_openssh_fingerprint_hashes`

> 功能测试 - openssh - Fingerprint hashes

**功能点：**

- Check openssh is installed
- Check ssh-keygen available
- ssh-keygen help
- SHA256 fingerprint
- MD5 fingerprint

#### `test_openssh_hash_known_hosts`

> 功能测试 - openssh - Hash known hosts

**功能点：**

- Check openssh is installed
- Check ssh-keygen available
- ssh-keygen help
- Hash known hosts

#### `test_openssh_key_conversion`

> 功能测试 - openssh - Key conversion

**功能点：**

- Check openssh is installed
- Check ssh-keygen available
- ssh-keygen help
- Export RFC4716 format
- Import RFC4716 format

#### `test_openssh_key_with_comment`

> 功能测试 - openssh - Key with comment

**功能点：**

- Check openssh is installed
- Check ssh-keygen available
- ssh-keygen help
- Generate key with comment
- Verify comment in pubkey

#### `test_openssh_key_with_passphrase`

> 功能测试 - openssh - Key with passphrase

**功能点：**

- Check openssh is installed
- Check ssh-keygen available
- ssh-keygen help
- Generate key with passphrase
- Remove passphrase

#### `test_openssh_public_key_extraction`

> 功能测试 - openssh - Public key extraction

**功能点：**

- Check openssh is installed
- Check ssh-keygen available
- ssh-keygen help
- Extract public key from private

#### `test_openssh_rsa_key_generation`

> 功能测试 - openssh - RSA key generation

**功能点：**

- Check openssh is installed
- Check ssh-keygen available
- ssh-keygen help
- Generate RSA 2048 key
- Private key exists
- Public key exists
- Show RSA key fingerprint

#### `test_openssh_rsa_key_options`

> 功能测试 - openssh - RSA key options

**功能点：**

- Check openssh is installed
- Check ssh-keygen available
- ssh-keygen help
- Generate RSA 2048 key
- Verify RSA 2048 key

</details>

---

## openssh-clients

<details open>
<summary><b>openssh-clients — 9 个测试用例</b></summary>

#### `test_openssh_clients_error_handling`

> 功能测试 - openssh-clients - Error handling

**功能点：**

- Check openssh-clients installed
- Check ssh available
- Check scp available
- Check sftp available
- Check ssh-add available
- Check ssh-agent available
- Check ssh-copy-id available
- Check ssh-keyscan available

#### `test_openssh_clients_scp`

> 功能测试 - openssh-clients - scp

**功能点：**

- Check openssh-clients installed
- Check ssh available
- Check scp available
- Check sftp available
- Check ssh-add available
- Check ssh-agent available
- Check ssh-copy-id available
- Check ssh-keyscan available

#### `test_openssh_clients_sftp`

> 功能测试 - openssh-clients - sftp

**功能点：**

- Check openssh-clients installed
- Check ssh available
- Check scp available
- Check sftp available
- Check ssh-add available
- Check ssh-agent available
- Check ssh-copy-id available
- Check ssh-keyscan available
- sftp: help command

#### `test_openssh_clients_ssh_agent`

> 功能测试 - openssh-clients - ssh-agent

**功能点：**

- Check openssh-clients installed
- Check ssh available
- Check scp available
- Check sftp available
- Check ssh-add available
- Check ssh-agent available
- Check ssh-copy-id available
- Check ssh-keyscan available
- ssh-add: list keys
- ssh-add: add key
- ssh-add: verify key added
- ssh-add -L: list public keys
- ssh-add -d: remove key

#### `test_openssh_clients_ssh_connection__dry_run`

> 功能测试 - openssh-clients - ssh connection (dry-run)

**功能点：**

- Check openssh-clients installed
- Check ssh available
- Check scp available
- Check sftp available
- Check ssh-add available
- Check ssh-agent available
- Check ssh-copy-id available
- Check ssh-keyscan available
- ssh -G: print config
- ssh -T: disable PTY
- ssh -v: verbose

#### `test_openssh_clients_ssh_copy_id`

> 功能测试 - openssh-clients - ssh-copy-id

**功能点：**

- Check openssh-clients installed
- Check ssh available
- Check scp available
- Check sftp available
- Check ssh-add available
- Check ssh-agent available
- Check ssh-copy-id available
- Check ssh-keyscan available

#### `test_openssh_clients_ssh_keygen_via_openssh`

> 功能测试 - openssh-clients - ssh-keygen via openssh

**功能点：**

- Check openssh-clients installed
- Check ssh available
- Check scp available
- Check sftp available
- Check ssh-add available
- Check ssh-agent available
- Check ssh-copy-id available
- Check ssh-keyscan available
- Generate test key

#### `test_openssh_clients_ssh_keyscan`

> 功能测试 - openssh-clients - ssh-keyscan

**功能点：**

- Check openssh-clients installed
- Check ssh available
- Check scp available
- Check sftp available
- Check ssh-add available
- Check ssh-agent available
- Check ssh-copy-id available
- Check ssh-keyscan available
- ssh-keyscan: scan localhost
- ssh-keyscan -t rsa
- ssh-keyscan -t ecdsa

#### `test_openssh_clients_ssh_version_and_help`

> 功能测试 - openssh-clients - ssh version and help

**功能点：**

- Check openssh-clients installed
- Check ssh available
- Check scp available
- Check sftp available
- Check ssh-add available
- Check ssh-agent available
- Check ssh-copy-id available
- Check ssh-keyscan available
- ssh -Q key: supported keys
- ssh -Q cipher: ciphers
- ssh -Q mac: MACs
- ssh -Q kex: key exchange

</details>

---

## pam

<details open>
<summary><b>pam — 2 个测试用例</b></summary>

#### `test_pam_error_handling`

> 功能测试 - pam - 错误处理

**功能点：**

- faillock: 无效选项

#### `test_pam_version_help`

> 功能测试 - pam - 版本和帮助

**功能点：**

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

</details>

---

## pciutils

<details open>
<summary><b>pciutils — 13 个测试用例</b></summary>

#### `test_pciutils_error_handling`

> 功能测试 - pciutils - Error handling

**测试段：**
- Error handling

#### `test_pciutils_lspci_basic`

> 功能测试 - pciutils - lspci basic

**测试段：**
- lspci basic

#### `test_pciutils_lspci_by_device_class`

> 功能测试 - pciutils - lspci by device class

**测试段：**
- lspci by device class

#### `test_pciutils_lspci_format_options`

> 功能测试 - pciutils - lspci format options

**测试段：**
- lspci format options

#### `test_pciutils_lspci_kernel_drivers`

> 功能测试 - pciutils - lspci kernel drivers

**测试段：**
- lspci kernel drivers

#### `test_pciutils_lspci_numeric`

> 功能测试 - pciutils - lspci numeric

**测试段：**
- lspci numeric

#### `test_pciutils_lspci_tree_view`

> 功能测试 - pciutils - lspci tree view

**测试段：**
- lspci tree view

#### `test_pciutils_lspci_verbose`

> 功能测试 - pciutils - lspci verbose

**测试段：**
- lspci verbose

#### `test_pciutils_lspci_with_domain`

> 功能测试 - pciutils - lspci with domain

**测试段：**
- lspci with domain

#### `test_pciutils_lspci_with_filtering`

> 功能测试 - pciutils - lspci with filtering

**测试段：**
- lspci with filtering

#### `test_pciutils_pcilmr`

> 功能测试 - pciutils - pcilmr

**测试段：**
- pcilmr

#### `test_pciutils_setpci`

> 功能测试 - pciutils - setpci

**测试段：**
- setpci

#### `test_pciutils_update_pciids`

> 功能测试 - pciutils - update-pciids

**测试段：**
- update-pciids

</details>

---

## pkgconf

<details open>
<summary><b>pkgconf — 2 个测试用例</b></summary>

#### `test_pkgconf_error_handling`

> 功能测试 - pkgconf - 错误处理

**功能点：**

- pkgconf: 无效选项

#### `test_pkgconf_version_help`

> 功能测试 - pkgconf - 版本和帮助

**功能点：**

- pkgconf 版本信息
- pkgconf 帮助信息
- bomtool 版本信息
- bomtool 帮助信息

</details>

---

## podman

<details open>
<summary><b>podman — 7 个测试用例</b></summary>

#### `test_podman_container_operations`

> 功能测试 - podman - Container operations

**功能点：**

- Check podman installed
- Check podman available
- Check podman-remote available
- podman info
- podman ps: list containers
- podman ps -a: all containers
- podman container list

#### `test_podman_error_handling`

> 功能测试 - podman - Error handling

**功能点：**

- Check podman installed
- Check podman available
- Check podman-remote available
- podman info
- podman: invalid command

#### `test_podman_help_commands`

> 功能测试 - podman - Help commands

**功能点：**

- Check podman installed
- Check podman available
- Check podman-remote available
- podman info
- podman manifest help
- podman healthcheck help
- podman events help
- podman pod list
- podman-remote help

#### `test_podman_image_operations`

> 功能测试 - podman - Image operations

**功能点：**

- Check podman installed
- Check podman available
- Check podman-remote available
- podman info
- podman images: list images
- podman image list

#### `test_podman_network_operations`

> 功能测试 - podman - Network operations

**功能点：**

- Check podman installed
- Check podman available
- Check podman-remote available
- podman info
- podman network ls
- podman network inspect

#### `test_podman_system_operations`

> 功能测试 - podman - System operations

**功能点：**

- Check podman installed
- Check podman available
- Check podman-remote available
- podman info
- podman system info
- podman system df: disk usage

#### `test_podman_volume_operations`

> 功能测试 - podman - Volume operations

**功能点：**

- Check podman installed
- Check podman available
- Check podman-remote available
- podman info
- podman volume ls

</details>

---

## podmansh

<details open>
<summary><b>podmansh — 11 个测试用例</b></summary>

#### `test_podmansh_cleanup`

> 功能测试 - podmansh - Cleanup

**测试段：**
- Cleanup

#### `test_podmansh_error_handling`

> 功能测试 - podmansh - Error handling

**测试段：**
- Error handling

#### `test_podmansh_podman_basic`

> 功能测试 - podmansh - podman basic

**测试段：**
- podman basic

#### `test_podmansh_podman_images`

> 功能测试 - podmansh - podman images

**测试段：**
- podman images

#### `test_podmansh_podman_network`

> 功能测试 - podmansh - podman network

**测试段：**
- podman network

#### `test_podmansh_podman_ps`

> 功能测试 - podmansh - podman ps

**测试段：**
- podman ps

#### `test_podmansh_podman_stats`

> 功能测试 - podmansh - podman stats

**测试段：**
- podman stats

#### `test_podmansh_podman_volume`

> 功能测试 - podmansh - podman volume

**测试段：**
- podman volume

#### `test_podmansh_podmansh_basic`

> 功能测试 - podmansh - podmansh basic

**测试段：**
- podmansh basic

#### `test_podmansh_podmansh_config`

> 功能测试 - podmansh - podmansh config

**测试段：**
- podmansh config

#### `test_podmansh_podmansh_help`

> 功能测试 - podmansh - podmansh help

**测试段：**
- podmansh help

</details>

---

## procps-ng

<details open>
<summary><b>procps-ng — 14 个测试用例</b></summary>

#### `test_procps_ng_error_handling`

> 功能测试 - procps-ng - Error handling

**测试段：**
- Error handling

#### `test_procps_ng_free_command`

> 功能测试 - procps-ng - free command

**测试段：**
- free command

#### `test_procps_ng_kill_command`

> 功能测试 - procps-ng - kill command

**测试段：**
- kill command

#### `test_procps_ng_pidof_and_pgrep`

> 功能测试 - procps-ng - pidof and pgrep

**测试段：**
- pidof and pgrep

#### `test_procps_ng_pkill_and_pidwait`

> 功能测试 - procps-ng - pkill and pidwait

**测试段：**
- pkill and pidwait

#### `test_procps_ng_ps_command_advanced_features`

> 功能测试 - procps-ng - ps command advanced features

**测试段：**
- ps command advanced features

#### `test_procps_ng_ps_command_basic_functionality`

> 功能测试 - procps-ng - ps command basic functionality

**测试段：**
- ps command basic functionality

#### `test_procps_ng_pwdx_and_pmap`

> 功能测试 - procps-ng - pwdx and pmap

**测试段：**
- pwdx and pmap

#### `test_procps_ng_slabtop__tload__watch__hugetop`

> 功能测试 - procps-ng - slabtop, tload, watch, hugetop

**测试段：**
- slabtop, tload, watch, hugetop

#### `test_procps_ng_special_scenarios`

> 功能测试 - procps-ng - Special scenarios

**测试段：**
- Special scenarios

#### `test_procps_ng_sysctl__if_available`

> 功能测试 - procps-ng - sysctl (if available)

**测试段：**
- sysctl (if available)

#### `test_procps_ng_top_command`

> 功能测试 - procps-ng - top command

**测试段：**
- top command

#### `test_procps_ng_uptime_and_w_commands`

> 功能测试 - procps-ng - uptime and w commands

**测试段：**
- uptime and w commands

#### `test_procps_ng_vmstat_command`

> 功能测试 - procps-ng - vmstat command

**测试段：**
- vmstat command

</details>

---

## psmisc

<details open>
<summary><b>psmisc — 13 个测试用例</b></summary>

#### `test_psmisc_error_handling`

> 功能测试 - psmisc - Error handling

**测试段：**
- Error handling

#### `test_psmisc_fuser_basic`

> 功能测试 - psmisc - fuser basic

**测试段：**
- fuser basic

#### `test_psmisc_fuser_mount_points`

> 功能测试 - psmisc - fuser mount points

**测试段：**
- fuser mount points

#### `test_psmisc_fuser_special_cases`

> 功能测试 - psmisc - fuser special cases

**测试段：**
- fuser special cases

#### `test_psmisc_fuser_with_options`

> 功能测试 - psmisc - fuser with options

**测试段：**
- fuser with options

#### `test_psmisc_fuser_with_processes`

> 功能测试 - psmisc - fuser with processes

**测试段：**
- fuser with processes

#### `test_psmisc_killall_basic`

> 功能测试 - psmisc - killall basic

**测试段：**
- killall basic

#### `test_psmisc_killall_with_signals`

> 功能测试 - psmisc - killall with signals

**测试段：**
- killall with signals

#### `test_psmisc_peekfd`

> 功能测试 - psmisc - peekfd

**测试段：**
- peekfd

#### `test_psmisc_prtstat`

> 功能测试 - psmisc - prtstat

**测试段：**
- prtstat

#### `test_psmisc_pslog`

> 功能测试 - psmisc - pslog

**测试段：**
- pslog

#### `test_psmisc_pstree_basic`

> 功能测试 - psmisc - pstree basic

**测试段：**
- pstree basic

#### `test_psmisc_pstree_with_options`

> 功能测试 - psmisc - pstree with options

**测试段：**
- pstree with options

</details>

---

## python

<details open>
<summary><b>python — 5 个测试用例</b></summary>

#### `test_python_basic_execution`

> 功能测试 - python - 基本执行

**功能点：**

- Python 版本
- python3 可用
- Python 基本运算
- Python sys模块

#### `test_python_command_options`

> 功能测试 - python - 命令行选项

**功能点：**

- Python 版本
- python3 可用
- python3 -h: 帮助
- python3 -V: 版本
- python3: os模块

#### `test_python_error_handling`

> 功能测试 - python - 错误处理

**功能点：**

- Python 版本
- python3 可用
- python3: 导入错误

#### `test_python_module_import`

> 功能测试 - python - 模块导入

**功能点：**

- Python 版本
- python3 可用
- python3: 导入标准模块

#### `test_python_script_execution`

> 功能测试 - python - 脚本执行

**功能点：**

- Python 版本
- python3 可用
- python3 执行脚本

</details>

---

## rpm-config-openruyi

<details open>
<summary><b>rpm-config-openruyi — 2 个测试用例</b></summary>

#### `test_rpm_config_openruyi_error_handling`

> 功能测试 - rpm-config-openruyi - 错误处理

**测试段：**
- 错误处理

#### `test_rpm_config_openruyi_version_help`

> 功能测试 - rpm-config-openruyi - 版本和帮助

**功能点：**

- 列出包文件
- 库文件检查

</details>

---

## rpmbuild

<details open>
<summary><b>rpmbuild — 9 个测试用例</b></summary>

#### `test_rpmbuild_build_rpm_package`

> 功能测试 - rpmbuild - Build RPM package

**测试段：**
- Build RPM package

#### `test_rpmbuild_create_simple_spec_file`

> 功能测试 - rpmbuild - Create simple spec file

**测试段：**
- Create simple spec file

#### `test_rpmbuild_create_source_tarball`

> 功能测试 - rpmbuild - Create source tarball

**测试段：**
- Create source tarball

#### `test_rpmbuild_error_handling`

> 功能测试 - rpmbuild - Error handling

**测试段：**
- Error handling

#### `test_rpmbuild_install_and_test_rpm`

> 功能测试 - rpmbuild - Install and test RPM

**测试段：**
- Install and test RPM

#### `test_rpmbuild_rpm_build_options`

> 功能测试 - rpmbuild - RPM build options

**测试段：**
- RPM build options

#### `test_rpmbuild_rpm_verification`

> 功能测试 - rpmbuild - RPM verification

**测试段：**
- RPM verification

#### `test_rpmbuild_rpmbuild_basic_functionality`

> 功能测试 - rpmbuild - rpmbuild basic functionality

**测试段：**
- rpmbuild basic functionality

#### `test_rpmbuild_verify_built_rpm`

> 功能测试 - rpmbuild - Verify built RPM

**测试段：**
- Verify built RPM

</details>

---

## sddm

<details open>
<summary><b>sddm — 7 个测试用例</b></summary>

#### `test_sddm_config_values`

> 功能测试 - sddm - Config values

**功能点：**

- Check sddm installed
- Check sddm available
- Check sddm-greeter available
- sddm: key config values

#### `test_sddm_configuration`

> 功能测试 - sddm - Configuration

**功能点：**

- Check sddm installed
- Check sddm available
- Check sddm-greeter available
- sddm: example config
- Config directory
- Default config dir

#### `test_sddm_d_bus`

> 功能测试 - sddm - D-Bus

**功能点：**

- Check sddm installed
- Check sddm available
- Check sddm-greeter available

#### `test_sddm_error_handling`

> 功能测试 - sddm - Error handling

**功能点：**

- Check sddm installed
- Check sddm available
- Check sddm-greeter available

#### `test_sddm_service_check`

> 功能测试 - sddm - Service check

**功能点：**

- Check sddm installed
- Check sddm available
- Check sddm-greeter available
- sddm service unit
- sddm service status
- sddm enabled status

#### `test_sddm_theme_check`

> 功能测试 - sddm - Theme check

**功能点：**

- Check sddm installed
- Check sddm available
- Check sddm-greeter available
- sddm themes installed

#### `test_sddm_version_and_help`

> 功能测试 - sddm - Version and help

**功能点：**

- Check sddm installed
- Check sddm available
- Check sddm-greeter available
- sddm help
- sddm --test-mode help

</details>

---

## sed

<details open>
<summary><b>sed — 6 个测试用例</b></summary>

#### `test_sed_basic_substitution`

> 功能测试 - sed - 基本替换

**功能点：**

- sed 版本
- sed s: 基本替换
- sed s: 替换hello

#### `test_sed_error_handling`

> 功能测试 - sed - 错误处理

**功能点：**

- sed 版本
- sed: 无效选项

#### `test_sed_global_regex`

> 功能测试 - sed - 全局和正则

**功能点：**

- sed 版本
- sed g: 全局替换
- sed: 正则替换

#### `test_sed_inplace_edit`

> 功能测试 - sed - 就地编辑

**功能点：**

- sed 版本
- sed -i: 就地编辑
- sed -i: 验证修改

#### `test_sed_line_operations`

> 功能测试 - sed - 行操作

**功能点：**

- sed 版本
- sed -n: 打印指定行
- sed d: 删除指定行
- sed a: 追加行
- sed i: 插入行

#### `test_sed_multi_expression`

> 功能测试 - sed - 多表达式

**功能点：**

- sed 版本
- sed -e: 多表达式

</details>

---

## systemd

<details open>
<summary><b>systemd — 36 个测试用例</b></summary>

#### `test_systemd_busctl___d_bus_introspection`

> 功能测试 - systemd - busctl - D-Bus introspection

**功能点：**

- Check systemd package is installed
- busctl list: list services
- busctl status: bus status
- busctl tree: object tree
- busctl introspect

#### `test_systemd_coredumpctl`

> 功能测试 - systemd - coredumpctl

**功能点：**

- Check systemd package is installed
- coredumpctl list: list dumps
- coredumpctl info

#### `test_systemd_error_handling`

> 功能测试 - systemd - Error handling

**功能点：**

- Check systemd package is installed
- systemctl: invalid command
- journalctl: invalid option
- hostnamectl: invalid option

#### `test_systemd_hostnamectl___hostname_management`

> 功能测试 - systemd - hostnamectl - Hostname management

**功能点：**

- Check systemd package is installed
- hostnamectl status: system info
- hostnamectl hostname: current name
- hostnamectl --static
- hostnamectl --transient
- hostnamectl --pretty
- hostnamectl chassis

#### `test_systemd_journalctl___journal_query`

> 功能测试 - systemd - journalctl - Journal query

**功能点：**

- Check systemd package is installed
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

#### `test_systemd_localectl___locale_management`

> 功能测试 - systemd - localectl - Locale management

**功能点：**

- Check systemd package is installed
- localectl status: locale info
- localectl list-locales

#### `test_systemd_loginctl___login_management`

> 功能测试 - systemd - loginctl - Login management

**功能点：**

- Check systemd package is installed
- loginctl list-sessions
- loginctl list-users
- loginctl show-session
- loginctl show-user
- loginctl user-status

#### `test_systemd_oomctl`

> 功能测试 - systemd - oomctl

**功能点：**

- Check systemd package is installed
- oomctl help
- oomctl dump

#### `test_systemd_power_management_commands`

> 功能测试 - systemd - Power management commands

**功能点：**

- Check systemd package is installed
- $cmd help

#### `test_systemd_run0___privilege_escalation`

> 功能测试 - systemd - run0 - Privilege escalation

**功能点：**

- Check systemd package is installed
- run0 help

#### `test_systemd_systemctl___service_and_system_management`

> 功能测试 - systemd - systemctl - Service and system management

**功能点：**

- Check systemd package is installed
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

#### `test_systemd_systemctl_service_operations`

> 功能测试 - systemd - systemctl service operations

**功能点：**

- Check systemd package is installed
- systemctl try-restart
- systemctl reload-or-restart
- systemctl reset-failed
- systemctl daemon-reload

#### `test_systemd_systemd_ac_power`

> 功能测试 - systemd - systemd-ac-power

**功能点：**

- Check systemd package is installed
- systemd-ac-power: check power

#### `test_systemd_systemd_analyze___system_profiling`

> 功能测试 - systemd - systemd-analyze - System profiling

**功能点：**

- Check systemd package is installed
- systemd-analyze time: boot time
- systemd-analyze security

#### `test_systemd_systemd_ask_password`

> 功能测试 - systemd - systemd-ask-password

**功能点：**

- Check systemd package is installed
- systemd-ask-password help

#### `test_systemd_systemd_cat`

> 功能测试 - systemd - systemd-cat

**功能点：**

- Check systemd package is installed
- systemd-cat: pipe to journal

#### `test_systemd_systemd_cgls___cgroup_listing`

> 功能测试 - systemd - systemd-cgls - Cgroup listing

**功能点：**

- Check systemd package is installed
- systemd-cgls: cgroup tree
- systemd-cgls -k: kernel threads
- systemd-cgls --no-pager

#### `test_systemd_systemd_cgtop___cgroup_top`

> 功能测试 - systemd - systemd-cgtop - Cgroup top

**功能点：**

- Check systemd package is installed
- systemd-cgtop -b: batch mode

#### `test_systemd_systemd_confext`

> 功能测试 - systemd - systemd-confext

**功能点：**

- Check systemd package is installed
- systemd-confext help

#### `test_systemd_systemd_creds`

> 功能测试 - systemd - systemd-creds

**功能点：**

- Check systemd package is installed
- systemd-creds help

#### `test_systemd_systemd_delta`

> 功能测试 - systemd - systemd-delta

**功能点：**

- Check systemd package is installed
- systemd-delta help
- systemd-delta: show overrides

#### `test_systemd_systemd_detect_virt`

> 功能测试 - systemd - systemd-detect-virt

**功能点：**

- Check systemd package is installed
- systemd-detect-virt: detect VM
- systemd-detect-virt -q: quiet mode
- systemd-detect-virt -c: container only
- systemd-detect-virt -v: VM only
- systemd-detect-virt -r: chroot only

#### `test_systemd_systemd_escape`

> 功能测试 - systemd - systemd-escape

**功能点：**

- Check systemd package is installed
- systemd-escape: basic escape
- systemd-escape --path: path escape
- systemd-escape -u: unescape
- systemd-escape --suffix
- systemd-escape --template

#### `test_systemd_systemd_firstboot`

> 功能测试 - systemd - systemd-firstboot

**功能点：**

- Check systemd package is installed
- systemd-firstboot help

#### `test_systemd_systemd_id128`

> 功能测试 - systemd - systemd-id128

**功能点：**

- Check systemd package is installed
- systemd-id128 show: show IDs
- systemd-id128 new: generate ID

#### `test_systemd_systemd_inhibit`

> 功能测试 - systemd - systemd-inhibit

**功能点：**

- Check systemd package is installed
- systemd-inhibit help
- systemd-inhibit --list

#### `test_systemd_systemd_machine_id_setup`

> 功能测试 - systemd - systemd-machine-id-setup

**功能点：**

- Check systemd package is installed
- systemd-machine-id-setup help
- systemd-machine-id-setup: check machine-id

#### `test_systemd_systemd_mount`

> 功能测试 - systemd - systemd-mount

**功能点：**

- Check systemd package is installed
- systemd-mount help

#### `test_systemd_systemd_notify`

> 功能测试 - systemd - systemd-notify

**功能点：**

- Check systemd package is installed
- systemd-notify help

#### `test_systemd_systemd_path`

> 功能测试 - systemd - systemd-path

**功能点：**

- Check systemd package is installed
- systemd-path: all paths
- systemd-path: specific path
- systemd-path --suffix
- systemd-path help

#### `test_systemd_systemd_run`

> 功能测试 - systemd - systemd-run

**功能点：**

- Check systemd package is installed
- systemd-run --user --scope

#### `test_systemd_systemd_socket_activate`

> 功能测试 - systemd - systemd-socket-activate

**功能点：**

- Check systemd package is installed
- systemd-socket-activate help

#### `test_systemd_systemd_stdio_bridge`

> 功能测试 - systemd - systemd-stdio-bridge

**功能点：**

- Check systemd package is installed
- systemd-stdio-bridge help

#### `test_systemd_systemd_sysext`

> 功能测试 - systemd - systemd-sysext

**功能点：**

- Check systemd package is installed
- systemd-sysext help

#### `test_systemd_systemd_tmpfiles`

> 功能测试 - systemd - systemd-tmpfiles

**功能点：**

- Check systemd package is installed
- systemd-tmpfiles --cat-config

#### `test_systemd_timedatectl___time_date_management`

> 功能测试 - systemd - timedatectl - Time/date management

**功能点：**

- Check systemd package is installed
- timedatectl status: time info
- timedatectl show: all properties
- timedatectl list-timezones
- timedatectl show-timesync

</details>

---

## systemd-timesyncd

<details open>
<summary><b>systemd-timesyncd — 5 个测试用例</b></summary>

#### `test_systemd_timesyncd_configuration`

> 功能测试 - systemd-timesyncd - Configuration

**功能点：**

- Check systemd-timesyncd is installed
- Config file
- Cat config

#### `test_systemd_timesyncd_ntp_management`

> 功能测试 - systemd-timesyncd - NTP management

**功能点：**

- Check systemd-timesyncd is installed
- Fallback NTP servers
- Current NTP server
- Server address
- NTP servers list

#### `test_systemd_timesyncd_service_control`

> 功能测试 - systemd-timesyncd - Service control

**功能点：**

- Check systemd-timesyncd is installed
- Restart service
- Is active

#### `test_systemd_timesyncd_service_status`

> 功能测试 - systemd-timesyncd - Service status

**功能点：**

- Check systemd-timesyncd is installed
- Service status
- Time sync status
- Timesync detail
- Is enabled

#### `test_systemd_timesyncd_systemd_time_wait_sync`

> 功能测试 - systemd-timesyncd - systemd-time-wait-sync

**功能点：**

- Check systemd-timesyncd is installed
- Wait sync service

</details>

---

## tar

<details open>
<summary><b>tar — 10 个测试用例</b></summary>

#### `test_tar_advanced_tar_options`

> 功能测试 - tar - Advanced tar options

**测试段：**
- Advanced tar options

#### `test_tar_archive_extraction`

> 功能测试 - tar - Archive extraction

**测试段：**
- Archive extraction

#### `test_tar_archive_verification`

> 功能测试 - tar - Archive verification

**测试段：**
- Archive verification

#### `test_tar_basic_archive_creation`

> 功能测试 - tar - Basic archive creation

**测试段：**
- Basic archive creation

#### `test_tar_compression_formats`

> 功能测试 - tar - Compression formats

**测试段：**
- Compression formats

#### `test_tar_error_handling`

> 功能测试 - tar - Error handling

**测试段：**
- Error handling

#### `test_tar_incremental_backup`

> 功能测试 - tar - Incremental backup

**测试段：**
- Incremental backup

#### `test_tar_special_attributes`

> 功能测试 - tar - Special attributes

**测试段：**
- Special attributes

#### `test_tar_special_file_types`

> 功能测试 - tar - Special file types

**测试段：**
- Special file types

#### `test_tar_wildcard_and_patterns`

> 功能测试 - tar - Wildcard and patterns

**测试段：**
- Wildcard and patterns

</details>

---

## tmux

<details open>
<summary><b>tmux — 22 个测试用例</b></summary>

#### `test_tmux_buffer_management`

> 功能测试 - tmux - Buffer management

**功能点：**

- Check tmux package is installed
- Check tmux command available
- set-buffer -b: named buffer
- hello world
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

#### `test_tmux_choose_commands__interactive`

> 功能测试 - tmux - Choose commands (interactive)

**功能点：**

- Check tmux package is installed
- Check tmux command available
- choose-tree -G: tree display
- choose-client: client selection

#### `test_tmux_cleanup___kill_sessions`

> 功能测试 - tmux - Cleanup - kill sessions

**功能点：**

- Check tmux package is installed
- Check tmux command available
- kill-session: kill renamed_sess
- kill-session: kill sess_fmt
- kill-session: kill sess_sz
- kill-session: kill sess_flags
- kill-session: kill sess_env
- kill-session: kill main test session
- kill-server: terminate server

#### `test_tmux_clock_mode`

> 功能测试 - tmux - Clock mode

**功能点：**

- Check tmux package is installed
- Check tmux command available
- clock-mode: show clock

#### `test_tmux_conditional_and_shell_execution`

> 功能测试 - tmux - Conditional and shell execution

**功能点：**

- Check tmux package is installed
- Check tmux command available
- if-shell: true condition
- run-shell: run shell command
- run-shell -b: background
- command-prompt: open prompt
- confirm-before: confirm dialog

#### `test_tmux_copy_mode`

> 功能测试 - tmux - Copy mode

**功能点：**

- Check tmux package is installed
- Check tmux command available
- copy-mode: enter copy mode

#### `test_tmux_environment_variables`

> 功能测试 - tmux - Environment variables

**功能点：**

- Check tmux package is installed
- Check tmux command available
- set-environment -g: global env
- set-environment: session env
- set-environment -gur: update then remove
- show-environment -g: global env
- show-environment: session env

#### `test_tmux_error_handling`

> 功能测试 - tmux - Error handling

**功能点：**

- Check tmux package is installed
- Check tmux command available
- Error: nonexistent session
- Error: invalid option

#### `test_tmux_find_window`

> 功能测试 - tmux - Find window

**功能点：**

- Check tmux package is installed
- Check tmux command available
- find-window: search windows

#### `test_tmux_hooks`

> 功能测试 - tmux - Hooks

**功能点：**

- Check tmux package is installed
- Check tmux command available
- set-hook: session-created
- set-hook: client-attached
- show-hooks -g: global hooks
- set-hook -gu: remove global hook
- set-hook -gu: remove hook

#### `test_tmux_key_bindings_and_input`

> 功能测试 - tmux - Key bindings and input

**功能点：**

- Check tmux package is installed
- Check tmux command available
- list-keys: list all keys
- list-keys -T: prefix table
- list-keys -T: root table
- list-keys -a: all keys
- list-keys -N: with notes
- bind-key -n: bind to key
- unbind-key -n: unbind key
- bind-key -T: bind in table
- unbind-key -T: unbind in table
- echo hello
- literal
- 0d
- send-prefix: send prefix key

#### `test_tmux_layout_management`

> 功能测试 - tmux - Layout management

**功能点：**

- Check tmux package is installed
- Check tmux command available
- select-layout: even-horizontal
- select-layout: even-vertical
- select-layout: main-horizontal
- select-layout: main-vertical
- select-layout: tiled
- next-layout: cycle layouts
- previous-layout: prev layout

#### `test_tmux_lock_management`

> 功能测试 - tmux - Lock management

**功能点：**

- Check tmux package is installed
- Check tmux command available
- lock-server: lock server
- lock-session: lock session

#### `test_tmux_messages_and_display`

> 功能测试 - tmux - Messages and display

**功能点：**

- Check tmux package is installed
- Check tmux command available
- display-message: show message
- display-message -p: print format
- show-messages: message log
- display-popup -C: close popup
- clear-history: clear pane history

#### `test_tmux_options_and_settings`

> 功能测试 - tmux - Options and settings

**功能点：**

- Check tmux package is installed
- Check tmux command available
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

#### `test_tmux_pane_management`

> 功能测试 - tmux - Pane management

**功能点：**

- Check tmux package is installed
- Check tmux command available
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
- ... 等共 40 个测试点

#### `test_tmux_server_management`

> 功能测试 - tmux - Server management

**功能点：**

- Check tmux package is installed
- Check tmux command available
- start-server: start tmux server
- list-sessions: initial state
- has-session: check nonexistent
- list-clients: list connected clients
- list-commands: list all commands
- list-commands: filter specific command
- list-commands: format output
- server-access -l: list access

#### `test_tmux_session_creation_and_management`

> 功能测试 - tmux - Session creation and management

**功能点：**

- Check tmux package is installed
- Check tmux command available
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

#### `test_tmux_show_prompt_history`

> 功能测试 - tmux - Show prompt history

**功能点：**

- Check tmux package is installed
- Check tmux command available
- show-prompt-history: prompt history
- clear-prompt-history: clear prompt history

#### `test_tmux_source_and_configuration`

> 功能测试 - tmux - Source and configuration

**功能点：**

- Check tmux package is installed
- Check tmux command available
- source-file: source config

#### `test_tmux_wait_for__event_channels`

> 功能测试 - tmux - Wait-for (event channels)

**功能点：**

- Check tmux package is installed
- Check tmux command available
- wait-for -L: lock channel

#### `test_tmux_window_management`

> 功能测试 - tmux - Window management

**功能点：**

- Check tmux package is installed
- Check tmux command available
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
- ... 等共 31 个测试点

</details>

---

## util-linux

<details open>
<summary><b>util-linux — 2 个测试用例</b></summary>

#### `test_util_linux_error_handling`

> 功能测试 - util-linux - 错误处理

**功能点：**

- addpart: 无效选项

#### `test_util_linux_version_help`

> 功能测试 - util-linux - 版本和帮助

**功能点：**

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
- ... 等共 30 个测试点

</details>

---

## vim

<details open>
<summary><b>vim — 10 个测试用例</b></summary>

#### `test_vim_basic_editing`

> 功能测试 - vim - Basic editing

**功能点：**

- Check vim-common installed
- Check vim available
- vim -e: ex mode

#### `test_vim_batch_ex_mode_commands`

> 功能测试 - vim - Batch/ex mode commands

**功能点：**

- Check vim-common installed
- Check vim available
- vim: print buffer

#### `test_vim_command_line_options`

> 功能测试 - vim - Command line options

**功能点：**

- Check vim-common installed
- Check vim available
- vim --help
- vim -c: execute command
- vim -R: readonly mode
- vim -b: binary mode
- vim -n: no swap file

#### `test_vim_error_handling`

> 功能测试 - vim - Error handling

**功能点：**

- Check vim-common installed
- Check vim available
- vim: invalid option
- vim: nonexistent file

#### `test_vim_multiple_files`

> 功能测试 - vim - Multiple files

**功能点：**

- Check vim-common installed
- Check vim available
- vim: multiple files

#### `test_vim_recording_test`

> 功能测试 - vim - Recording test

**功能点：**

- Check vim-common installed
- Check vim available
- vim: insert in ex mode

#### `test_vim_search_and_replace__ex_mode`

> 功能测试 - vim - Search and replace (ex mode)

**功能点：**

- Check vim-common installed
- Check vim available
- vim: search and replace
- Replace verified

#### `test_vim_syntax_check`

> 功能测试 - vim - Syntax check

**功能点：**

- Check vim-common installed
- Check vim available
- vim: syntax enable

#### `test_vim_terminal_options`

> 功能测试 - vim - Terminal options

**功能点：**

- Check vim-common installed
- Check vim available
- vim -T: terminal type

#### `test_vim_vimdiff`

> 功能测试 - vim - Vimdiff

**功能点：**

- Check vim-common installed
- Check vim available
- vimdiff available
- vimdiff: compare files

</details>

---

## weston

<details open>
<summary><b>weston — 9 个测试用例</b></summary>

#### `test_weston_backend_check`

> 功能测试 - weston - Backend check

**功能点：**

- Check weston installed
- Check weston available
- Check weston-debug available
- Check weston-screenshooter available
- Check weston-terminal available
- Check wcap-decode available
- Available backends

#### `test_weston_error_handling`

> 功能测试 - weston - Error handling

**功能点：**

- Check weston installed
- Check weston available
- Check weston-debug available
- Check weston-screenshooter available
- Check weston-terminal available
- Check wcap-decode available
- weston: invalid option

#### `test_weston_headless_backend_test`

> 功能测试 - weston - Headless backend test

**功能点：**

- Check weston installed
- Check weston available
- Check weston-debug available
- Check weston-screenshooter available
- Check weston-terminal available
- Check wcap-decode available
- weston: headless backend

#### `test_weston_help`

> 功能测试 - weston - Help

**功能点：**

- Check weston installed
- Check weston available
- Check weston-debug available
- Check weston-screenshooter available
- Check weston-terminal available
- Check wcap-decode available
- weston help

#### `test_weston_screenshooter`

> 功能测试 - weston - Screenshooter

**功能点：**

- Check weston installed
- Check weston available
- Check weston-debug available
- Check weston-screenshooter available
- Check weston-terminal available
- Check wcap-decode available
- weston-screenshooter help

#### `test_weston_version`

> 功能测试 - weston - Version

**功能点：**

- Check weston installed
- Check weston available
- Check weston-debug available
- Check weston-screenshooter available
- Check weston-terminal available
- Check wcap-decode available

#### `test_weston_wcap_decode`

> 功能测试 - weston - wcap-decode

**功能点：**

- Check weston installed
- Check weston available
- Check weston-debug available
- Check weston-screenshooter available
- Check weston-terminal available
- Check wcap-decode available
- wcap-decode help

#### `test_weston_weston_debug`

> 功能测试 - weston - Weston debug

**功能点：**

- Check weston installed
- Check weston available
- Check weston-debug available
- Check weston-screenshooter available
- Check weston-terminal available
- Check wcap-decode available
- weston-debug help

#### `test_weston_weston_terminal__headless`

> 功能测试 - weston - Weston terminal (headless)

**功能点：**

- Check weston installed
- Check weston available
- Check weston-debug available
- Check weston-screenshooter available
- Check weston-terminal available
- Check wcap-decode available
- weston-terminal help

</details>

---

## wget

<details open>
<summary><b>wget — 15 个测试用例</b></summary>

#### `test_wget_basic_download`

> 功能测试 - wget - Basic download

**测试段：**
- Basic download

#### `test_wget_continue_and_mirror`

> 功能测试 - wget - Continue and mirror

**测试段：**
- Continue and mirror

#### `test_wget_directory_listing`

> 功能测试 - wget - Directory listing

**测试段：**
- Directory listing

#### `test_wget_error_handling`

> 功能测试 - wget - Error handling

**测试段：**
- Error handling

#### `test_wget_header_options`

> 功能测试 - wget - Header options

**测试段：**
- Header options

#### `test_wget_output_options`

> 功能测试 - wget - Output options

**测试段：**
- Output options

#### `test_wget_progress_indicators`

> 功能测试 - wget - Progress indicators

**测试段：**
- Progress indicators

#### `test_wget_rate_limiting`

> 功能测试 - wget - Rate limiting

**测试段：**
- Rate limiting

#### `test_wget_recursive_download`

> 功能测试 - wget - Recursive download

**测试段：**
- Recursive download

#### `test_wget_special_features`

> 功能测试 - wget - Special features

**测试段：**
- Special features

#### `test_wget_spider_mode`

> 功能测试 - wget - Spider mode

**测试段：**
- Spider mode

#### `test_wget_timeout_and_retries`

> 功能测试 - wget - Timeout and retries

**测试段：**
- Timeout and retries

#### `test_wget_timestamps`

> 功能测试 - wget - Timestamps

**测试段：**
- Timestamps

#### `test_wget_user_agent`

> 功能测试 - wget - User agent

**测试段：**
- User agent

#### `test_wget_verbose_and_quiet_modes`

> 功能测试 - wget - Verbose and quiet modes

**测试段：**
- Verbose and quiet modes

</details>

---

## wget2

<details open>
<summary><b>wget2 — 15 个测试用例</b></summary>

#### `test_wget2_basic_download`

> 功能测试 - wget2 - Basic download

**测试段：**
- Basic download

#### `test_wget2_content_disposition`

> 功能测试 - wget2 - Content disposition

**测试段：**
- Content disposition

#### `test_wget2_continue_download`

> 功能测试 - wget2 - Continue download

**测试段：**
- Continue download

#### `test_wget2_error_handling`

> 功能测试 - wget2 - Error handling

**测试段：**
- Error handling

#### `test_wget2_follow_redirects`

> 功能测试 - wget2 - Follow redirects

**测试段：**
- Follow redirects

#### `test_wget2_headers`

> 功能测试 - wget2 - Headers

**测试段：**
- Headers

#### `test_wget2_http_2_support`

> 功能测试 - wget2 - HTTP/2 support

**测试段：**
- HTTP/2 support

#### `test_wget2_output_file_options`

> 功能测试 - wget2 - Output file options

**测试段：**
- Output file options

#### `test_wget2_plugin_system`

> 功能测试 - wget2 - Plugin system

**测试段：**
- Plugin system

#### `test_wget2_rate_limiting`

> 功能测试 - wget2 - Rate limiting

**测试段：**
- Rate limiting

#### `test_wget2_spider_mode`

> 功能测试 - wget2 - Spider mode

**测试段：**
- Spider mode

#### `test_wget2_timeouts_and_retries`

> 功能测试 - wget2 - Timeouts and retries

**测试段：**
- Timeouts and retries

#### `test_wget2_tls_options`

> 功能测试 - wget2 - TLS options

**测试段：**
- TLS options

#### `test_wget2_user_agent`

> 功能测试 - wget2 - User agent

**测试段：**
- User agent

#### `test_wget2_verbose_modes`

> 功能测试 - wget2 - Verbose modes

**测试段：**
- Verbose modes

</details>

---

## xz

<details open>
<summary><b>xz — 2 个测试用例</b></summary>

#### `test_xz_error_handling`

> 功能测试 - xz - 错误处理

**功能点：**

- xz: 无效选项

#### `test_xz_version_help`

> 功能测试 - xz - 版本和帮助

**功能点：**

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
- ... 等共 30 个测试点

</details>

---

## zstd

<details open>
<summary><b>zstd — 2 个测试用例</b></summary>

#### `test_zstd_error_handling`

> 功能测试 - zstd - 错误处理

**功能点：**

- zstd: 无效选项

#### `test_zstd_version_help`

> 功能测试 - zstd - 版本和帮助

**功能点：**

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

</details>
