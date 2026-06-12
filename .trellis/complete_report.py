"""Run remaining untested cases and regenerate complete CSV."""
import paramiko, os, time, csv

SERVER = '10.20.237.192'; PORT = 12055; USER = 'openruyi'; PASS = 'openruyi'
BASE = 'e:/code/openruyi-autotest/tests/functional'

# Get all cases from local
all_cases = []
for pkg in sorted(os.listdir(BASE)):
    pkg_path = os.path.join(BASE, pkg)
    if not os.path.isdir(pkg_path): continue
    for case in sorted(os.listdir(pkg_path)):
        if not os.path.isdir(os.path.join(pkg_path, case)) or not case.startswith('test_'): continue
        all_cases.append((pkg, case))

print(f'All cases: {len(all_cases)}')

ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(SERVER, port=PORT, username=USER, password=PASS, timeout=15)

# Find which have logs
tested = set()
stdin, stdout, stderr = ssh.exec_command('ls /home/openruyi/test_cases/*.log 2>/dev/null | sed "s|.*/||; s|.log||"')
for c in stdout.read().decode().strip().split('\n'):
    if c: tested.add(c)

# Run remaining ones
remaining = [(p,c) for p,c in all_cases if c not in tested]
print(f'Already tested: {len(tested)}, Remaining: {len(remaining)}')

if remaining:
    print('Running remaining...')
    for i in range(0, len(remaining), 20):
        batch = remaining[i:i+20]
        n = i//20 + 1
        for _, case in batch:
            ssh.exec_command(f'nohup timeout 60 bash /home/openruyi/test_cases/{case}.sh > /home/openruyi/test_cases/{case}.log 2>&1 &')
        time.sleep(30)

# Collect all results
print('Collecting results...')
results = []
for pkg, case in all_cases:
    stdin, stdout, stderr = ssh.exec_command(f'grep -c "tests passed" /home/openruyi/test_cases/{case}.log 2>/dev/null || echo 0')
    count = stdout.read().decode().strip().split('\n')[0]
    passed = count == '1'
    results.append((pkg, case, 'PASS' if passed else 'FAIL'))

ssh.close()

# Write CSV
with open('docs/test_report.csv', 'w', newline='', encoding='utf-8-sig') as f:
    writer = csv.writer(f)
    writer.writerow(['测试套', '测试用例', '测试结果'])
    for row in results:
        writer.writerow(row)

total_pass = sum(1 for r in results if r[2] == 'PASS')
print(f'Total: {total_pass}/{len(results)} passed')
