
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/notification_model.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class NotificationScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit , SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Notification'),
            leading: IconButton(
              onPressed: (){Navigator.pop(context);},
              icon: Icon(IconBroken.Arrow___Left_2),
            ),
          ),
          body: Container(),
          /*ListView.separated(
            itemBuilder: (context, index) => buildNotificationItem(SocialCubit.get(context).notificationList[index],context) ,
            separatorBuilder: (context, index) => const SizedBox(height: 15.0,),
            itemCount: 10,
          ),*/
        );
      },
    );
  }
  Widget buildNotificationItem(NotificationModel model ,context) =>InkWell(
    onTap: () {},
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30.0,
            backgroundImage: NetworkImage('${model.senderImage}'),
          ),
          const SizedBox(width: 15.0,),
          Column(
            children:
            [
              Row(
                children: [
                  Text('${model.senderName}'),
                ],
              ),
              const SizedBox(height: 8.0,),
              Text('${model.dateTime}'),
            ],
          ),
        ],
      ),
    ),
  );
}
