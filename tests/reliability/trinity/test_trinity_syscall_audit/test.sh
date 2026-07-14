#!/bin/bash

# Reliability: trinity - syscall: listexport, typeavailable syscall

. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

    rlPhaseStartSetup "Environment setup"

    trinitySetup

    TmpDir=$(mktemp -d)

    rlRun "cd $TmpDir" 0 "Enter temporary directory"

    trinity -L 2>&1 | tail -n +2 > /tmp/trinity_syscalls.txt

    rlLogInfo "total syscall count: $(wc -l < /tmp/trinity_syscalls.txt)"

    rlPhaseEnd



    rlPhaseStartTest "security syscall type"

    # security syscall: onlyreadnowith

    local safe_pattern="getpid|getuid|getgid|geteuid|getegid|getppid|gettimeofday|time|clock_gettime|getcpu|uname|sysinfo|getrandom|read|write|close|brk|arch_prctl"

    local safe_count

    safe_count=$(grep -ciE "$safe_pattern" /tmp/trinity_syscalls.txt || echo 0)

    rlLogInfo "security syscall count: $safe_count"



    # syscall: possiblesystem

    local dangerous_pattern="reboot|shutdown|kill|init_module|delete_module|mount|umount|mkmod|swapon|swapoff|ioperm|iopl"

    local dangerous_count

    dangerous_count=$(grep -ciE "$dangerous_pattern" /tmp/trinity_syscalls.txt || echo 0)

    rlLogInfo " syscall count: $dangerous_count"



    # network syscall

    local net_count

    net_count=$(grep -ciE "socket|bind|connect|listen|accept|send|recv" /tmp/trinity_syscalls.txt || echo 0)

    rlLogInfo "network syscall count: $net_count"



    # file syscall

    local file_count

    file_count=$(grep -ciE "open|creat|read|write|close|stat|fstat|lseek|mkdir|rmdir|unlink|rename|link|symlink|chmod|chown" /tmp/trinity_syscalls.txt || echo 0)

    rlLogInfo "file syscall count: $file_count"



    # process syscall

    local proc_count

    proc_count=$(grep -ciE "fork|vfork|clone|execve|exit|wait4|kill|ptrace|capget|capset|prctl|seccomp" /tmp/trinity_syscalls.txt || echo 0)

    rlLogInfo "process syscall count: $proc_count"



    # memory syscall

    local mem_count

    mem_count=$(grep -ciE "mmap|munmap|mprotect|mremap|brk|mlock|mlockall|msync|madvise|mincore" /tmp/trinity_syscalls.txt || echo 0)

    rlLogInfo "memory syscall count: $mem_count"



    rlPass "Syscall Complete (total $(wc -l < /tmp/trinity_syscalls.txt), security $safe_count)"

    rlPhaseEnd



    rlPhaseStartTest " syscall"

    local arch

    arch=$(uname -m)

    rlLogInfo "current: $arch"

    # listexporthas syscall

    if [ "$arch" = "riscv64" ]; then

    trinity -L 2>&1 | grep -i "riscv" | head -10

    local riscv_count

    riscv_count=$(trinity -L 2>&1 | grep -ci "riscv" || echo 0)

    rlLogInfo "RISC-V has syscall: $riscv_count"

    fi

    rlPass "Complete: $arch"

    rlPhaseEnd



    rlPhaseStartCleanup "Cleanup"

    rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""

    rm -f /tmp/trinity_syscalls.txt

    rlPhaseEnd

    rlJournalPrintText

rlJournalEnd

