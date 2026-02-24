---
# Locust Testing README
---
Locust is an open source tool for simulating HTTP GET requests. Locust is a Python package. It can spawn many concurrent pseudo-users who try to access a specific website(s). You can setup how often each user should try to reach a website, randomize which website to visit, set priorities for different tasks, and much more.
## Files
### locustfile.py
This file is what controls the behavior of each psuedo-user. It tells what URL path to go to, after being provided the hostname by run_locust.sh or a CLI input.
For more info, go to the official Locust website. 
https://docs.locust.io/en/stable/writing-a-locustfile.html

### run_locust.sh
This file is the bash script that dictates what the hostname of the target is, how many pseudo-users to spawn, the spawn rate, how long to run the test for, and where to save a CSV of the results. This 

### requirements.txt
This file contains all the required packages for locust to work. run_locust.sh either looks for or creates a virtual environment with those required packages before running its script. This ensures all the right versions of packages are installed, and provides a containerized way of storing information. For more info about virtual environments, read https://docs.python.org/3/library/venv.html

## Usage
This will be implemented into a larger bash script that runs other tests. It could also be run on it's own.