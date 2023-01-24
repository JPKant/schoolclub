import 'dart:ui';

import 'package:flutter/material.dart';
import "package:login_app/DataBaseHandler/DbHelper.dart";
import 'package:login_app/Model/ClubModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'openUI.dart';

class ClubPage extends StatefulWidget {
  const ClubPage({super.key, required this.title, required this.club});
  final String title;
  final ClubModel club;

  @override
  State<ClubPage> createState() => _ClubPageState();
}

class _ClubPageState extends State<ClubPage> {
  final formKey = new GlobalKey<FormState>();
  late String? _conUserId;
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  List<Comment> comments = [];
  TextEditingController commentController = TextEditingController();
  DateTime now = DateTime.now();

  var dbHelper;

  void initState() {
    super.initState();
    dbHelper = DbHelper();
    dbHelper.initDb();
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

  @override
  Widget build(BuildContext context) {
    // 1
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.club.club_name),
      ),
      // 2
      body: Stack(
        children: <Widget>[
          // 4
          Positioned(
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: Image(
                  image: AssetImage(widget.club.assetAssignment),
                ),
              ),
              top: 20,
              left: 20,
              right: 20),

          Positioned(
            child: Text(
              widget.club.club_name,
              style: TextStyle(
                fontFamily: "Roboto",
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
            top: 35,
            left: 40,
          ),

          Positioned(
            child: Text(
              widget.club.room,
              style: TextStyle(
                fontFamily: "Roboto",
                fontSize: 20,
                color: Color.fromARGB(255, 123, 123, 123),
              ),
            ),
            top: 78,
            left: 40,
          ),
/*
          Positioned(
            child: Column(
              children: [Table(children: [TableRow(
                children: [SizedBox(
              height: double.infinity,
              width: MediaQuery.of(context).size.width / 2 - 70,
              child: Container(
                padding:
                    EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(.5),
                          spreadRadius: 5,
                          blurRadius: 7)
                    ]),
                child: Text('Info'),
              ),
            ),],
              )],)],
            ),
            top: 260,
            left: 40,
            bottom: 40,
          ),
          */

          Positioned(
            child: ListView.builder(
                itemCount: comments.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                      padding: EdgeInsets.only(bottom: 20, left: 10, right: 10),
                      child: SizedBox(
                        height: 60,
                        width: MediaQuery.of(context).size.width / 2 - 180,
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 15, right: 15, bottom: 7, top: 7),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(.5),
                                    spreadRadius: 5,
                                    blurRadius: 7)
                              ]),
                          child: Column(children: [
                            Padding(
                                padding: EdgeInsets.only(bottom: 4),
                                child: Text(
                                  comments[index].author +
                                      " at " +
                                      comments[index].timestamp,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.left,
                                )),
                            Text(comments[index].info)
                          ]),
                        ),
                      ));
                }),
            top: 350,
            bottom: 40,
            right: 40,
            left: 40,
          ),

          Positioned(
            child: ElevatedButton(
              child: Text('Add a Comment'),
              style: ButtonStyle(
                  textStyle: MaterialStateProperty.all(
                      const TextStyle(fontSize: 20, fontFamily: "Roboto")),
                  backgroundColor: MaterialStateProperty.all(
                      Color.fromARGB(255, 85, 169, 238)),
                  fixedSize: MaterialStateProperty.all(const Size(300, 60)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)))),
              onPressed: () {
                _showNewTaskDialog();
              },
            ),
            top: 260,
            right: 100,
            left: 100,
          ),
        ],
      ),
    );
  }

  void _showNewTaskDialog() {
    commentController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Post a New Comment"),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: commentController,
                  decoration: InputDecoration(
                    labelText: "Comment Details",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your comment.";
                    }
                    return null;
                  },
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
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  setState(() {
                    comments.add(Comment(
                        info: commentController.text,
                        author: 'Anonymous',
                        timestamp:
                            now.hour.toString() + ':' + now.minute.toString()));
                    Navigator.of(context).pop();
                  });
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

class Comment {
  String info;
  String author;
  String timestamp;

  Comment({required this.info, required this.author, required this.timestamp});
}
