// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'home_cubit.dart';

enum ChangeType {
  loading,
  crouselUpdated,
  vehichelOwnerListUpdated,
}

class HomeState {
  final List<DetailsModel> vehichalOwnerList;
  final UserModel? user;
  final List<String> couselImages;
  final ChangeType changeType;
  final double? downloadProgress;
  final List<File> files;

  HomeState({
    required this.vehichalOwnerList,
    required this.couselImages,
    required this.changeType,
    required this.files,
    this.downloadProgress,
    this.user,
  });

  factory HomeState.initial() {
    return HomeState(
      vehichalOwnerList: [],
      couselImages: [],
      changeType: ChangeType.loading,
      files: [],
    );
  }

  HomeState copywith({
    List<DetailsModel>? vehichalOwnerList,
    UserModel? user,
    List<String>? couselImages,
    ChangeType? changeType,
    double? downloadProgress,
    List<File>? files,
  }) {
    return HomeState(
      vehichalOwnerList: vehichalOwnerList ?? this.vehichalOwnerList,
      user: user ?? this.user,
      couselImages: couselImages ?? this.couselImages,
      changeType: changeType ?? this.changeType,
      downloadProgress: downloadProgress ?? this.downloadProgress,
      files: files ?? this.files,
    );
  }
}
