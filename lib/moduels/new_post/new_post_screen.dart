import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class NewPostScreen extends StatelessWidget {

  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit , SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {Navigator.pop(context);},
              icon:  const Icon(IconBroken.Arrow___Left_2),
            ),
            title: const Text('Create Post'),
            actions: [
              defaultTextButton(
                function: ()
                {
                  var now = DateTime.now();
                  if(SocialCubit.get(context).postImage == null)
                    {
                      SocialCubit.get(context).createPost(
                        dateTime: now.toString(),
                        text: textController.text,
                      );
                    }else
                      {
                        SocialCubit.get(context).uploadPostImage(
                          dateTime: now.toString(),
                          text: textController.text,
                        );
                      }
                },
                text: 'post',
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children:
              [
                if(state is SocialCreatePostLoadingState)
                  const LinearProgressIndicator(),
                if(state is SocialCreatePostLoadingState)
                  const SizedBox(height: 10.0,),
                Row(
                  children:
                   [
                    CircleAvatar(
                      radius: 25.0,
                      backgroundImage: NetworkImage(
                          '${SocialCubit.get(context).userModel!.image}'),
                    ),
                    const SizedBox(width: 15.0,),
                    Expanded(
                      child: Text(
                        '${SocialCubit.get(context).userModel!.name}',
                        style: const TextStyle(
                          height: 1.3,
                        ),
                      ),),
                  ],
                ),
                Expanded(
                  child: TextFormField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: 'what is on your mind ....',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                if(SocialCubit.get(context).postImage != null)
                  Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    Container(
                        height: 140.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius:  BorderRadius.circular(4.0),
                          image: DecorationImage(
                            image: FileImage(SocialCubit.get(context).postImage!) ,
                            fit: BoxFit.cover,
                          ),
                        )

                    ),
                    IconButton(
                      onPressed: () {
                        SocialCubit.get(context).removePostImage();
                      }
                      , icon: const CircleAvatar(
                        radius: 20.0,
                        child: Icon(
                          Icons.close,
                          size: 16.0,
                        )
                    ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0,),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                          onPressed: ()
                          {
                            SocialCubit.get(context).getPostImage();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:
                            const [
                              Icon(IconBroken.Image),
                              SizedBox(width: 5.0,),
                              Text('Add Photo'),
                            ],
                          ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {},
                        child: Text('# Tags'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
