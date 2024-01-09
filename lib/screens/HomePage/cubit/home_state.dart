// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'home_cubit.dart';

enum ChangeType {
  loading,
  crouselUpdated,
  vehichelOwnerListUpdated,
}

class HomeState {
  final UserModel? user;
  final List<String> couselImages;
  final ChangeType changeType;

  HomeState({
    required this.couselImages,
    required this.changeType,
    this.user,
  });

  factory HomeState.initial() {
    return HomeState(
      couselImages: [],
      changeType: ChangeType.loading,
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
      user: user ?? this.user,
      couselImages: couselImages ?? this.couselImages,
      changeType: changeType ?? this.changeType,
    );
  }
}
