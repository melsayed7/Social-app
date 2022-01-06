import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/social_user_model.dart';
import 'package:social_app/moduels/chat_details/chat_details_screen.dart';
import 'package:social_app/shared/components/components.dart';

class ChatsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit , SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: SocialCubit.get(context).users.isNotEmpty,
          builder: (context) => ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => buildChatItem (SocialCubit.get(context).users[index],context) ,
            separatorBuilder: (context, index) => myDivider(),
            itemCount: SocialCubit.get(context).users.length ,
          ),
          fallback: (context) => const Center(child: CircularProgressIndicator()),
        );
      },
    ) ;
  }

  Widget buildChatItem (SocialUserModel model,context) => InkWell(
    onTap: ()
    {
      navigateTO(context, ChatDetailsScreen(
        userModel:model,
      ));
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children:  [
          CircleAvatar(
            radius: 25.0,
            backgroundImage: NetworkImage(
              '${model.image}',
            ),
          ),
          const SizedBox(width: 15.0,),
          Text(
            '${model.name}',
            style: const TextStyle(
              height: 1.3,
            ),
          ),
        ],
      ),
    ),
  );
}
