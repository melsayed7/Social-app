import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/shared/components/components.dart';

import 'package:social_app/shared/styles/icon_broken.dart';

class EditProfileScreen extends StatelessWidget {

  var nameController = TextEditingController();
  var bioController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit , SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = SocialCubit.get(context).userModel;
        var profileImage = SocialCubit.get(context).profileImage;
        var coverImage = SocialCubit.get(context).coverImage;

        nameController.text =userModel!.name!;
        bioController.text =userModel.bio!;
        phoneController.text =userModel.phone!;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {Navigator.pop(context);},
              icon:  const Icon(IconBroken.Arrow___Left_2),
            ),
            title: const Text('Edit Profile'),
            titleSpacing: 5.0,
            actions: [
              defaultTextButton(
                function: (){
                  SocialCubit.get(context).updateUser(
                      name: nameController.text,
                      phone: phoneController.text,
                      bio: bioController.text,
                  );
                },
                text: 'update',
              ),
              const SizedBox(width: 20.0,)
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if(state is SocialUserUpdateLoadingState)
                    const LinearProgressIndicator(),
                  if(state is SocialUserUpdateLoadingState)
                    const SizedBox(height: 10.0,),
                  Container(
                    height: 190.0,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Container(
                                  height: 140.0,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4.0),
                                      topRight: Radius.circular(4.0),
                                    ),
                                    image: DecorationImage(
                                      image: coverImage == null ?
                                          NetworkImage(
                                        '${userModel.cover}',
                                      ) :
                                          FileImage(coverImage) as ImageProvider ,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                              ),
                              IconButton(
                                  onPressed: () {
                                    SocialCubit.get(context).getCoverImage();
                                  }
                                  , icon: const CircleAvatar(
                                       radius: 20.0,
                                       child: Icon(
                                           IconBroken.Camera,
                                           size: 16.0,
                                       )
                              ),
                              ),
                            ],
                          ),
                          alignment: AlignmentDirectional.topCenter,
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 64.0,
                              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                radius: 60.0,
                                backgroundImage: profileImage == null ?
                                NetworkImage('${userModel.image}',) :
                                FileImage(profileImage) as ImageProvider,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                SocialCubit.get(context).getProfileImage();
                              }
                              , icon: const CircleAvatar(
                                radius: 20.0,
                                child: Icon(
                                  IconBroken.Camera,
                                  size: 16.0,
                                )
                            ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0,),
                  if(SocialCubit.get(context).profileImage != null || SocialCubit.get(context).coverImage != null)
                  Row(
                    children:
                    [
                      if(SocialCubit.get(context).profileImage != null)
                        Expanded(
                        child: Column(
                          children: [
                            defaultButton(
                              function: (){
                                SocialCubit.get(context).uploadProfileImage(
                                  name: nameController.text,
                                  phone: phoneController.text,
                                  bio: bioController.text,
                                );
                              },
                              text: 'update profile',
                            ),
                            if(state is SocialUserUpdateLoadingState)
                              const SizedBox(height: 5.0,),
                            if(state is SocialUserUpdateLoadingState)
                              const LinearProgressIndicator(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6.0,),
                      if(SocialCubit.get(context).coverImage != null)
                        Expanded(
                        child: Column(
                          children: [
                            defaultButton(
                              text: 'update cover',
                              function: (){
                                SocialCubit.get(context).uploadCoverImage(
                                  name: nameController.text,
                                  phone: phoneController.text,
                                  bio: bioController.text,
                                );
                              },
                            ),
                            if(state is SocialUserUpdateLoadingState)
                              const SizedBox(height: 5.0,),
                            if(state is SocialUserUpdateLoadingState)
                              const LinearProgressIndicator(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if(SocialCubit.get(context).profileImage != null || SocialCubit.get(context).coverImage != null)
                  const SizedBox(height: 20.0,),
                  defaultTextFeild(
                      controller: nameController,
                      type: TextInputType.name,
                      label: 'Name',
                      prefix: IconBroken.User,
                      validate: (value)
                        {
                          if(value!.isEmpty) {
                            return('Name Must Not Be Empty');
                          }
                        },
                  ),
                  const SizedBox(height: 15.0,),
                  defaultTextFeild(
                    controller: bioController,
                    type: TextInputType.text,
                    label: 'Bio ... ',
                    prefix: IconBroken.Info_Circle,
                    validate: (value)
                    {
                      if(value!.isEmpty) {
                        return('Bio Must Not Be Empty');
                      }
                    },
                  ),
                  const SizedBox(height: 15.0,),
                  defaultTextFeild(
                    controller: phoneController,
                    type: TextInputType.phone,
                    label: 'Phone',
                    prefix: IconBroken.Call,
                    validate: (value)
                    {
                      if(value!.isEmpty) {
                        return('Phone Must Not Be Empty');
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
