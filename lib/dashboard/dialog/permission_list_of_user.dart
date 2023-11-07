import 'package:flutter/material.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/dashboard/model/permission_list.dart';
import 'package:flutter_framework/utils/spacing.dart';

Future<int> showPermissionListOfUserDialog(
    BuildContext context, PermissionList permissionList) async {
  List<Widget> roleWidgets = [];

  for (var i = 0; i < permissionList.getBody().length; i++) {
    var name = permissionList.getBody()[i].getName();
    var major = permissionList.getBody()[i].getMajor();
    var minor = permissionList.getBody()[i].getMinor();
    roleWidgets.add(_buildFilterChip(
        label: name, textColor: Colors.white, tooltip: '$major-$minor'));
  }

  await showDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) {
      return AlertDialog(
        // title: const Text('角色列表'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
          Spacing.addVerticalSpace(50),
        ],
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              width: 400,
              height: 250,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Spacing.addVerticalSpace(10),
                    const Divider(),
                    _buildChip(label: '权限列表', textColor: Colors.white),
                    Spacing.addVerticalSpace(10),
                    SizedBox(
                      width: 380,
                      child: Row(
                        children: [
                          Expanded(
                            child: Wrap(
                              spacing: 6.0,
                              runSpacing: 6.0,
                              children: roleWidgets,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  );
  return Code.oK;
}

Chip _buildChip({required String label, required Color textColor}) {
  return Chip(
    // avatar: const CircleAvatar(
    //   backgroundColor: Colors.orangeAccent,
    //   child: Text('角色'),
    // ),
    labelPadding: const EdgeInsets.all(2.0),
    label: Text(
      label,
      style: TextStyle(
        color: textColor,
      ),
    ),
    backgroundColor: Colors.cyan,
    elevation: 6.0,
    shadowColor: Colors.grey[60],
    padding: const EdgeInsets.all(8.0),
  );
}

Widget _buildFilterChip(
    {required String label,
    required Color textColor,
    required String tooltip}) {
  return FilterChip(
    tooltip: tooltip,
    onSelected: (b) {},
    labelPadding: const EdgeInsets.all(2.0),
    label: Text(
      label,
      style: TextStyle(
        color: textColor,
      ),
    ),
    backgroundColor: Colors.blueGrey,
    elevation: 6.0,
    shadowColor: Colors.grey[60],
    padding: const EdgeInsets.all(8.0),
  );
}
