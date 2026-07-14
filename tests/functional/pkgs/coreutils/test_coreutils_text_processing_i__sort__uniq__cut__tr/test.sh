#!/bin/bash
# Functional test: coreutils - Text-processing-I--sort--uniq--cut--tr
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
    coreutilsSetup
    TmpDir=$(mktemp -d)
    rlRun "cd $TmpDir" 0 "Enter temporary test directory"
    rlPhaseEnd

    rlPhaseStartTest "Text-processing-I--sort--uniq--cut--tr"
    rlRun "sort fruits.txt" 0 "sort alphabetically"
    rlRun "test \"$(sort fruits.txt | head -1)\" = \"apple\"" 0 "sort: first is apple"
    rlRun "sort -r fruits.txt" 0 "sort -r reverse"
    rlRun "sort -u fruits.txt" 0 "sort -u unique"
    rlRun "sort -n fruits.txt 2>&1 | grep -qiE \"error|Error|not found|No such|Unable to\" || echo expected-error" 1 "sort -n numeric"
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


    rlPhaseStartCleanup "Clean up test environment"
    rlRun "cd /" 0 "Leave test directory"
    if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
    rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
    fi
    # coreutils Package managed by lib.sh 's reference counting auto-uninstall
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
