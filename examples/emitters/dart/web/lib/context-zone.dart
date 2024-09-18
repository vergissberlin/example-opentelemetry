// Copyright 2021-2022 Workiva.
// Licensed under the Apache License, Version 2.0. Please see https://github.com/Workiva/opentelemetry-dart/blob/master/LICENSE for more information
import 'dart:async';

import 'package:opentelemetry/api.dart';
import 'package:opentelemetry/sdk.dart'
    show
        BatchSpanProcessor,
        CollectorExporter,
        ConsoleExporter,
        SimpleSpanProcessor,
        TracerProviderBase;
import 'package:opentelemetry/src/experimental_api.dart'
    show ZoneContext, ZoneContextManager;

final processors = [
  BatchSpanProcessor(
    CollectorExporter(Uri.parse('http://0.0.0.0:4318/v1/traces'), headers: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET,PUT,PATCH,POST,DELETE,OPTIONS',
      'Access-Control-Allow-Headers': 'Origin, X-Requested-With, '
          'Content-Type, Accept',
      'Access-Control-Allow-Credentials': 'true',
    }),
  ),
  SimpleSpanProcessor(ConsoleExporter())
];

void main(List<String> args) {
  initializeOpenTelemetry(args);
}

Future<void> initializeOpenTelemetry(List<String> args) async {
  final tp = TracerProviderBase(processors: processors);
  registerGlobalTracerProvider(tp);

  final cm = ZoneContextManager();
  registerGlobalContextManager(cm);

  final span = tp.getTracer('instrumentation-name').startSpan('test-span-0');
  await (contextWithSpan(cm.active, span) as ZoneContext).run((_) => test());
  span.end();
}

Future test() async {
  spanFromContext(globalContextManager.active)
      .setStatus(StatusCode.error, 'test error');
  globalTracerProvider
      .getTracer('instrumentation-name')
      .startSpan('test-span-1')
      .end();
}
