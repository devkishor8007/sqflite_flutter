import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sqflite_flutter/data/helper/db_helper.dart';
import 'package:sqflite_flutter/data/model/register_data.dart';
import 'package:sqflite_flutter/widget/drawer_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? selectItem;
  final TextEditingController _name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _name,
          style: const TextStyle(
            color: Colors.white,
          ),
          decoration: InputDecoration(
              hintText: "enter your name",
              hintStyle: const TextStyle(color: Colors.white54),
              suffixIcon: IconButton(
                  tooltip: 'Add/Edit Button',
                  onPressed: () async {
                    _name.text == ""
                        ? ""
                        : selectItem != null
                            ? await DatabaseHelper.instance.update(
                                RegisterData(id: selectItem, name: _name.text),
                              )
                            : await DatabaseHelper.instance.add(
                                RegisterData(name: _name.text),
                              );
                    setState(() {
                      _name.clear();
                    });
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ))),
        ),
      ),
      drawer: const DrawerPage(),
      body: FutureBuilder<List<RegisterData>>(
          future: DatabaseHelper.instance.getRegister(),
          builder: (context, AsyncSnapshot<List<RegisterData>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: Text('Loading...'),
              );
            }
            return ListView(
              children: snapshot.data!.map((e) {
                var d = Hive.box<bool>('darkThemes').containsKey('isDark');
                return snapshot.data!.isEmpty
                    ? const Center(child: Text('No User in List'))
                    : Card(
                        color:
                            selectItem == e.id ? Colors.white54 : Colors.white,
                        child: ListTile(
                          title: Text(
                            e.name ?? "",
                            style: TextStyle(
                                color: d ? Colors.black : Colors.black),
                          ),
                          onTap: () {
                            setState(() {
                              if (selectItem == null) {
                                _name.text = e.name ?? '';
                                selectItem = e.id;
                              } else {
                                _name.text = '';
                                selectItem = null;
                              }
                            });
                          },
                          onLongPress: () {
                            setState(() {
                              DatabaseHelper.instance.delete(e.id ?? 1);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                duration: Duration(seconds: 6),
                                content: Text('Delete Successfully'),
                              ),
                            );
                          },
                        ),
                      );
              }).toList(),
            );
          }),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     _name.text == ""
      //         ? ""
      //         : selectItem != null
      //             ? await DatabaseHelper.instance.update(
      //                 RegisterData(id: selectItem, name: _name.text),
      //               )
      //             : await DatabaseHelper.instance.add(
      //                 RegisterData(name: _name.text),
      //               );
      //     setState(() {
      //       _name.clear();
      //     });
      //   },
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
