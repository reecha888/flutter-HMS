import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospital_management/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:hospital_management/features/authentication/presentation/pages/login.dart';
import 'package:hospital_management/features/profile/data/model/get_patient_profile_model.dart';
import 'package:hospital_management/features/profile/presentation/bloc/patient_profile_bloc.dart';
import 'package:hospital_management/features/profile/presentation/bloc/patient_profile_event.dart';
import 'package:hospital_management/features/profile/presentation/bloc/patient_profile_state.dart';
import 'package:hospital_management/features/profile/presentation/pages/personal_information_page.dart';
import 'package:hospital_management/features/profile/presentation/pages/update_profile_page.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/base/base_bloc.dart';
import '../../../../core/error_bloc_builder/error_builder_listener.dart';
import '../../../../core/strings/strings.dart';
import '../../../../custom/progress_bar.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/device_file.dart';
import '../../../../utils/style.dart';
import '../../../../widget/custom_appbar.dart';
import '../../../authentication/presentation/bloc/allergies_bloc.dart';
import '../../../authentication/presentation/bloc/food_preference_bloc.dart';
import '../../../authentication/presentation/bloc/injuries_bloc.dart';
import '../../../authentication/presentation/bloc/medication_bloc.dart';
import '../../../authentication/presentation/bloc/surgery_bloc.dart';
import 'medical_information_page.dart';
import 'package:hospital_management/injection_container.dart' as Sl;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? imageFile;
  GetPatientProfileModel getPatientProfileModel = GetPatientProfileModel();
  int? patientId;


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      patientId  = int.parse(prefs.getString("id") ?? "");
      await _getPatientProfile(patientId!);
    });
    super.initState();
  }


  Future<String> _getPatientProfile(int id) {
    return Future.delayed(const Duration()).then((_) {
      // ProgressDialog.showLoadingDialog(context);
      BlocProvider.of<PatientProfileBloc>(context).add(
          GetPatientProfileEvent(id: id));
      return "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: CustomColors.colorDarkBlue,
      body: ErrorBlocListener<PatientProfileBloc>(
        bloc: BlocProvider.of<PatientProfileBloc>(context),
        // callback:  _loginUser(userName.text,tiePassword.text),
        child:  BlocBuilder<PatientProfileBloc, BaseState>(builder: (context, state)  {
          if(state is GetPatientProfileState) {
            ProgressDialog.hideLoadingDialog(context);
            getPatientProfileModel = state.model!;
          }
          return (getPatientProfileModel.data != null)  ? buildWidget() :
          Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }),
      ),
    );
  }

  buildWidget(){
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 4,
              decoration: const BoxDecoration(
                  color: CustomColors.colorDarkBlue,
              ),
              padding: EdgeInsets.all(0),
              child: Padding(
                padding: EdgeInsets.only(left: 14),
                child: InkWell(
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.arrow_back_ios,color: Colors.white,size: 20,),
                )
              )
            ),
            Flexible(child:
            Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.only(top: 8,left: 10,right: 10),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(25.0),
                      topLeft: Radius.circular(25.0))
              ),
              child: userDetailsList(),
            ),
            )
          ],
        ),
        Positioned(
          top: ((MediaQuery.of(context).size.height / 3.3) / 2) ,
          child:   userProfilePic(radius: 46.0,
            imagePath:
            (getPatientProfileModel.data?.profilePic != null && getPatientProfileModel.data?.profilePic != "")
                ? "${Strings.baseUrl}${getPatientProfileModel.data?.profilePic}"
                : "",),
        ),
      ],
    );
  }

  userDetailsList(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical:  20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 15,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(getPatientProfileModel.data!.firstName ?? ""),
                    Text("  ${getPatientProfileModel.data!.lastName}"),
                  ],
                ),
                SizedBox(height: 7,),
                Text(getPatientProfileModel.data!.contactNumber.toString().substring(3)),
              ],
            ),
            const SizedBox(height: 30,),
            customCard(title: "Personal information",
                index: 1,
                icon:  Icon(
                  Icons.person,
                  color: CustomColors.colorDarkBlue,
                  size: DeviceUtil.isTablet ? 30 : 25,
                )),
            const SizedBox(height: 15,),
            customCard(title: "Medical information",
                index: 2,
                icon: Icon(Icons.medical_information, color: CustomColors.colorDarkBlue,
                  size: DeviceUtil.isTablet ? 30 : 25,)),
