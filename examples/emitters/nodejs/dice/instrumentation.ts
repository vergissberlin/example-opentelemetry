/*instrumentation.ts*/
import * as opentelemetry from '@opentelemetry/sdk-node';
import { getNodeAutoInstrumentations } from '@opentelemetry/auto-instrumentations-node';
import { OTLPMetricExporter } from '@opentelemetry/exporter-metrics-otlp-proto';
import { PeriodicExportingMetricReader } from '@opentelemetry/sdk-metrics';
const { CollectorTraceExporter } =  require('@opentelemetry/exporter-collector-grpc');
import { Resource } from '@opentelemetry/resources';
import {
    SEMRESATTRS_SERVICE_NAME,
    SEMRESATTRS_SERVICE_VERSION,
  } from '@opentelemetry/semantic-conventions';
  

const sdk = new opentelemetry.NodeSDK({
    resource: new Resource({
        [SEMRESATTRS_SERVICE_NAME]: 'nodejs-dice',
        [SEMRESATTRS_SERVICE_VERSION]: '1.0',
      }),
  traceExporter: new CollectorTraceExporter({
    url: 'grpc://collector_opentelemetry_contrib:4317/v1/traces'
  }),
  metricReader: new PeriodicExportingMetricReader({
    exporter: new OTLPMetricExporter({
      url: 'http://collector_opentelemetry_contrib:4317/v1/metrics', // url is optional and can be omitted - default is http://localhost:4318/v1/metrics
      headers: {}, // an optional object containing custom headers to be sent with each request
    }),
  }),
  instrumentations: [getNodeAutoInstrumentations()],
});
sdk.start();
