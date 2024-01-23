import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:recovery_app/models/user_model.dart';
import 'package:recovery_app/services/csv_file_service.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

import 'package:recovery_app/storage/database_helper.dart';
import 'package:recovery_app/storage/user_storage.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState.initial());

  void setUser(UserModel user) {
    emit(state.copyWith(user: user));
  }

  void homeInitialization() async {
    emit(state.copyWith(
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
    emit(state.copyWith(estimatedTime: timeString));
  }

  void updateDataCount(int count) async {
    await Storage.addEntryCount(count);

    emit(state.copyWith(entryCount: await Storage.getEntryCount()));
  }

  Future<void> downloadData() async {
    await deleteAllData();
    log('downlaing data');
    emit(state.copyWith(changeType: ChangeType.loading));
    try {
      await CsvFileServices.updateData(
        // state.user!.agencyId,
        "2",
        state.streamController,
        this,
      );
    } catch (e) {
      print(e);
    }
    emit(state.copyWith(
      changeType: ChangeType.vehicleOwnerListUpdated,
      entryCount: await Storage.getEntryCount(),
    ));
  }

  void updateIsColumSearch(bool isColumSearch) {
    Storage.setIsTwoColumSearch(isColumSearch);
    emit(
      state.copyWith(isTwoColumnSearch: isColumSearch),
    );
  }

  Future<void> deleteAllData() async {
    emit(state.copyWith(changeType: ChangeType.loading));
    await CsvFileServices.deleteAllFilesInVehicleDetails();
    await DatabaseHelper.deleteAllData();
    await Storage.addProcessedFileIndex(0);
    await Storage.emptyEntryCount();

    emit(state.copyWith(
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
