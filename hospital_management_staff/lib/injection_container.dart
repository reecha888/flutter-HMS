import 'dart:collection';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hospital_management_staff/core/failure/error_object.dart';
import 'package:hospital_management_staff/core/strings/strings.dart';
import 'package:hospital_management_staff/feature/appointments/data/datasourse/appointment_data_sourse.dart';
import 'package:hospital_management_staff/feature/appointments/data/datasourse/appointment_data_sourse_impl.dart';
import 'package:hospital_management_staff/feature/appointments/data/repositories/appointment_repositories.dart';
import 'package:hospital_management_staff/feature/appointments/domain/repositories/appointment_repositories.dart';
import 'package:hospital_management_staff/feature/appointments/domain/usecases/get_appointment_status_usecase.dart';
import 'package:hospital_management_staff/feature/appointments/domain/usecases/get_appointment_usecase.dart';
import 'package:hospital_management_staff/feature/appointments/presentation/bloc/appointment_bloc.dart';
import 'package:hospital_management_staff/feature/appointments/presentation/bloc/appointment_status_bloc.dart';
import 'package:hospital_management_staff/feature/authentication/data/datasourse/authentication_data_source.dart';
import 'package:hospital_management_staff/feature/authentication/data/datasourse/authentication_data_source_impl.dart';
import 'package:hospital_management_staff/feature/authentication/data/repositories/authentication_repositories.dart';
import 'package:hospital_management_staff/feature/authentication/domain/repositories/authentication_repositories.dart';
import 'package:hospital_management_staff/feature/authentication/domain/usecases/forgot_password_usecase.dart';
import 'package:hospital_management_staff/feature/authentication/domain/usecases/reset_password_usecase.dart';
import 'package:hospital_management_staff/feature/authentication/domain/usecases/sign_in_doctor_usecase.dart';
import 'package:hospital_management_staff/feature/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:hospital_management_staff/feature/medicine/data/datasourse/medicine_data_sourse.dart';
import 'package:hospital_management_staff/feature/medicine/data/datasourse/medicine_data_sourse_impl.dart';
import 'package:hospital_management_staff/feature/medicine/data/repositories/medicine_repositories.dart';
import 'package:hospital_management_staff/feature/medicine/domain/repositories/medicine_repositories.dart';
import 'package:hospital_management_staff/feature/medicine/domain/usecases/add_medicine_usecase.dart';
import 'package:hospital_management_staff/feature/medicine/domain/usecases/delete_medicine_usecase.dart';
import 'package:hospital_management_staff/feature/medicine/domain/usecases/get_medicine_usecase.dart';
import 'package:hospital_management_staff/feature/medicine/domain/usecases/update_medicine_usecase.dart';
import 'package:hospital_management_staff/feature/medicine/presentation/bloc/medicine_bloc.dart';
import 'package:hospital_management_staff/feature/patient/data/datasourse/patient_data_sourse.dart';
import 'package:hospital_management_staff/feature/patient/data/datasourse/patient_data_sourse_impl.dart';
import 'package:hospital_management_staff/feature/patient/data/repositories/patient_repositories.dart';
import 'package:hospital_management_staff/feature/patient/domain/repositories/patient_repositories.dart';
import 'package:hospital_management_staff/feature/patient/domain/usecases/get_patient_usecase.dart';
import 'package:hospital_management_staff/feature/patient/presentation/bloc/patient_bloc.dart';
import 'package:hospital_management_staff/feature/profile/data/datasourse/profile_data_sourse.dart';
import 'package:hospital_management_staff/feature/profile/data/datasourse/profile_data_sourse_impl.dart';
import 'package:hospital_management_staff/feature/profile/data/repositories/profile_repositories.dart';
import 'package:hospital_management_staff/feature/profile/domain/repositories/profile_repositories.dart';
import 'package:hospital_management_staff/feature/profile/domain/usecases/get_profile_usecase.dart';
import 'package:hospital_management_staff/feature/profile/domain/usecases/update_profile_usecase.dart';
import 'package:hospital_management_staff/feature/profile/presentation/bloc/profile_bloc.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'core/api_call/base_client.dart';




final Sl = GetIt.instance;

