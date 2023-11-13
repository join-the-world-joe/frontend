import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:flutter_framework/dashboard/business/fetch_menu_list_of_condition.dart';
import 'package:flutter_framework/dashboard/business/fetch_permission_list_of_condition.dart';
import 'package:flutter_framework/dashboard/business/fetch_role_list_of_condition.dart';
import 'package:flutter_framework/dashboard/business/fetch_user_list_of_condition.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/dashboard/business/soft_delete_user_recode.dart';
import 'package:flutter_framework/dashboard/component/permission.dart';
import 'package:flutter_framework/dashboard/component/user.dart';
import 'package:flutter_framework/dashboard/dialog/insert_user.dart';
import 'package:flutter_framework/dashboard/dialog/menu_list_of_user.dart';
import 'package:flutter_framework/dashboard/dialog/permission_list_of_user.dart';
import 'package:flutter_framework/dashboard/dialog/remove_user.dart';
import 'package:flutter_framework/dashboard/dialog/role_list_of_user.dart';
import 'package:flutter_framework/dashboard/model/menu_list.dart';
import 'package:flutter_framework/dashboard/model/permission_list.dart';
import 'package:flutter_framework/dashboard/model/role_list.dart';
import 'package:flutter_framework/dashboard/model/user.dart' as usr;
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import '../responsive.dart';
import '../config/config.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/utils/navigate.dart';
import '../screen/screen.dart';
import 'package:flutter_framework/dashboard/cache/cache.dart';
import 'package:flutter_framework/dashboard/model/role.dart';
import '../setup.dart';
import 'package:flutter_framework/dashboard/business/insert_user_record.dart';

class Test extends StatelessWidget {
  final List<int> shades = [100, 200, 300, 400, 500, 600, 700, 800, 900];
  final ScrollController _horizontal = ScrollController(),
      _vertical = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      width: 400,
      child: Scrollbar(
        controller: _vertical,
        thumbVisibility: true,
        trackVisibility: true,
        child: Scrollbar(
          controller: _horizontal,
          thumbVisibility: true,
          trackVisibility: true,
          notificationPredicate: (notif) => notif.depth == 1,
          child: SingleChildScrollView(
            controller: _vertical,
            child: SingleChildScrollView(
              controller: _horizontal,
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const <DataColumn>[
                  DataColumn(label: Text('Preview')),
                  DataColumn(label: Text('Color')),
                  DataColumn(label: Text('Shade')),
                ],
                rows: [
                  for (var color in Colors.primaries)
                    for (var shade in shades)
                      DataRow(
                        cells: [
                          DataCell(Container(
                              height: 20, width: 50, color: color[shade])),
                          DataCell(Text(color.toString())),
                          DataCell(Text('$shade')),
                        ],
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}