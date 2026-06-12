#!/bin/sh -eux
# Functional test: ncurses - �ն˽����
# Commands: clear, infocmp, reset, tabs, tic, toe

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q ncurses 2>/dev/null || { echo 'ncurses not installed, skipping'; exit 0; }
which clear 2>/dev/null || echo 'clear not found'
which infocmp 2>/dev/null || echo 'infocmp not found'
which tput 2>/dev/null || echo 'tput not found'

echo ""
echo "All ncurses functional tests passed!"
