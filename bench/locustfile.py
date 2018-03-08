from locust import HttpLocust, TaskSet, task


class BenchTaskSet(TaskSet):

    @task(1)
    def getSync(l):
        l.client.request(
            method="GET",
            url="/sync",
            timeout=5000
        )

    @task(0)
    def getAsync(l):
        l.client.request(
            method="GET",
            url="/async",
            timeout=5000
        )


class BenchLocust(HttpLocust):
    task_set = BenchTaskSet
    min_wait = 100
    max_wait = 1000
