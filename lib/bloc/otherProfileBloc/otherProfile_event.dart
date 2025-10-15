

import 'package:flutter/cupertino.dart';

@immutable
sealed class OtherProfileEvent {}

class OtherProfileDataEvent extends OtherProfileEvent{
  final BuildContext context;
  final String userId;
  OtherProfileDataEvent({required this.context,
    required this.userId, });
}

class GetOtherProfileSummary extends OtherProfileEvent{
  final BuildContext context;
  final String categoryId;
  final String userId;
  GetOtherProfileSummary({required this.context, required this.categoryId, required this.userId});
}

