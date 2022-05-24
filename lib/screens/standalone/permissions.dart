// import 'package:flutter/material.dart';
// import 'package:flutter_contacts/flutter_contacts.dart';
// import 'package:hive/hive.dart';
//
// import '../../components/appbar.dart';
// import '../../components/bottom_navigation_bar.dart';
// import '../../services/auth.dart';
// import '../../utilities/bottom_navigation_items.dart';
// import '../../utilities/constants.dart';
//
// class PermissionRequest extends StatefulWidget {
//   const PermissionRequest({Key? key}) : super(key: key);
//
//   @override
//   State<PermissionRequest> createState() => _PermissionRequestState();
// }
//
// class _PermissionRequestState extends State<PermissionRequest> {
//   @override
//   Widget build(BuildContext context) {
//
//
//     return Scaffold(
//       appBar: const ForgeAppBar(),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//
//             const Text('Contacts Usage Policy', style: TextStyle(fontSize: 24, color: Constants.kPrimaryColor),),
//             const SizedBox(height: 10,),
//             const Text('We require access to your contacts to enable you to setup and manage relationships. If you consent to this, please click accept and allow access on the next screen',
//             textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 10,),
//
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//
//
//               children: [
//
//                 OutlinedButton(
//                   onPressed: () async {
//
//                     FirebaseAuthService auth = FirebaseAuthService();
//
//                     await auth.signOutFromGoogle();
//
//
//                   },
//                   child: const Text('Reject',style: TextStyle(color: Constants.kErrorColor),),
//                   style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Constants.kWhiteColor),)
//                 ),
//
//                 SizedBox(width: 5,),
//                 TextButton(
//                   onPressed: () async {
//                     if (await FlutterContacts.requestPermission()) {
//                       Navigator.pushNamed(context, Constants.wrapperNavigate);
//                     }
//                     else {
//                       FirebaseAuthService auth = FirebaseAuthService();
//
//                       await auth.signOutFromGoogle();
//                     }
//
//                   },
//                   child: const Text('Accept',style: TextStyle(color: Constants.kWhiteColor),),
//                   style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Constants.kPrimaryColor)),
//                 ),
//
//
//               ],
//             )
//
//
//           ],
//         ),
//       ),
//       //bottomNavigationBar: ForgeBottomNavigationBar(currentTab: TabName.timeline, onSelectTab: (tab) {}),
//     );
//
//   }
// }
