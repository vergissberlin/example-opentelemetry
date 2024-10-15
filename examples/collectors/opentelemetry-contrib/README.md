# OpenTelemetry Collector Contrib

## Quickstart

1. Start the OpenTelemetry Collector with Docker

    ```bash
    docker compose up -d
    ```

2. Create a span with otel-cli

Use [otel-cli](https://github.com/equinix-labs/otel-cli) to create a span:

   ```bash
   otel-cli span \
     --service "my-service" \
     --name "test-span" \
     --kind client \
     --endpoint "http://0.0.0.0:4317" \
     --timeout 2s
   ```