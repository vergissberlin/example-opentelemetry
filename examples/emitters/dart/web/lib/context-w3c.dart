// Copyright 2021-2022 Workiva.
// Licensed under the Apache License, Version 2.0. Please see https://github.com/Workiva/opentelemetry-dart/blob/master/LICENSE for more information

import 'package:opentelemetry/api.dart';
import 'package:opentelemetry/sdk.dart'
    show
        BatchSpanProcessor,
        CollectorExporter,
        ConsoleExporter,
        SimpleSpanProcessor,
        TracerProviderBase;
import 'package:opentelemetry/src/experimental_api.dart'
    show NoopContextManager;

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

class MapSetter implements TextMapSetter<Map> {
  @override
  void set(Map carrier, String key, String value) {
    carrier[key] = value;
  }
}

class MapGetter implements TextMapGetter<Map> {
  @override
  String? get(Map? carrier, String key) {
    return (carrier == null) ? null : carrier[key];
  }

  @override
  Iterable<String> keys(Map carrier) {
    return carrier.keys.map((key) => key.toString());
  }
}

void main(List<String> args) async {
  final tp = TracerProviderBase(processors: processors);
  registerGlobalTracerProvider(tp);

  final cm = NoopContextManager();
  registerGlobalContextManager(cm);

  final tmp = W3CTraceContextPropagator();
  registerGlobalTextMapPropagator(tmp);

  final span = tp.getTracer('instrumentation-name').startSpan('test-span-0');
  final carrier = <String, String>{};
  tmp.inject(contextWithSpan(cm.active, span), carrier, MapSetter());
  await test(carrier);
  span.end();
}

Future test(Map<String, String> carrier) async {
  globalTracerProvider
      .getTracer('instrumentation-name')
      .startSpan('test-span-1',
          context: globalTextMapPropagator.extract(
              globalContextManager.active, carrier, MapGetter()))
      .end();
}
