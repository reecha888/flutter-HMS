import 'dart:collection';

import 'package:hospital_management_doctor/core/api_call/baseClient.dart';
import 'package:hospital_management_doctor/feature/authentication/data/datasourse/authentication_data_source.dart';
import 'package:hospital_management_doctor/feature/authentication/data/model/forgot_password_model.dart';
import 'package:hospital_management_doctor/feature/authentication/data/model/reset_password_model.dart';
import 'package:hospital_management_doctor/feature/authentication/data/model/sign_in_doctor.dart';
import 'package:hospital_management_doctor/feature/authentication/domain/usecases/forgot_password_usecase.dart';
import 'package:hospital_management_doctor/feature/authentication/domain/usecases/reset_password_usecase.dart';
import 'package:hospital_management_doctor/feature/authentication/domain/usecases/sign_in_doctor_usecase.dart';

class AuthenticationDataSourceImpl implements AuthenticationDataSource {
  final ApiClient _apiClient;

  AuthenticationDataSourceImpl(this._apiClient);

  @override
  Future<SignInDoctorModel> signInDoctorCall(SignInParams params) async{
    var map =  HashMap<String, String>();
    map['email'] = params.email;
    map['password'] = params.password;
    final response = await _apiClient.doctorLogIn(map);
    var data ;
    if(response != null ){
      data = response;
      return data;
    }else {
      print('failed');
    }
    return data;
  }

  @override
  Future<ForgotPasswordModel> forgotPasswordCall(ForgotPasswordParams params) async {
    var map = new HashMap<String, String>();
    map['email'] = params.email;
    final response = await _apiClient.forgotPassword(map);
    var data ;
    if(response != null ){
      data = response;
      return data;
    }else {
      print('failed');
    }
    return data;
  }

  @override
  Future<ResetPasswardModel> resetPasswordCall(ResetPasswordParams params) async {
    var map = new HashMap<String, String>();
    map['new_password'] = params.password;
    map['otp'] = params.OTP;
    final response = await _apiClient.resetPassword(map);
    var data ;
    if(response != null ){
      data = response;
      return data;
    }else {
      print('failed');
    }
    return data;
  }



}