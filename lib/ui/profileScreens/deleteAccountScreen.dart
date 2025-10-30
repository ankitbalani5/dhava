import 'package:coherent_endurance/bloc/deleteAccountBloc/deleteAccount_bloc.dart';
import 'package:coherent_endurance/bloc/deleteAccountBloc/deleteAccount_event.dart';
import 'package:coherent_endurance/bloc/deleteAccountBloc/deleteAccount_state.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/ui/authScreens/registerScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final TextEditingController _remarkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          'Requests to Delete Account',
          style: CustomTextStyles.bold(),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Text(
              "Want to delete your account?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "You will lose every piece of essential information stored in our app.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.4),
            ),
            SizedBox(height: 50),
            Center(
              child: Image.asset(
                AppImageOthers.deleteAccount,
                height: 220,
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  _showDeleteDialog(context);
                },
                child: Text(
                  "Delete Account",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 25,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.red.withOpacity(0.1),
                child: Image.asset(
                  AppImageOthers.deleteAccount,
                  height: 40,
                  width: 40,
                ),
              ),
              SizedBox(height: 15),
              Text(
                "Delete Account",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Please provide a remark before deleting your account.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(height: 20),

              TextField(
                controller: _remarkController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: "Enter your remark...",
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              SizedBox(height: 25),

              BlocConsumer<DeleteAccountBloc, DeleteAccountState>(
                listener: (context, state) {
                  if (state is DeleteAccountLoading) {
                    Center(
                      child: LoadingAnimationWidget.inkDrop(
                        color: Colors.white,
                        size: 20,
                      ),
                    );
                  }

                  final remark = _remarkController.text.trim();
                  if (remark.isNotEmpty) {
                    if (state is DeleteAccountSuccess) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ),
                        (route) => false,
                      );
                    }
                  } else {
                    Fluttertoast.showToast(msg: "Please enter Remark first");
                  }
                },
                builder: (context, state) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        final remark = _remarkController.text.trim();
                        if (remark.isNotEmpty) {
                          context.read<DeleteAccountBloc>().add(
                            PostDeleteAccountEvent(
                              context: context,
                              remark: remark,
                            ),
                          );
                        }
                      },
                      child: Text(
                        "OK",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
