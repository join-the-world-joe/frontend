import 'dart:convert';

import 'package:flutter_framework/common/route/backend_gateway.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/service/backend_gateway/protocol/fetch_rate_limiting_config.dart';

void fetchRateLimitingConfig({
  required String from,
  required String caller,
}) {
  Runtime.request(
    from: from,
    caller: caller,
    major: Major.backendGateway,
    minor: BackendGateway.fetchRateLimitingConfigReq,
    body: FetchRateLimitingConfigReq(),
  );
}
