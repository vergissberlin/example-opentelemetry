# OpenTelemetry Collector

## Quickstart

1. Start the OpenTelemetry Collector with Docker

    ```bash
    make collector-up
    ```

2. Create a span with CURL

    ```bash
    curl -i http://localhost:4318/v1/traces -X POST -H "Content-Type: application/json" -d @span.json
    ```
