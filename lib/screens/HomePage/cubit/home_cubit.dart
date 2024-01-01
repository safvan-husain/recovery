import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:recovery_app/models/detail_model.dart';
import 'package:recovery_app/models/user_model.dart';
import 'package:recovery_app/services/excel_store.dart';
import 'package:recovery_app/services/home_service.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
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
    emit(state.copywith(
      vehichalOwnerList: await ExcelStore.getVehichalMapList(),
      changeType: ChangeType.vehichelOwnerListUpdated,
    ));
  }

  void homeInitialization() async {
    emit(state.copywith(files: await ExcelStore.getFiles()));
    getVehichelOwners();
    //TODO: needd optimization here.
  }

  void getCrouselImages() {
    emit(state.copywith(
      couselImages: _homeServices.getCarouselItems(),
      changeType: ChangeType.crouselUpdated,
    ));
  }

  void downloadData() async {
    emit(state.copywith(changeType: ChangeType.loading));
    print(state.user!.agencyId!); //TODO: agencyId is hard coded.
    StreamController<double> downloadProgress = StreamController<double>();
    ExcelStore.downloadFile("2", downloadProgress);
    downloadProgress.stream.listen((p) {
      if (p >= 100) {
        homeInitialization();
      } else {
        emit(
          state.copywith(downloadProgress: p),
        );
      }
    });
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
