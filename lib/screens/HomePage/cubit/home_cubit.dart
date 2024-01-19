import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';

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
    getCrouselImages();
    emit(state.copywith(
      isTwoColumnSearch: await Storage.getIsTwoColumnSearch(),
      entryCount: await Storage.getEntryCount(),
    ));
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
    // try {
    await CsvFileServices.updateData("2", state.streamController);
    // } catch (e) {
    //   print(e);
    // error = e.toString();
    // }
    emit(state.copywith(
      changeType: ChangeType.vehichelOwnerListUpdated,
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
    emit(state.copywith(changeType: ChangeType.loading));
    await CsvFileServices.deleteAllFilesInVehicleDetails();
    await DatabaseHelper.deleteAllData();
    await Storage.emptyEntryCount();
    emit(state.copywith(
        changeType: ChangeType.vehichelOwnerListUpdated, entryCount: 0));
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
