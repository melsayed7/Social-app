
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/social_layout.dart';
import 'package:social_app/moduels/social_login/login_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/network/remote/dio_helper.dart';
import 'package:social_app/shared/styles/themes.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async
{
  print('on Messaging Background App');
  print(message.data.toString());
  showToast(text: 'on Message Background App', state: ToastStates.SUCCESS );
}

void main()async{

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  var token = await FirebaseMessaging.instance.getToken();
  print(token);

  FirebaseMessaging.onMessage.listen((event) {
    print('on Message');
    print(event.data.toString());
    showToast(text: 'on Message', state: ToastStates.SUCCESS );
  });

  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print('on Message Opened App');
    print(event.data.toString());
    showToast(text: 'on Message Opened App', state: ToastStates.SUCCESS );
  });

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);


  DioHelper.init();
  await CacheHelper.init();

  Widget widget ;
  uId = CacheHelper.getData(key: 'uId');

  if(uId != null)
    {
      widget =SocialLayout();
    }else
      {
        widget =SocialLoginScreen();
      }


  runApp(MyApp(widget));
}

class MyApp extends StatelessWidget {

  final Widget startWidget ;

  MyApp(this.startWidget);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (BuildContext context) => SocialCubit()..getUserData()..getPosts() ,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme ,
        home: startWidget ,
      ),
    );
  }
}
