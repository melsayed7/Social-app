import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/comment_model.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/notification_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/social_user_model.dart';
import 'package:social_app/moduels/chats/chats_screen.dart';
import 'package:social_app/moduels/feeds/feeds_screen.dart';
import 'package:social_app/moduels/new_post/new_post_screen.dart';
import 'package:social_app/moduels/settings/settings_screen.dart';
import 'package:social_app/moduels/social_login/login_screen.dart';
import 'package:social_app/moduels/users/users_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:social_app/shared/network/local/cache_helper.dart';

class SocialCubit extends Cubit<SocialStates>
{
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) =>BlocProvider.of(context);

  SocialUserModel? userModel;

  void getUserData()
  {
    emit(SocialGetUserLoadingState());

    FirebaseFirestore.instance.collection('users')
        .doc(uId)
        .get()
        .then((value) {
          //print(value.data());
      userModel = SocialUserModel.fromJson(value.data());
          emit(SocialGetUserSuccessState());
    })
        .catchError((error){
          print(error.toString());
          emit(SocialGetUserErrorState(error.toString()));
    });
  }

  int currentIndex =0;

  List<Widget> screens = [
    FeedsScreen(),
    ChatsScreen(),
    NewPostScreen(),
    UsersScreen(),
    SettingsScreen(),
  ];

  List<String> titles = [
    'News Feed',
    'Chats',
    'Post',
    'Users',
    'Settings',
  ];

  void changeBottomNav (int index)
  {
    if(index ==1)
    {
      getUsers();
    }
    if(index == 2)
    {
      emit(SocialNewPostState());
    }else
      {
        currentIndex = index;
        emit(SocialChangeBottomNavState());
      }
  }

  File? profileImage ;
  var picker =ImagePicker();

  Future<void> getProfileImage ()async
  {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if( pickedFile != null)
    {
      profileImage = File(pickedFile.path);
      emit(SocialProfileImagePickedSuccessState());
    }else{
      print('No Image Selected');
      emit(SocialProfileImagePickedErrorState());
    }
  }

  File? coverImage ;
  Future<void> getCoverImage ()async
  {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if( pickedFile != null)
    {
      coverImage = File(pickedFile.path);
      emit(SocialCoverImagePickedSuccessState());
    }else{
      print('No Image Selected');
      emit(SocialCoverImagePickedErrorState());
    }
  }

  void uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
})
  {
    emit(SocialUserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value)
    {
      value.ref.getDownloadURL()
          .then((value) {
            //emit(SocialUploadProfileImageSuccessState());
            print(value);
            updateUser(name: name,phone: phone,bio: bio,image: value);
      })
          .catchError((error){
        emit(SocialUploadProfileImageErrorState());
      });
    })
        .catchError((error){
      emit(SocialUploadProfileImageErrorState());
    });
  }

   void uploadCoverImage({
    required String name,
    required String phone,
    required String bio,
})
  {
    emit(SocialUserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value)
    {
      value.ref.getDownloadURL()
          .then((value) {
        //emit(SocialUploadCoverImageSuccessState());
        print(value);
        updateUser(name: name, phone: phone, bio: bio,cover: value);
      })
          .catchError((error){
        emit(SocialUploadCoverImageErrorState());
      });
    })
        .catchError((error){
      emit(SocialUploadCoverImageErrorState());
    });
  }

