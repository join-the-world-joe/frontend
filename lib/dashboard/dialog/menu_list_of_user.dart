import 'package:flutter/material.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:flutter_framework/dashboard/component/menu.dart';
import 'package:flutter_framework/dashboard/model/menu_list.dart';
import 'package:flutter_framework/utils/spacing.dart';

Future<int> showMenuListOfUserDialog(BuildContext context, MenuList menuList) async {
  List<Widget> menuWidgets = [];

  for (var i = 0; i < menuList.getBody().length; i++) {
    menuWidgets.add(Spacing.addVerticalSpace(10));
    menuWidgets.add(const Divider());
    menuWidgets.add(
      _buildChip(label: Translator.translate(menuList.getBody()[i].getTitle()), textColor: Colors.white),
    );
    menuWidgets.add(Spacing.addVerticalSpace(10));
    List<Widget> chips = [];
    for (var j = 0; j < menuList.getBody()[i].getItemList().length; j++) {
      chips.add(
        _buildFilterChip(
          label: Translator.translate(menuList.getBody()[i].getItemList()[j]),
          textColor: Colors.white,
          tooltip: menuList.getBody()[i].getDescList()[j],
        ),
      );
    }
    menuWidgets.add(SizedBox(
      width: 380,
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              spacing: 6.0,
              runSpacing: 6.0,
              children: chips,
            ),
          ),
        ],
      ),
    ));
    menuWidgets.add(const Divider());
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
            child: Text(Translator.translate(Language.ok)),
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
                  children: menuWidgets,
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

Widget _buildFilterChip({required String label, required Color textColor, required String tooltip}) {
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
