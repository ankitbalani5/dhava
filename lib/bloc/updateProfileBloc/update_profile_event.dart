part of 'update_profile_bloc.dart';

@immutable
class UpdateProfileEvent {
  final BuildContext context;
  final String firstName;
  final String lastName;
  final String? profilePic;
  final String city;
  final String state;
  final String country;
  final String address;
  final String bio;
  final String dob;
  final String height;
  final String heightUnitId;
  final String weight;
  final String weightUnitId;
  final String gender;
  final String latitude;
  final String longitude;
  final String fitnessLevel;
  final String planToUse;
  final String categoryIds;
  final String primaryCategoryId;
  UpdateProfileEvent({required this.context, required this.firstName, required this.lastName,
    this.profilePic = '', this.city = '', this.state = '', this.country = '',
    this.address = '', this.bio = '', required this.dob , this.height = '', this.heightUnitId = '',
    this.weight = '', this.weightUnitId = '', required this.gender , this.latitude = '',
    this.longitude = '', required this.fitnessLevel , required this.planToUse , this.categoryIds = '',
    this.primaryCategoryId = ''
  });
}