import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel
{
  String? uId ;
  String? name ;
  String? text ;
  String? dateTime ;



  CommentModel({
    this.uId,
    this.dateTime,
    this.name,
    this.text,

  });

  CommentModel.fromJson(Map<String , dynamic>? json)
  {
    uId = json!['uId'];
    name = json['name'];
    dateTime = json['dateTime'];
    text = json['text'];

  }

  Map<String , dynamic> toMap()
  {
    return
      {
        'uId' : uId ,
        'name' : name ,
        'dateTime' : dateTime ,
        'text' : text ,
      };
  }
}