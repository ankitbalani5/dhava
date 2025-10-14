part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}
final class ProfileLoading extends ProfileState {}
final class ProfileSuccess extends ProfileState {
  final ProfileModel? profileModel;
  final SummaryModel? summaryModel;
  ProfileSuccess(this.profileModel, this.summaryModel);
}
final class ProfileError extends ProfileState {
  final String error;
  ProfileError(this.error);
}

final class CategoryLoading extends ProfileState {}
final class CategorySuccess extends ProfileState {
  final CategoryModel categoryModel;
  CategorySuccess(this.categoryModel);
}
final class CategoryError extends ProfileState {
  final String error;
  CategoryError(this.error);
}
