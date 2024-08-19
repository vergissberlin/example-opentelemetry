# OpenTelemetry examples

With this examples you can learn how to use OpenTelemetry in your applications. We have added examples for different languages and exporters. Only checked features are implemented.

## Features

> An easy way ro get all open port is also to run `make ps` in the root of the repository after you have started the services with `make up`.

### Emitters (SDKs)

| SDK    | Status | URL                   |
|--------|--------|-----------------------|
| dart   |        |                       |
| go     |        |                       |
| java   |        |                       |
| nodejs | ✅      | <http://0.0.0.0:8030> |
| python | ✅      |                       |
| rust   |        |                       |

### Collectors

| Service                         | Status | URL                   |
|---------------------------------|--------|-----------------------|
| OpenTelemetry Collector         | ✅      | <http://0.0.0.0:4318> |
| OpenTelemetry Collector Contrib | ✅      | <http://0.0.0.0:5318> |

### Processors

| Processor | Status |
|-----------|--------|
| Batch     |        |
| Filter    |        |

### Exporters

| Service | Status | URL |
|---------|--------|-----|
| Kaflka  |        |     |
| MQTT    |        |     |
| Solace  |        |     |

### Receivers

| Service            | Status | URL                    |
|--------------------|--------|------------------------|
| AWS X-Ray          |        |                        |
| DataDog            |        |                        |
| Dynatrace          |        |                        |
| Google Cloud Trace |        |                        |
| Grafana            | ✅      | <http://0.0.0.0:3000>  |
| Honeycomb          |        |                        |
| Instana            |        |                        |
| Jaeger             | ✅      | <http://0.0.0.0:16686> |
| Lightstep          |        |                        |
| New Relic          |        |                        |
| OpenCensus         |        |                        |
| Prometheus         |        |                        |
| Sentry             |        |                        |
| SignalFx           |        |                        |
| Wavefront          |        |                        |

## Getting started

1. Clone the repository
2. Choose the language you want to learn
3. Start the collector and receiver locally with Docker
    1. `make collector-up`
    2. `make receiver-up`
4. Run the example in the language you have chosen (see README.md in the language folder)

## Contributing

If you want to contribute to this repository, please read the [CONTRIBUTING.md](CONTRIBUTING.md) file.
