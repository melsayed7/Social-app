import 'package:cloud_firestore/cloud_firestore.dart';

class LikeModel
{
  String? uId ;
  String? name ;
  String? profilePicture ;
  FieldValue? dateTime ;



  LikeModel({
    this.uId,
    this.dateTime,
    this.name,
    this.profilePicture,

  });

  LikeModel.fromJson(Map<String , dynamic>? json)
  {
    uId = json!['uId'];
    name = json['name'];
    dateTime = json['dateTime'];
    profilePicture = json['profilePicture'];

  }

  Map<String , dynamic> toMap()
  {
    return
      {
        'uId' : uId ,
        'name' : name ,
        'dateTime' : dateTime ,
        'profilePicture' : profilePicture ,
      };
  }
}