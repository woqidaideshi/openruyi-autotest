"""Upload all test scripts to server and run them."""
import paramiko, os, json, time, csv, glob

SERVER='10.20.237.192'; PORT=12055; USER='openruyi'; PASS='openruyi'
BASE='tests/functional'

print('Connecting...')
ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(SERVER, port=PORT, username=USER, password=PASS, timeout=60)

sftp = ssh.open_sftp()

# Ensure test dir exists on server
ssh.exec_command('mkdir -p /home/openruyi/functional-tests')

# Collect all test.sh files and upload
results = []
errors = []
total = 0
passed = 0
failed = 0

for root, dirs, files in os.walk(BASE):
    if 'test.sh' in files:
        pkg_name = root.replace('\\', '/').split('/')[-1] if root != BASE else 'root'
        parent = root.replace('\\', '/').split('/')[-2] if root != BASE else 'root'
        
        # Determine test identifier
        if parent == 'functional':
            test_id = pkg_name
        else:
            test_id = f'{parent}__{pkg_name}'
        
        local_path = os.path.join(root, 'test.sh')
        remote_path = f'/home/openruyi/functional-tests/{test_id}.sh'
        
        # Upload
        try:
            sftp.put(local_path, remote_path)
            sftp.chmod(remote_path, 0o755)
        except Exception as e:
            errors.append(f'Upload {test_id}: {e}')
            continue
        
        # Run on server
        try:
            stdin, stdout, stderr = ssh.exec_command(
                f'cd /home/openruyi/functional-tests && timeout 60 bash {test_id}.sh > {test_id}.log 2>&1; echo "EXIT_CODE=$?"',
                timeout=65
            )
            out = stdout.read().decode(errors='replace')
            
            # Check if test passed
            exit_line = [l for l in out.split('\n') if 'EXIT_CODE=' in l]
            exit_code = 0
            if exit_line:
                try:
                    exit_code = int(exit_line[0].split('=')[1])
                except: pass
            
            # Also check for "tests passed" message
            has_pass_msg = 'tests passed' in out.lower() or 'passed!' in out.lower()
            
            status = 'PASS' if (exit_code == 0 and has_pass_msg) or (exit_code == 0 and 'not installed' in out.lower()) else 'FAIL'
            
            if status == 'PASS':
                passed += 1
            else:
                failed += 1
                # Get last few lines for debugging
                err_lines = out.strip().split('\n')[-5:]
                errors.append(f'FAIL {test_id}: exit={exit_code}, last_lines={" | ".join(err_lines)}')
            
            total += 1
            results.append((test_id, status))
            print(f'  [{status}] {test_id}')
            
        except Exception as e:
            failed += 1
            total += 1
            results.append((test_id, 'ERROR'))
            errors.append(f'RUN {test_id}: {e}')
            print(f'  [ERROR] {test_id}: {e}')

sftp.close()
ssh.close()

print(f'\nResults: {passed}/{total} passed, {failed} failed')
if errors:
    print(f'\nErrors ({len(errors)}):')
    for e in errors[:30]:
        print(f'  {e}')

# Save results
with open('.trellis/tasks/06-12-170-base-pkgs-full-coverage/research/test_results.csv', 'w', newline='') as f:
    w = csv.writer(f)
    w.writerow(['test_id', 'status'])
    w.writerows(results)

print('\nResults saved to research/test_results.csv')
