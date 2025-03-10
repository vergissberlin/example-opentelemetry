//
//  Generated code. Do not modify.
//  source: propagator.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'my_service.pb.dart' as $0;

export 'my_service.pb.dart';

@$pb.GrpcServiceName('MyGrpcService')
class MyGrpcServiceClient extends $grpc.Client {
  static final _$myRpcMethod = $grpc.ClientMethod<$0.MyRequest, $0.MyResponse>(
      '/MyGrpcService/MyRpcMethod',
      ($0.MyRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.MyResponse.fromBuffer(value));

  MyGrpcServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.MyResponse> myRpcMethod($0.MyRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$myRpcMethod, request, options: options);
  }
}

@$pb.GrpcServiceName('MyGrpcService')
abstract class MyGrpcServiceBase extends $grpc.Service {
  $core.String get $name => 'MyGrpcService';

  MyGrpcServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.MyRequest, $0.MyResponse>(
        'MyRpcMethod',
        myRpcMethod_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.MyRequest.fromBuffer(value),
        ($0.MyResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.MyResponse> myRpcMethod_Pre(
      $grpc.ServiceCall call, $async.Future<$0.MyRequest> request) async {
    return myRpcMethod(call, await request);
  }

  $async.Future<$0.MyResponse> myRpcMethod(
      $grpc.ServiceCall call, $0.MyRequest request);
}
