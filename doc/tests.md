# Tests

Here is the canonical list of tests we will run to compare Versa and FRR failover:

* [test_all.yaml](../failover/tests/test_all.yaml): 5 minute test that completely fails Starlink-1, Starlink-2, and BYU internet at 1 minute intervals before restoring all of them.
* [test_drop_15.yaml](../failover/tests/test_drop_15.yaml): 4 minute test that degrades Starlink-1 to 15% packet drop, then restores it two minutes later.
* [test_delay_150.yaml](../failover/tests/test_delay_150.yaml): 4 minute test that degrades Starlink-1 to >150 ms latency at minute 1, then restores it two minutes later.
* [test_jitter_80.yaml](../failover/tests/test_jitter_80.yaml): 4 minutes test that degrades Starlink-1 to 80 ms jitter at minute 1, then restores it two minutes later.

Each test will be run in triplicate.