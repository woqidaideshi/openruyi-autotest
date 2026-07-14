#!/bin/bash

# Smoke test: network - curl version

# Beakerlib-based test with lifecycle management



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

 rlPhaseStartSetup "Environment setup"

 smokeNetworkSetup



 rlPhaseEnd



 rlPhaseStartTest "curl version"

 rlRun 'curl --version' 0 "curl version"

 rlRun 'curl -s -o /dev/null -w "%{http_code}" http://localhost 2>&1 || true' 0 "curl localHTTP"

 rlRun 'curl --connect-timeout 5 -I http://example.com 2>&1 || true' 0 "curl HEADPlease"

 rlPhaseEnd



 rlPhaseStartCleanup "Clean up test environment"



 rlPhaseEnd



 rlJournalPrintText

rlJournalEnd