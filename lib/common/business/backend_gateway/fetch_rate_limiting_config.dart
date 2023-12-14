import 'dart:convert';

import 'package:flutter_framework/common/route/backend_gateway.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/protocol/backend_gateway/fetch_rate_limiting_config.dart';

void fetchRateLimitingConfig({
  required String from,
}) {
  Runtime.request(
    from: from,
    major: Major.backendGateway,
    minor: BackendGateway.fetchRateLimitingConfigReq,
    body: FetchRateLimitingConfigReq(),
  );
}
