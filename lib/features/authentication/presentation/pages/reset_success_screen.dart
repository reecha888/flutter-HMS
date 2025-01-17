import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospital_management/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:hospital_management/features/authentication/presentation/pages/login.dart';

import '../../../../utils/colors.dart';
import '../../../../utils/style.dart';
import 'package:hospital_management/injection_container.dart' as Sl;

class ResetSuccess extends StatefulWidget {
  @override
  _ResetSuccessState createState() => _ResetSuccessState();
}

class _ResetSuccessState extends State<ResetSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: Container()),
            Image.asset(
              "assets/images/ic_reset_success.png",
              width: MediaQuery.of(context).size.width * .5,
              height: MediaQuery.of(context).size.width * .5,
            ),
            SizedBox(
              height: 24,
            ),
            Text(
              "Successful!",
              textAlign: TextAlign.center,
              style: CustomTextStyle.styleBold.copyWith(fontSize: 28),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              "You have successfully change password.\nPlease use your new password when\nlogging in.",
              textAlign: TextAlign.center,
              style: CustomTextStyle.styleMedium
                  .copyWith(fontSize: 14, color: Colors.grey.shade700),
            ),
            const SizedBox(
              height: 50,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,MaterialPageRoute(builder: (context) =>BlocProvider<AuthenticationBloc>(
                  create: (context) => Sl.Sl<AuthenticationBloc>(),
                  child: LoginScreen(),
                )),
                      (route) => false,
                );
              },
              child: Text(
                "Login",
                style: CustomTextStyle.styleBold
                    .copyWith(color: CustomColors.colorDarkBlue),
              ),
            ),
            Expanded(child: Container()),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}