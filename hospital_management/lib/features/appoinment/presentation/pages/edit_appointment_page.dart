import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hospital_management/core/common_keys/common_keys.dart';
import 'package:hospital_management/features/appoinment/data/model/get_appointment_model.dart';
import 'package:hospital_management/features/appoinment/presentation/bloc/appointment_event.dart';
import 'package:hospital_management/features/appoinment/presentation/bloc/appointment_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/base/base_bloc.dart';
import '../../../../core/error_bloc_builder/error_builder_listener.dart';
import '../../../../core/strings/strings.dart';
import '../../../../custom/progress_bar.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/device_file.dart';
import '../../../../utils/style.dart';
import '../../../../widget/custom_appbar.dart';
import '../../../../widget/date_picker.dart';
import '../../../../widget/drop_down.dart';
import '../../../../widget/text_field.dart';
import '../bloc/appointment_bloc.dart';

class UpdateAppointmentPage extends StatefulWidget {
  String patientId;
  GetAppointmentModel? getAppointmentModel;
  int index;
   UpdateAppointmentPage({Key? key,required this.patientId, this.getAppointmentModel, required this.index}) : super(key: key);

  @override
  _UpdateAppointmentPageState createState() => _UpdateAppointmentPageState();
}

class _UpdateAppointmentPageState extends State<UpdateAppointmentPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController timeSlotController = TextEditingController();
  TextEditingController appointmentDateController = TextEditingController();
  TextEditingController diseaseController = TextEditingController();
  File? fileForProfilePic;
  File? fileForReport;
  List<String> timeSlotDropDown = [
    Strings.kSelectTimeSlot,
    Strings.kTimeSlot1,
    Strings.kTimeSlot2
  ];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    firstNameController.text = widget.getAppointmentModel!.data![widget.index].firstName ?? "";
    lastNameController.text = widget.getAppointmentModel!.data![widget.index].lastName ?? "";
    mobileNumberController.text = widget.getAppointmentModel!.data![widget.index].mobileNumber!.substring(3);
    timeSlotController.text = widget.getAppointmentModel!.data![widget.index].timeSlot ?? "";
    appointmentDateController.text = widget.getAppointmentModel!.data![widget.index].appointmentDate ?? "";
    diseaseController.text = widget.getAppointmentModel!.data![widget.index].disease ?? "";
    fileForProfilePic = File(widget.getAppointmentModel!.data![widget.index].patientProfilePic ?? "");
    fileForReport = File(widget.getAppointmentModel!.data![widget.index].fileData ?? "");
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 100),
        child: CustomAppBar(title: Strings.kUpdateAppointment,isBackPress: true),
      ),
      body: ErrorBlocListener<AppointmentBloc>(
        bloc: BlocProvider.of<AppointmentBloc>(context),
        child:  BlocBuilder<AppointmentBloc, BaseState>(builder: (context, state)  {
          return  Form(
            key: _formKey,
            child: buildWidget(),
          );
        }),
      ),
    );
  }

  buildWidget(){
    return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 20,),
              Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    //fit: StackFit.expand,
                    children: [
                      GestureDetector(
                        child: CircleAvatar(
                          radius: DeviceUtil.isTablet ? 75 : 48,
                          backgroundColor: Colors.transparent,
                          backgroundImage: (fileForProfilePic!.path == null || fileForProfilePic!.path == "")
                              ? const AssetImage(
                            Strings.kPersonImage,
                          )
                              : fileForProfilePic.toString().contains(CommonKeys.K_Patient_Profile_Pic_Files)
                              ? NetworkImage(
                            "${Strings.baseUrl}${fileForProfilePic?.path}",
                          )
                              : FileImage(
                            fileForProfilePic!,
                          ) as ImageProvider,
                        ),
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: Theme(
                                    data: ThemeData(
                                        bottomSheetTheme:
                                        const BottomSheetThemeData(
                                            backgroundColor: Colors.black,
                                            modalBackgroundColor:
                                            Colors.grey)),
                                    child: showSheetForImage()),
                              ));
                        },
                      ),
                      Positioned(
                        bottom: 3,
                        right: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 3,
                              color: Colors.white,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(
                                50,
                              ),
                            ),
                            color: CustomColors.colorDarkBlue,
                          ),
                          child: InkWell(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(
                                Icons.edit_outlined,
                                color: Colors.white,
                                size: DeviceUtil.isTablet ? 20 : 15,
                              ),
                            ),
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) => GestureDetector(
                                    onTap: () => Navigator.of(context).pop(),
                                    child: Theme(
                                        data: ThemeData(
                                            bottomSheetTheme:
                                            const BottomSheetThemeData(
                                                backgroundColor:
                                                Colors.black,
                                                modalBackgroundColor:
                                                Colors.grey)),
                                        child: showSheetForImage()),
                                  ));
                            },
                          ),
                        ),
                      ),
                    ],
                  )),
              const SizedBox(height: 20,),
              CustomTextField(
                key: const Key(Strings.kFirstNameKey),
                label: Strings.kFirstNameLabel,
                hint: Strings.kFirstNameHint,
                errorMessage: Strings.kFirstNameErrorMessage,
                textEditingController: firstNameController,
              ),
              const SizedBox(height: 10,),
              CustomTextField(
                key: const Key(Strings.kLastNameKey),
                label: Strings.kLastNameLabel,
                hint: Strings.kLastNameHint,
                errorMessage: Strings.kLastNameErrorMessage,
                textEditingController: lastNameController,
              ),
              const SizedBox(height: 10,),
              CustomTextField(
                key: const Key(Strings.kMobileKey),
                label: Strings.kMobileLabel,
                hint: Strings.kMobileHint,
                errorMessage: Strings.kMobileErrorMessage,
                isMobile: true,
                textInputType: TextInputType.phone,
                textEditingController: mobileNumberController,
              ),
              const SizedBox(height: 10,),
              CustomTextField(
                key: const Key(Strings.kDiseaseKey),
                label: Strings.kDiseaseLabel,
                hint: Strings.kDiseaseHint,
                errorMessage: Strings.kDiseaseErrorMessage,
                textEditingController: diseaseController,
              ),
              const SizedBox(height: 10,),
              DropDown(
                controller: timeSlotController,
                dropDownList: timeSlotDropDown,
                selectedValue:  timeSlotController.text,
                label: Strings.kSelectTimeSlotLabel,
                errorMessage: Strings.kSelectTimeSlotLabel,
              ),
              const SizedBox(height: 10,),
              DatePicker(
                dateController: appointmentDateController,
                lableText: Strings.kAppointmentDate,
                firstDate: DateTime.now(),
                lastDate: DateTime(2024),
                errorMessage: Strings.kAppointmentDateErrorMessage,
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  (fileForReport?.path != null && fileForReport!.path.isNotEmpty)
                      ? Container(
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      width: MediaQuery.of(context).size.width / 2.5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey.shade500,width: 2)
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5,vertical: 7),
                        child: Row(
                          children: [
                            Icon(Icons.picture_as_pdf_outlined,color: Colors.red),
                            SizedBox(width: 5,),
                            Flexible(child: Text(
                              fileForReport?.path.split('/').last ?? "",
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                            ))
                          ],
                        ),
                      )
                  )
                      : const SizedBox(),
                  TextButton(
                    onPressed: (){
                      getFromGalleryForReport();
                    },
                    child:  Text(
                      Strings.kUploadFile,
                      style: CustomTextStyle.styleMedium.copyWith(color: CustomColors.colorDarkBlue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if(_formKey.currentState!.validate()){
                          _formKey.currentState?.save();
                          FocusScope.of(context).unfocus();
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          var patientId = prefs.getString(CommonKeys.K_Id);
                          _updateAppointment(
                              doctorId: widget.getAppointmentModel!.data![widget.index].doctorData!.id.toString() ,
                              firstName: firstNameController.text,
                              lastName: lastNameController.text,
                              appointmentDate: appointmentDateController.text,
                              bookingTime: getFormatedDate(DateTime.now().toString()),
                              fileData:  fileForReport!.path.isNotEmpty && !fileForReport!.path.contains('appointment_files') ? fileForReport!.path : "",
                              hospitalId: "",
                              mobileNumber: "+91${mobileNumberController.text}",
                              patientId: patientId,
                              staffId: "",
                              statusId: "1",
                              timeSlot: timeSlotController.text,
                              patientProfilePic: fileForProfilePic!.path.isNotEmpty && !fileForProfilePic!.path.contains('patient_profile_pic_files') ? fileForProfilePic!.path : "",
                              disease: diseaseController.text,
                            appointmentId: widget.getAppointmentModel!.data![widget.index].id.toString()
                          );
                        }else{
                          FocusScope.of(context).unfocus();
                          print(getFormatedDate(DateTime.now().toString()));
                          Fluttertoast.cancel();
                          Fluttertoast.showToast(
                              msg: Strings.kFillAllDetails,
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
                        Strings.kUpdateAppointment,
                        style: CustomTextStyle.styleSemiBold.copyWith(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        )
    );
  }
  Future<String> _updateAppointment({String? firstName,lastName,bookingTime,doctorId,patientId,staffId,hospitalId,
    mobileNumber,timeSlot,statusId,appointmentDate,fileData,disease,patientProfilePic,appointmentId}) {
    return Future.delayed(const Duration()).then((_) {
      ProgressDialog.showLoadingDialog(context);
      BlocProvider.of<AppointmentBloc>(context).add(
          UpdateAppointmentEvent(
              timeSlot: timeSlot,
              statusId: statusId,
              staffId: staffId,
              patientId: patientId,
              mobileNumber: mobileNumber,
              hospitalId: hospitalId,
              fileData: fileData,
              bookingTime: bookingTime,
              appointmentDate: appointmentDate,
              lastName: lastName,
              firstName: firstName,
              doctorId: doctorId,
              disease: disease,
              patientProfilePic: patientProfilePic,
            appointmentId: appointmentId
          ));
      return "";
    });
  }

  showSheetForImage() {
    return Material(
      child: Container(
        height: 150,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16)),
            color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.camera,
                    size: DeviceUtil.isTablet ? 35 : 27,
                  ),
                  onPressed: () {
                    Get.back();
                    getFromCamera();
                  },
                ),
                Text(
                  Strings.kCamera,
                  style: CustomTextStyle.styleBold,
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 120),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.image_outlined,
                      size: DeviceUtil.isTablet ? 35 : 27,
                    ),
                    onPressed: () {
                      Get.back();
                      getFromGallery();
                    },
                  ),
                  Text(
                    Strings.kGallery,
                    style: CustomTextStyle.styleBold,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        fileForProfilePic = File(pickedFile.path);
        print(fileForProfilePic);
      });
    }
  }

  getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        fileForProfilePic = File(pickedFile.path);
        print(fileForProfilePic);
      });
    }
  }

  getFormatedDate(date) {
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
    var inputDate = inputFormat.parse(date);
    var outputFormat = DateFormat('dd/MM/yyyy');
    print(outputFormat.format(inputDate));
    return outputFormat.format(inputDate);
  }

  getFromGalleryForReport() async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc'],
    );
    if (pickedFile != null) {
      setState(() {
        fileForReport = File(pickedFile.files.first.path ?? "");
        print(fileForReport);
      });
    }
  }
}