Future<void> init() async {
  var dio = await createDioClient();
  Sl.registerFactory<Dio>(() => dio);

  Sl.registerSingleton(ApiClient(Sl.get()));


  //bloc

  Sl.registerFactory(() => AuthenticationBloc(
      signInDoctorUsecase:  Sl.call(),
      forgotPasswordUsecase: Sl.call(),
      resetPasswordUsecase: Sl.call()
  ));

  Sl.registerFactory(() => ProfileBloc(
      getProfileUsecase:  Sl.call(),
      updateProfileUsecase: Sl.call()
  ));

  Sl.registerFactory(() => PatientBloc(
    getPatientUsecase:  Sl.call(),
  ));

  Sl.registerFactory(() => AppointmentBloc(
    getAppointmentUsecase:  Sl.call(),
  ));

  Sl.registerFactory(() => AppointmentStatusBloc(
    getAppointmentStatusUsecase:  Sl.call(),
  ));

  Sl.registerFactory(() => MedicineBloc(
    addMedicineUsecase:  Sl.call(),
    getMedicineUsecase: Sl.call(),
    updateMedicineUsecase: Sl.call(),
    deleteMedicineUsecase: Sl.call()
  ));



  // Use cases

  Sl.registerLazySingleton(() => SignInDoctorUsecase(authenticationRepositories: Sl()));
  Sl.registerLazySingleton(() => ForgotPasswordUsecase(authenticationRepositories: Sl()));
  Sl.registerLazySingleton(() => ResetPasswordUsecase(authenticationRepositories: Sl()));
  Sl.registerLazySingleton(() => GetProfileUsecase(profileRepositories: Sl()));
  Sl.registerLazySingleton(() => UpdateProfileUsecase(profileRepositories: Sl()));
  Sl.registerLazySingleton(() => GetPatientUsecase(patientRepositories: Sl()));
  Sl.registerLazySingleton(() => GetAppointmentUsecase(appointmentRepositories: Sl()));
  Sl.registerLazySingleton(() => GetAppointmentStatusUsecase(appointmentRepositories: Sl()));
  Sl.registerLazySingleton(() => AddMedicineUsecase(medicineRepositories: Sl()));
  Sl.registerLazySingleton(() => GetMedicineUsecase(medicineRepositories: Sl()));
  Sl.registerLazySingleton(() => UpdateMedicineUsecase(medicineRepositories: Sl()));
  Sl.registerLazySingleton(() => DeleteMedicineUsecase(medicineRepositories: Sl()));


  // Repository

  Sl.registerLazySingleton<AuthenticationRepositories>(
        () => AuthenticationRepositoriesImpl(authenticationDataSource: Sl()),
  );

  Sl.registerLazySingleton<ProfileRepositories>(
        () => ProfileRepositoriesImpl(profileDataSource: Sl()),
  );

  Sl.registerLazySingleton<PatientRepositories>(
        () => PatientRepositoriesImpl(patientDataSource: Sl()),
  );

  Sl.registerLazySingleton<AppointmentRepositories>(
        () => AppointmentRepositoriesImpl(appointmentDataSource: Sl()),
  );

  Sl.registerLazySingleton<MedicineRepositories>(
        () => MedicineRepositoriesImpl(medicineDataSource: Sl()),
  );



  // Local Data sources

  Sl.registerLazySingleton<AuthenticationDataSource>(
        () => AuthenticationDataSourceImpl(Sl.get()),
  );

  Sl.registerLazySingleton<ProfileDataSource>(
        () => ProfileDataSourceImpl(Sl.get()),
  );


  Sl.registerLazySingleton<PatientDataSource>(
        () => PatientDataSourceImpl(Sl.get()),
  );

  Sl.registerLazySingleton<AppointmentDataSource>(
        () => AppointmentDataSourceImpl(Sl.get()),
  );

  Sl.registerLazySingleton<MedicineDataSource>(
        () => MedicineDataSourceImpl(Sl.get()),
  );


}

Future<Dio> createDioClient() async {
  Dio dio = Dio();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var authToken = prefs.getString(Strings.kAccess);
  Map<String, dynamic> headers = {};
  if (authToken != null && authToken != "") {
    headers[Strings.kAccept] = Strings.kApplicationJson;
    headers[Strings.kAuthorization] = authToken;
  }else{
    headers[Strings.kAccept] = Strings.kApplicationJson;
  }

  (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
      (HttpClient client) {
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  };

  dio.options.headers = headers;
  dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (request, handler) async {
        if (authToken != null && authToken != ''){
          var authToken1 = prefs.getString(Strings.kAccess);
          request.headers[Strings.kAuthorization] = 'Bearer $authToken1';
        }else {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var authToken = prefs.getString(Strings.kAccess);
          Map<String, dynamic> headers = {};
          if (authToken != null && authToken != "") {
            request.headers[Strings.kAuthorization] = 'Bearer $authToken';
          }else{
            request.headers[Strings.kAccept] = Strings.kApplicationJson;
          }
        }
        return handler.next(request);
      },
      onError: (err, handler) async {
        if (err.response?.statusCode == 401) {
          try {
            ErrorObject.logout();
          } catch (err, st) {
            print(err);
          }
        }else{
          handler.reject(err);
        }
      },
    ),
  );
  return dio;
}


