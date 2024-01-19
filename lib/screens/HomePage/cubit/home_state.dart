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
  final StreamController<Map<String, int>?> streamController;
  final ChangeType changeType;
  final bool isTwoColumnSearch;
  final int entryCount;
  final String esitimatedTime;

  HomeState({
    this.user,
    this.isTwoColumnSearch = false,
    this.entryCount = 0,
    this.esitimatedTime = '',
    required this.couselImages,
    required this.streamController,
    required this.changeType,
  });

  factory HomeState.initial() {
    return HomeState(
      couselImages: [
        'assets/images/pic-1.webp',
        'assets/images/pic-2.webp',
        'assets/images/pic-3.webp',
      ],
      changeType: ChangeType.loading,
      streamController: StreamController<Map<String, int>?>.broadcast(),
    );
  }

  HomeState copywith({
    UserModel? user,
    List<String>? couselImages,
    StreamController<Map<String, int>?>? streamController,
    ChangeType? changeType,
    bool? isTwoColumnSearch,
    int? entryCount,
    String? esitimatedTime,
  }) {
    return HomeState(
      entryCount: entryCount ?? this.entryCount,
      isTwoColumnSearch: isTwoColumnSearch ?? this.isTwoColumnSearch,
      user: user ?? this.user,
      couselImages: couselImages ?? this.couselImages,
      streamController: streamController ?? this.streamController,
      changeType: changeType ?? this.changeType,
      esitimatedTime: esitimatedTime ?? this.esitimatedTime,
    );
  }
}
