#!/bin/bash
# Functional test: ltp - syscalls - setuid04
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        ltpSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "LTP syscalls - setuid04"
        rlRun "kirk -f syscalls -p setuid04 2>&1 | tee /tmp/ltp_out_$$; exit ${PIPESTATUS[0]}" 0 "执行 LTP setuid04"
        rlRun "grep -qE 'Failed:[[:space:]]*0' /tmp/ltp_out_$$ && grep -qE 'Broken:[[:space:]]*0' /tmp/ltp_out_$$" 0 "验证用例结果（无失败/无损坏）"
        rlRun "rm -f /tmp/ltp_out_$$" 0 "清理临时文件"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "清理"
        # LTP 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
