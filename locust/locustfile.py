from locust import HttpUser, task, between
import time
import random

class WebsiteUser(HttpUser):
    #how long a simulated user waits between tasks
    wait_time = between (1, 5)
    
    # @task
    # def load_homepage(self):
    #     # this is basically just a placeholder until we know what 
    #     # websites we'll be pinging on SLU 2. "/dashboard" is the 
    #     # suffix on the end of the URL provided when locust is run
    #     # from either the command line or the bash script
    #     self.client.get("/dashboard.html")
        
    # you could also totally do something like this to go to multiple
    # websites in the same test. It's pretty versatile
    
    @task
    def view_items(self):
        port = random.randint(8001, 8010)   # uniform distribution
        base = self.host.rstrip("/")

        self.client.get(
            f"{base}:{port}/",
            name=f"site_{port}"
        )
    
