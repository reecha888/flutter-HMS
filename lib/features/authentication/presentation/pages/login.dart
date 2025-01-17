import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hospital_management/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:hospital_management/features/authentication/presentation/bloc/authentication_event.dart';
import 'package:hospital_management/features/authentication/presentation/bloc/authentication_state.dart';
import 'package:hospital_management/features/authentication/presentation/pages/forgot_password.dart';
import 'package:hospital_management/features/authentication/presentation/pages/sign_up_screen_main.dart';
import 'package:hospital_management/utils/device_file.dart';
import 'package:hospital_management/utils/style.dart';
import 'package:hospital_management/widget/text_field_with_border.dart';
import 'package:hospital_management/injection_container.dart' as Sl;

import '../../../../core/base/base_bloc.dart';
import '../../../../core/error_bloc_builder/error_builder_listener.dart';
import '../../../../custom/progress_bar.dart';
import '../../../../utils/colors.dart';
import '../../../../widget/custom_appbar.dart';
import '../../../home.dart';
import '../bloc/allergies_bloc.dart';
import '../bloc/food_preference_bloc.dart';
import '../bloc/injuries_bloc.dart';
import '../bloc/medication_bloc.dart';
import '../bloc/surgery_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ErrorBlocListener<AuthenticationBloc>(
          bloc: BlocProvider.of<AuthenticationBloc>(context),
          // callback:  _loginUser(userName.text,tiePassword.text),
          child:  BlocBuilder<AuthenticationBloc, BaseState>(builder: (context, state)  {
            if(state is SignInPatientState) {
              ProgressDialog.hideLoadingDialog(context);
              Future.delayed(Duration.zero, () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Home()),
                        (route) => false);
              });
            }
            return Form(
                key: _formKey,
                child: buildWidget());
          }),
      ),
    );
  }

  buildWidget(){
    return Padding(
      padding: EdgeInsets.only(top: 80,right: 40, left: 40),
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Center(
                            child: Container(
                              height: 200,
                              width: 200,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/images/patient.jpeg"),
                                    fit: BoxFit.fill,
                                  )
                              ),
                            ),
                          ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "LOGIN",
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontStyle: FontStyle.normal,
                                    fontFamily: 'Open Sans',
                                    fontSize: 28,
                                  color: CustomColors.colorDarkBlue
                                ),
                              ),
                              Text(
                                "PAGE",
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontStyle: FontStyle.normal,
                                    fontFamily: 'Open Sans',
                                    fontSize: 28,
                                    color: CustomColors.colorPowerBlue
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10,),
                        CustomTextFieldWithBorder(
                          key: const Key("tefEmail"),
                          label: "Email Address",
                          hint: "Enter Email",
                          errorMessage: "Please Enter Email",
                          isEmail: true,
                          textInputType: TextInputType.emailAddress,
                          textEditingController: emailController,
                        ),
                        const SizedBox(height: 20,),
                        CustomTextFieldWithBorder(
                          key: const Key("tefPassword"),
                          label: "Password",
                          hint: "Enter Password",
                          errorMessage: "Please Enter Password",
                          textEditingController: passwordController,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              child: Text(
                                "Forgot Password ?",
                                style: CustomTextStyle.styleMedium.copyWith(
                                    color: CustomColors.colorDarkBlue,
                                  fontSize: DeviceUtil.isTablet ? 16 : 14
                                ),
                              ),
                              onPressed: (){
                                Future.delayed(Duration.zero, () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>BlocProvider<AuthenticationBloc>(
                                      create: (context) => Sl.Sl<AuthenticationBloc>(),
                                      child: ForgotPasswordScreen(),
                                    )),
                                  );
                                });
                              },
                            )
                          ],
                        ),
                        const SizedBox(height: 10,),
                       Row(
                         children: [
                           Expanded(
                             child: ElevatedButton(
                               onPressed: (){
                                 if(_formKey.currentState!.validate()){
                                   _formKey.currentState?.save();
                                   FocusScope.of(context).unfocus();
                                   _loginPatient(emailController.text,passwordController.text);
                                 }else{
                                   FocusScope.of(context).unfocus();
                                   Fluttertoast.cancel();
                                   Fluttertoast.showToast(
                                       msg: "Please fill all the details.",
                                       toastLength: Toast.LENGTH_LONG,
                                       fontSize: DeviceUtil.isTablet ? 20 : 12,
                                       backgroundColor: CustomColors.colorDarkBlue,
                                       textColor: Colors.white
                                   );
                                 }
                               },
                               style: ElevatedButton.styleFrom(
                                 primary: CustomColors.colorDarkBlue,
                                 shape: StadiumBorder(),
                               ),
                               child:  Text(
                                   "Log In",
                                 style: CustomTextStyle.styleSemiBold.copyWith(color: Colors.white),
                               ),
                             ),
                           )
                         ],
                       ),
                        const SizedBox(height: 20,),
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: CustomTextStyle.styleMedium,
                    ),
                    TextButton(
                      child: Text(
                        "Sign up here",
                        style: CustomTextStyle.styleMedium.copyWith(
                          color: CustomColors.colorDarkBlue,),
                      ),
                      onPressed: (){
                        Future.delayed(Duration.zero, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MultiBlocProvider(providers: [
                                  BlocProvider<AuthenticationBloc>(
                                    create: (context) => Sl.Sl<AuthenticationBloc>(),
                                  ),
                                  BlocProvider<AllergiesBloc>(
                                    create: (context) => Sl.Sl<AllergiesBloc>(),
                                  ),
                                  BlocProvider<MedicationBloc>(
                                    create: (context) => Sl.Sl<MedicationBloc>(),
                                  ),
                                  BlocProvider<InjuryBloc>(
                                    create: (context) => Sl.Sl<InjuryBloc>(),
                                  ),
                                  BlocProvider<SurgeryBloc>(
                                    create: (context) => Sl.Sl<SurgeryBloc>(),
                                  ),
                                  BlocProvider<FoodPreferenceBloc>(
                                    create: (context) => Sl.Sl<FoodPreferenceBloc>(),
                                  ),
                                ], child: SignUpScreenMain())),
                          );
                        });
                       /* Future.delayed(Duration.zero, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>BlocProvider<AuthenticationBloc>(
                              create: (context) => Sl.Sl<AuthenticationBloc>(),
                              child: SignUpScreenMain(),
                            )),
                          );
                        });*/
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<String> _loginPatient(String email,String password) {
    return Future.delayed(Duration()).then((_) {
      ProgressDialog.showLoadingDialog(context);
      BlocProvider.of<AuthenticationBloc>(context).add(
          SignInPatientEvent(email: email.trim(), password: password.trim()));
      return "";
    });
  }
}
