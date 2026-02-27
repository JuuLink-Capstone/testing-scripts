```
Author: Calin Schurig on 12 Feb 2026
```

# Failover Testing

These scripts are created with the goal of automating failover testing. Listed below are the different components of this test, and how different files in this repository relate to each test component.

* Wanulator
* PVE host (hosts wanulators)
* Versa routers
* Traffic generators

To start a single test, three things need to happen:

* Packet capture must be enabled (on the PVE host).
* Traffic generation must be enabled (on the traffic generator).
* Link degredation must be initiated (on the wanulators).

Because two of those three things happen on the PVE host, I think that the scripts should be run from the PVE host.

Ethan proposed a more decentralized test, where messages are sent to schedule different types of tests, and then everything just starts the test at the same time. I think this is probably a good idea. 

Whatever the case, I think the following would be a good way of doing it: have some way of scheduling commands across different devices. This requires a few things:

* A file that defines different hosts and how to access them
* A way of representing commands on hosts at specified relative times
* A way of scheduling commands, which probably requires some sort of lingering thingy. 

One promising option looks like `at`, which can be used to sync everything up, at least by the minute. This way, we can just execute commands over ssh, and schedule them all for the same time.

We can create an ssh config file with password info and stuff, and then run ssh -F <config> <host>, and it should work just fine.

We can parse yaml using pyyaml, or the package python3-yaml.

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
