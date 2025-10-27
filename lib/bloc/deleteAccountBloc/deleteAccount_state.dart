
import 'package:coherent_endurance/models/deleteAccountModel.dart';
import 'package:flutter/cupertino.dart';

@immutable
sealed class DeleteAccountState {}

final class DeleteAccountInitial extends DeleteAccountState {}
final class DeleteAccountLoading extends DeleteAccountState {}
final class DeleteAccountSuccess extends DeleteAccountState {
  final DeleteAccountModel deleteAccountModel;
  DeleteAccountSuccess(this.deleteAccountModel);
}


final class DeleteAccountError extends DeleteAccountState {
  final String error;
  DeleteAccountError(this.error);
}

