import 'package:flutter/material.dart';
import 'package:login_app/Comm/comHelper.dart';
import 'package:login_app/Comm/genLoginSignupHeader.dart';
import 'package:login_app/Comm/genTextFormField.dart';
import 'package:login_app/DataBaseHandler/DbHelper.dart';
import 'package:login_app/Model/UserModel.dart';
import 'package:login_app/Screens/HomePage.dart';
import 'package:login_app/Screens/SignupForm.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomeForm.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  final _formKey = new GlobalKey<FormState>();

  final _conUserId = TextEditingController();
  final _conPassword = TextEditingController();
  var dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
    dbHelper.initDb();
  }

  login() async {
    String uid = _conUserId.text;
    String passwd = _conPassword.text;

    if (uid.isEmpty) {
      AlertDialog(title: Text("Please Enter User ID"));
    } else if (passwd.isEmpty) {
      AlertDialog(title: Text("Please Enter Password"));
    } else {
      await dbHelper.getLoginUser(uid.toString(), passwd).then((userData) {
        if (userData != null) {
          setSP(userData).whenComplete(() {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (_) => HomePage(
                          title: '',
                        )),
                (Route<dynamic> route) => false);
          });
        } else {
          AlertDialog(title: Text("Error: User Not Found"));
        }
      }).catchError((error) {
        print(error);
        AlertDialog(title: Text("Error: Login Fail"));
      });
    }
  }

  Future setSP(UserModel user) async {
    final SharedPreferences sp = await _pref;

    sp.setString("user_id", user.user_id ?? "");
    sp.setString("user_name", user.user_name ?? "");
    sp.setString("email", user.email ?? "");
    sp.setString("password", user.password ?? "");
  }

  Future<UserModel> getSP() async {
    final SharedPreferences sp = await _pref;

    final userId = sp.getString("user_id") ?? "";
    final userName = sp.getString("user_name") ?? "";
    final email = sp.getString("email") ?? "";
    final password = sp.getString("password") ?? "";

    return UserModel(userId, userName, email, password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                genLoginSignupHeader('Login'),
                getTextFormField(
                    controller: _conUserId,
                    icon: Icons.person,
                    hintName: 'User ID'),
                SizedBox(height: 10.0),
                getTextFormField(
                  controller: _conPassword,
                  icon: Icons.lock,
                  hintName: 'Password',
                  isObscureText: true,
                ),
                Container(
                  margin: EdgeInsets.all(30.0),
                  width: double.infinity,
                  child: ElevatedButton(
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: login,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? "),
                      ElevatedButton(
                        child: Text('Sign Up'),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => SignupForm()));
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
