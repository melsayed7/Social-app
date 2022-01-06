class SocialUserModel
{
  String? name ;
  String? phone ;
  String? email ;
  String? uId ;
  String? image ;
  late String? cover ;
  String? bio ;
  late bool isEmailVerified ;

  SocialUserModel({
    this.name,
    this.email,
    this.phone,
    this.uId,
    this.image,
    this.cover,
    this.bio,
    required this.isEmailVerified
});

  SocialUserModel.fromJson(Map<String , dynamic>? json)
  {
    name = json!['name'];
    phone = json['phone'];
    email = json['email'];
    uId = json['uId'];
    image = json['image'];
    cover = json['cover'];
    bio = json['bio'];
    isEmailVerified = json['isEmailVerified'];
  }

  Map<String , dynamic> toMap()
  {
    return
      {
        'name' : name ,
        'phone' : phone ,
        'email' : email ,
        'uId' : uId ,
        'image' : image ,
        'cover' : cover ,
        'bio' : bio ,
        'isEmailVerified' : isEmailVerified ,
      };
  }
}