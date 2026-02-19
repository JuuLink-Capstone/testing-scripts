from locust import HttpUser, task, between, time

class WebsiteUser(HttpUser):
    #how long a simulated user waits between tasks
    wait_time = between (1, 5)
    
    @task
    def load_homepage(self):
        # this is basically just a placeholder until we know what 
        # websites we'll be pinging on SLU 2. "/dashboard" is the 
        # suffix on the end of the URL provided when locust is run
        # from either the command line or the bash script
        self.client.get("/dashboard.html")
        
    # you could also totally do something like this to go to multiple
    # websites in the same test. It's pretty versatile
    # @task
    # def view_items(self):
    #     for item_id in range(10):
    #         self.client.get(f"/item?id={item_id}", name="/item")
    #         time.sleep(1)
        
