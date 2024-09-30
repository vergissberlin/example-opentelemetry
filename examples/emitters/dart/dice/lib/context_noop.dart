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

Future<void> main(List<String> args) async {
  final tp = TracerProviderBase(processors: processors);
  registerGlobalTracerProvider(tp);

  final cm = NoopContextManager();
  registerGlobalContextManager(cm);

  final span = tp.getTracer('instrumentation-name').startSpan('test-span-0');
  await test(contextWithSpan(cm.active, span));
  span.end();
}

Future test(Context context) async {
  spanFromContext(context).setStatus(StatusCode.error, 'test error');
  spanFromContext(context).setStatus(StatusCode.ok, 'test ok');

  globalTracerProvider
      .getTracer('instrumentation-name')
      .startSpan('test-span-1', context: context)
      .end();
}
