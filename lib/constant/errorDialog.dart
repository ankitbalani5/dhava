
import 'package:flutter/material.dart';

import '../resources/color/appColor.dart';
import '../resources/style/textStyle.dart';
import '../widgets/customButton.dart';

class ErrorDialog extends StatelessWidget {
  final String message;
  final bool isSuccess;
  final VoidCallback callback;
  ErrorDialog({required this.message, required this.isSuccess, required this.callback});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevent dialog dismissal on back press
      child: Dialog(
        backgroundColor: Colors.transparent, // Make the Dialog background transparent
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColor.textBackgroundGrey, width: 2), // Stroke with color and width
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSuccess ? Icons.check_circle_rounded : Icons.warning_amber_rounded,
                  size: 48,
                  color: isSuccess ? AppColor.primaryColor : Colors.red,
                ),
                SizedBox(height: 16),
                Text(
                  isSuccess ? "Success" :"Error",
                  style: CustomTextStyles.bold(),
                ),
                SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: CustomTextStyles.medium(),
                ),
                SizedBox(height: 16),
                CustomButton(
                  text: 'Okay',
                  callback: () {
                    Navigator.pop(context);
                    if (isSuccess) {
                      callback(); // Properly execute the callback function
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

