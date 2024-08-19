# OpenTelemetry Collector

## Quickstart

1. Start the OpenTelemetry Collector with Docker

    ```bash
    docker compose up -d
    ```

2. View the spans in the CLI

    ```bash
    make collector-logs
    ```

3. Create a span with CURL

    ```bash
    curl -i http://localhost:4318/v1/traces -X POST -H "Content-Type: application/json" -d @span.json
    ```
