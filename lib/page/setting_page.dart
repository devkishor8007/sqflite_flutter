import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sqflite_flutter/widget/drawer_page.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        drawer: const DrawerPage(),
        body: ValueListenableBuilder<Box<bool>>(
            valueListenable: Hive.box<bool>('darkThemes').listenable(),
            builder: (context, Box box, widget) {
              final isDark = box.get('isDark', defaultValue: false) ?? false;
              return SwitchListTile(
                  title: const Text('Switch Theme'),
                  value: isDark,
                  onChanged: (val) {
                    box.put('isDark', !isDark);
                  });
            }),
      ),
    );
  }
}
