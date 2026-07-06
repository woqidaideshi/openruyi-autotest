#!/bin/bash
# Reliability: trinity - syscall 审计: 列出、分类可用 syscall
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        trinitySetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时目录"
        trinity -L 2>&1 | tail -n +2 > /tmp/trinity_syscalls.txt
        rlLogInfo "总 syscall 数: $(wc -l < /tmp/trinity_syscalls.txt)"
    rlPhaseEnd

    rlPhaseStartTest "安全 syscall 分类"
        # 安全 syscall: 只读无副作用
        local safe_pattern="getpid|getuid|getgid|geteuid|getegid|getppid|gettimeofday|time|clock_gettime|getcpu|uname|sysinfo|getrandom|read|write|close|brk|arch_prctl"
        local safe_count
        safe_count=$(grep -ciE "$safe_pattern" /tmp/trinity_syscalls.txt || echo 0)
        rlLogInfo "安全 syscall 数量: $safe_count"

        # 危险 syscall: 可能影响系统
        local dangerous_pattern="reboot|shutdown|kill|init_module|delete_module|mount|umount|mkmod|swapon|swapoff|ioperm|iopl"
        local dangerous_count
        dangerous_count=$(grep -ciE "$dangerous_pattern" /tmp/trinity_syscalls.txt || echo 0)
        rlLogInfo "危险 syscall 数量: $dangerous_count"

        # 网络 syscall
        local net_count
        net_count=$(grep -ciE "socket|bind|connect|listen|accept|send|recv" /tmp/trinity_syscalls.txt || echo 0)
        rlLogInfo "网络 syscall 数量: $net_count"

        # 文件 syscall
        local file_count
        file_count=$(grep -ciE "open|creat|read|write|close|stat|fstat|lseek|mkdir|rmdir|unlink|rename|link|symlink|chmod|chown" /tmp/trinity_syscalls.txt || echo 0)
        rlLogInfo "文件 syscall 数量: $file_count"

        # 进程 syscall
        local proc_count
        proc_count=$(grep -ciE "fork|vfork|clone|execve|exit|wait4|kill|ptrace|capget|capset|prctl|seccomp" /tmp/trinity_syscalls.txt || echo 0)
        rlLogInfo "进程 syscall 数量: $proc_count"

        # 内存 syscall
        local mem_count
        mem_count=$(grep -ciE "mmap|munmap|mprotect|mremap|brk|mlock|mlockall|msync|madvise|mincore" /tmp/trinity_syscalls.txt || echo 0)
        rlLogInfo "内存 syscall 数量: $mem_count"

        rlPass "Syscall 审计完成 (总 $(wc -l < /tmp/trinity_syscalls.txt), 安全 $safe_count)"
    rlPhaseEnd

    rlPhaseStartTest "架构相关 syscall"
        local arch
        arch=$(uname -m)
        rlLogInfo "当前架构: $arch"
        # 列出架构特有 syscall
        if [ "$arch" = "riscv64" ]; then
            trinity -L 2>&1 | grep -i "riscv" | head -10
            local riscv_count
            riscv_count=$(trinity -L 2>&1 | grep -ci "riscv" || echo 0)
            rlLogInfo "RISC-V 特有 syscall: $riscv_count"
        fi
        rlPass "架构审计完成: $arch"
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
        rm -f /tmp/trinity_syscalls.txt
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
