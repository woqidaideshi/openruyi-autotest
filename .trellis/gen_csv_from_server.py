"""Generate CSV from server test results."""
import paramiko, csv

SERVER = '10.20.237.192'; PORT = 12055; USER = 'openruyi'; PASS = 'openruyi'

ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(SERVER, port=PORT, username=USER, password=PASS, timeout=15)

# Get list of test case log files
stdin, stdout, stderr = ssh.exec_command('ls /home/openruyi/test_cases/*.log 2>/dev/null | sed "s|.*/||; s|\.log||"')
cases = stdout.read().decode().strip().split('\n')
cases = [c for c in cases if c]

results = []
for case in sorted(cases):
    stdin, stdout, stderr = ssh.exec_command(f'grep -c "tests passed" /home/openruyi/test_cases/{case}.log 2>/dev/null || echo 0')
    count = stdout.read().decode().strip().split('\n')[0]
    passed = count.strip() == '1'
    
    # Extract package name from case: test_{pkg}_{desc}
    parts = case.split('_', 2)
    pkg = parts[1] if len(parts) > 1 else 'unknown'
    
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
print(f'CSV: docs/test_report.csv ({len(results)} rows)')
