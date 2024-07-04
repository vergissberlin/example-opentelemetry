from prometheus_client import start_http_server, Summary, Counter, push_to_gateway, CollectorRegistry
import random
import time

registry = CollectorRegistry()


REQUEST_TIME = Summary("request_processing_seconds", "Time spent processing a function", registry=registry)
MY_COUNTER= Counter("emitter:python:counter", "A counter for my function", ["mylabel"], registry=registry)
@REQUEST_TIME.time()
def process_request(t):
    """A dummy function that takes some time."""
    time.sleep(t)

if __name__ == '__main__':
    start_http_server(5000)
    while True:
        MY_COUNTER.labels(mylabel='myvalue').inc()
        process_request(random.random())
        push_to_gateway('prometheus_pushgateway:9091', job='myjob', registry=CollectorRegistry())
        time.sleep(1)
