#!/bin/bash
# Smoke test: security - chmod 设置权限
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeSecuritySetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
        rlRun "echo "data" > f.txt" 0 "创建测试数据"
        rlRun "chmod +x f.txt" 0 "创建测试数据"

    rlPhaseEnd

    rlPhaseStartTest "chmod 设置权限"
        rlRun 'chmod 644 f.txt' 0 "chmod 设置权限"
        rlRun 'test -r f.txt' 0 "文件可读"
        rlRun 'test -w f.txt' 0 "文件可写"
        rlRun 'test -x f.txt' 0 "文件可执行"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd