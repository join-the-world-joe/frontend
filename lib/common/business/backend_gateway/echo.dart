import 'dart:typed_data';
import 'package:flutter_framework/common/route/backend_gateway.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/protocol/backend_gateway/echo.dart';

void echo({
  required String from,
  required String caller,
  required String message,
}) {
  Runtime.request(
    from: from,
    caller: caller,
    body: PingReq.construct(
      message: message,
    ),
    major: Major.backendGateway,
    minor: BackendGateway.pingReq,
  );
}
