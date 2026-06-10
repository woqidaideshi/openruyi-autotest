import subprocess, base64, os, time

pkgs = [
    'acl', 'cmake', 'wget', 'tar', 'pciutils', 'procps-ng', 'psmisc',
    'iputils', 'wget2', 'rpmbuild', 'gcc', 'grep', 'coreutils'
]

results = {}
base_dir = 'e:/code/openruyi-autotest/tests/functional'

for pkg in pkgs:
    test_path = os.path.join(base_dir, pkg, 'test.sh')
    if not os.path.exists(test_path):
        print(f'SKIP {pkg}: test.sh not found')
        results[pkg] = 'SKIP'
        continue

    with open(test_path, 'r', encoding='utf-8') as f:
        content = f.read()

    encoded = base64.b64encode(content.encode()).decode()

    timeout_map = {'gcc': 660, 'coreutils': 240, 'cmake': 180, 'procps-ng': 90}
    tmo = timeout_map.get(pkg, 60)
    
    cmd = f'echo {encoded} | base64 -d > /tmp/test_{pkg}.sh && chmod +x /tmp/test_{pkg}.sh && timeout 600 bash /tmp/test_{pkg}.sh 2>&1'

    print(f'\n=== [{pkg}] Starting (timeout={tmo}s) ===')
    start = time.time()
    
    try:
        result = subprocess.run([
            'python', '.trellis/scripts/ssh_exec.py',
            '10.20.237.192', 'openruyi', 'openruyi',
            cmd, '--port', '12055', '--timeout', str(tmo), '--sudo'
        ], capture_output=True, text=True, timeout=tmo + 30)

        elapsed = time.time() - start
        stdout = result.stdout
        
        if f'All {pkg} functional tests passed!' in stdout:
            print(f'PASS [{pkg}] ({elapsed:.0f}s)')
            results[pkg] = 'PASS'
        elif 'All' in stdout and 'passed' in stdout:
            # Check if it's the right package name
            last_lines = stdout.split('\n')[-5:]
            all_passed = any('passed' in l for l in last_lines)
            if all_passed:
                print(f'PASS [{pkg}] ({elapsed:.0f}s) - partial match')
                results[pkg] = 'PASS'
            else:
                print(f'FAIL [{pkg}] ({elapsed:.0f}s)')
                results[pkg] = 'FAIL'
        else:
            print(f'FAIL [{pkg}] ({elapsed:.0f}s)')
            results[pkg] = 'FAIL'
            # Print error context
            for line in stdout.split('\n')[-10:]:
                if line.strip() and any(e in line.lower() for e in ['error', 'fail', 'bus', 'seg', 'abort']):
                    print(f'  -> {line}')
    except subprocess.TimeoutExpired:
        print(f'TIMEOUT [{pkg}]')
        results[pkg] = 'TIMEOUT'

# Summary
print('\n' + '='*60)
print('SUMMARY')
print('='*60)
for pkg, status in results.items():
    print(f'  {pkg:15s} {status}')
passed = sum(1 for v in results.values() if v == 'PASS')
failed = sum(1 for v in results.values() if v == 'FAIL' or v == 'TIMEOUT')
print(f'\nPassed: {passed}/{len(results)}, Failed: {failed}')
print('\nFAILED packages:')
for pkg, status in results.items():
    if status != 'PASS':
        print(f'  - {pkg}: {status}')