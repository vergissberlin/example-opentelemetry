import 'package:flutter/material.dart';
import 'package:opentelemetry/api.dart' as otel_api;
import 'package:opentelemetry/api.dart';
import 'package:opentelemetry/sdk.dart' as otel_sdk;

// Optionally, multiple processors can be registered
final provider = otel_sdk.TracerProviderBase(processors: [
  otel_sdk.BatchSpanProcessor(
    otel_sdk.CollectorExporter(
      Uri.parse('http://localhost:4317/v1/traces'),
    ),
    scheduledDelayMillis: 100,
    maxExportBatchSize: 512,
  ),
  otel_sdk.SimpleSpanProcessor(otel_sdk.ConsoleExporter())
]);

final tracer = provider.getTracer(
  'example-dart-button',
  schemaUrl: 'http://localhost:4317',
  version: '1.2.2',
  attributes: [
    otel_api.Attribute.fromString('key', 'dirk'),
    otel_api.Attribute.fromString(
      ResourceAttributes.serviceName,
      'MyService',
    ),
    otel_api.Attribute.fromString(
      ResourceAttributes.serviceNamespace,
      'Vergissberlin',
    ),
  ],
);
registerGlobalTracerProvider(provider) {}
// final tracer = globalTracerProvider.getTracer('instrumentation-name');

void main() {
  final span = tracer.startSpan(
    'doingWork',
    attributes: [
      otel_api.Attribute.fromString(
        ResourceAttributes.serviceName,
        'MyService',
      ),
      otel_api.Attribute.fromString(
        ResourceAttributes.serviceNamespace,
        'Vergissberlin',
      ),
    ],
  );
  runApp(const MyApp());
  span.end();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    final spanClick = tracer.startSpan(
      context: otel_api.Context.current,
      attributes: [
        otel_api.Attribute.fromStringList('mylist', [
          'moko',
          'ole',
          'lorem',
          'ipsum',
        ]),
        otel_api.Attribute.fromString(
          ResourceAttributes.serviceName,
          'DartButtonApp',
        ),
        otel_api.Attribute.fromString(
          ResourceAttributes.serviceNamespace,
          'Thinkport',
        ),
      ],
      'click',
    );
    spanClick.addEvent('clickEvent',
        attributes: [otel_api.Attribute.fromInt('click', _counter)]);
    setState(() {
      _counter++;
    });
    spanClick.end();
  }

  @override
  Widget build(BuildContext context) {
    Span parentSpan = Context.current.span;

    Context.current.withSpan(parentSpan).execute(() {
      final spanInside = tracer.startSpan(
        'build-inside',
        context: otel_api.Context.current,
        attributes: [],
      );
      spanInside.addEvent('buildEvent');
      spanInside.end();
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
