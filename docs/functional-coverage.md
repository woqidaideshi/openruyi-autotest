# 功能测试覆盖详情

> 共 **30** 个软件包，**1168** 个测试点
> 点击展开查看各软件包详情

## 目录

| 软件包 | 测试点 | 版本 |
|--------|:-----:|------|
| [acl](#acl) | 99 | acl 2.3.2 |
| [clang](#clang) | 32 | clang 21.1 |
| [cloud-utils-growpart](#cloud-utils-growpart) | 12 | cloud-utils-growpart |
| [cmake](#cmake) | 7 | cmake |
| [coreutils](#coreutils) | 238 | coreutils 9.10 |
| [dnf5-plugins](#dnf5-plugins) | 13 | dnf5-plugins 5.4 |
| [gcc](#gcc) | 63 | gcc |
| [git](#git) | 50 | git 2.54.0 |
| [grep](#grep) | 50 | GNU grep 3.12 |
| [gxx](#gxx) | 20 | gcc-c++ |
| [iputils](#iputils) | 10 | iputils 20250605 |
| [labwc](#labwc) | 14 | labwc 0.9.7 |
| [make](#make) | 26 | GNU Make 4.4.1 |
| [openssh](#openssh) | 27 | openssh 10.3p1 |
| [openssh-clients](#openssh-clients) | 27 | openssh-clients 10.3p1 |
| [pciutils](#pciutils) | 13 | pciutils |
| [podman](#podman) | 21 | podman |
| [podmansh](#podmansh) | 11 | podmansh |
| [procps-ng](#procps-ng) | 14 | procps-ng 4.0.5 |
| [psmisc](#psmisc) | 13 | psmisc |
| [rpmbuild](#rpmbuild) | 9 | rpm-build |
| [sddm](#sddm) | 13 | sddm 0.21.0 |
| [systemd](#systemd) | 115 | systemd 259 |
| [systemd-timesyncd](#systemd-timesyncd) | 14 | systemd-timesyncd 259 |
| [tar](#tar) | 10 | tar 1.35 |
| [tmux](#tmux) | 182 | tmux 3.6a |
| [vim](#vim) | 20 | Vim 9.2 |
| [weston](#weston) | 15 | weston 14.0.2 |
| [wget](#wget) | 15 | wget (provided by wget2) |
| [wget2](#wget2) | 15 | wget2 |

---

## acl

- **版本**: acl 2.3.2
- **测试点**: 99
- **被测命令**: `getfacl`, `setfacl`, `chacl`

<details>
<summary><b>测试点列表</b></summary>

- 检查 acl 软件包是否已安装
- 检查 getfacl 命令是否可用
- 检查 setfacl 命令是否可用
- 检查 chacl 命令是否可用
- 获取 getfacl 版本信息
- 获取 setfacl 版本信息
- 创建临时测试目录
- 进入测试目录
- 创建测试文件
- 创建测试目录
- 查看文件默认 ACL
- 查看目录默认 ACL
- 使用 -a 参数查看 访问控制 ACL权限
- 使用 -d 参数查看 默认 ACL权限
- 使用 -c 参数不显示注释头
- 使用 -n 参数显示数字 ID
- 使用 -t 参数表格输出
- 设置用户 root 的 rwx 权限
- 验证 ACL 设置
- 设置组 root 的 r-x 权限
- 验证 ACL 设置
- 设置 other 的只读权限
- 验证 ACL 设置
- 设置 掩码 为 rwx
- 验证 mask 设置
- 使用 -n 参数不重新计算 mask
- 验证 ACL 设置
- 为目录设置 默认 用户 ACL权限
- 验证 默认 ACL权限 设置
- 为目录设置 默认 组 ACL权限
- 验证 默认 组 ACL权限
- 为目录设置 默认 掩码
- 验证 默认 掩码
- 为目录设置 默认 其他用户
- 验证 默认 其他用户
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
- 删除目录的 默认 ACL权限
- 验证 默认 ACL权限 已删除
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
- 使用 chacl命令 查看 ACL权限
- 使用 chacl 设置基本 ACL
- 验证 chacl 设置的 ACL
- 使用 chacl命令 设置 默认 ACL权限
- 验证 chacl命令 设置的 默认 ACL权限
- 使用 chacl 递归设置 ACL
- 验证 chacl 递归设置
- 使用 chacl -b 同时设置
- 验证 chacl命令 -b 设置
- 设置目录 默认 ACL权限
- 在目录中创建新文件
- 验证新文件继承了 default ACL
- 在目录中创建子目录
- 验证子目录继承了 default ACL
- 设置完整权限
- 验证权限设置
- 设置 mask 限制有效权限
- 验证 mask 限制后的有效权限
- 测试对不存在文件 getfacl 报错
- 测试对不存在文件 setfacl 报错
- 测试无效权限字符报错
- 测试无效类型报错
- 测试权限不足报错
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

## clang

- **版本**: clang 21.1
- **测试点**: 32
- **被测命令**: `clang`, `clang++`, `clang-cl`, `clang-cpp`, `clang-scan-deps`

<details>
<summary><b>基本 C 编译</b></summary>

- 检查 clang 已安装
- 检查 clang 可用
- 检查 clang++ 可用
- 检查 clang-cl 可用
- 检查 clang-cpp 可用
- 检查 clang-scan-deps 可用
- clang 版本
- 编译 hello.c
- 运行 已编译 binary
- 输出 ELF binary

</details>

<details>
<summary><b>基本 C++ 编译</b></summary>

- 编译 C++ from hello.c
- 运行 C++ binary
- clang -c: 编译 仅
- Object 文件 存在
- 优化 -$lvl
- 调试 symbols
- -Wall 警告
- -Wextra 警告
- -Werror
- C 标准: $std

</details>

<details>
<summary><b>编译-仅</b></summary>

- C++ 标准: $std
- clang -E: preprocess
- clang -dM: dump macros
- clang --analyze: 静态 分析
- clang-cl 帮助
- clang-cpp: 预处理器
- clang-scan-deps 帮助
- 编译 使用 -fPIC
- clang -shared: shared library
- clang -v: 详细

</details>

<details>
<summary><b>优化 级别</b></summary>

- Compilation 错误
- Invalid 选项

</details>

<details>
<summary><b>调试 和 警告</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>C 标准</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>C++ 标准</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>预处理器</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>静态 分析</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>clang-cl (MSVC 兼容)</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>clang-cpp</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>clang-scan-deps</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>链接 选项</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>详细 模式</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>错误 处理</b></summary>

- 执行相关功能验证

</details>


---

## cloud-utils-growpart

- **版本**: cloud-utils-growpart
- **测试点**: 12
- **被测命令**: `growpart`

<details>
<summary><b>帮助 和 版本</b></summary>

- 检查 cloud-utils-growpart 已安装
- 检查 growpart 命令 可用
- growpart 帮助
- growpart -h: short 帮助
- lsblk: 列出 block devices
- df: disk free space
- growpart -N: dry 运行
- growpart: has free-百分比 选项
- growpart: has fudge 选项
- growpart: 无 args (expected fail)

</details>

<details>
<summary><b>磁盘/分区 信息</b></summary>

- growpart: nonexistent disk
- growpart: invalid 选项

</details>

<details>
<summary><b>模拟-运行 (无 实际 调整大小)</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>空闲 百分比 选项</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Fudge factor 选项</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>错误 处理</b></summary>

- 执行相关功能验证

</details>


---

## cmake

- **版本**: cmake
- **测试点**: 7
- **被测命令**: `cmake`

<details>
<summary><b>基本 CMake project</b></summary>

- 测试 section: 基本 CMake project ===
- 测试 section: CMake 配置 ===
- 测试 section: CMake 构建 和 运行 ===
- 测试 section: Library project ===
- 测试 section: Module finder ===
- 测试 section: 错误 处理 ===
- 测试 section: CMake 版本 和 帮助 ===

</details>

<details>
<summary><b>CMake 配置</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>CMake 构建 和 运行</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Library project</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Module finder</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>错误 处理</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>CMake 版本 和 帮助</b></summary>

- 执行相关功能验证

</details>


---

## coreutils

- **版本**: coreutils 9.10
- **测试点**: 238

<details>
<summary><b>文件 creation 和 listing (echo, cat, ls, dir, vdir)</b></summary>

- 检查 coreutils 软件包 已安装
- echo 创建 文件
- echo append
- echo -n suppress newline
- echo -n: 验证 无 trailing newline
- cat display 文件
- cat: 验证 2 lines
- cat -n number all lines
- cat -b number non-blank lines
- ls -la 列出 all files

</details>

<details>
<summary><b>复制, 移动, 删除 (cp, mv, rm, rmdir)</b></summary>

- ls specific 文件
- ls -l: regular 文件 检查
- ls -ld: 目录 检查
- ls -1 single column
- dir 列出 目录
- vdir long format 列出
- cp 复制 文件
- cp: 验证 复制 存在
- cp: files identical
- cp -r 递归 复制

</details>

<details>
<summary><b>目录, 文件 creation, temp files (mkdir, touch, mktemp)</b></summary>

- cp -r: 验证 目录 复制
- mv 重命名 文件
- mv: old name gone
- mv: new name 存在
- mv subdirectory
- 创建 temp 文件
- rm 删除 文件
- rm: 文件 removed
- 创建 dir 删除
- rm -rf 递归 force

</details>

<details>
<summary><b>Links 和 路径 resolution (ln, 链接, unlink, readlink, realpath)</b></summary>

- rm -rf: 目录 removed
- 创建 empty 目录
- rmdir 删除 empty 目录
- rmdir: 目录 removed
- mkdir -p nested directories
- mkdir -p: 验证 nested dir
- mkdir -m 设置 模式
- touch 创建 文件
- touch: 文件 存在
- touch -t 设置 timestamp

</details>

<details>
<summary><b>文件 viewing (head, tail, tac, nl)</b></summary>

- touch -a 访问控制 time 仅
- mktemp 创建 temp 文件
- mktemp: temp 文件 存在
- mktemp -d 创建 temp 目录
- 创建 链接 source
- ln 创建 hard 链接
- ln: hard 链接 same inode
- ln -s 符号链接
- ln -s: symlink 存在
- ln -s: read through symlink

</details>

<details>
<summary><b>Counting 和 statistics (wc, du, df, stat)</b></summary>

- ln -sf force recreate symlink
- 链接 创建 hard 链接
- 链接: same inode
- unlink 删除 hard 链接
- unlink: 文件 removed
- readlink 显示 symlink target
- readlink: correct target
- readlink -f canonicalize
- realpath canonical 路径
- head -n 5: first 5 lines

</details>

<details>
<summary><b>Text processing I (sort, uniq, cut, tr)</b></summary>

- head -n 3: 验证 count
- head -c 10: first 10 bytes
- tail -n 5: last 5 lines
- tail -n 3: 验证 count
- tail -n +18: from line 18
- tail -c 10: last 10 bytes
- tac reverse lines
- tac: first becomes last
- nl number lines
- wc -l line count

</details>

<details>
<summary><b>Text processing II (paste, comm, 合并, fmt, fold, pr, expand, unexpand)</b></summary>

- wc -l: 20 lines
- wc -c byte count
- wc -w word count
- wc -m character count
- du -sh summary human
- du -h 目录 usage
- df -h human readable
- df: root filesystem
- stat 文件 状态
- stat -c format 输出

</details>

<details>
<summary><b>Octal dump (od)</b></summary>

- stat -f filesystem 状态
- sort alphabetically
- sort: first apple
- sort -r reverse
- sort -u unique
- sort -n numeric
- uniq unique lines
- uniq: 4 unique
- uniq -c count occurrences
- uniq -d 仅 duplicates

</details>

<details>
<summary><b>路径 operations (basename, dirname, pwd)</b></summary>

- uniq -u 仅 uniques
- cut -d: -f1 first field
- cut -d: -f2 second field
- cut multiple fields
- cut -c character range
- tr translate uppercase lowercase
- tr -d 删除 characters
- tr -s squeeze repeats
- paste merge files side by side
- paste -d: custom delimiter

</details>

<details>
<summary><b>Permissions 和 ownership (chmod, chown, chgrp)</b></summary>

- paste -s serial
- comm compare sorted files
- 合并 files on common field
- fmt reformat text
- fmt -w 设置 width
- fold -w wrap at width
- pr paginate 文件
- pr -n number lines
- expand tabs spaces
- unexpand -a spaces tabs

</details>

<details>
<summary><b>Redirection (tee)</b></summary>

- od octal dump
- od -c character dump
- od -x hex dump
- od -A x hex address
- basename 提取 filename
- basename strip suffix
- dirname 提取 目录
- dirname 路径 extraction
- pwd print working 目录
- 创建 权限 测试 文件

</details>

<details>
<summary><b>Checksums (cksum, md5sum, sha1sum, sha224sum, sha384sum, sha512sum, sha256sum, b2sum, sum)</b></summary>

- chmod u+x add exec
- chmod: 验证 exec 设置
- chmod 644 numeric
- chmod: 验证 644 perms
- Setup 递归 chmod
- chmod -R 递归
- chown 版本 检查
- chown self
- chgrp 版本 检查
- tee write 文件

</details>

<details>
<summary><b>编码 (base32, base64, basenc)</b></summary>

- tee: 验证 输出
- tee -a append 模式
- cksum CRC checksum
- md5sum compute
- md5sum save
- md5sum -c 验证
- sha1sum compute
- sha1sum save
- sha1sum -c 验证
- sha224sum compute

</details>

<details>
<summary><b>System information (uname, who, whoami, id, groups, users, hostid, nproc, tty, logname, pinky)</b></summary>

- sha256sum compute
- sha256sum save
- sha256sum -c 验证
- sha384sum compute
- sha512sum compute
- b2sum BLAKE2 checksum
- sum BSD checksum
- base32 encode
- base32 -d decode
- base64 encode

</details>

<details>
<summary><b>Boolean 和 condition (true, false, 测试, [)</b></summary>

- base64 -d decode
- basenc --base64 encode
- uname system name
- uname -a all 信息
- uname -r kernel release
- uname -m machine hardware
- who 显示 logged in users
- whoami current 用户
- id 用户 identity
- id -u 用户 ID

</details>

<details>
<summary><b>环境变量 和 time (env, printenv, date, printf)</b></summary>

- id -g 组 ID
- groups 显示 组 membership
- groups specific 用户
- users 列出 logged in users
- hostid numeric host identifier
- nproc number CPUs
- nproc --all all processors
- tty terminal name
- logname login name
- pinky 用户 信息

</details>

<details>
<summary><b>Flow control (sleep, timeout, yes)</b></summary>

- true returns success
- false returns failure
- 测试 -f: 文件 存在
- 测试 -d: 目录 存在
- 测试 string equality
- 测试 numeric comparison
- [ -f: 文件 存在
- [ string equality
- env 显示 环境变量
- env 设置 variable 命令

</details>

<details>
<summary><b>Process control (nice, nohup, stdbuf)</b></summary>

- printenv 显示 路径
- date current date/time
- date custom format
- date -u UTC time
- printf formatted 输出
- printf string 输出
- sleep delay
- timeout: 命令 finishes in time
- timeout: successful completion
- timeout: kills slow 命令

</details>

<details>
<summary><b>文件 operations (dd, truncate, shred, sync, 安装, chroot)</b></summary>

- yes repeated 输出
- yes custom string
- nice adjust priority
- nohup 运行 命令
- stdbuf line buffered 输出
- dd 复制 文件
- truncate 设置 size
- truncate: 验证 size
- 创建 文件 shred
- shred 删除 文件 securely

</details>

<details>
<summary><b>Numbers 和 expressions (seq, factor, shuf, numfmt, expr)</b></summary>

- shred: 文件 removed
- sync flush filesystem buffers
- 安装 复制 使用 模式
- 安装: destination 存在
- 安装 -d 创建 目录
- 安装 -d: 目录 存在
- chroot 版本 检查
- mkfifo 创建 named 管道
- mkfifo: 验证 管道 created
- mknod 版本 检查

</details>

<details>
<summary><b>分割 files (分割, csplit)</b></summary>

- seq 生成 sequence
- seq: 5 numbers
- seq -s custom separator
- factor prime factorization
- factor prime number
- shuf randomize lines
- shuf: same line count
- numfmt SI units
- numfmt from SI units
- numfmt IEC units

</details>

<details>
<summary><b>Special utilities (stty, pathchk, tsort, ptx, dircolors)</b></summary>

- expr 基本 arithmetic
- expr multiplication
- expr string length
- 分割 by lines
- 分割: multiple 输出 files
- csplit 分割 by pattern
- stty -a 显示 all terminal settings
- pathchk validate 路径
- pathchk -p POSIX 检查
- tsort topological sort

</details>

<details>
<summary><b>错误 处理</b></summary>

- ptx permuted index
- dircolors -p print database
- dircolors 输出 LS_COLORS
- cp: 错误 on nonexistent source
- ls: 错误 on nonexistent 文件
- mkdir: 错误 on existing dir
- rm: 错误 on dir without -r
- rmdir: 错误 on non-empty dir

</details>


---

## dnf5-plugins

- **版本**: dnf5-plugins 5.4
- **测试点**: 13
- **被测命令**: `dnf5`

<details>
<summary><b>dnf5 版本</b></summary>

- 检查 dnf5-plugins 已安装
- 检查 dnf5 可用
- dnf5 版本
- dnf5 帮助
- Plugin files
- Plugin 目录
- 检查 plugin: $plugin
- Plugin commands in 帮助
- dnf5 repoquery 帮助
- dnf5 repolist

</details>

<details>
<summary><b>dnf5 帮助</b></summary>

- dnf5 列出 已安装
- dnf5 信息
- dnf5: invalid 选项

</details>

<details>
<summary><b>列出 已安装 plugins</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>可用 plugins</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Commands 使用 plugins</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>dnf5 repoquery</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>dnf5 repolist</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>dnf5 列出</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>dnf5 信息</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>错误 处理</b></summary>

- 执行相关功能验证

</details>


---

## gcc

- **版本**: gcc
- **测试点**: 63
- **被测命令**: `gcc`, `g++`, `cpp`

<details>
<summary><b>基本 C 编译</b></summary>

- 检查 gcc 软件包 已安装
- 检查 gcc-c++ 软件包 已安装
- 检查 gcc 命令 可用
- 检查 g++ 命令 可用
- 检查 cpp 命令 可用
- 获取 gcc 版本 信息
- 获取 g++ 版本 信息
- 编译 hello.c hello
- 运行 已编译 hello
- 验证 输出 ELF binary

</details>

<details>
<summary><b>C++ 编译</b></summary>

- 编译 使用 -o 参数
- 运行 myhello
- 编译 hello.cpp
- 编译 使用 C++11 标准
- 编译 使用 -O0
- 编译 使用 -O2
- 编译 使用 调试 symbols -g
- 验证 调试 symbols present
- Preprocess 使用 -E
- 验证 macro expanded in preprocessed 输出

</details>

<details>
<summary><b>Compiler 优化 flags</b></summary>

- 编译 preprocessed .i 文件
- 运行 from preprocessed source
- 编译 使用 -D 参数
- 运行 使用 -D defined macro
- 生成 assembly 使用 -S
- 检查 main label in assembly
- Assemble object 文件
- 链接 使用 -lm
- 运行 math linked program
- 编译 静态 binary

</details>

<details>
<summary><b>预处理器</b></summary>

- 编译 使用 -Wall 警告 enabled
- 编译 使用 -Werror
- 编译 使用 -pedantic
- 编译 add.c object
- 编译 main.c object
- 链接 multiple objects
- 运行 multi-文件 program
- 编译 multiple files in one 命令
- 运行 single-命令 multi-文件 program
- 编译 使用 coverage flags

</details>

<details>
<summary><b>Assembly 输出</b></summary>

- 运行 coverage 测试 program
- 运行 gcov
- 检查 gcov 输出 文件 存在
- 测试 syntax 错误 detection
- 测试 missing 文件 错误
- 测试 undefined function 错误
- 测试 type mismatch 警告
- 编译 使用 C99 标准
- 编译 使用 __attribute__
- 运行 attribute 测试

</details>

<details>
<summary><b>链接 和 libraries</b></summary>

- 编译 使用 -I 包含 路径
- 运行 包含 路径 测试
- gcc-ar 版本 检查
- gcc-nm 版本 检查
- gcc-ranlib 版本 检查
- gcov-dump 版本 检查
- gcov-tool 版本 检查
- lto-dump 版本 检查
- cc 版本 检查
- cc equals gcc

</details>

<details>
<summary><b>警告 flags</b></summary>

- c++ 版本 检查
- c++ equals g++

</details>

<details>
<summary><b>Multi-文件 编译</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Code coverage (gcov)</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>错误 处理</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Special features</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>GCC toolchain utilities</b></summary>

- 执行相关功能验证

</details>


---

## git

- **版本**: git 2.54.0
- **测试点**: 50
- **被测命令**: `git`, `git-shell`, `scalar`

<details>
<summary><b>仓库 initialization</b></summary>

- 检查 git-core 已安装
- 检查 git 可用
- git 版本
- git 初始化: 创建 repo
- git 状态: 检查 状态
- git 初始化: .git 目录 存在
- git config: 设置 用户 name
- git config: 设置 email
- git config: 获取 用户 name
- git config --列出

</details>

<details>
<summary><b>用户 configuration</b></summary>

- git add: stage 文件
- git 状态 --short
- git 提交: first 提交
- git 日志: 显示 commits
- git 分支: 创建 分支
- git 分支: 列出 branches
- git 分支 -a: all branches
- git switch: switch 分支
- git switch -: previous 分支
- git 分支 -d: 删除 分支

</details>

<details>
<summary><b>文件 operations</b></summary>

- git add: second 文件
- git 提交: second 提交
- git 差异: 显示 changes
- git 差异 --cached: staged changes
- git 提交: modify
- git 日志: last 3 commits
- git 日志 --graph
- git 显示: latest 提交
- git 显示: previous 提交
- git 标签: 创建 标签

</details>

<details>
<summary><b>分支 operations</b></summary>

- git 标签: 列出 tags
- git 标签 -d: 删除 标签
- git add: temp 文件
- git 重置: unstage
- git 恢复 --staged
- Cleanup temp
- git 远程: 列出 remotes
- git 远程 add
- git 暂存: 推送
- git 暂存 列出

</details>

<details>
<summary><b>文件 modifications</b></summary>

- git 暂存 pop
- git 搜索: search
- git 追溯: annotate
- git 清理 -n: dry 运行
- git gc: garbage collect
- git-shell 可用
- scalar 可用
- scalar 帮助
- git: invalid 命令
- git: invalid 选项

</details>

<details>
<summary><b>日志 和 显示</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>标签 operations</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>重置 和 恢复</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>远程 operations</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>暂存</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>搜索 和 追溯</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>清理 和 gc</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>git-shell</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>scalar</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>错误 处理</b></summary>

- 执行相关功能验证

</details>


---

## grep

- **版本**: GNU grep 3.12
- **测试点**: 50
- **被测命令**: `grep`, `egrep`, `fgrep`

<details>
<summary><b>基本 pattern matching</b></summary>

- 检查 搜索 软件包 已安装
- 检查 搜索 命令 可用
- 检查 egrep 命令 可用
- 检查 fgrep 命令 可用
- 获取 搜索 版本 信息
- 基本 搜索 Hello
- 验证 multiple matches
- 搜索 from 管道
- 搜索 across multiple files
- Case insensitive 搜索

</details>

<details>
<summary><b>Case insensitive (-i)</b></summary>

- 验证 case insensitive matches
- Case sensitive: lowercase 仅 matches lowercase
- Invert match: exclude Hello
- 验证 inverted 输出 contains 其他用户 lines
- 创建 word 测试 文件
- Add line 使用 separate words
- Whole word match: hello matches 仅 standalone
- 创建 line 测试 文件
- Add different line
- Whole line exact match

</details>

<details>
<summary><b>Invert match (-v)</b></summary>

- Count matches 使用 -c
- 验证 count >= 2
- 显示 line numbers 使用 -n
- 验证 line number format
- 递归 搜索 in subdirectory
- 递归 列出 files 使用 matches
- 递归 使用 --包含 filter
- Extended regex 使用 alternation
- Extended regex: digit quantifier
- 验证 digit match count

</details>

<details>
<summary><b>Word 和 line matching (-w, -x)</b></summary>

- egrep equivalent 搜索 -E
- Fixed string 使用 special chars
- Fixed string: 无 regex meta-char interpretation
- fgrep equivalent 搜索 -F
- Only matching: digits 仅
- Quiet 模式: pattern found
- Quiet 模式: pattern not found
- Hello World
- Hello Linux
- Hello World

</details>

<details>
<summary><b>Count 和 line numbers (-c, -n)</b></summary>

- 列出 files 使用 matches
- 列出 files without matches
- Multiple patterns 使用 -e
- Patterns from 文件 使用 -f
- Max count: 停止 after first match
- 错误 on nonexistent 文件
- 错误 on invalid regex
- 错误 on 目录 without -r
- No match returns exit code 1

</details>

<details>
<summary><b>递归 search (-r)</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Extended regex (-E)</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Fixed strings (-F)</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Only matching 和 quiet (-o, -q)</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Context lines (-A, -B, -C)</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>文件 listing (-l, -L)</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Multiple patterns (-e, -f)</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>错误 处理</b></summary>

- 执行相关功能验证

</details>


---

## gxx

- **版本**: gcc-c++
- **测试点**: 20
- **被测命令**: `g++`, `c++`

<details>
<summary><b>基本 C++ 编译</b></summary>

- 检查 gcc-c++ 已安装
- 检查 g++ 命令 可用
- 检查 c++ 命令 可用
- g++ 版本 信息
- 编译 hello.cpp
- 运行 已编译 binary
- 输出 ELF binary
- g++ -c: 编译 仅
- Object 文件 存在
- 优化 -$lvl

</details>

<details>
<summary><b>编译-仅</b></summary>

- 调试 symbols
- -Wall 警告
- -Wextra 警告
- g++ -E: preprocess
- 链接 from object
- g++ -shared: shared library
- g++ -I: 包含 路径
- c++ 别名 works
- Compilation 错误
- Invalid 选项

</details>

<details>
<summary><b>优化</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>调试 和 警告</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>预处理器</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>链接</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>包含 paths</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>c++ 别名</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>错误 处理</b></summary>

- 执行相关功能验证

</details>


---

## iputils

- **版本**: iputils 20250605
- **测试点**: 10
- **被测命令**: `ping`

<details>
<summary><b>ping 基本 functionality</b></summary>

- 测试 section: ping 基本 functionality ===
- 测试 section: ping 高级 选项 ===
- 测试 section: ping6 (IPv6) ===
- 测试 section: traceroute6 ===
- 测试 section: tracepath ===
- 测试 section: arping ===
- 测试 section: clockdiff ===
- 测试 section: ping 错误 处理 ===
- 测试 section: ping special scenarios ===
- 测试 section: 网络 interface testing ===

</details>

<details>
<summary><b>ping 高级 选项</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>ping6 (IPv6)</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>traceroute6</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>tracepath</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>arping</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>clockdiff</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>ping 错误 处理</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>ping special scenarios</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>网络 interface testing</b></summary>

- 执行相关功能验证

</details>


---

## labwc

- **版本**: labwc 0.9.7
- **测试点**: 14
- **被测命令**: `labwc`, `labnag`, `lab-sensible-terminal`, `labwc)`

<details>
<summary><b>帮助</b></summary>

- 检查 labwc 已安装
- 检查 labwc 可用
- 检查 labnag 可用
- 检查 lab-sensible-terminal 可用
- labwc 帮助
- labwc: config 选项
- labwc: 调试 选项
- labwc: startup/会话 选项
- labwc: linked libraries
- labnag 帮助

</details>

<details>
<summary><b>Configuration</b></summary>

- lab-sensible-terminal 帮助
- System config dir
- Data dir
- labwc: invalid 选项

</details>

<details>
<summary><b>调试 模式</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>检查 display (无 DISPLAY)</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Library 检查</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>labnag</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>lab-sensible-terminal</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Config dirs</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>错误 处理</b></summary>

- 执行相关功能验证

</details>


---

## make

- **版本**: GNU Make 4.4.1
- **测试点**: 26
- **被测命令**: `make`, `gmake`

<details>
<summary><b>基本 Makefile execution</b></summary>

- 检查 make 已安装
- 检查 make 命令 可用
- 检查 gmake 命令 可用
- make 版本
- gmake 版本
- 运行 默认 target
- 运行 specific target
- 运行 清理 target
- make -s: silent 模式
- Variable expansion

</details>

<details>
<summary><b>Variables</b></summary>

- Override variable
- make -n: dry 运行
- make -B: always make
- make --just-print
- make -d: 调试 输出
- make --调试=b: 基本 调试
- make -q: question 模式
- make -s: silent
- make -j2: parallel 2 jobs
- make -e: 环境变量 overrides

</details>

<details>
<summary><b>选项</b></summary>

- 环境变量 variable in make
- make -C: change 目录
- 包含 文件
- gmake GNU Make
- make -k: continue on 错误
- make -i: ignore errors

</details>

<details>
<summary><b>Parallel execution</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>环境变量</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>目录 change</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>包含</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>gmake 别名</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>错误 处理</b></summary>

- 执行相关功能验证

</details>


---

## openssh

- **版本**: openssh 10.3p1
- **测试点**: 27
- **被测命令**: `ssh-keygen`

<details>
<summary><b>RSA 密钥生成</b></summary>

- 检查 openssh 已安装
- 检查 ssh-keygen 可用
- ssh-keygen 帮助
- 生成 RSA 2048 key
- 私钥 存在
- 公钥 存在
- 显示 RSA key 指纹
- 生成 ECDSA 256 key
- 显示 ECDSA 指纹
- 生成 Ed25519 key

</details>

<details>
<summary><b>ECDSA 密钥生成</b></summary>

- 显示 Ed25519 指纹
- 详细 指纹
- 生成 key 使用 密码
- 删除 密码
- 生成 key 使用 注释
- 验证 注释 in pubkey
- Export RFC4716 format
- Import RFC4716 format
- 提取 公钥 from private
- Change key 注释

</details>

<details>
<summary><b>Ed25519 密钥生成</b></summary>

- Hash known hosts
- SHA256 指纹
- MD5 指纹
- 生成 RSA 2048 key
- 验证 RSA 2048 key
- Invalid key type
- Invalid 路径

</details>

<details>
<summary><b>Key 使用 密码</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Key 使用 注释</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Key conversion</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>公钥 extraction</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Change 注释</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Hash known hosts</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>指纹 hashes</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>RSA key 选项</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>错误 处理</b></summary>

- 执行相关功能验证

</details>


---

## openssh-clients

- **版本**: openssh-clients 10.3p1
- **测试点**: 27
- **被测命令**: `ssh`, `scp`, `sftp`, `ssh-add`, `ssh-agent`, `ssh-copy-id`, `ssh-keyscan`

<details>
<summary><b>ssh 版本 和 帮助</b></summary>

- 检查 openssh-clients 已安装
- 检查 ssh 可用
- 检查 scp 可用
- 检查 sftp 可用
- 检查 ssh-add 可用
- 检查 ssh-agent 可用
- 检查 ssh-复制-id 可用
- 检查 ssh-keyscan 可用
- ssh 版本
- ssh -Q key: supported keys

</details>

<details>
<summary><b>ssh connection (dry-运行)</b></summary>

- ssh -Q cipher: ciphers
- ssh -Q mac: MACs
- ssh -Q kex: key exchange
- ssh -G: print config
- ssh -T: 禁用 PTY
- ssh -v: 详细
- 生成 测试 key
- ssh-add: 列出 keys
- ssh-add: add key
- ssh-add: 验证 key added

</details>

<details>
<summary><b>ssh-keygen via openssh</b></summary>

- ssh-add -L: 列出 public keys
- ssh-add -d: 删除 key
- ssh-keyscan: scan localhost
- ssh-keyscan -t rsa
- ssh-keyscan -t ecdsa
- sftp: 帮助 命令
- scp 版本

</details>

<details>
<summary><b>ssh-agent</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>ssh-keyscan</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>sftp</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>scp</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>ssh-复制-id</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>错误 处理</b></summary>

- 执行相关功能验证

</details>


---

## pciutils

- **版本**: pciutils
- **测试点**: 13
- **被测命令**: `lspci`

<details>
<summary><b>lspci 基本</b></summary>

- 测试 section: lspci 基本 ===
- 测试 section: lspci 详细 ===
- 测试 section: lspci 使用 filtering ===
- 测试 section: lspci numeric ===
- 测试 section: lspci tree view ===
- 测试 section: lspci kernel drivers ===
- 测试 section: lspci by device class ===
- 测试 section: lspci 使用 domain ===
- 测试 section: update-pciids ===
- 测试 section: lspci format 选项 ===

</details>

<details>
<summary><b>lspci 详细</b></summary>

- 测试 section: setpci ===
- 测试 section: pcilmr ===
- 测试 section: 错误 处理 ===

</details>

<details>
<summary><b>lspci 使用 filtering</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>lspci numeric</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>lspci tree view</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>lspci kernel drivers</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>lspci by device class</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>lspci 使用 domain</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>update-pciids</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>lspci format 选项</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>setpci</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>pcilmr</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>错误 处理</b></summary>

- 执行相关功能验证

</details>


---

## podman

- **版本**: podman
- **测试点**: 21
- **被测命令**: `podman`, `podman-remote`

<details>
<summary><b>镜像 operations</b></summary>

- 检查 podman 已安装
- 检查 podman 可用
- 检查 podman-远程 可用
- podman 版本
- podman 信息
- podman images: 列出 images
- podman 镜像 列出
- podman ps: 列出 containers
- podman ps -a: all containers
- podman 容器 列出

</details>

<details>
<summary><b>容器 operations</b></summary>

- podman 网络 ls
- podman 网络 inspect
- podman 卷 ls
- podman system 信息
- podman system df: disk usage
- podman 清单 帮助
- podman healthcheck 帮助
- podman events 帮助
- podman Pod 列出
- podman-远程 帮助

</details>

<details>
<summary><b>网络 operations</b></summary>

- podman: invalid 命令

</details>

<details>
<summary><b>卷 operations</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>System operations</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>帮助 commands</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>错误 处理</b></summary>

- 执行相关功能验证

</details>


---

## podmansh

- **版本**: podmansh
- **测试点**: 11
- **被测命令**: `podmansh`

<details>
<summary><b>podmansh 基本</b></summary>

- 测试 section: podmansh 基本 ===
- 测试 section: podmansh 帮助 ===
- 测试 section: podmansh config ===
- 测试 section: podman 基本 ===
- 测试 section: podman images ===
- 测试 section: podman 网络 ===
- 测试 section: podman 卷 ===
- 测试 section: podman stats ===
- 测试 section: podman ps ===
- 测试 section: 错误 处理 ===

</details>

<details>
<summary><b>podmansh 帮助</b></summary>

- 测试 section: Cleanup ===

</details>

<details>
<summary><b>podmansh config</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>podman 基本</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>podman images</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>podman 网络</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>podman 卷</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>podman stats</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>podman ps</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>错误 处理</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Cleanup</b></summary>

- 执行相关功能验证

</details>


---

## procps-ng

- **版本**: procps-ng 4.0.5
- **测试点**: 14
- **被测命令**: `ps`

<details>
<summary><b>ps 命令 基本 functionality</b></summary>

- 测试 section: ps 命令 基本 functionality ===
- 测试 section: ps 命令 高级 features ===
- 测试 section: free 命令 ===
- 测试 section: top 命令 ===
- 测试 section: vmstat 命令 ===
- 测试 section: uptime 和 w commands ===
- 测试 section: 终止 命令 ===
- 测试 section: pidof 和 pgrep ===
- 测试 section: pwdx 和 pmap ===
- 测试 section: sysctl (if 可用) ===

</details>

<details>
<summary><b>ps 命令 高级 features</b></summary>

- 测试 section: 错误 处理 ===
- 测试 section: Special scenarios ===
- 测试 section: pkill 和 pidwait ===
- 测试 section: slabtop, tload, watch, hugetop ===

</details>

<details>
<summary><b>free 命令</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>top 命令</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>vmstat 命令</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>uptime 和 w commands</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>终止 命令</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>pidof 和 pgrep</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>pwdx 和 pmap</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>sysctl (if 可用)</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>错误 处理</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Special scenarios</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>pkill 和 pidwait</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>slabtop, tload, watch, hugetop</b></summary>

- 执行相关功能验证

</details>


---

## psmisc

- **版本**: psmisc
- **测试点**: 13
- **被测命令**: `fuser`

<details>
<summary><b>fuser 基本</b></summary>

- 测试 section: fuser 基本 ===
- 测试 section: fuser 使用 processes ===
- 测试 section: fuser 挂载 points ===
- 测试 section: fuser 使用 选项 ===
- 测试 section: pstree 基本 ===
- 测试 section: pstree 使用 选项 ===
- 测试 section: killall 基本 ===
- 测试 section: prtstat ===
- 测试 section: peekfd ===
- 测试 section: pslog ===

</details>

<details>
<summary><b>fuser 使用 processes</b></summary>

- 测试 section: killall 使用 signals ===
- 测试 section: fuser special cases ===
- 测试 section: 错误 处理 ===

</details>

<details>
<summary><b>fuser 挂载 points</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>fuser 使用 选项</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>pstree 基本</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>pstree 使用 选项</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>killall 基本</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>prtstat</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>peekfd</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>pslog</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>killall 使用 signals</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>fuser special cases</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>错误 处理</b></summary>

- 执行相关功能验证

</details>


---

## rpmbuild

- **版本**: rpm-build
- **测试点**: 9
- **被测命令**: `rpmbuild`

<details>
<summary><b>rpmbuild 基本 functionality</b></summary>

- 测试 section: rpmbuild 基本 functionality ===
- 测试 section: 创建 simple spec 文件 ===
- 测试 section: 创建 source tarball ===
- 测试 section: 构建 RPM 软件包 ===
- 测试 section: 验证 built RPM ===
- 测试 section: 安装 和 测试 RPM ===
- 测试 section: RPM 构建 选项 ===
- 测试 section: 错误 处理 ===
- 测试 section: RPM verification ===

</details>

<details>
<summary><b>创建 simple spec 文件</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>创建 source tarball</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>构建 RPM 软件包</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>验证 built RPM</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>安装 和 测试 RPM</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>RPM 构建 选项</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>错误 处理</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>RPM verification</b></summary>

- 执行相关功能验证

</details>


---

## sddm

- **版本**: sddm 0.21.0
- **测试点**: 13
- **被测命令**: `sddm`, `sddm-greeter-qt6`

<details>
<summary><b>版本 和 帮助</b></summary>

- 检查 sddm 已安装
- 检查 sddm 可用
- 检查 sddm-greeter 可用
- sddm 帮助
- sddm --测试-模式 帮助
- sddm: example config
- Config 目录
- 默认 config dir
- sddm 服务 unit
- sddm 服务 状态

</details>

<details>
<summary><b>Configuration</b></summary>

- sddm enabled 状态
- sddm themes 已安装
- sddm: key config values

</details>

<details>
<summary><b>服务 检查</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Theme 检查</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Config values</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>D-Bus</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>错误 处理</b></summary>

- 执行相关功能验证

</details>


---

## systemd

- **版本**: systemd 259
- **测试点**: 115

<details>
<summary><b>systemctl - 服务 和 system management</b></summary>

- 检查 系统管理 软件包 已安装
- systemctl 版本
- systemctl: 列出 running services
- systemctl: 列出 targets
- systemctl --all: all services
- systemctl: 列出 unit files
- systemctl -active: 检查 服务 状态
- systemctl -enabled: 检查 enabled
- systemctl -failed: 列出 failed units
- systemctl 状态: 服务 状态

</details>

<details>
<summary><b>journalctl - 日志 query</b></summary>

- systemctl 显示: 服务 properties
- systemctl cat: 显示 unit 文件
- systemctl 列出-dependencies
- systemctl 列出-sockets
- systemctl 列出-timers
- systemctl 列出-machines
- journalctl 版本
- journalctl -n: last entries
- journalctl -b: current boot
- journalctl --列出-boots

</details>

<details>
<summary><b>系统管理-analyze - System 性能分析</b></summary>

- journalctl -k: kernel messages
- journalctl -o short: short format
- journalctl -o json: json format
- journalctl -o 详细
- journalctl --disk-usage
- journalctl --输出=cat
- journalctl -p err: 错误 messages
- journalctl --since
- journalctl -q: quiet
- 系统管理-analyze 版本

</details>

<details>
<summary><b>hostnamectl - 主机名 management</b></summary>

- 系统管理-analyze time: boot time
- 系统管理-analyze security
- hostnamectl 版本
- hostnamectl 状态: system 信息
- hostnamectl 主机名: current name
- hostnamectl --静态
- hostnamectl --transient
- hostnamectl --pretty
- hostnamectl chassis
- localectl 版本

</details>

<details>
<summary><b>localectl - 区域设置 management</b></summary>

- localectl 状态: 区域设置 信息
- localectl 列出-locales
- timedatectl 版本
- timedatectl 状态: time 信息
- timedatectl 显示: all properties
- timedatectl 列出-timezones
- timedatectl 显示-timesync
- loginctl 版本
- loginctl 列出-sessions
- loginctl 列出-users

</details>

<details>
<summary><b>timedatectl - Time/date management</b></summary>

- loginctl 显示-会话
- loginctl 显示-用户
- loginctl 用户-状态
- 系统管理-检测-virt: 检测 VM
- 系统管理-检测-virt -q: quiet 模式
- 系统管理-检测-virt -c: 容器 仅
- 系统管理-检测-virt -v: VM 仅
- 系统管理-检测-virt -r: chroot 仅
- 系统管理-cgls: 控制组 tree
- 系统管理-cgls -k: kernel threads

</details>

<details>
<summary><b>loginctl - Login management</b></summary>

- 系统管理-cgls --无-pager
- 系统管理-cgtop -b: batch 模式
- 系统管理-临时文件 版本
- 系统管理-临时文件 --cat-config
- busctl 版本
- busctl 列出: 列出 services
- busctl 状态: bus 状态
- busctl tree: object tree
- busctl introspect
- 系统管理-运行 版本

</details>

<details>
<summary><b>系统管理-检测-virt</b></summary>

- 系统管理-运行 --用户 --scope
- 系统管理-cat: 管道 日志
- 系统管理-cat 版本
- 系统管理-通知 版本
- 系统管理-通知 帮助
- 系统管理-路径: all paths
- 系统管理-路径: specific 路径
- 系统管理-路径 --suffix
- 系统管理-路径 帮助
- 系统管理-转义: 基本 转义

</details>

<details>
<summary><b>系统管理-cgls - 控制组 listing</b></summary>

- 系统管理-转义 --路径: 路径 转义
- 系统管理-转义 -u: unescape
- 系统管理-转义 --suffix
- 系统管理-转义 --模板
- 系统管理-machine-id-setup 帮助
- 系统管理-machine-id-setup: 检查 machine-id
- coredumpctl 版本
- coredumpctl 列出: 列出 dumps
- coredumpctl 信息
- 系统管理-delta 帮助

</details>

<details>
<summary><b>系统管理-cgtop - 控制组 top</b></summary>

- 系统管理-delta: 显示 overrides
- 系统管理-id128 显示: 显示 IDs
- 系统管理-id128 new: 生成 ID
- 系统管理-inhibit 帮助
- 系统管理-inhibit --列出
- 系统管理-ac-电源: 检查 电源
- 系统管理-ask-password 帮助
- 系统管理-creds 帮助
- 系统管理-socket-activate 帮助
- $cmd 帮助

</details>

<details>
<summary><b>系统管理-临时文件</b></summary>

- 系统管理-firstboot 帮助
- 系统管理-stdio-bridge 帮助
- oomctl 帮助
- oomctl dump
- systemctl try-重启
- systemctl reload-or-重启
- systemctl 重置-failed
- systemctl daemon-reload
- run0 帮助
- 系统管理-挂载 帮助

</details>

<details>
<summary><b>busctl - D-Bus introspection</b></summary>

- 系统管理-sysext 帮助
- 系统管理-confext 帮助
- systemctl: invalid 命令
- journalctl: invalid 选项
- hostnamectl: invalid 选项

</details>

<details>
<summary><b>系统管理-运行</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>系统管理-cat</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>系统管理-通知</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>系统管理-路径</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>系统管理-转义</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>系统管理-machine-id-setup</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>coredumpctl</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>系统管理-delta</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>系统管理-id128</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>系统管理-inhibit</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>系统管理-ac-电源</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>系统管理-ask-password</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>系统管理-creds</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>系统管理-socket-activate</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>电源 management commands</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>系统管理-firstboot</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>系统管理-stdio-bridge</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>oomctl</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>systemctl 服务 operations</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>run0 - Privilege escalation</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>系统管理-挂载</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>系统管理-sysext</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>系统管理-confext</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>错误 处理</b></summary>

- 执行相关功能验证

</details>


---

## systemd-timesyncd

- **版本**: systemd-timesyncd 259
- **测试点**: 14

<details>
<summary><b>服务 状态</b></summary>

- 检查 系统管理-timesyncd 已安装
- 服务 状态
- Time sync 状态
- Timesync detail
- Is enabled
- Fallback NTP同步 servers
- Current NTP同步 server
- Server address
- NTP同步 servers 列出
- 重启 服务

</details>

<details>
<summary><b>NTP同步 management</b></summary>

- Is active
- Config 文件
- Cat config
- Wait sync 服务

</details>

<details>
<summary><b>服务 control</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Configuration</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>系统管理-time-wait-sync</b></summary>

- 执行相关功能验证

</details>


---

## tar

- **版本**: tar 1.35
- **测试点**: 10
- **被测命令**: `tar`

<details>
<summary><b>基本 归档 creation</b></summary>

- 测试 section: 基本 归档 creation ===
- 测试 section: 归档 extraction ===
- 测试 section: Compression formats ===
- 测试 section: 高级 tar 选项 ===
- 测试 section: 归档 verification ===
- 测试 section: Special attributes ===
- 测试 section: 错误 处理 ===
- 测试 section: Wildcard 和 patterns ===
- 测试 section: Incremental 备份 ===
- 测试 section: Special 文件 types ===

</details>

<details>
<summary><b>归档 extraction</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Compression formats</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>高级 tar 选项</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>归档 verification</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Special attributes</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>错误 处理</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Wildcard 和 patterns</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Incremental 备份</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Special 文件 types</b></summary>

- 执行相关功能验证

</details>


---

## tmux

- **版本**: tmux 3.6a
- **测试点**: 182
- **被测命令**: `tmux`

<details>
<summary><b>Server management</b></summary>

- 检查 tmux 软件包 已安装
- 检查 tmux 命令 可用
- tmux 版本
- 启动-server: 启动 tmux server
- 列出-sessions: initial state
- has-会话: 检查 nonexistent
- 列出-clients: 列出 connected clients
- 列出-commands: 列出 all commands
- 列出-commands: filter specific 命令
- 列出-commands: format 输出

</details>

<details>
<summary><b>会话 creation 和 management</b></summary>

- server-访问控制 -l: 列出 访问控制
- new-会话 -d: 创建 detached 会话
- has-会话: 验证 会话 存在
- new-会话 -d: 使用 启动 目录
- has-会话: 验证 sess2 存在
- new-会话 -e: 设置 环境变量
- new-会话 -F: format 输出
- new-会话: 设置 dimensions
- new-会话 -A: 附加 if 存在
- 列出-sessions: 列出 all sessions

</details>

<details>
<summary><b>窗口 management</b></summary>

- 列出-sessions -F: formatted
- 重命名-会话: 重命名 sess2
- has-会话: 验证 renamed 会话
- 锁定-会话: 锁定 会话
- switch-client -t: switch 会话
- 附加-会话 -d: 附加 和 分离 others
- 分离-client -P
- 分离-client -a: all in 会话
- 挂起-client: 挂起 client
- 锁定-client: 锁定 client

</details>

<details>
<summary><b>窗格 management</b></summary>

- refresh-client -S: 状态 line 仅
- refresh-client -L: lease
- new-窗口: 创建 窗口
- new-窗口 -d: detached
- new-窗口 -c: 使用 目录
- new-窗口 -e: 使用 env
- 列出-windows: 列出 all windows
- 列出-windows -a: all sessions
- 列出-windows -F: formatted
- 选择-窗口: by name

</details>

<details>
<summary><b>布局 management</b></summary>

- 选择-窗口: by index
- 选择-窗口 -l: last 窗口
- 选择-窗口 -n: next
- 选择-窗口 -p: previous
- 重命名-窗口: 重命名 窗口
- next-窗口: next
- previous-窗口: prev
- last-窗口: last
- 移动-窗口 -a: after
- 移动-窗口 -b: before

</details>

<details>
<summary><b>缓冲区 management</b></summary>

- 交换-窗口
- 链接-窗口: 链接 窗口
- unlink-窗口: unlink
- 终止-窗口: 创建 temp 窗口
- 终止-窗口: 终止 窗口
- 旋转-窗口: 旋转
- 旋转-窗口 -D: downward
- 重生-窗口 -k: 重生
- 调整大小-窗口: 设置 size
- 调整大小-窗口 -U: up

</details>

<details>
<summary><b>Key bindings 和 输入</b></summary>

- 调整大小-窗口 -D: down
- 分割-窗口: horizontal 分割
- 分割-窗口 -h: vertical 分割
- 分割-窗口 -v: vertical explicit
- 分割-窗口 -l: 使用 size
- 分割-窗口 -d: don't focus
- 分割-窗口 -f: full size
- 分割-窗口 -b: before
- 分割-窗口 -I: 创建 empty 窗格
- 列出-panes: 列出 panes

</details>

<details>
<summary><b>选项 和 settings</b></summary>

- 列出-panes -as: all panes
- 列出-panes -F: formatted
- display-panes: 显示 窗格 IDs
- 选择-窗格: by ID
- 选择-窗格 -l: last 窗格
- 选择-窗格 -U: up
- 选择-窗格 -D: down
- 选择-窗格 -L: left
- 选择-窗格 -R: right
- 调整大小-窗格 -y: height

</details>

<details>
<summary><b>环境变量 variables</b></summary>

- 调整大小-窗格 -x: width
- 调整大小-窗格 -U: up
- 调整大小-窗格 -D: down
- 调整大小-窗格 -L: left
- 调整大小-窗格 -R: right
- 调整大小-窗格 -Z: zoom
- 分离-窗格 -d: 分离 窗格 new 窗口
- 合并-窗格: 合并 窗格 back
- 移动-窗格: 移动 窗格
- 交换-窗格: 交换 panes

</details>

<details>
<summary><b>Hooks</b></summary>

- last-窗格: switch last 窗格
- 终止-窗格: 创建 temp 窗格
- 终止-窗格: 终止 窗格
- 终止-窗格 -a: 终止 all but current
- 捕获-窗格 -p: print stdout
- 捕获-窗格: range 捕获
- 捕获-窗格 -J: 合并 lines
- 管道-窗格 -o: 管道 输出
- 重生-窗格 -k: 重生
- 选择-布局: even-horizontal

</details>

<details>
<summary><b>Messages 和 display</b></summary>

- 选择-布局: even-vertical
- 选择-布局: main-horizontal
- 选择-布局: main-vertical
- 选择-布局: tiled
- next-布局: cycle layouts
- previous-布局: prev 布局
- 设置-缓冲区 -b: named 缓冲区
- hello world
- 设置-缓冲区 -a: append
- 列出-buffers: 列出 all buffers

</details>

<details>
<summary><b>Conditional 和 shell execution</b></summary>

- 列出-buffers -F: formatted
- 显示-缓冲区: 显示 缓冲区 contents
- paste-缓冲区: paste 缓冲区
- paste-缓冲区 -d: 删除 after paste
- 删除-缓冲区: 创建 temp 缓冲区
- 删除-缓冲区: 删除 缓冲区
- save-缓冲区: 创建 缓冲区
- save-缓冲区: save 文件
- load-缓冲区: load from 文件
- 列出-keys: 列出 all keys

</details>

<details>
<summary><b>Source 和 configuration</b></summary>

- 列出-keys -T: prefix table
- 列出-keys -T: root table
- 列出-keys -a: all keys
- 列出-keys -N: 使用 notes
- bind-key -n: bind key
- unbind-key -n: unbind key
- bind-key -T: bind in table
- unbind-key -T: unbind in table
- echo hello
- literal

</details>

<details>
<summary><b>复制 模式</b></summary>

- 0d
- send-prefix: send prefix key
- 设置-选项 -g: global
- 设置-选项 -a: append
- 设置-选项: mouse on
- 设置-选项 -s: server 选项
- 设置-窗口-选项: monitor activity
- 设置-窗口-选项 -g: global
- 显示-选项 -g: global 选项
- 显示-选项 -s: server 选项

</details>

<details>
<summary><b>Find 窗口</b></summary>

- 显示-窗口-选项: 窗口 选项
- 显示-窗口-选项 -g: global 窗口 选项
- 设置-环境变量 -g: global env
- 设置-环境变量: 会话 env
- 设置-环境变量 -gur: update then 删除
- 显示-环境变量 -g: global env
- 显示-环境变量: 会话 env
- 设置-钩子: 会话-created
- 设置-钩子: client-attached
- 显示-hooks -g: global hooks

</details>

<details>
<summary><b>Choose commands (interactive)</b></summary>

- 设置-钩子 -gu: 删除 global 钩子
- 设置-钩子 -gu: 删除 钩子
- display-message: 显示 message
- display-message -p: print format
- 显示-messages: message 日志
- display-popup -C: close popup
- clear-历史: clear 窗格 历史
- if-shell: true condition
- 运行-shell: 运行 shell 命令
- 运行-shell -b: background

</details>

<details>
<summary><b>Clock 模式</b></summary>

- 命令-prompt: open prompt
- confirm-before: confirm dialog
- source-文件: source config
- 复制-模式: enter 复制 模式
- find-窗口: search windows
- choose-tree -G: tree display
- choose-client: client selection
- clock-模式: 显示 clock
- 锁定-server: 锁定 server
- 锁定-会话: 锁定 会话

</details>

<details>
<summary><b>锁定 management</b></summary>

- 显示-prompt-历史: prompt 历史
- clear-prompt-历史: clear prompt 历史
- wait- -L: 锁定 channel
- 终止-会话: 终止 renamed_sess
- 终止-会话: 终止 sess_fmt
- 终止-会话: 终止 sess_sz
- 终止-会话: 终止 sess_flags
- 终止-会话: 终止 sess_env
- 终止-会话: 终止 main 测试 会话
- 终止-server: terminate server

</details>

<details>
<summary><b>显示 prompt 历史</b></summary>

- 错误: nonexistent 会话
- 错误: invalid 选项

</details>

<details>
<summary><b>Wait- (event channels)</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Cleanup - 终止 sessions</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>错误 处理</b></summary>

- 执行相关功能验证

</details>


---

## vim

- **版本**: Vim 9.2
- **测试点**: 20
- **被测命令**: `vim`, `vimdiff`

<details>
<summary><b>基本 editing</b></summary>

- 检查 vim-common 已安装
- 检查 vim 可用
- vim 版本
- vim -e: ex 模式
- vim: print 缓冲区
- vim --帮助
- vim -c: execute 命令
- vim -R: readonly 模式
- vim -b: binary 模式
- vim -n: 无 交换 文件

</details>

<details>
<summary><b>Batch/ex 模式 commands</b></summary>

- vimdiff 可用
- vimdiff: compare files
- vim: syntax 启用
- vim: search 和 replace
- Replace verified
- vim: multiple files
- vim: insert in ex 模式
- vim -T: terminal type
- vim: invalid 选项
- vim: nonexistent 文件

</details>

<details>
<summary><b>命令 line 选项</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Vimdiff</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Syntax 检查</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Search 和 replace (ex 模式)</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Multiple files</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Recording 测试</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Terminal 选项</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>错误 处理</b></summary>

- 执行相关功能验证

</details>


---

## weston

- **版本**: weston 14.0.2
- **测试点**: 15
- **被测命令**: `weston`, `weston-debug`, `weston-screenshooter`, `weston-terminal`, `wcap-decode`

<details>
<summary><b>版本</b></summary>

- 检查 weston 已安装
- 检查 weston 可用
- 检查 weston-调试 可用
- 检查 weston-screenshooter 可用
- 检查 weston-terminal 可用
- 检查 wcap-decode 可用
- weston 版本
- weston 帮助
- weston-terminal 帮助
- weston-调试 帮助

</details>

<details>
<summary><b>帮助</b></summary>

- weston-screenshooter 帮助
- wcap-decode 帮助
- 可用 backends
- weston: headless backend
- weston: invalid 选项

</details>

<details>
<summary><b>Weston terminal (headless)</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Weston 调试</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Screenshooter</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>wcap-decode</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Backend 检查</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Headless backend 测试</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>错误 处理</b></summary>

- 执行相关功能验证

</details>


---

## wget

- **版本**: wget (provided by wget2)
- **测试点**: 15
- **被测命令**: `wget`

<details>
<summary><b>基本 下载</b></summary>

- 测试 section: 基本 下载 ===
- 测试 section: 输出 选项 ===
- 测试 section: 详细 和 quiet modes ===
- 测试 section: Spider 模式 ===
- 测试 section: Header 选项 ===
- 测试 section: 用户 agent ===
- 测试 section: Timeout 和 retries ===
- 测试 section: 递归 下载 ===
- 测试 section: Continue 和 mirror ===
- 测试 section: Rate limiting ===

</details>

<details>
<summary><b>输出 选项</b></summary>

- 测试 section: Progress indicators ===
- 测试 section: 错误 处理 ===
- 测试 section: 目录 listing ===
- 测试 section: Timestamps ===
- 测试 section: Special features ===

</details>

<details>
<summary><b>详细 和 quiet modes</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Spider 模式</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Header 选项</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>用户 agent</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Timeout 和 retries</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>递归 下载</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Continue 和 mirror</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Rate limiting</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Progress indicators</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>错误 处理</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>目录 listing</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Timestamps</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Special features</b></summary>

- 执行相关功能验证

</details>


---

## wget2

- **版本**: wget2
- **测试点**: 15
- **被测命令**: `wget2`

<details>
<summary><b>基本 下载</b></summary>

- 测试 section: 基本 下载 ===
- 测试 section: 输出 文件 选项 ===
- 测试 section: 详细 modes ===
- 测试 section: Spider 模式 ===
- 测试 section: Headers ===
- 测试 section: 用户 agent ===
- 测试 section: Timeouts 和 retries ===
- 测试 section: Continue 下载 ===
- 测试 section: Rate limiting ===
- 测试 section: HTTP/2 support ===

</details>

<details>
<summary><b>输出 文件 选项</b></summary>

- 测试 section: TLS 选项 ===
- 测试 section: 错误 处理 ===
- 测试 section: Follow redirects ===
- 测试 section: Content disposition ===
- 测试 section: Plugin system ===

</details>

<details>
<summary><b>详细 modes</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Spider 模式</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Headers</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>用户 agent</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Timeouts 和 retries</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Continue 下载</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Rate limiting</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>HTTP/2 support</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>TLS 选项</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>错误 处理</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Follow redirects</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Content disposition</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Plugin system</b></summary>

- 执行相关功能验证

</details>

