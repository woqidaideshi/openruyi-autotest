# UnixBench 性能测试结果

> 测试服务器: 10.20.237.192:12055
> 测试时间: 2026-06-22

## 测试用例执行结果

| 测试用例 | 退出码 | 综合评分 |
|----------|--------|----------|
| test_unixbench_single_thread | 0 | System Benchmarks Index Score 25.8 |
| test_unixbench_multi_thread | 0 | System Benchmarks Index Score 85.7 |
| test_unixbench_integer_only | 0 | System Benchmarks Index Score (Partial Only)                           61.1 |
| test_unixbench_io_only | 0 | System Benchmarks Index Score (Partial Only)                           55.0 |
| test_unixbench_process_only | 0 | System Benchmarks Index Score (Partial Only)                            9.4 |
| test_unixbench_quick_mode | 0 | System Benchmarks Index Score (Partial Only)                           20.2 |
| test_unixbench_half_cpu | 0 | System Benchmarks Index Score                                          85.8 |

## 结论
- 单线程综合评分: **25.8**
- 多线程综合评分: **85.7**（并行加速比 ~3.3x）
- 服务器已成功执行 UnixBench 基准测试
