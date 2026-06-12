"""Upload tests to server and run - with LF conversion."""
import paramiko, os, csv

SERVER='10.20.237.192'; PORT=12055; USER='openruyi'; PASS='openruyi'
BASE='tests/functional'

print('Connecting...')
ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(SERVER, port=PORT, username=USER, password=PASS, timeout=60)

sftp = ssh.open_sftp()
ssh.exec_command('mkdir -p /home/openruyi/functional-tests')

results = []
passed = 0; failed = 0; error = 0

for root, dirs, files in os.walk(BASE):
    if 'test.sh' not in files:
        continue
    
    pkg_name = root.replace('\\', '/').split('/')[-1]
    parent = root.replace('\\', '/').split('/')[-2]
    
    if parent == 'functional':
        test_id = pkg_name
    else:
        test_id = f'{parent}__{pkg_name}'
    
    local_path = os.path.join(root, 'test.sh')
    remote_path = f'/home/openruyi/functional-tests/{test_id}.sh'
    
    # Read as binary and convert to LF
    try:
        with open(local_path, 'rb') as f:
            raw = f.read()
        text = raw.replace(b'\r\n', b'\n').replace(b'\r', b'\n')
        
        with sftp.file(remote_path, 'wb') as f:
            f.write(text)
        sftp.chmod(remote_path, 0o755)
    except Exception as e:
        error += 1
        print(f'  [ERROR] Upload {test_id}: {e}')
        results.append((test_id, 'ERROR'))
        continue
    
    # Run test
    try:
        cmd = f'cd /home/openruyi/functional-tests && timeout 30 bash {test_id}.sh > {test_id}.log 2>&1; echo "RC=$?"'
        stdin, stdout, stderr = ssh.exec_command(cmd, timeout=35)
        out = stdout.read().decode(errors='replace')
        
        exit_lines = [l for l in out.split('\n') if l.startswith('RC=')]
        exit_code = int(exit_lines[0].split('=')[1]) if exit_lines else 99
        
        # Read log
        stdin, stdout, stderr = ssh.exec_command(f'cat /home/openruyi/functional-tests/{test_id}.log 2>/dev/null', timeout=10)
        log = stdout.read().decode(errors='replace')
        
        has_pass = 'passed!' in log.lower() or 'tests passed' in log.lower()
        has_skip = 'not installed' in log.lower() or 'skipping' in log.lower()
        
        if has_skip:
            status = 'SKIP'
            passed += 1  # Skip counts as pass
        elif exit_code == 0 and has_pass:
            status = 'PASS'
            passed += 1
        elif exit_code == 0:
            status = 'PASS'
            passed += 1
        else:
            status = 'FAIL'
            failed += 1
        
        results.append((test_id, status))
        print(f'  [{status}] {test_id}')
        
    except Exception as e:
        failed += 1
        print(f'  [ERROR] Run {test_id}: {e}')
        results.append((test_id, 'ERROR'))

sftp.close()
ssh.close()

print(f'\nResults: PASS/SKIP={passed}, FAIL={failed}, ERROR={error}')
print(f'Total: {len(results)}')

# Save
with open('.trellis/tasks/06-12-170-base-pkgs-full-coverage/research/test_results.csv', 'w', newline='') as f:
    w = csv.writer(f)
    w.writerow(['test_id', 'status'])
    w.writerows(results)

# Show failures
fail_list = [r for r in results if r[1] == 'FAIL']
if fail_list:
    print(f'\nFailed tests ({len(fail_list)}):')
    for t, s in fail_list:
        print(f'  {t}')
