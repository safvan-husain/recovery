import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:recovery_app/models/user_model.dart';
import 'package:recovery_app/services/csv_file_service.dart';
import 'package:recovery_app/services/home_service.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

import 'package:recovery_app/storage/database_helper.dart';
import 'package:recovery_app/storage/user_storage.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState.initial());

  final HomeServices _homeServices = HomeServices();

  void setUser(UserModel user) {
    emit(state.copywith(user: user));
  }

  void homeInitialization() async {
    emit(state.copywith(
      changeType: ChangeType.vehicleOwnerListUpdated,
      isTwoColumnSearch: await Storage.getIsTwoColumnSearch(),
      entryCount: await Storage.getEntryCount(),
    ));
  }

  void updateEstimatedTime(int microSeconds) {
    String timeString;
    int totalSeconds =
        microSeconds ~/ 1000000; // Convert microseconds to seconds
    int totalMinutes = totalSeconds ~/ 60; // Convert seconds to minutes
    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;
    if (hours > 0) {
      timeString = "$hours hours and $minutes minutes";
    } else {
      timeString = "$minutes minutes";
    }
    emit(state.copywith(estimatedTime: timeString));
  }

  Future<String> downloadData(
    BuildContext context,
  ) async {
    emit(state.copywith(changeType: ChangeType.loading));
    log("agency id : ${state.user!.agencyId}"); //TODO: agencyid.
    String error = '';
    try {
      await CsvFileServices.updateData("1", state.streamController, context);
    } catch (e) {
      print(e);
      // error = e.toString();
    }
    emit(state.copywith(
      changeType: ChangeType.vehicleOwnerListUpdated,
      entryCount: await Storage.getEntryCount(),
    ));
    return error;
  }

  void updateIsColumSearch(bool isColumSearch) {
    Storage.setIsTwoColumSearch(isColumSearch);
    emit(
      state.copywith(isTwoColumnSearch: isColumSearch),
    );
  }

  void deleteAllData() async {
    log('delete called');
    emit(state.copywith(changeType: ChangeType.loading));
    await CsvFileServices.deleteAllFilesInVehicleDetails();
    await DatabaseHelper.deleteAllData();
    await Storage.addProcessedFileIndex(0);
    await Storage.emptyEntryCount();

    emit(state.copywith(
      changeType: ChangeType.vehicleOwnerListUpdated,
      entryCount: 0,
    ));
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
