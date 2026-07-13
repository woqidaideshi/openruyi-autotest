#!/bin/bash
# Smoke test: shell_basics - test -f file exists
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeShellBasicsSetup

 rlPhaseEnd

 rlPhaseStartTest "test -f file exists"
 rlRun 'test -f /etc/os-release' 0 "test -f file exists"
 rlRun '[ -d /tmp ]' 0 "[ -d ] directory exists"
 rlRun 'test "a" = "a"' 0 "test "
 rlRun 'test 1 -lt 2' 0 "test countvaluecompare"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd