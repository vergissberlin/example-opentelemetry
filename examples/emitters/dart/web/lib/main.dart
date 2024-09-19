import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:opentelemetry/api.dart'
    show
        Attribute,
        contextWithSpan,
        globalTextMapPropagator,
        globalTracerProvider,
        registerGlobalTracerProvider,
        registerGlobalTextMapPropagator,
        ResourceAttributes,
        StatusCode,
        W3CTraceContextPropagator,
        TextMapGetter,
        TextMapSetter;
import 'package:opentelemetry/sdk.dart';
import 'package:opentelemetry/src/api/context/context_manager.dart';
import 'package:opentelemetry/src/experimental_api.dart'
    show NoopContextManager;

const String instrumentationName = 'dart-web-service';

final exampleAttributes = [
  Attribute.fromBoolean('custom.boolean', true),
  Attribute.fromBooleanList('custom.boolean.list', [true, true, false]),
  Attribute.fromInt('custom.int', 12),
  Attribute.fromIntList('custom.int.list', [12, 144, 42]),
  Attribute.fromDouble('custom.double', 1.44),
  Attribute.fromDoubleList('custom.double', [1.44, 12.0]),
  Attribute.fromString('custom.string', 'This is my key value'),
  Attribute.fromStringList('custom.string.list', ['moo', 'foo'])
];

final resource = Resource([
  Attribute.fromString(ResourceAttributes.serviceName, 'dart-web'),
  Attribute.fromString(ResourceAttributes.deploymentEnvironment, 'Development'),
  Attribute.fromString(ResourceAttributes.serviceVersion, '1.0.0'),
]);

/// Applications use a tracer to create sets of spans that constitute a trace.
/// There are several components needed to get a tracer:

/// An exporter is needed to send ended spans to a backend such as the dev
/// console.
final exporter = ConsoleExporter();

/// A processor is needed to handle starting and ending spans. The
/// [SimpleSpanProcessor] doesn't do any processing and immediately forwards
/// ended spans to the exporter. This is in contrast to the [BatchSpanProcessor]
/// which will batch spans together before forwarding them to the exporter.
final processors = [
  BatchSpanProcessor(
    CollectorExporter(
      Uri.parse('http://0.0.0.0.0:4318/v1/traces'),
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET,PUT,PATCH,POST,DELETE,OPTIONS',
        'Access-Control-Allow-Headers': 'Origin, X-Requested-With, '
            'Content-Type, Accept',
        'Access-Control-Allow-Credentials': 'true',
      },
    ),
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

final tp = TracerProviderBase(
  processors: processors,
  resource: resource,
);

final cm = NoopContextManager();
final tmp = W3CTraceContextPropagator();

Future<void> main(List<String> args) async {
  registerGlobalTracerProvider(tp);
  registerGlobalContextManager(cm as ContextManager);
  registerGlobalTextMapPropagator(tmp);
  final carrier = <String, String>{};
  final span = tp.getTracer(instrumentationName).startSpan('test-span-0',
      context: globalTextMapPropagator.extract(
        globalContextManager.active,
        carrier,
        MapGetter(),
      ));

  tmp.inject(contextWithSpan(cm.active, span), carrier, MapSetter());
  await test(carrier);
  span.end();
  try {
    runApp(const MyApp());
  } catch (e) {
    rethrow;
  } finally {}
}

Future test(Map<String, String> carrier) async {
  globalTracerProvider
      .getTracer(instrumentationName)
      .startSpan('test-span-test',
          context: globalTextMapPropagator.extract(
              globalContextManager.active, carrier, MapGetter()))
      .end();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter OpenTelemetry Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.teal, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter OpenTelemetry Example'),
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
  int _diceNumber = 0;

  Future<void> _rollDice(throwError) async {
    final carrier = <String, String>{};
    final parentSpan = tp.getTracer(instrumentationName).startSpan(
          'parent-span',
          context: globalTextMapPropagator.extract(
            globalContextManager.active,
            carrier,
            MapGetter(),
          ),
        );
    tmp.inject(contextWithSpan(cm.active, parentSpan), carrier, MapSetter());
    final span = tp.getTracer(instrumentationName).startSpan(
          'child-span',
          attributes: exampleAttributes,
          context: globalTextMapPropagator.extract(
            globalContextManager.active,
            carrier,
            MapGetter(),
          ),
        );

    if (throwError) {
      span.setStatus(StatusCode.error, 'test error');
      try {
        // Simulate an exception
        throw Exception('Simulated exception');
      } catch (e) {
        span.recordException(e);
        span.setStatus(StatusCode.error, 'Exception occurred');
      }
    }

    /// Updates the state of the widget by setting a new random dice number.
    ///
    /// The new dice number is generated using `Random().nextInt(6) + 1`,
    /// which produces a value between 1 and 6.
    setState(() {
      _diceNumber = Random().nextInt(6) + 1;
    });

    /// Adds a delay of 12 to 144 milliseconds before ending the span
    /// to simulate workload
    Future.delayed(Duration(milliseconds: 12 + Random().nextInt(144)), () {
      span.addEvent('Example event with delay', attributes: exampleAttributes);
      span.parentSpanId;

      span.end();
    });

    /// Adds a delay of 12 to 144 milliseconds before ending the span
    /// to simulate workload
    Future.delayed(Duration(milliseconds: 12 + Random().nextInt(144)), () {
      parentSpan.end();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Push the button to roll the dice:',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              '$_diceNumber',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  autofocus: true,
                  onPressed: () => _rollDice(false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                    foregroundColor: Theme.of(context).colorScheme.onTertiary,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    minimumSize:
                        const Size(96.0, 96.0), // Ensures the button is
                    // square
                  ),
                  child: const Icon(
                    Icons.shuffle,
                    size: 42.0,
                  ),
                ),
                const SizedBox(width: 16.0), // Ad
                ElevatedButton(
                  autofocus: true,
                  onPressed: () => _rollDice(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                    foregroundColor: Theme.of(context).colorScheme.onError,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    minimumSize: const Size(96.0, 96.0), // Ensures the
                    // button is
                    // square
                  ),
                  child: const Icon(
                    Icons.flash_on_sharp,
                    size: 42.0,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
