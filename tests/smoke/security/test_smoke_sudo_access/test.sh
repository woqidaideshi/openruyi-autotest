#!/bin/bash
# Smoke test: security - /etc/sudoers exists
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeSecuritySetup

 rlPhaseEnd

 rlPhaseStartTest "/etc/sudoers exists"
 rlRun 'test -f /etc/sudoers' 0 "/etc/sudoers exists"
 rlRun'sudo -l 2>&1 || true' 0 "sudo -l listexportpermission"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd