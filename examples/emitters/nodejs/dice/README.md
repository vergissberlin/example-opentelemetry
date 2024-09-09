# OpenTelemetry Node.js Example

This example is taken from the [OpenTelemetry documentation](https://opentelemetry.io/docs/languages/js/). It demonstrates how to use OpenTelemetry to instrument a simple Node.js application.

## Prerequisites

1. Install Docker
2. Start the OpenTelemtry Collector by running `make collector-contrib-up`.
3. Start the Jaeger backend by running `make receiver-jaeger-up`.

## Run application

```bash
npx ts-node --require ./instrumentation.ts app.ts
```

## View traces

1. Go to the [Jaeger UI](http://localhost:16686).
2. Look for traces with the service name `nodejs-dice`.
