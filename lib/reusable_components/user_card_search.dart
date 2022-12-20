// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:mcm/admins/view_single_customer.dart';
// import 'package:mcm/shared/colors.dart';

// import '../services/database_services.dart';

// class UserCardSearch extends StatefulWidget {
//   const UserCardSearch({Key? key, this.userProfile, this.isAdmin})
//       : super(key: key);

//   final QueryDocumentSnapshot? userProfile;
//   final bool? isAdmin;
//   // final String? userId;

//   @override
//   _UserCardSearchState createState() => _UserCardSearchState();
// }

// class _UserCardSearchState extends State<UserCardSearch> {
//   CollectionReference userDeletionCollection =
//       FirebaseFirestore.instance.collection('userDeletion');

//   bool? isLoading = false;
//   String? url = "";

//   @override
//   Widget build(BuildContext context) {
//     getImage() async {
//       await imagesCollection
//           .where("name", isEqualTo: widget.userProfile!.id)
//           .get()
//           .then((value) {
//         if (mounted) {
//           setState(() {
//             url = (value.docs.first.data() as dynamic)['url'];
//             print("url ${url!}");
//           });
//         }
//       }).onError((error, stackTrace) {
//         if (mounted) {
//           setState(() {
//             url = "";
//           });
//         }
//       });
//     }

//     getImage();

//     return GestureDetector(
//       child: Card(
//         color: backgroundColor,
//         child: ListTile(
//           leading: CircleAvatar(
//               child:
//                   // url != ""
//                   //     ?
//                   Center(
//             child: isLoading == true
//                 ? const CircularProgressIndicator()
//                 : Container(
//                     height: 120.0,
//                     width: 120.0,
//                     decoration: BoxDecoration(
//                         image: DecorationImage(
//                             image: NetworkImage(
//                               url!,
//                             ),
//                             fit: BoxFit.cover),
//                         borderRadius:
//                             const BorderRadius.all(Radius.circular(15))),
//                   ),
//           )
//               // :
//               // Center(
//               //     child: Container(
//               //       height: 120.0,
//               //       width: 120.0,
//               //       decoration: const BoxDecoration(
//               //           image: DecorationImage(
//               //               image:
//               //                   AssetImage("assets/images/MCM app icon.png"),
//               //               fit: BoxFit.cover),
//               //           borderRadius: BorderRadius.all(Radius.circular(15))),
//               //     ),
//               //   ),
//               ),
//           title: Text(
//             (widget.userProfile!.data() as dynamic)['firstName'] +
//                 ' ' +
//                 (widget.userProfile!.data() as dynamic)['lastName'],
//             style: const TextStyle(
//               color: black,
//               fontSize: 18.0,
//               fontWeight: FontWeight.normal,
//             ),
//           ),
//           subtitle: Text(
//             (widget.userProfile!.data() as dynamic)['userId'],
//             style: const TextStyle(
//               color: Color(0xff8d99ae),
//             ),
//           ),
//           trailing: const Icon(
//             Icons.chevron_right,
//             size: 40,
//           ),
//           // trailing: isLoading == true
//           //     ? const CircularProgressIndicator(
//           //         backgroundColor: Color(0xffD90429),
//           //         valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
//           //       )
//           //     : IconButton(
//           //         onPressed: () async {
//           //           setState(() {
//           //             isLoading = true;
//           //           });
//           //           await userDeletionCollection.add({
//           //             "uid": FieldValue.arrayUnion([widget.userProfile!.id]),
//           //           });
//           //           setState(() {
//           //             isLoading = false;
//           //           });
//           //         },
//           //         icon: const Icon(
//           //           Icons.delete,
//           //           color: Colors.red,
//           //         ),
//           //       ),
//         ),
//       ),
//       onTap: () {
//           setState(() {
//                                 uid = user.docs.first.id;
//                                 userName = (user.docs.first.data()
//                                         as dynamic)['firstName'] +
//                                     " " +
//                                     (user.docs.first.data()
//                                         as dynamic)['lastName'];

//                                 userId = (user.docs.first.data()
//                                     as dynamic)['userId'];
//                               });
//       },
//     );
//   }
// }
