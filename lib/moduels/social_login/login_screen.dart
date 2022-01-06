import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_layout.dart';
import 'package:social_app/moduels/social_register/social_register_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';

class SocialLoginScreen extends StatelessWidget {

  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SocialLoginCubit(),
      child: BlocConsumer<SocialLoginCubit , SocialLoginStates>(
        listener: (context, state)
        {
          if(state is SocialLoginErrorState)
            {
              showToast(text: state.error, state: ToastStates.ERROR);
            }
          if( state is SocialLoginSuccessState)
            {
              CacheHelper.saveData(
                  key: 'uId',
                  value: state.uId,
              ).then((value)
              {
                navigateAndFinish(context, SocialLayout());
              });
            }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOGIN',
                          style: Theme.of(context).textTheme.headline4!.copyWith(color: Colors.black),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          'Login now to communicate with friends',
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        defaultTextFeild(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          label: 'Email Address',
                          prefix: Icons.email_outlined,
                          validate: (value){
                            if(value!.isEmpty)
                            {
                              return('please enter your email address');
                            }
                          },
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        defaultTextFeild(
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          suffix: SocialLoginCubit.get(context).suffix,
                          isPassword: SocialLoginCubit.get(context).isPassword,
                          suffixPressed: (){
                            SocialLoginCubit.get(context).changePasswordVisibility();
                          },
                          label: 'Password',
                          prefix: Icons.lock_outlined,
                          validate: (value){
                            if(value!.isEmpty)
                            {
                              return('password is too short');
                            }
                          },
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! SocialLoginLoadingState ,
                          builder:(context) => defaultButton(
                            function: (){
                              if(formKey.currentState!.validate())
                              {
                              SocialLoginCubit.get(context).userLogin(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                              }
                            },
                            text: 'login',
                            isUppercase: true,
                          ),
                          fallback:(context) => const Center(child: CircularProgressIndicator()),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                                'Don\'t have an account?'
                            ),
                            defaultTextButton(
                              function: (){
                                navigateTO(context, SocialRegisterScreen());
                              },
                              text: 'register',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