/*  void updateUserImages({
    required String name,
    required String phone,
    required String bio,
})
  {
    emit(SocialUserUpdateLoadingState());
    if(coverImage != null)
    {
      uploadCoverImage();
    }else if(profileImage != null)
    {
      uploadProfileImage();
    }else if(coverImage != null && profileImage != null)
    {} else
     {
       updateUser(
         name: name,
         phone: phone,
         bio: bio,
       );
     }
  }*/

  void updateUser({
    required String name,
    required String phone,
    required String bio,
    String? cover ,
    String? image ,
  })
  {
    SocialUserModel model = SocialUserModel(
      name: name,
      phone: phone,
      email: userModel!.email,
      image: image??userModel!.image,
      cover: cover??userModel!.cover,
      uId: userModel!.uId,
      bio: bio,
      isEmailVerified: false ,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .update(model.toMap())
        .then((value)
    {
      getUserData();
    })
        .catchError((error){
      emit(SocialUserUpdateErrorState());
    });
  }

  File? postImage ;
  Future<void> getPostImage ()async
  {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if( pickedFile != null)
    {
      postImage = File(pickedFile.path);
      emit(SocialPostImagePickedSuccessState());
    }else{
      print('No Image Selected');
      emit(SocialPostImagePickedErrorState());
    }
  }

  void removePostImage()
  {
    postImage = null ;
    emit(SocialRemovePostImageState());
  }
  void uploadPostImage({
    required String dateTime,
    required String text,
  })
  {
    emit(SocialCreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value)
    {
      value.ref.getDownloadURL().then((value) {
        print(value);
        createPost(
          text: text,
          dateTime: dateTime,
          postImage: value,
        );
      }).catchError((error){
        emit(SocialCreatePostErrorState());
      });
    }).catchError((error){
      emit(SocialCreatePostErrorState());
    });
  }

  void createPost({
    required String dateTime,
    required String text,
    String? postImage ,
  })
  {
    emit(SocialCreatePostLoadingState());
    PostModel model = PostModel(
      name: userModel!.name,
      uId: userModel!.uId,
      image: userModel!.image,
      dateTime: dateTime,
      text: text ,
      postImage: postImage??'',
    );

    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
          emit(SocialCreatePostSuccessState());
    }).catchError((error){
      emit(SocialCreatePostErrorState());
    });
  }


  List<PostModel> posts =[];
  List<String> postId =[];
  List<int> likes =[];
  List<int> comments =[];

  void getPosts()
  {
    FirebaseFirestore.instance
        .collection('posts')
        .get()
        .then((value){
          for (var element in value.docs) {
            element.reference
            .collection('likes')
            .get()
            .then((value) {
              likes.add(value.docs.length);
              comments.add(value.docs.length);
              postId.add(element.id);
              posts.add(PostModel.fromJson(element.data()));
            }).catchError((error){});
          }
          emit(SocialGetPostSuccessState());
    }).catchError((error){
          emit(SocialGetPostErrorState(error.toString()));
    });
  }

  void likePost(String postId)
  {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uId)
        .set({'like':true})
        .then((value) {
          emit(SocialLikePostSuccessState());
    }).catchError((error){
      emit(SocialLikePostErrorState(error.toString()));
    });
  }

  void commentPost({
    required String text,
    required String dateTime,
    String? postId,
})
  {
    CommentModel model =CommentModel(
      name: userModel!.name,
      uId: userModel!.uId,
      dateTime: dateTime,
      text: text,
    );
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(userModel!.uId)
        .set(model.toMap())
        .then((value) {
      emit(SocialCommentPostSuccessState());
    }).catchError((error){
      emit(SocialCommentPostErrorState(error.toString()));
    });
  }

  List<SocialUserModel> users =[];

  void getUsers()
  {
    if(users.isEmpty) {
      FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((value){
      for (var element in value.docs) {
        if(element.data()['uId'] != userModel!.uId)
        {
          users.add(SocialUserModel.fromJson(element.data()));
        }
      }
      emit(SocialGetAllUserSuccessState());
    }).catchError((error){
      emit(SocialGetAllUserErrorState(error.toString()));
    });
    }
  }

  void sendMessage({
    required String receiverId ,
    required String dateTime ,
    required String text ,
})
  {
    MessageModel model = MessageModel(
      text: text,
      dateTime: dateTime,
      receiverId: receiverId,
      senderId: userModel!.uId,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
          saveNotifications(NotificationModel(
              senderName: userModel!.name,
              senderImage:  userModel!.image,
              dateTime: dateTime));
          emit(SocialSendMessageSuccessState());
        })
        .catchError((error){
          emit(SocialSendMessageErrorState());
        });

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    })
        .catchError((error){
      emit(SocialSendMessageErrorState());
    });
  }

  List<MessageModel> messages = [];

  void getMessages({
    required String receiverId ,
})
  {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
           messages = [];
           for (var element in event.docs) {
             messages.add(MessageModel.fromJson(element.data()));
          }
          emit(SocialGetMessagesSuccessState());
        });
  }

  Future<void> logOut(context)async
  {
    await FirebaseAuth.instance
        .signOut()
        .then((value) {
          users =[];
          messages=[];
          postId=[];
          posts=[];
          likes=[];
          userModel=null;
          currentIndex=0;
          CacheHelper.removeData(key: 'uId');
          navigateAndFinish(context, SocialLoginScreen());
      emit(SocialLogOutSuccessState());
    }).catchError((error){
      emit(SocialLogOutErrorState(error.toString()));
    });
  }

  // save Notifications.......
  void saveNotifications (NotificationModel notification){
    FirebaseFirestore.instance
        .collection('notifications')
        .add(notification.toMap());
  }

  //get notifications.........
  List<NotificationModel> notificationList = [];
  Future<void> getNotifications() async
  {
    notificationList.clear();
    await FirebaseFirestore.instance
        .collection('notifications')
        .orderBy('dateTime',descending: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        notificationList.add(NotificationModel.fromJson(element.data()));
      }

    });
  }

  Future<void> handleRefresh() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(seconds: 3), () {
      completer.complete();
    });
    return completer.future.then<void>((_) {
      FirebaseFirestore.instance.collection('posts').get().then((value) {
        // posts = [];
        value.docs.forEach((element) {
          element.reference.collection('likes').get().then((value) {
            likes.add(value.docs.length);
            postId.add(element.id);
            posts.add(PostModel.fromJson(element.data()));
          }).catchError((error) {});
        });
        emit(SocialGetPostSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(SocialGetPostErrorState(error.toString()));
      });
    });
  }
}

