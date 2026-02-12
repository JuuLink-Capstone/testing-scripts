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

We can parse yaml using yq. 