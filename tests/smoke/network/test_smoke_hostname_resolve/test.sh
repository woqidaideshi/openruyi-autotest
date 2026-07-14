#!/bin/bash
# Smoke test: network - getent resolve localhost
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
    smokeNetworkSetup

    rlPhaseEnd

    rlPhaseStartTest "getent resolve localhost"
    rlRun 'getent hosts localhost' 0 "getent resolve localhost"
    rlRun 'cat /etc/resolv.conf' 0 "/etc/resolv.conf DNSconfiguration"
    rlRun 'cat /etc/hosts' 0 "/etc/hosts localresolve"
    rlPhaseEnd

    rlPhaseStartCleanup "Clean up test environment"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd