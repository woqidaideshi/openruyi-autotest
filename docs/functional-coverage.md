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
<summary><b>Basic C compilation ===</b></summary>

- Check clang installed
- Check clang available
- Check clang++ available
- Check clang-cl available
- Check clang-cpp available
- Check clang-scan-deps available
- clang version
- Compile hello.c
- Run compiled binary
- Output is ELF binary

</details>

<details>
<summary><b>Basic C++ compilation ===</b></summary>

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

</details>

<details>
<summary><b>Compile-only ===</b></summary>

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

</details>

<details>
<summary><b>Optimization levels ===</b></summary>

- Compilation error
- Invalid option

</details>

<details>
<summary><b>Debug and warnings ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>C standards ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>C++ standards ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Preprocessor ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Static analysis ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>clang-cl (MSVC compat) ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>clang-cpp ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>clang-scan-deps ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Linking options ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Verbose mode ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Error handling ===</b></summary>

- 执行相关功能验证

</details>


---

## cloud-utils-growpart

- **版本**: cloud-utils-growpart
- **测试点**: 12
- **被测命令**: `growpart`

<details>
<summary><b>Help and version ===</b></summary>

- Check cloud-utils-growpart installed
- Check growpart command available
- growpart help
- growpart -h: short help
- lsblk: list block devices
- df: disk free space
- growpart -N: dry run
- growpart: has free-percent option
- growpart: has fudge option
- growpart: no args (expected fail)

</details>

<details>
<summary><b>Disk/partition info ===</b></summary>

- growpart: nonexistent disk
- growpart: invalid option

</details>

<details>
<summary><b>Dry-run (no actual resize) ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Free percent option ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Fudge factor option ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Error handling ===</b></summary>

- 执行相关功能验证

</details>


---

## cmake

- **版本**: cmake
- **测试点**: 7
- **被测命令**: `cmake`

<details>
<summary><b>Basic CMake project ===</b></summary>

- Test section: Basic CMake project ===
- Test section: CMake configure ===
- Test section: CMake build and run ===
- Test section: Library project ===
- Test section: Module finder ===
- Test section: Error handling ===
- Test section: CMake version and help ===

</details>

<details>
<summary><b>CMake configure ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>CMake build and run ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Library project ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Module finder ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Error handling ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>CMake version and help ===</b></summary>

- 执行相关功能验证

</details>


---

## coreutils

- **版本**: coreutils 9.10
- **测试点**: 238

<details>
<summary><b>File creation and listing (echo, cat, ls, dir, vdir) ===</b></summary>

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

</details>

<details>
<summary><b>Copy, move, remove (cp, mv, rm, rmdir) ===</b></summary>

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

</details>

<details>
<summary><b>Directory, file creation, temp files (mkdir, touch, mktemp) ===</b></summary>

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

</details>

<details>
<summary><b>Links and path resolution (ln, link, unlink, readlink, realpath) ===</b></summary>

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

</details>

<details>
<summary><b>File viewing (head, tail, tac, nl) ===</b></summary>

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

</details>

<details>
<summary><b>Counting and statistics (wc, du, df, stat) ===</b></summary>

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

</details>

<details>
<summary><b>Text processing I (sort, uniq, cut, tr) ===</b></summary>

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

</details>

<details>
<summary><b>Text processing II (paste, comm, join, fmt, fold, pr, expand, unexpand) ===</b></summary>

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

</details>

<details>
<summary><b>Octal dump (od) ===</b></summary>

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

</details>

<details>
<summary><b>Path operations (basename, dirname, pwd) ===</b></summary>

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

</details>

<details>
<summary><b>Permissions and ownership (chmod, chown, chgrp) ===</b></summary>

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

<details>
<summary><b>Redirection (tee) ===</b></summary>

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

</details>

<details>
<summary><b>Checksums (cksum, md5sum, sha1sum, sha224sum, sha384sum, sha512sum, sha256sum, b2sum, sum) ===</b></summary>

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

</details>

<details>
<summary><b>Encoding (base32, base64, basenc) ===</b></summary>

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

</details>

<details>
<summary><b>System information (uname, who, whoami, id, groups, users, hostid, nproc, tty, logname, pinky) ===</b></summary>

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

</details>

<details>
<summary><b>Boolean and condition (true, false, test, [) ===</b></summary>

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

</details>

<details>
<summary><b>Environment and time (env, printenv, date, printf) ===</b></summary>

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

</details>

<details>
<summary><b>Flow control (sleep, timeout, yes) ===</b></summary>

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

</details>

<details>
<summary><b>Process control (nice, nohup, stdbuf) ===</b></summary>

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

</details>

<details>
<summary><b>File operations (dd, truncate, shred, sync, install, chroot) ===</b></summary>

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

</details>

<details>
<summary><b>Numbers and expressions (seq, factor, shuf, numfmt, expr) ===</b></summary>

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

</details>

<details>
<summary><b>Split files (split, csplit) ===</b></summary>

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

</details>

<details>
<summary><b>Special utilities (stty, pathchk, tsort, ptx, dircolors) ===</b></summary>

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

</details>

<details>
<summary><b>Error handling ===</b></summary>

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

## dnf5-plugins

- **版本**: dnf5-plugins 5.4
- **测试点**: 13
- **被测命令**: `dnf5`

<details>
<summary><b>dnf5 version ===</b></summary>

- Check dnf5-plugins installed
- Check dnf5 available
- dnf5 version
- dnf5 help
- Plugin files
- Plugin directory
- Check plugin: $plugin
- Plugin commands in help
- dnf5 repoquery help
- dnf5 repolist

</details>

<details>
<summary><b>dnf5 help ===</b></summary>

- dnf5 list installed
- dnf5 info
- dnf5: invalid option

</details>

<details>
<summary><b>List installed plugins ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Available plugins ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Commands with plugins ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>dnf5 repoquery ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>dnf5 repolist ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>dnf5 list ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>dnf5 info ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Error handling ===</b></summary>

- 执行相关功能验证

</details>


---

## gcc

- **版本**: gcc
- **测试点**: 63
- **被测命令**: `gcc`, `g++`, `cpp`

<details>
<summary><b>Basic C compilation ===</b></summary>

- Check gcc package is installed
- Check gcc-c++ package is installed
- Check gcc command is available
- Check g++ command is available
- Check cpp command is available
- Get gcc version info
- Get g++ version info
- Compile hello.c to hello
- Run compiled hello
- Verify output is ELF binary

</details>

<details>
<summary><b>C++ compilation ===</b></summary>

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

</details>

<details>
<summary><b>Compiler optimization flags ===</b></summary>

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

</details>

<details>
<summary><b>Preprocessor ===</b></summary>

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

</details>

<details>
<summary><b>Assembly output ===</b></summary>

- Run coverage test program
- Run gcov
- Check gcov output file exists
- Test syntax error detection
- Test missing file error
- Test undefined function error
- Test type mismatch warning
- Compile with C99 standard
- Compile with __attribute__
- Run attribute test

</details>

<details>
<summary><b>Linking and libraries ===</b></summary>

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

</details>

<details>
<summary><b>Warning flags ===</b></summary>

- c++ version check
- c++ equals g++

</details>

<details>
<summary><b>Multi-file compilation ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Code coverage (gcov) ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Error handling ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Special features ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>GCC toolchain utilities ===</b></summary>

- 执行相关功能验证

</details>


---

## git

- **版本**: git 2.54.0
- **测试点**: 50
- **被测命令**: `git`, `git-shell`, `scalar`

<details>
<summary><b>Repository initialization ===</b></summary>

- Check git-core installed
- Check git available
- git version
- git init: create repo
- git status: check status
- git init: .git directory exists
- git config: set user name
- git config: set email
- git config: get user name
- git config --list

</details>

<details>
<summary><b>User configuration ===</b></summary>

- git add: stage file
- git status --short
- git commit: first commit
- git log: show commits
- git branch: create branch
- git branch: list branches
- git branch -a: all branches
- git switch: switch branch
- git switch -: previous branch
- git branch -d: delete branch

</details>

<details>
<summary><b>File operations ===</b></summary>

- git add: second file
- git commit: second commit
- git diff: show changes
- git diff --cached: staged changes
- git commit: modify
- git log: last 3 commits
- git log --graph
- git show: latest commit
- git show: previous commit
- git tag: create tag

</details>

<details>
<summary><b>Branch operations ===</b></summary>

- git tag: list tags
- git tag -d: delete tag
- git add: temp file
- git reset: unstage
- git restore --staged
- Cleanup temp
- git remote: list remotes
- git remote add
- git stash: push
- git stash list

</details>

<details>
<summary><b>File modifications ===</b></summary>

- git stash pop
- git grep: search
- git blame: annotate
- git clean -n: dry run
- git gc: garbage collect
- git-shell available
- scalar available
- scalar help
- git: invalid command
- git: invalid option

</details>

<details>
<summary><b>Log and show ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Tag operations ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Reset and restore ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Remote operations ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Stash ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>grep and blame ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Clean and gc ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>git-shell ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>scalar ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Error handling ===</b></summary>

- 执行相关功能验证

</details>


---

## grep

- **版本**: GNU grep 3.12
- **测试点**: 50
- **被测命令**: `grep`, `egrep`, `fgrep`

<details>
<summary><b>Basic pattern matching ===</b></summary>

- Check grep package is installed
- Check grep command is available
- Check egrep command is available
- Check fgrep command is available
- Get grep version info
- Basic grep for Hello
- Verify multiple matches
- Grep from pipe
- Grep across multiple files
- Case insensitive grep

</details>

<details>
<summary><b>Case insensitive (-i) ===</b></summary>

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

</details>

<details>
<summary><b>Invert match (-v) ===</b></summary>

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

</details>

<details>
<summary><b>Word and line matching (-w, -x) ===</b></summary>

- egrep equivalent to grep -E
- Fixed string with special chars
- Fixed string: no regex meta-char interpretation
- fgrep equivalent to grep -F
- Only matching: digits only
- Quiet mode: pattern found
- Quiet mode: pattern not found
- Hello World
- Hello Linux
- Hello World

</details>

<details>
<summary><b>Count and line numbers (-c, -n) ===</b></summary>

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

<details>
<summary><b>Recursive search (-r) ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Extended regex (-E) ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Fixed strings (-F) ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Only matching and quiet (-o, -q) ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Context lines (-A, -B, -C) ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>File listing (-l, -L) ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Multiple patterns (-e, -f) ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Error handling ===</b></summary>

- 执行相关功能验证

</details>


---

## gxx

- **版本**: gcc-c++
- **测试点**: 20
- **被测命令**: `g++`, `c++`

<details>
<summary><b>Basic C++ compilation ===</b></summary>

- Check gcc-c++ is installed
- Check g++ command available
- Check c++ command available
- g++ version info
- Compile hello.cpp
- Run compiled binary
- Output is ELF binary
- g++ -c: compile only
- Object file exists
- Optimization -$lvl

</details>

<details>
<summary><b>Compile-only ===</b></summary>

- Debug symbols
- -Wall warnings
- -Wextra warnings
- g++ -E: preprocess
- Link from object
- g++ -shared: shared library
- g++ -I: include path
- c++ alias works
- Compilation error
- Invalid option

</details>

<details>
<summary><b>Optimization ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Debug and warnings ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Preprocessor ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Linking ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Include paths ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>c++ alias ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Error handling ===</b></summary>

- 执行相关功能验证

</details>


---

## iputils

- **版本**: iputils 20250605
- **测试点**: 10
- **被测命令**: `ping`

<details>
<summary><b>ping basic functionality ===</b></summary>

- Test section: ping basic functionality ===
- Test section: ping advanced options ===
- Test section: ping6 (IPv6) ===
- Test section: traceroute6 ===
- Test section: tracepath ===
- Test section: arping ===
- Test section: clockdiff ===
- Test section: ping error handling ===
- Test section: ping special scenarios ===
- Test section: Network interface testing ===

</details>

<details>
<summary><b>ping advanced options ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>ping6 (IPv6) ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>traceroute6 ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>tracepath ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>arping ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>clockdiff ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>ping error handling ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>ping special scenarios ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Network interface testing ===</b></summary>

- 执行相关功能验证

</details>


---

## labwc

- **版本**: labwc 0.9.7
- **测试点**: 14
- **被测命令**: `labwc`, `labnag`, `lab-sensible-terminal`, `labwc)`

<details>
<summary><b>Help ===</b></summary>

- Check labwc installed
- Check labwc available
- Check labnag available
- Check lab-sensible-terminal available
- labwc help
- labwc: config options
- labwc: debug option
- labwc: startup/session options
- labwc: linked libraries
- labnag help

</details>

<details>
<summary><b>Configuration ===</b></summary>

- lab-sensible-terminal help
- System config dir
- Data dir
- labwc: invalid option

</details>

<details>
<summary><b>Debug mode ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Check for display (no DISPLAY) ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Library check ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>labnag ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>lab-sensible-terminal ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Config dirs ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Error handling ===</b></summary>

- 执行相关功能验证

</details>


---

## make

- **版本**: GNU Make 4.4.1
- **测试点**: 26
- **被测命令**: `make`, `gmake`

<details>
<summary><b>Basic Makefile execution ===</b></summary>

- Check make is installed
- Check make command available
- Check gmake command available
- make version
- gmake version
- Run default target
- Run specific target
- Run clean target
- make -s: silent mode
- Variable expansion

</details>

<details>
<summary><b>Variables ===</b></summary>

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

</details>

<details>
<summary><b>Options ===</b></summary>

- Environment variable in make
- make -C: change directory
- Include file
- gmake is GNU Make
- make -k: continue on error
- make -i: ignore errors

</details>

<details>
<summary><b>Parallel execution ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Environment ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Directory change ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Include ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>gmake alias ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Error handling ===</b></summary>

- 执行相关功能验证

</details>


---

## openssh

- **版本**: openssh 10.3p1
- **测试点**: 27
- **被测命令**: `ssh-keygen`

<details>
<summary><b>RSA key generation ===</b></summary>

- Check openssh is installed
- Check ssh-keygen available
- ssh-keygen help
- Generate RSA 2048 key
- Private key exists
- Public key exists
- Show RSA key fingerprint
- Generate ECDSA 256 key
- Show ECDSA fingerprint
- Generate Ed25519 key

</details>

<details>
<summary><b>ECDSA key generation ===</b></summary>

- Show Ed25519 fingerprint
- Verbose fingerprint
- Generate key with passphrase
- Remove passphrase
- Generate key with comment
- Verify comment in pubkey
- Export RFC4716 format
- Import RFC4716 format
- Extract public key from private
- Change key comment

</details>

<details>
<summary><b>Ed25519 key generation ===</b></summary>

- Hash known hosts
- SHA256 fingerprint
- MD5 fingerprint
- Generate RSA 2048 key
- Verify RSA 2048 key
- Invalid key type
- Invalid path

</details>

<details>
<summary><b>Key with passphrase ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Key with comment ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Key conversion ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Public key extraction ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Change comment ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Hash known hosts ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Fingerprint hashes ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>RSA key options ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Error handling ===</b></summary>

- 执行相关功能验证

</details>


---

## openssh-clients

- **版本**: openssh-clients 10.3p1
- **测试点**: 27
- **被测命令**: `ssh`, `scp`, `sftp`, `ssh-add`, `ssh-agent`, `ssh-copy-id`, `ssh-keyscan`

<details>
<summary><b>ssh version and help ===</b></summary>

- Check openssh-clients installed
- Check ssh available
- Check scp available
- Check sftp available
- Check ssh-add available
- Check ssh-agent available
- Check ssh-copy-id available
- Check ssh-keyscan available
- ssh version
- ssh -Q key: supported keys

</details>

<details>
<summary><b>ssh connection (dry-run) ===</b></summary>

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

</details>

<details>
<summary><b>ssh-keygen via openssh ===</b></summary>

- ssh-add -L: list public keys
- ssh-add -d: remove key
- ssh-keyscan: scan localhost
- ssh-keyscan -t rsa
- ssh-keyscan -t ecdsa
- sftp: help command
- scp version

</details>

<details>
<summary><b>ssh-agent ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>ssh-keyscan ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>sftp ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>scp ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>ssh-copy-id ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Error handling ===</b></summary>

- 执行相关功能验证

</details>


---

## pciutils

- **版本**: pciutils
- **测试点**: 13
- **被测命令**: `lspci`

<details>
<summary><b>lspci basic ===</b></summary>

- Test section: lspci basic ===
- Test section: lspci verbose ===
- Test section: lspci with filtering ===
- Test section: lspci numeric ===
- Test section: lspci tree view ===
- Test section: lspci kernel drivers ===
- Test section: lspci by device class ===
- Test section: lspci with domain ===
- Test section: update-pciids ===
- Test section: lspci format options ===

</details>

<details>
<summary><b>lspci verbose ===</b></summary>

- Test section: setpci ===
- Test section: pcilmr ===
- Test section: Error handling ===

</details>

<details>
<summary><b>lspci with filtering ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>lspci numeric ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>lspci tree view ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>lspci kernel drivers ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>lspci by device class ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>lspci with domain ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>update-pciids ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>lspci format options ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>setpci ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>pcilmr ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Error handling ===</b></summary>

- 执行相关功能验证

</details>


---

## podman

- **版本**: podman
- **测试点**: 21
- **被测命令**: `podman`, `podman-remote`

<details>
<summary><b>Image operations ===</b></summary>

- Check podman installed
- Check podman available
- Check podman-remote available
- podman version
- podman info
- podman images: list images
- podman image list
- podman ps: list containers
- podman ps -a: all containers
- podman container list

</details>

<details>
<summary><b>Container operations ===</b></summary>

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

</details>

<details>
<summary><b>Network operations ===</b></summary>

- podman: invalid command

</details>

<details>
<summary><b>Volume operations ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>System operations ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Help commands ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Error handling ===</b></summary>

- 执行相关功能验证

</details>


---

## podmansh

- **版本**: podmansh
- **测试点**: 11
- **被测命令**: `podmansh`

<details>
<summary><b>podmansh basic ===</b></summary>

- Test section: podmansh basic ===
- Test section: podmansh help ===
- Test section: podmansh config ===
- Test section: podman basic ===
- Test section: podman images ===
- Test section: podman network ===
- Test section: podman volume ===
- Test section: podman stats ===
- Test section: podman ps ===
- Test section: Error handling ===

</details>

<details>
<summary><b>podmansh help ===</b></summary>

- Test section: Cleanup ===

</details>

<details>
<summary><b>podmansh config ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>podman basic ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>podman images ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>podman network ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>podman volume ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>podman stats ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>podman ps ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Error handling ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Cleanup ===</b></summary>

- 执行相关功能验证

</details>


---

## procps-ng

- **版本**: procps-ng 4.0.5
- **测试点**: 14
- **被测命令**: `ps`

<details>
<summary><b>ps command basic functionality ===</b></summary>

- Test section: ps command basic functionality ===
- Test section: ps command advanced features ===
- Test section: free command ===
- Test section: top command ===
- Test section: vmstat command ===
- Test section: uptime and w commands ===
- Test section: kill command ===
- Test section: pidof and pgrep ===
- Test section: pwdx and pmap ===
- Test section: sysctl (if available) ===

</details>

<details>
<summary><b>ps command advanced features ===</b></summary>

- Test section: Error handling ===
- Test section: Special scenarios ===
- Test section: pkill and pidwait ===
- Test section: slabtop, tload, watch, hugetop ===

</details>

<details>
<summary><b>free command ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>top command ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>vmstat command ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>uptime and w commands ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>kill command ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>pidof and pgrep ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>pwdx and pmap ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>sysctl (if available) ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Error handling ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Special scenarios ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>pkill and pidwait ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>slabtop, tload, watch, hugetop ===</b></summary>

- 执行相关功能验证

</details>


---

## psmisc

- **版本**: psmisc
- **测试点**: 13
- **被测命令**: `fuser`

<details>
<summary><b>fuser basic ===</b></summary>

- Test section: fuser basic ===
- Test section: fuser with processes ===
- Test section: fuser mount points ===
- Test section: fuser with options ===
- Test section: pstree basic ===
- Test section: pstree with options ===
- Test section: killall basic ===
- Test section: prtstat ===
- Test section: peekfd ===
- Test section: pslog ===

</details>

<details>
<summary><b>fuser with processes ===</b></summary>

- Test section: killall with signals ===
- Test section: fuser special cases ===
- Test section: Error handling ===

</details>

<details>
<summary><b>fuser mount points ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>fuser with options ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>pstree basic ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>pstree with options ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>killall basic ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>prtstat ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>peekfd ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>pslog ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>killall with signals ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>fuser special cases ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Error handling ===</b></summary>

- 执行相关功能验证

</details>


---

## rpmbuild

- **版本**: rpm-build
- **测试点**: 9
- **被测命令**: `rpmbuild`

<details>
<summary><b>rpmbuild basic functionality ===</b></summary>

- Test section: rpmbuild basic functionality ===
- Test section: Create simple spec file ===
- Test section: Create source tarball ===
- Test section: Build RPM package ===
- Test section: Verify built RPM ===
- Test section: Install and test RPM ===
- Test section: RPM build options ===
- Test section: Error handling ===
- Test section: RPM verification ===

</details>

<details>
<summary><b>Create simple spec file ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Create source tarball ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Build RPM package ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Verify built RPM ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Install and test RPM ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>RPM build options ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Error handling ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>RPM verification ===</b></summary>

- 执行相关功能验证

</details>


---

## sddm

- **版本**: sddm 0.21.0
- **测试点**: 13
- **被测命令**: `sddm`, `sddm-greeter-qt6`

<details>
<summary><b>Version and help ===</b></summary>

- Check sddm installed
- Check sddm available
- Check sddm-greeter available
- sddm help
- sddm --test-mode help
- sddm: example config
- Config directory
- Default config dir
- sddm service unit
- sddm service status

</details>

<details>
<summary><b>Configuration ===</b></summary>

- sddm enabled status
- sddm themes installed
- sddm: key config values

</details>

<details>
<summary><b>Service check ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Theme check ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Config values ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>D-Bus ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Error handling ===</b></summary>

- 执行相关功能验证

</details>


---

## systemd

- **版本**: systemd 259
- **测试点**: 115

<details>
<summary><b>systemctl - Service and system management ===</b></summary>

- Check systemd package is installed
- systemctl version
- systemctl: list running services
- systemctl: list targets
- systemctl --all: all services
- systemctl: list unit files
- systemctl is-active: check service status
- systemctl is-enabled: check enabled
- systemctl is-failed: list failed units
- systemctl status: service status

</details>

<details>
<summary><b>journalctl - Journal query ===</b></summary>

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

</details>

<details>
<summary><b>systemd-analyze - System profiling ===</b></summary>

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

</details>

<details>
<summary><b>hostnamectl - Hostname management ===</b></summary>

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

</details>

<details>
<summary><b>localectl - Locale management ===</b></summary>

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

</details>

<details>
<summary><b>timedatectl - Time/date management ===</b></summary>

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

</details>

<details>
<summary><b>loginctl - Login management ===</b></summary>

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

</details>

<details>
<summary><b>systemd-detect-virt ===</b></summary>

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

</details>

<details>
<summary><b>systemd-cgls - Cgroup listing ===</b></summary>

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

</details>

<details>
<summary><b>systemd-cgtop - Cgroup top ===</b></summary>

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

</details>

<details>
<summary><b>systemd-tmpfiles ===</b></summary>

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

</details>

<details>
<summary><b>busctl - D-Bus introspection ===</b></summary>

- systemd-sysext help
- systemd-confext help
- systemctl: invalid command
- journalctl: invalid option
- hostnamectl: invalid option

</details>

<details>
<summary><b>systemd-run ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>systemd-cat ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>systemd-notify ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>systemd-path ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>systemd-escape ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>systemd-machine-id-setup ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>coredumpctl ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>systemd-delta ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>systemd-id128 ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>systemd-inhibit ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>systemd-ac-power ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>systemd-ask-password ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>systemd-creds ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>systemd-socket-activate ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Power management commands ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>systemd-firstboot ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>systemd-stdio-bridge ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>oomctl ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>systemctl service operations ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>run0 - Privilege escalation ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>systemd-mount ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>systemd-sysext ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>systemd-confext ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Error handling ===</b></summary>

- 执行相关功能验证

</details>


---

## systemd-timesyncd

- **版本**: systemd-timesyncd 259
- **测试点**: 14

<details>
<summary><b>Service status ===</b></summary>

- Check systemd-timesyncd is installed
- Service status
- Time sync status
- Timesync detail
- Is enabled
- Fallback NTP servers
- Current NTP server
- Server address
- NTP servers list
- Restart service

</details>

<details>
<summary><b>NTP management ===</b></summary>

- Is active
- Config file
- Cat config
- Wait sync service

</details>

<details>
<summary><b>Service control ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Configuration ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>systemd-time-wait-sync ===</b></summary>

- 执行相关功能验证

</details>


---

## tar

- **版本**: tar 1.35
- **测试点**: 10
- **被测命令**: `tar`

<details>
<summary><b>Basic archive creation ===</b></summary>

- Test section: Basic archive creation ===
- Test section: Archive extraction ===
- Test section: Compression formats ===
- Test section: Advanced tar options ===
- Test section: Archive verification ===
- Test section: Special attributes ===
- Test section: Error handling ===
- Test section: Wildcard and patterns ===
- Test section: Incremental backup ===
- Test section: Special file types ===

</details>

<details>
<summary><b>Archive extraction ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Compression formats ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Advanced tar options ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Archive verification ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Special attributes ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Error handling ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Wildcard and patterns ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Incremental backup ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Special file types ===</b></summary>

- 执行相关功能验证

</details>


---

## tmux

- **版本**: tmux 3.6a
- **测试点**: 182
- **被测命令**: `tmux`

<details>
<summary><b>Server management ===</b></summary>

- Check tmux package is installed
- Check tmux command available
- tmux version
- start-server: start tmux server
- list-sessions: initial state
- has-session: check nonexistent
- list-clients: list connected clients
- list-commands: list all commands
- list-commands: filter specific command
- list-commands: format output

</details>

<details>
<summary><b>Session creation and management ===</b></summary>

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

</details>

<details>
<summary><b>Window management ===</b></summary>

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

</details>

<details>
<summary><b>Pane management ===</b></summary>

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

</details>

<details>
<summary><b>Layout management ===</b></summary>

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

</details>

<details>
<summary><b>Buffer management ===</b></summary>

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

</details>

<details>
<summary><b>Key bindings and input ===</b></summary>

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

</details>

<details>
<summary><b>Options and settings ===</b></summary>

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

</details>

<details>
<summary><b>Environment variables ===</b></summary>

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

</details>

<details>
<summary><b>Hooks ===</b></summary>

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

</details>

<details>
<summary><b>Messages and display ===</b></summary>

- select-layout: even-vertical
- select-layout: main-horizontal
- select-layout: main-vertical
- select-layout: tiled
- next-layout: cycle layouts
- previous-layout: prev layout
- set-buffer -b: named buffer
- hello world
- set-buffer -a: append
- list-buffers: list all buffers

</details>

<details>
<summary><b>Conditional and shell execution ===</b></summary>

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

</details>

<details>
<summary><b>Source and configuration ===</b></summary>

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

</details>

<details>
<summary><b>Copy mode ===</b></summary>

- 0d
- send-prefix: send prefix key
- set-option -g: global
- set-option -a: append
- set-option: mouse on
- set-option -s: server option
- set-window-option: monitor activity
- set-window-option -g: global
- show-options -g: global options
- show-options -s: server options

</details>

<details>
<summary><b>Find window ===</b></summary>

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

</details>

<details>
<summary><b>Choose commands (interactive) ===</b></summary>

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

</details>

<details>
<summary><b>Clock mode ===</b></summary>

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

</details>

<details>
<summary><b>Lock management ===</b></summary>

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

</details>

<details>
<summary><b>Show prompt history ===</b></summary>

- Error: nonexistent session
- Error: invalid option

</details>

<details>
<summary><b>Wait-for (event channels) ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Cleanup - kill sessions ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Error handling ===</b></summary>

- 执行相关功能验证

</details>


---

## vim

- **版本**: Vim 9.2
- **测试点**: 20
- **被测命令**: `vim`, `vimdiff`

<details>
<summary><b>Basic editing ===</b></summary>

- Check vim-common installed
- Check vim available
- vim version
- vim -e: ex mode
- vim: print buffer
- vim --help
- vim -c: execute command
- vim -R: readonly mode
- vim -b: binary mode
- vim -n: no swap file

</details>

<details>
<summary><b>Batch/ex mode commands ===</b></summary>

- vimdiff available
- vimdiff: compare files
- vim: syntax enable
- vim: search and replace
- Replace verified
- vim: multiple files
- vim: insert in ex mode
- vim -T: terminal type
- vim: invalid option
- vim: nonexistent file

</details>

<details>
<summary><b>Command line options ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Vimdiff ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Syntax check ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Search and replace (ex mode) ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Multiple files ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Recording test ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Terminal options ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Error handling ===</b></summary>

- 执行相关功能验证

</details>


---

## weston

- **版本**: weston 14.0.2
- **测试点**: 15
- **被测命令**: `weston`, `weston-debug`, `weston-screenshooter`, `weston-terminal`, `wcap-decode`

<details>
<summary><b>Version ===</b></summary>

- Check weston installed
- Check weston available
- Check weston-debug available
- Check weston-screenshooter available
- Check weston-terminal available
- Check wcap-decode available
- weston version
- weston help
- weston-terminal help
- weston-debug help

</details>

<details>
<summary><b>Help ===</b></summary>

- weston-screenshooter help
- wcap-decode help
- Available backends
- weston: headless backend
- weston: invalid option

</details>

<details>
<summary><b>Weston terminal (headless) ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Weston debug ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Screenshooter ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>wcap-decode ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Backend check ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Headless backend test ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Error handling ===</b></summary>

- 执行相关功能验证

</details>


---

## wget

- **版本**: wget (provided by wget2)
- **测试点**: 15
- **被测命令**: `wget`

<details>
<summary><b>Basic download ===</b></summary>

- Test section: Basic download ===
- Test section: Output options ===
- Test section: Verbose and quiet modes ===
- Test section: Spider mode ===
- Test section: Header options ===
- Test section: User agent ===
- Test section: Timeout and retries ===
- Test section: Recursive download ===
- Test section: Continue and mirror ===
- Test section: Rate limiting ===

</details>

<details>
<summary><b>Output options ===</b></summary>

- Test section: Progress indicators ===
- Test section: Error handling ===
- Test section: Directory listing ===
- Test section: Timestamps ===
- Test section: Special features ===

</details>

<details>
<summary><b>Verbose and quiet modes ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Spider mode ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Header options ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>User agent ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Timeout and retries ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Recursive download ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Continue and mirror ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Rate limiting ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Progress indicators ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Error handling ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Directory listing ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Timestamps ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Special features ===</b></summary>

- 执行相关功能验证

</details>


---

## wget2

- **版本**: wget2
- **测试点**: 15
- **被测命令**: `wget2`

<details>
<summary><b>Basic download ===</b></summary>

- Test section: Basic download ===
- Test section: Output file options ===
- Test section: Verbose modes ===
- Test section: Spider mode ===
- Test section: Headers ===
- Test section: User agent ===
- Test section: Timeouts and retries ===
- Test section: Continue download ===
- Test section: Rate limiting ===
- Test section: HTTP/2 support ===

</details>

<details>
<summary><b>Output file options ===</b></summary>

- Test section: TLS options ===
- Test section: Error handling ===
- Test section: Follow redirects ===
- Test section: Content disposition ===
- Test section: Plugin system ===

</details>

<details>
<summary><b>Verbose modes ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Spider mode ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Headers ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>User agent ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Timeouts and retries ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Continue download ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Rate limiting ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>HTTP/2 support ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>TLS options ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Error handling ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Follow redirects ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Content disposition ===</b></summary>

- 执行相关功能验证

</details>

<details>
<summary><b>Plugin system ===</b></summary>

- 执行相关功能验证

</details>

