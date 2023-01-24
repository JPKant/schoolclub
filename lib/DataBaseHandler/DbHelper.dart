import 'package:flutter/widgets.dart';
import 'package:login_app/Model/UserModel.dart';
import 'package:login_app/Model/ClubModel.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;
import 'package:postgres/postgres.dart';

class DbHelper {
  String passTable = "test";
  String clubTable = "clubInfo";
  final connection = PostgreSQLConnection("localhost", 5432, "club",
      username: "postgres", password: "jpk@2005");

  Future<void> initDb() async {
    try {
      await connection.open();
      debugPrint("Database Connected!");
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  Future<UserModel?> getLoginUser(String userId, String password) async {
    try {
      var stmt =
          "SELECT * FROM $passTable WHERE id = '$userId' AND password = '$password'";
      debugPrint(stmt);
      var res = await connection.mappedResultsQuery(stmt);

      if (res.isNotEmpty) {
        return UserModel.fromMap(res.first);
      }

      return null;
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  Future<UserModel?> getLoginTeacher(String email, String password) async {
    try {
      var stmt =
          "SELECT * FROM $passTable WHERE email = '$email' AND password = '$password'";
      debugPrint(stmt);
      var res = await connection.mappedResultsQuery(stmt);

      if (res.isNotEmpty) {
        return UserModel.fromMap(res.first);
      }

      return null;
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  Future<int?> saveData(UserModel user) async {
    try {
      var res = await connection.execute(
          "INSERT INTO $passTable VALUES ('${user.user_id}','${user.password}','${user.email}','${user.user_name}')");
      return res;
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  Future<int?> updateUser(UserModel user) async {
    try {
      var res = await connection.execute(
          'UPDATE $passTable SET password = ${user.password}, email = ${user.email}, user_name = ${user.user_name} WHERE id = ${user.user_id}');
      return res;
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  Future<int?> deleteUser(String user_id) async {
    try {
      var res =
          await connection.execute('DELETE $passTable WHERE id = ${user_id}');
      return res;
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  Future<List<String>> getClubNames() async {
    var stmt = 'SELECT club_name FROM "clubInfo"';
    debugPrint(stmt);
    var res = await connection.mappedResultsQuery(stmt);
    if (res == null) {
      print("No results returned from query");
      return [];
    }
    return List<String>.from(res
        .map((item) => item.values.first['club_name'].toString())
        .where((item) => item != null));
  }

  Future<ClubModel> getClubData(String club_name) async {
    try {
      var stmt =
          ''' SELECT * FROM "clubInfo" WHERE club_name = '$club_name' ''';
      debugPrint(stmt);
      var res = await connection.mappedResultsQuery(stmt);
      print("Results returned: $res");
      print("Results returned: ${res.runtimeType}");
      if (res.isNotEmpty) {
        return ClubModel.fromMap(res.first);
      }

      throw Exception("Club not found");
    } catch (e) {
      debugPrint("Error: $e");
      throw e;
    }
  }

  Future<int?> addClub(String? club_id, String? user_id) async {
    try {
      var res = await connection
          .execute("INSERT INTO userinclub VALUES ('$user_id', '$club_id')");
      return res;
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  Future<int?> deleteClub(String club_id) async {
    try {
      var res =
          await connection.execute("DELETE userinclub WHERE id = '${club_id}'");
      debugPrint(res.toString());
      return res;
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  Future<List<String?>> getUserClubs(String? userId) async {
    final results = await connection
        .query("SELECT clubid FROM clubs WHERE userid = $userId");

    if (results == null) {
      print("No results returned from query");
      return [];
    }
    List<String> clubs = [];
    for (final row in results) {
      clubs.add(row[0]);
    }
    debugPrint(clubs.toString());
    return clubs;
  }
}
