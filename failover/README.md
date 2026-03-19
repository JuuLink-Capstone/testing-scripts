```
Author: Calin Schurig on 12 Feb 2026
```

# Failover Testing

These scripts are created with the goal of automating failover testing. Listed below are the different components of this test, and how different files in this repository relate to each test component.

* Wanulator
* PVE host (hosts wanulators)
* Versa routers
* Traffic generators

## Running tests

### Prerequisites:

Make sure you are running this on Linux, preferably Ubuntu. Windows Subsystem for Linux works just fine. To connect to the devices we use the test, you will also need to have tailscale set up according to [ART_002_Remote_Connection_to_starlinkone.docx](https://byu.app.box.com/file/2116730912991?s=jrpwljrhmy1i1xrsi884ymo650pmgcci)

Before running any tests, you should run the following command:

```bash
bash setup.sh juulink-edge-1 pve
```

This copies over ssh keys to juulink-edge-1 and pve so that you don't have to enter in your password a million times. Additionally, it ensures that any packages required by the tests are installed. If you do not know what ssh keys are or you do not have them generated, see the following [link](https://www.ssh.com/academy/ssh/keygen).

Additionally, [runner.py](runner.py) runs locally, and requires the pyYAML package to be installed. To install it on Ubuntu, run the following commands:

```bash
apt update
apt install python3-yaml
```

### Running a test

To run a test, run the following command:

```bash
python3 runner.py <path_to_test_yaml>
```

Most tests are contained in yaml files and are located in the [tests](tests) directory. For example, if you are in the [failover](.) directory, you can run:

```bash
python3 runner.py tests/test_all.yaml
```

To schedule a test for a time, a second argument can be passed to runner.py. For example, to schedule a test 10 minutes from now, run:

```bash
python3 runner.py tests/test_all.yaml "now + 10 min"
```

## Implementation Details

To start a single test, three things need to happen:

* Packet capture must be enabled (on the PVE host).
* Traffic generation must be enabled (on the traffic generator).
* Link degredation must be initiated (on the wanulators).

Each tests usually follows the same procedure:
1. Set each link to good (non-degraded).
2. Begin capturing packets.
3. Start traffic generation using Locust.
4. Degrade the desired link.
5. Wait a desired amount of time.
6. Restore the link.
7. Stop traffic generation.
8. Stop packet capture.

This procedure should allow us to collect all the information we need to analyze different failover patterns and behaviors of both the Versa SD-WAN system, as well as a more traditional routing system using FRR.

Ethan proposed a more decentralized test, where messages are sent to schedule different types of tests, and then everything just starts the test at the same time. This is what we are using. Overall, our testing setup requires the following: 

* A file that defines different hosts and how to access them ([ssh_config](./ssh_config))
* A way of representing commands on hosts at specified relative times ([basic_test.yaml](tests/basic_test.yaml))
* A way of scheduling commands at specific times ([at](https://man7.org/linux/man-pages/man1/at.1p.html))
* A script to tie it all together ([runner.py](./runner.py))

Most of the logic for our testing setup is contained in `runner.py`. It is responsible for parsing yaml files, which contain which commands should be run on which hosts at which times. Using that information, the script then uses `ssh` to access each host and then schedules commands using the `at` command line utility. 

## Interface mapping

In Versa machine CSG780-R2 [link](https://sase-concerto.poc.versanow.net/app/BYU/view/dashboard/secure-sdwan/overview?12hoursAgo=today=tab=all%20%3E%20Availability&key=value=SDWAN/SDWAN-SITE=12hoursAgo=today=Physical%20and%20Logical%20Interfaces=CSG780-R2%20%3E%20Interfaces&), here are the mappings:
  * vni-0/0.0: BYU ethernet
  * vni-0/1.0: Starlink-1
  * vni-0/2.0: Starlink-2

On the PVE host, the mappings are as follows:
  * enp1s0f0: (not plugged in)
  * enp1s0f1: (also not plugged in)
  * enp1s0f2: To Versa interface 0
  * enp1s0f3: To BYU internet
  * enp2s0f0: To Versa interface 2
  * enp2s0f1: To Starlink-2
  * enp2s0f2: To Versa interface 1
  * enp2s0f3: To Starlink-1 

  Versa-0 and BYU are bridged via WANulator 101
  Versa-2 and Starlink-2 are bridged via WANulator 102
  Versa-1 and Starlink-1 are bridged via WANulator 103

  In PVE, there are 4 WANulators, each with qm IDs. They are linked to physical interfaces as follows:
  * 100: Not hooked up
  * 101: Versa-0 and BYU
  * 102: Versa-2 and Starlink-2
  * 103: Versa-1 and Starlink-1

On Versa, the link priority is 1.) Starlink-1, 2.) Starlink-2, and 3.) BYU.