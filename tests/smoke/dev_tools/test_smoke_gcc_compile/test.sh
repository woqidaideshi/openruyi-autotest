#!/bin/bash
# Smoke test: dev_tools - gcc 可用
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeDevToolsSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
        cat > hello.c << 'EOF'
        #include <stdio.h>
        int main() { printf("smoke test"); return 0; }
        EOF

    rlPhaseEnd

    rlPhaseStartTest "gcc 可用"
        rlRun 'which gcc' 0 "gcc 可用"
        rlRun 'gcc hello.c -o hello' 0 "gcc 编译"
        rlRun './hello' 0 "编译结果可执行"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd