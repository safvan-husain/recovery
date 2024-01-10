import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';

import 'package:recovery_app/models/detail_model.dart';
import 'package:recovery_app/models/user_model.dart';
import 'package:recovery_app/services/csv_file_service.dart';
import 'package:recovery_app/services/home_service.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState.initial());

  final HomeServices _homeServices = HomeServices();

  void setUser(UserModel user) {
    emit(state.copywith(user: user));
  }

  void getVehichelOwners() async {
    // emit(HomeState(
    //   changeType: ChangeType,
    // ));
    getCrouselImages();
    // emit(state.copywith(
    //   vehichalOwnerList: await ExcelStore.getVehichalMapList(),
    //   changeType: ChangeType.vehichelOwnerListUpdated,
    // ));
  }

  void homeInitialization() async {
    // emit(state.copywith(files: await ExcelStore.getFiles()));
    getVehichelOwners();
    //TODO: needd optimization here.
  }

  void getCrouselImages() {
    emit(state.copywith(
      couselImages: _homeServices.getCarouselItems(),
      changeType: ChangeType.crouselUpdated,
    ));
  }

  Future<String> downloadData() async {
    emit(state.copywith(changeType: ChangeType.loading));
    log("agency id : ${state.user!.agencyId}"); //TODO: agencyid.
    String error = '';
    try {
      await CsvFileServices.updateData("2", state.streamController);
    } catch (e) {
      error = e.toString();
    }
    emit(state.copywith(changeType: ChangeType.vehichelOwnerListUpdated));
    return error;
  }
}

Future<File> getImageFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result != null) {
    File file = File(result.files.single.path!);
    return file;
  } else {
    throw ('no file selected');
    // User canceled the picker
  }
}
