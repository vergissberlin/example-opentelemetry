import 'package:grpc/grpc.dart';
import 'package:uuid/uuid.dart';

class MyGrpcClient {
  final ClientChannel channel;
  final MyGrpcServiceClient stub;

  MyGrpcClient(String host, int port)
      : channel = ClientChannel(
          host,
          port: port,
          options:
              const ChannelOptions(credentials: ChannelCredentials.insecure()),
        ),
        stub = MyGrpcServiceClient(
          channel,
          options: CallOptions(
            metadata: {
              'traceparent': generateTraceParent(),
            },
          ),
        );

  static String generateTraceParent() {
    final uuid = Uuid();
    final traceId =
        uuid.v4().replaceAll('-', ''); // Generiert eine zufällige Trace-ID
    final spanId =
        uuid.v4().substring(0, 16); // Generiert eine zufällige Span-ID
    return '00-$traceId-$spanId-01';
  }

  Future<void> callRpcMethod(String name) async {
    final request = MyRequest()..name = name;
    try {
      final response = await stub.myRpcMethod(request);
      print('Server response: ${response.message}');
    } catch (e) {
      print('Caught error: $e');
    }
  }

  Future<void> shutdown() async {
    await channel.shutdown();
  }
}
