import 'package:flutter/cupertino.dart';
import 'dart:math';

class ClubModel {
  late String club_id;
  late String club_name;
  late String room;
  late String meeting_day;
  late String pres_id;
  late String vp_id;
  late String secretary_id;
  late String assetAssignment = assetAssigner();

  ClubModel(this.club_id, this.club_name, this.room, this.meeting_day,
      this.pres_id, this.vp_id, this.secretary_id);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'club_id': club_id,
      'club_name': club_name,
      'room': room,
      'meeting_day': meeting_day,
      'pres_id': pres_id,
      'vp_id': vp_id,
      'secretary_id': secretary_id
    };
    return map;
  }

  ClubModel.fromMap(Map<String, dynamic> map) {
    var clubInfo = map['clubInfo'];
    club_id = clubInfo['club_id'].toString();
    club_name = clubInfo['club_name'];
    room = clubInfo['room_number'].toString();
    meeting_day = clubInfo['meeting_day'];
    pres_id = clubInfo['advisor_name'].toString();
    vp_id = clubInfo['advisor_email'].toString();
    secretary_id = clubInfo['club_id'].toString();
  }

  String? getClubId() => club_id;
  String? getClubName() => club_name;
  String? getRoom() => room;
  String? getMeetingDay() => meeting_day;
  String? getPresId() => pres_id;
}

String assetAssigner() {
  List<String> assetlist = [
    "assets/bannerasset1.jpg",
    "assets/bannerasset2.jpg",
    "assets/bannerasset3.jpg",
    "assets/bannerasset4.jpg"
  ];
  return assetlist[Random().nextInt(3) + 1];
}
