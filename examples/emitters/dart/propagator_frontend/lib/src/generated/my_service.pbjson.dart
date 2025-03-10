//
//  Generated code. Do not modify.
//  source: propagator.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use myRequestDescriptor instead')
const MyRequest$json = {
  '1': 'MyRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `MyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List myRequestDescriptor =
    $convert.base64Decode('CglNeVJlcXVlc3QSEgoEbmFtZRgBIAEoCVIEbmFtZQ==');

@$core.Deprecated('Use myResponseDescriptor instead')
const MyResponse$json = {
  '1': 'MyResponse',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `MyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List myResponseDescriptor = $convert
    .base64Decode('CgpNeVJlc3BvbnNlEhgKB21lc3NhZ2UYASABKAlSB21lc3NhZ2U=');
