/*instrumentation.ts*/
import * as opentelemetry from '@opentelemetry/sdk-node';
import { getNodeAutoInstrumentations } from '@opentelemetry/auto-instrumentations-node';
import { OTLPTraceExporter } from '@opentelemetry/exporter-trace-otlp-proto';
import { OTLPMetricExporter } from '@opentelemetry/exporter-metrics-otlp-proto';
import { PeriodicExportingMetricReader } from '@opentelemetry/sdk-metrics';
const { BasicTracerProvider, SimpleSpanProcessor } = require('@opentelemetry/sdk-trace-base');
const { CollectorTraceExporter } =  require('@opentelemetry/exporter-collector-grpc');


const sdk = new opentelemetry.NodeSDK({
  traceExporter: new CollectorTraceExporter({
    // optional - default url is http://localhost:4318/v1/traces
    url: 'grpc://localhost:4317/v1/traces'
  }),
  metricReader: new PeriodicExportingMetricReader({
    exporter: new OTLPMetricExporter({
      url: 'http://localhost:4317/v1/metrics', // url is optional and can be omitted - default is http://localhost:4318/v1/metrics
      headers: {}, // an optional object containing custom headers to be sent with each request
    }),
  }),
  instrumentations: [getNodeAutoInstrumentations()],
});
sdk.start();
