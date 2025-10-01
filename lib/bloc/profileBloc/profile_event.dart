part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

class GetProfileEvent extends ProfileEvent{
  final BuildContext context;
  final String userId;
  GetProfileEvent(this.context, this.userId);
}

class UpdateProfileEvent extends ProfileEvent{
  final BuildContext context;
  final String firstName;
  final String lastName;
  final String profilePic;
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

class CategoryEvent extends ProfileEvent{
  final BuildContext context;
  CategoryEvent(this.context);
}

class GetProfileSummary extends ProfileEvent{
  final BuildContext context;
  final String categoryId;
  GetProfileSummary(this.context, this.categoryId);
}