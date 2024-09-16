# OpenTelemetry Dart/Flutter Example

This example demonstrates how to use OpenTelemetry to instrument a simple Dart 
application.

## Prerequisites

1. Install Docker
2. Start the OpenTelemtry Collector by running `make collector-contrib-up`.
3. Start the Jaeger backend by running `make receiver-jaeger-up`.

## Run application

```bash
make emitters-dart-up
```

## View traces

1. Go to the [Jaeger UI](http://localhost:16686).
2. Look for traces with the service name `dart-button`.