/*            const SizedBox(height: 15,),
            customCard(title: "Other information",index: 3,
                icon: Icon(Icons.info_outline_rounded, color: CustomColors.colorDarkBlue,
                  size: DeviceUtil.isTablet ? 30 : 25,)),*/
            const SizedBox(height: 15,),
            customCard(title: "Update profile",
                index: 4,
                icon: Icon(Icons.edit, color: CustomColors.colorDarkBlue,
                  size: DeviceUtil.isTablet ? 30 : 25,)),
            const SizedBox(height: 15,),
            customCard(title: "Logout",
                index: 5,
                icon: Icon(Icons.logout, color: CustomColors.colorDarkBlue,
                  size: DeviceUtil.isTablet ? 30 : 25,)),
          ],
        ),
      ),
    );
  }
  customCard({String? title,Icon? icon,int? index}){
    return Card(
      color: Colors.grey.shade200,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          title: Text(title ?? ""),
         // leading: icon,
          trailing: Icon(Icons.arrow_forward_ios_rounded, color: CustomColors.colorDarkBlue,
            size: DeviceUtil.isTablet ? 30 : 20,),
          onTap: (){
            if(index == 1){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PersonalInformationPage(getPatientProfileModel: getPatientProfileModel)),
              );
            }else if(index == 2){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MedicalInformationPage(getPatientProfileModel: getPatientProfileModel)),
              );
            }else if(index == 4){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MultiBlocProvider(
                      providers: [
                        BlocProvider<PatientProfileBloc>(
                          create: (context) => Sl.Sl<PatientProfileBloc>(),
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
                      ],
                      child: UpdateProfilePage(getPatientProfileModel: getPatientProfileModel),
                    )),
              ).then((value) async {
                BlocProvider.of<PatientProfileBloc>(context).add(
                    GetPatientProfileEvent(id: patientId!));
              });
            }else if(index == 5){
              showDialog(
                context: context,
                builder: (ctx) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child:  AlertDialog(
                    title:  Text(
                      "Logout",
                      style: TextStyle(fontSize:  DeviceUtil.isTablet ? 18 : 14),
                    ),
                    content:  Container(
                      child: Text(
                        "Are you sure you want to logout?",
                        softWrap: true,
                        overflow: TextOverflow.fade,
                        style:  CustomTextStyle.styleMedium.copyWith(
                            fontSize: DeviceUtil.isTablet ? 18 : 14
                        ),
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.clear();
                          prefs.setString("isOnBoardingCompleted", "true");
                          print(prefs);
                          Future.delayed(Duration.zero, () {
                            Navigator.pushAndRemoveUntil(
                              context,MaterialPageRoute(builder: (context) =>BlocProvider<AuthenticationBloc>(
                              create: (context) => Sl.Sl<AuthenticationBloc>(),
                              child: LoginScreen(),
                            )),
                                  (route) => false,
                            );
                          });
                        },
                        child: Text(
                          "Yes",
                          style: CustomTextStyle.styleSemiBold
                              .copyWith(color: CustomColors.colorDarkBlue, fontSize:
                          DeviceUtil.isTablet ? 18 : 16),),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        )
    );
  }

  userProfilePic({radius=24.0,String? imagePath}) {
    return CircleAvatar(
      radius: radius,
      backgroundImage:  Image.network(
          (imagePath == null || imagePath == "")
              ? "https://mpng.subpng.com/20190123/jtv/kisspng-computer-icons-vector-graphics-person-portable-net-myada-baaranmy-teknik-servis-hizmetleri-5c48d5c2849149.051236271548277186543.jpg"
              : imagePath)
          .image,
    );
  }
}
