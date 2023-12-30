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

class HomeCubit extends HydratedCubit<HomeState> {
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

  void searchWithCamera(File file, void Function(String s) onSucess) async {
    onSucess(await _readTheText(file));
  }

  void getCrouselImages() {
    emit(state.copywith(
      couselImages: _homeServices.getCarouselItems(),
      changeType: ChangeType.crouselUpdated,
    ));
  }

  void downloadData() async {
    emit(state.copywith(changeType: ChangeType.loading));
    StreamController<double> downloadProgress = await ExcelStore.downloadFile(
      "https://www.recovery.starkinsolutions.com//uploads/bank_proof/c2v1tY7GAq/Repo%20List%20%20July-22%20(6).xlsx",
    );
    downloadProgress.stream.listen((p) {
      if (p >= 100) {
        getVehichelOwners();
      } else {
        emit(
          state.copywith(downloadProgress: p),
        );
      }
    });
  }

  @override
  HomeState? fromJson(Map<String, dynamic> json) {
    return HomeState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(HomeState state) {
    return state.toMap();
  }
}

Future<String> _readTheText(File imageFile) async {
  String number = '';
  // final File imageFile = await getImageFile();
  final GoogleVisionImage visionImage = GoogleVisionImage.fromFile(imageFile);
  final TextRecognizer textRecognizer = GoogleVision.instance.textRecognizer();
  final VisionText visionText = await textRecognizer.processImage(visionImage);
  if (visionText.text != null) {
    String text = visionText.text!;
    for (TextBlock block in visionText.blocks) {
      final Rect boundingBox = block.boundingBox!;
      final List<Offset> cornerPoints = block.cornerPoints;
      final String text = block.text!;
      final List<RecognizedLanguage> languages = block.recognizedLanguages;

      for (TextLine line in block.lines) {
        // Same getters as TextBlock
        for (TextElement element in line.elements) {
          if (element.text != null) {
            number = "$number ${element.text!}";
            log(element.text!);
          } else {
            throw ('element text is null');
          }

          // Same getters as TextBlock
        }
      }
    }
  } else {
    throw ('vision text not found');
  }
  textRecognizer.close();
  return number;
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
