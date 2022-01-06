

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/moduels/new_post/new_post_screen.dart';
import 'package:social_app/moduels/notifications/notification_screen.dart';
import 'package:social_app/moduels/search/search_screen.dart';
import 'package:social_app/moduels/social_login/login_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class SocialLayout extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit , SocialStates>(
     listener: (context, state) {
       if(state is SocialNewPostState)
         {
           navigateTO(context, NewPostScreen());
         }
     },
      builder: (context, state) {
       var cubit = SocialCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(cubit.titles[cubit.currentIndex]),
            actions: [
              IconButton(
                  onPressed: (){
                    navigateTO(context, NotificationScreen());
                  },
                  icon: const Icon(IconBroken.Notification)),
              IconButton(
                  onPressed: (){
                    navigateTO(context, SearchScreen());
                  },
                  icon: const Icon(IconBroken.Search)),
              IconButton(
                  onPressed: (){
                    SocialCubit.get(context).logOut(context);
                  },
                  icon: const Icon(IconBroken.Logout)),
            ],

          ),
          body:cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index) {cubit.changeBottomNav(index);},
            items: [
              BottomNavigationBarItem(
                  icon: Icon(IconBroken.Home) ,
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(IconBroken.Chat) ,
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(IconBroken.Paper_Upload) ,
                label: 'Post',
              ),
              BottomNavigationBarItem(
                icon: Icon(IconBroken.Location) ,
                label: 'Users',
              ),
              BottomNavigationBarItem(
                icon: Icon(IconBroken.Setting) ,
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }
}
