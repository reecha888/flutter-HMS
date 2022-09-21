

import 'package:hospital_management_staff/core/base/base_bloc.dart';
import 'package:hospital_management_staff/feature/appointments/data/model/get_appointment_model.dart';
import 'package:hospital_management_staff/feature/appointments/data/model/get_appointment_status.dart';

class GetAppointmentState extends BaseState {
  GetAppointmentModel? model;

  GetAppointmentState({this.model});
}

class GetAppointmentStatusState extends BaseState {
  GetAppointmentStatusModel? model;

  GetAppointmentStatusState({this.model});
}