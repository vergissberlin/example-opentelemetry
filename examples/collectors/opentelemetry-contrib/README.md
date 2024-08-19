# OpenTelemetry Collector Contrib

## Quickstart

1. Start the OpenTelemetry Collector with Docker

    ```bash
    docker compose up -d
    ```

2. Create a span with CURL

    ```bash
    curl -i http://localhost:5318/v1/traces -X POST -H "Content-Type: application/json" -d @span.json
    ```
