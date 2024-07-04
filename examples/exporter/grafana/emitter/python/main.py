from prometheus_client import start_http_server, Summary, Counter
import random
import time

REQUEST_TIME = Summary("request_processing_seconds", "Time spent processing a function")
MY_COUNTER= Counter("emitter:python:counter", "A counter for my function", ["mylabel"])
@REQUEST_TIME.time()
def process_request(t):
    """A dummy function that takes some time."""
    time.sleep(t)

if __name__ == '__main__':
    start_http_server(5000)
    while True:
        MY_COUNTER.labels(mylabel='myvalue').inc()
        process_request(random.random())
        #push_to_gateway('localhost:9090', job='myjob', registry=CollectorRegistry())
        #time.sleep(1)
