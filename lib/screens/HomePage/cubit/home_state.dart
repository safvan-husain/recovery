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

  HomeState({
    required this.vehichalOwnerList,
    required this.couselImages,
    required this.changeType,
    this.downloadProgress,
    this.user,
  });

  factory HomeState.initial() {
    return HomeState(
      vehichalOwnerList: [],
      couselImages: [],
      changeType: ChangeType.loading,
    );
  }

  HomeState copywith(
      {List<DetailsModel>? vehichalOwnerList,
      List<String>? couselImages,
      ChangeType? changeType,
      double? downloadProgress,
      UserModel? user}) {
    return HomeState(
      vehichalOwnerList: vehichalOwnerList ?? this.vehichalOwnerList,
      couselImages: couselImages ?? this.couselImages,
      changeType: changeType ?? this.changeType,
      downloadProgress: downloadProgress ?? this.downloadProgress,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'vehichalOwnerList': vehichalOwnerList.map((x) => x.toMap()).toList(),
      'couselImages': couselImages,
      'changeType': changeType.toString(),
    };
  }

  factory HomeState.fromMap(Map<String, dynamic> map) {
    return HomeState(
      vehichalOwnerList: List<DetailsModel>.from(
        (map['vehichalOwnerList'] as List<int>).map<DetailsModel>(
          (x) => DetailsModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      couselImages: List<String>.from(
        (map['couselImages'] as List<String>),
      ),
      changeType: ChangeType.vehichelOwnerListUpdated,
    );
  }

  String toJson() => json.encode(toMap());

  factory HomeState.fromJson(String source) =>
      HomeState.fromMap(json.decode(source) as Map<String, dynamic>);
}
