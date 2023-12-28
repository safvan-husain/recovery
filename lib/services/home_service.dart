import 'package:recovery_app/models/detail_model.dart';

class HomeServices {
  List<String> getCarouselItems() => [
        "https://images.unsplash.com/photo-1682686581221-c126206d12f0?ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwxfHx8ZW58MHx8fHx8&auto=format&fit=crop&w=500&q=60",
        "https://images.unsplash.com/photo-1682686581663-179efad3cd2f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwxNnx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
        "https://images.unsplash.com/photo-1682695797873-aa4cb6edd613?ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwyMXx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60"
      ];

  List<DetailsModel> getDetailsList(void Function(String m) onFailure) {
    try {
      return [
        DetailsModel(
            name: "Marvin McKinney",
            engineNo: "AS-01-BC-3353",
            vehicalNo: "UP77AN3725"),
        DetailsModel(
            name: "Marvin McKinney",
            engineNo: "AS-01-BC-3353",
            vehicalNo: "UP77AN3725"),
        DetailsModel(
            name: "Marvin McKinney",
            engineNo: "AS-01-BC-3353",
            vehicalNo: "UP77AN3725"),
        DetailsModel(
            name: "Marvin McKinney",
            engineNo: "AS-01-BC-3353",
            vehicalNo: "UP77AN3725"),
        DetailsModel(
            name: "Marvin McKinney",
            engineNo: "AS-01-BC-3353",
            vehicalNo: "UP77AN3725"),
      ];
    } catch (e) {
      onFailure(e.toString());
    }
    return [];
  }
}
