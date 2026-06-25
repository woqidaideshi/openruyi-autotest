#!/bin/bash
# Smoke test: text_processing - grep 基本搜索
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeTextProcessingSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
        cat > fruits.txt << EOF
        apple
        banana
        Apple pie
        orange
        EOF

    rlPhaseEnd

    rlPhaseStartTest "grep 基本搜索"
        rlRun 'grep apple fruits.txt' 0 "grep 基本搜索"
        rlRun 'grep -i apple fruits.txt' 0 "grep -i 忽略大小写"
        rlRun 'grep -c a fruits.txt' 0 "grep -c 计数"
        rlRun 'grep -v banana fruits.txt' 0 "grep -v 反向匹配"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd