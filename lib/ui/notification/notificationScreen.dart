import 'package:coherent_endurance/resources/color/appColor.dart';
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:coherent_endurance/widgets/backButton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

import '../../bloc/notificationBloc/notification_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String page = '1';
  String? perPage = '10';
  @override
  void initState() {
    context.read<NotificationBloc>().add(GetNotificationEvent(context: context, perPage: perPage.toString(), page: '1'));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: BackButtonWidget()),
        title: Text('Notification', style: CustomTextStyles.bold(),),
      ),
      body: BlocConsumer<NotificationBloc, NotificationState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if(state is NotificationLoading){
            return Center(
              child: LoadingAnimationWidget.inkDrop(
                color: AppColor.bgRed,
                size: 20,
              ),
            );
          }
          if(state is NotificationSuccess){
            return state.notificationModel.data!.data!.isEmpty
                ? Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(AppImageSvg.bell),
                    SizedBox(height: 20,),
                    Text('No Any Notification Yet')
                  ]
              ),
            )
                : ListView.builder(
              itemCount: state.notificationModel.data?.data?.length,
              itemBuilder: (context, index) {
                var notificationData = state.notificationModel.data!.data![index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                  child: notificationData.notificaionType == 'Follow Request'
                      ? followRequest(notificationData)
                      : follow(notificationData)

                );
              },
            );


            // ListView.builder(
            //   itemCount: 4,
            //   itemBuilder: (context, index) {
            //     return ListTile(
            //       leading: Image.asset(AppImageOthers.defaultImage),
            //       title: Text('Another activity down', style: CustomTextStyles.bold(fontSize: 16),),
            //       subtitle: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text('Great work out there. Check out your stats now!', style: CustomTextStyles.regular(fontSize: 14, textColor: Colors.grey),),
            //           Text('4 days ago', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey))
            //         ],
            //       ),
            //       trailing: Row(
            //         mainAxisAlignment: MainAxisAlignment.end,
            //         children: [
            //           Container(
            //             height: 45,
            //             width: 80,
            //             decoration: BoxDecoration(
            //               borderRadius: BorderRadius.circular(12),
            //               color:AppColor.bgRed
            //             ),
            //           ),
            //           SvgPicture.asset(AppImageSvg.cancel)
            //         ],
            //       ),
            //     );
            //   },);
              /*ListView.builder(
              itemCount: 4,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.asset(AppImageOthers.defaultImage),
                  title: Text('Another activity down', style: CustomTextStyles.bold(fontSize: 16),),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Great work out there. Check out your stats now!', style: CustomTextStyles.regular(fontSize: 14, textColor: Colors.grey),),
                      Text('4 days ago', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey))
                    ],
                  ),
                );
              },);*/
          }
          if(state is NotificationError){
            return Center(
              child: Text(state.error),
            );
          }
          return SizedBox();
        },
      )

      /*ListView.builder(
        itemCount: 4,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.asset(AppImageOthers.defaultImage),
            title: Text('Another activity down', style: CustomTextStyles.bold(fontSize: 16),),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Great work out there. Check out your stats now!', style: CustomTextStyles.regular(fontSize: 14, textColor: Colors.grey),),
                Text('4 days ago', style: CustomTextStyles.regular(fontSize: 12, textColor: Colors.grey))
              ],
            ),
          );
      },)*/
      /*Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(AppImageSvg.bell),
            SizedBox(height: 20,),
            Text('No Any Notification Yet')
          ]
        ),
      )*/
    );
  }

  Widget followRequest(notificationData){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start, // 👈 important
      children: [
        // 👈 Image aligned to top-left
        CachedNetworkImage(imageUrl: notificationData.userProfile?.profilePhoto ?? '',
          height: 40,
          width: 40,
          placeholder: (context, url) => Image.asset(AppImageOthers.userImg),
          errorWidget: (context, url, error) => Image.asset(AppImageOthers.userImg),
        ),

        const SizedBox(width: 12),

        // 👈 Title + Subtitle
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${notificationData.userProfile!.firstName} ${notificationData.userProfile!.lastName}',
                style: CustomTextStyles.bold(fontSize: 16),
              ),
              // const SizedBox(height: 2),
              Text(
                notificationData.message.toString(),
                style: CustomTextStyles.regular(
                  fontSize: 14,
                  textColor: Colors.grey,
                ),
              ),
              // const SizedBox(height: 2),
              // Text(
              //   '4 days ago',
              //   style: CustomTextStyles.regular(
              //     fontSize: 12,
              //     textColor: Colors.grey,
              //   ),
              // ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        // 👈 Trailing buttons
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  context.read<NotificationBloc>().add(FollowApproveEvent(
                      context: context, fromUserId: notificationData.fromUserId.toString()
                  )
                  );
                },
                child: Container(
                  height: 25,
                  width: 62,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColor.bgRed,
                  ),
                  child: Center(
                    child: Text(
                      'Confirm',
                      style: CustomTextStyles.medium(
                        fontSize: 12,
                        textColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                  onTap: () {
                    context.read<NotificationBloc>().add(FollowCancelEvent(
                        context: context, fromUserId: notificationData.fromUserId.toString()
                    )
                    );
                  },
                  child: SvgPicture.asset(AppImageSvg.cancel, color: Colors.black, height: 14,)),
            ],
          ),
        ),
      ],
    );
  }

  // Widget followApproved(notificationData){
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 18.0),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start, // 👈 important
  //       children: [
  //         // 👈 Image aligned to top-left
  //         CachedNetworkImage(imageUrl: notificationData.userProfile?.profilePhoto ?? '',
  //           height: 40,
  //           width: 40,
  //           placeholder: (context, url) => Image.asset(AppImageOthers.userImg),
  //           errorWidget: (context, url, error) => Image.asset(AppImageOthers.userImg),
  //         ),
  //
  //         const SizedBox(width: 12),
  //
  //         // 👈 Title + Subtitle
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 '${notificationData.userProfile!.firstName} ${notificationData.userProfile!.lastName}',
  //                 style: CustomTextStyles.bold(fontSize: 16),
  //               ),
  //               // const SizedBox(height: 2),
  //               Text(
  //                 notificationData.message.toString(),
  //                 style: CustomTextStyles.regular(
  //                   fontSize: 14,
  //                   textColor: Colors.grey,
  //                 ),
  //               ),
  //               // const SizedBox(height: 2),
  //               // Text(
  //               //   '4 days ago',
  //               //   style: CustomTextStyles.regular(
  //               //     fontSize: 12,
  //               //     textColor: Colors.grey,
  //               //   ),
  //               // ),
  //             ],
  //           ),
  //         ),
  //
  //         const SizedBox(width: 8),
  //
  //         // 👈 Trailing buttons
  //         Padding(
  //           padding: const EdgeInsets.symmetric(vertical: 20.0),
  //           child: Row(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               GestureDetector(
  //                 onTap: () {
  //                   context.read<NotificationBloc>().add(FollowApproveEvent(
  //                       context: context, fromUserId: notificationData.fromUserId.toString()
  //                   )
  //                   );
  //                 },
  //                 child: Container(
  //                   height: 25,
  //                   width: 62,
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(12),
  //                     color: AppColor.bgRed,
  //                   ),
  //                   child: Center(
  //                     child: Text(
  //                       'Confirm',
  //                       style: CustomTextStyles.medium(
  //                         fontSize: 12,
  //                         textColor: Colors.white,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(width: 8),
  //               GestureDetector(
  //                   onTap: () {
  //                     context.read<NotificationBloc>().add(FollowCancelEvent(
  //                         context: context, fromUserId: notificationData.fromUserId.toString()
  //                     )
  //                     );
  //                   },
  //                   child: SvgPicture.asset(AppImageSvg.cancel, color: Colors.black, height: 14,)),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget follow(notificationData){
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // 👈 important
        children: [
          // 👈 Image aligned to top-left
          CachedNetworkImage(imageUrl: notificationData.userProfile?.profilePhoto ?? '',
            height: 40,
            width: 40,
            placeholder: (context, url) => Image.asset(AppImageOthers.userImg),
            errorWidget: (context, url, error) => Image.asset(AppImageOthers.userImg),
          ),

          const SizedBox(width: 12),

          // 👈 Title + Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${notificationData.userProfile!.firstName} ${notificationData.userProfile!.lastName}',
                  style: CustomTextStyles.bold(fontSize: 16),
                ),
                // const SizedBox(height: 2),
                Text(
                  notificationData.message.toString(),
                  style: CustomTextStyles.regular(
                    fontSize: 14,
                    textColor: Colors.grey,
                  ),
                ),
                // const SizedBox(height: 2),
                // Text(
                //   '4 days ago',
                //   style: CustomTextStyles.regular(
                //     fontSize: 12,
                //     textColor: Colors.grey,
                //   ),
                // ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // 👈 Trailing buttons
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 20.0),
          //   child: Row(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       GestureDetector(
          //         onTap: () {
          //           context.read<NotificationBloc>().add(FollowApproveEvent(
          //               context: context, fromUserId: notificationData.fromUserId.toString()
          //           )
          //           );
          //         },
          //         child: Container(
          //           height: 25,
          //           width: 62,
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(12),
          //             color: AppColor.bgRed,
          //           ),
          //           child: Center(
          //             child: Text(
          //               'Confirm',
          //               style: CustomTextStyles.medium(
          //                 fontSize: 12,
          //                 textColor: Colors.white,
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //       const SizedBox(width: 8),
          //       GestureDetector(
          //           onTap: () {
          //             context.read<NotificationBloc>().add(FollowCancelEvent(
          //                 context: context, fromUserId: notificationData.fromUserId.toString()
          //             )
          //             );
          //           },
          //           child: SvgPicture.asset(AppImageSvg.cancel, color: Colors.black, height: 14,)),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
