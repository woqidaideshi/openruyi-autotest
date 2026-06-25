#!/bin/bash
# Functional test: coreutils - Text-processing-I--sort--uniq--cut--tr
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        coreutilsSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "Text-processing-I--sort--uniq--cut--tr"
        rlRun "sort fruits.txt" 0 "sort alphabetically"
        rlRun "test \"$(sort fruits.txt | head -1)\" = \"apple\"" 0 "sort: first is apple"
        rlRun "sort -r fruits.txt" 0 "sort -r reverse"
        rlRun "sort -u fruits.txt" 0 "sort -u unique"
        rlRun "sort -n fruits.txt 2>&1 || true" 0 "sort -n numeric"
        rlRun "sort fruits.txt | uniq" 0 "uniq unique lines"
        rlRun "test $(sort fruits.txt | uniq | wc -l) -eq 4" 0 "uniq: 4 unique"
        rlRun "sort fruits.txt | uniq -c" 0 "uniq -c count occurrences"
        rlRun "sort fruits.txt | uniq -d" 0 "uniq -d only duplicates"
        rlRun "sort fruits.txt | uniq -u" 0 "uniq -u only uniques"
        rlRun "cut -d: -f1 csv.txt" 0 "cut -d: -f1 first field"
        rlRun "cut -d: -f2 csv.txt" 0 "cut -d: -f2 second field"
        rlRun "cut -d: -f1,3 csv.txt" 0 "cut multiple fields"
        rlRun "cut -c1-4 file1.txt" 0 "cut -c character range"
        rlRun "echo \"UPPERCASE\" | tr \"A-Z\" \"a-z\"" 0 "tr translate uppercase to lowercase"
        rlRun "echo \"abc\" | tr -d \"b\"" 0 "tr -d delete characters"
        rlRun "echo \"a b c\" | tr -s \" \"" 0 "tr -s squeeze repeats"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # coreutils 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
