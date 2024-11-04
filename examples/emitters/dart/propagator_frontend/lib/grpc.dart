import 'package:grpc/grpc.dart';
import 'package:uuid/uuid.dart';

import 'src/generated/my_service.pbgrpc.dart';

class MyGrpcClient {
  final ClientChannel channel;
  late final MyGrpcServiceClient stub;

  MyGrpcClient(String host, int port)
      : channel = ClientChannel(
          host,
          port: port,
          options:
              const ChannelOptions(credentials: ChannelCredentials.insecure()),
        ) {
    // Initialize `stub` here instead of in the initializer list
    stub = MyGrpcServiceClient(
      channel,
      options: CallOptions(
        metadata: {
          'traceparent': generateTraceParent(),
        },
      ),
    );
  }

  // Funktion zur Generierung des `traceparent` Headers
  static String generateTraceParent() {
    final uuid = Uuid();
    final traceId = uuid.v4().replaceAll('-', ''); // Zufällige Trace-ID
    final spanId = uuid.v4().substring(0, 16); // Zufällige Span-ID
    return '00-$traceId-$spanId-01';
  }

  // Beispiel-Methode zum Aufrufen von `MyRpcMethod`
  Future<void> callRpcMethod(String name) async {
    final request = MyRequest()..name = name;
    try {
      final response = await stub.myRpcMethod(request);
      print('Server response: ${response.message}');
    } catch (e) {
      print('Caught error: $e');
    }
  }

  // Beendet die Verbindung
  Future<void> shutdown() async {
    await channel.shutdown();
  }
}
