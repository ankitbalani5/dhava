
import 'package:flutter/material.dart';

@immutable
sealed class DeleteAccountEvent {}

class PostDeleteAccountEvent extends DeleteAccountEvent {
  final BuildContext context;
  final String remark;


  PostDeleteAccountEvent({
    required this.context,
    required this.remark,

  });
}


