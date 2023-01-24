import 'package:flutter/material.dart';
import 'package:login_app/Comm/comHelper.dart';
import 'package:login_app/Comm/genTextFormField.dart';
import 'package:login_app/DataBaseHandler/DbHelper.dart';
import 'package:login_app/Model/ClubModel.dart';
import 'package:login_app/Model/UserModel.dart';
import 'package:login_app/Screens/HomeForm.dart';
import 'package:login_app/Screens/LoginForm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ClubPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ClubModel> clubs = [];
  final formKey = new GlobalKey<FormState>();
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  TextEditingController nameController = TextEditingController();
  TextEditingController dayController = TextEditingController();
  TextEditingController roomController = TextEditingController();
  late String? _conUserId;
  int? _hoverIndex;
  var dbHelper;

  void initState() {
    super.initState();
    dbHelper = DbHelper();
    dbHelper.initDb();
    getUserData();
  }

  Future<void> getUserData() async {
    final SharedPreferences sp = await _pref;
    var userId = sp.getString("user_id");
    if (userId != null) {
      setState(() {
        _conUserId = userId;
      });
    }
  }

  late List<String> myList;
  void getStringList() async {
    var tempList = await dbHelper.getClubNames();
// Or use setState to assign the tempList to myList
    myList = tempList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Club List"),
          leading: IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomeForm()));
            },
          ),
        ),
        body: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Expanded(
              child: Container(
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(clubs.length, (index) {
                    ClubModel club = clubs[index];
                    return GestureDetector(
                      onLongPress: () {
                        showMenu(
                            context: context,
                            position: RelativeRect.fromLTRB(100, 100, 0, 0),
                            items: [
                              PopupMenuItem(
                                  child: ListTile(
                                leading: Icon(Icons.delete),
                                title: Text("Remove"),
                                onTap: () {
                                  setState(() {
                                    clubs.removeAt(index);
                                  });
                                },
                              ))
                            ]);
                      },
                      child: MouseRegion(
                        onEnter: (e) {
                          setState(() {
                            _hoverIndex = index;
                          });
                        },
                        onExit: (e) {
                          setState(() {
                            _hoverIndex = null;
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3.5,
                          height: 235,
                          decoration: BoxDecoration(
                              color: _hoverIndex == index
                                  ? Color.fromARGB(255, 172, 214, 247)
                                  : Color.fromARGB(255, 253, 253, 253),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Color.fromARGB(255, 158, 158, 158),
                                  width: 1.0)),
                          padding: EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topRight,
                                child: PopupMenuButton(
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      PopupMenuItem(
                                        child: Text("Remove"),
                                        value: "remove",
                                      ),
                                    ];
                                  },
                                  onSelected: (value) {
                                    if (value == "remove") {
                                      setState(() {
                                        dbHelper.deleteClub(
                                            clubs[index].getClubId());
                                        clubs.removeAt(index);
                                      });
                                    }
                                  },
                                  icon: Icon(Icons.more_vert),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => ClubPage(
                                                club: club,
                                                title: '',
                                              )));
                                },
                                child: Text(
                                  "${club.getClubName() ?? ""}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    decoration: _hoverIndex == index
                                        ? TextDecoration.underline
                                        : TextDecoration.none,
                                    fontSize: 24,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "${club.getMeetingDay() ?? "N/A"} in Room ${club.getRoom() ?? "N/A"}",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 80),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showNewTaskDialog,
          child: Icon(Icons.add),
        ));
  }

  Future<UserModel> getSP() async {
    final SharedPreferences sp = await _pref;

    final userId = sp.getString("user_id") ?? "";
    final userName = sp.getString("user_name") ?? "";
    final email = sp.getString("email") ?? "";
    final password = sp.getString("password") ?? "";

    return UserModel(userId, userName, email, password);
  }

  void _showNewTaskDialog() async {
    List<String> clubNames = await dbHelper.getClubNames() ?? [];
    String selectedClub = clubNames[0];
    nameController.clear();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Join New Club"),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                DropdownSearch<String>(
                  popupProps: PopupProps.menu(
                    showSelectedItems: true,
                  ),
                  items: clubNames,
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      labelText: "Select Club",
                      hintText: "Select a Club to join",
                    ),
                  ),
                  onChanged: (value) => selectedClub = value!,
                  selectedItem: selectedClub,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (formKey.currentState?.validate() == true) {
                  ClubModel clubData =
                      await dbHelper.getClubData(selectedClub) ?? [];
                  debugPrint(clubData.toString());
                  if (clubData != null) {
                    setState(() {
                      clubs.add(clubData);
                      dbHelper.addClub(clubData.club_id, _conUserId);
                      Navigator.of(context).pop();
                    });
                  }
                }
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
