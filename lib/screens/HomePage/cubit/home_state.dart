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
  final StreamController<String> streamController;
  final ChangeType changeType;

  HomeState({
    this.user,
    required this.couselImages,
    required this.streamController,
    required this.changeType,
  });

  factory HomeState.initial() {
    return HomeState(
      couselImages: [],
      changeType: ChangeType.loading,
      streamController: StreamController<String>.broadcast(),
    );
  }

  HomeState copywith({
    UserModel? user,
    List<String>? couselImages,
    StreamController<String>? streamController,
    ChangeType? changeType,
  }) {
    return HomeState(
      user: user ?? this.user,
      couselImages: couselImages ?? this.couselImages,
      streamController: streamController ?? this.streamController,
      changeType: changeType ?? this.changeType,
    );
  }
}
