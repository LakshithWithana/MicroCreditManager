import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mcm/admins/view_single_customer.dart';
import 'package:mcm/shared/colors.dart';

class UserCard extends StatefulWidget {
  UserCard({Key? key, this.userProfile, this.isAdmin}) : super(key: key);
  final QueryDocumentSnapshot? userProfile;
  final bool? isAdmin;

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  CollectionReference userDeletionCollection =
      FirebaseFirestore.instance.collection('userDeletion');

  bool? isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        color: backgroundColor,
        child: ListTile(
          title: Text(
            (widget.userProfile!.data() as dynamic)['firstName'] +
                ' ' +
                (widget.userProfile!.data() as dynamic)['lastName'],
            style: const TextStyle(
              color: black,
              fontSize: 18.0,
              fontWeight: FontWeight.normal,
            ),
          ),
          subtitle: Text(
            (widget.userProfile!.data() as dynamic)['userId'],
            style: const TextStyle(
              color: Color(0xff8d99ae),
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            size: 40,
          ),
          // trailing: isLoading == true
          //     ? const CircularProgressIndicator(
          //         backgroundColor: Color(0xffD90429),
          //         valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          //       )
          //     : IconButton(
          //         onPressed: () async {
          //           setState(() {
          //             isLoading = true;
          //           });
          //           await userDeletionCollection.add({
          //             "uid": FieldValue.arrayUnion([widget.userProfile!.id]),
          //           });
          //           setState(() {
          //             isLoading = false;
          //           });
          //         },
          //         icon: const Icon(
          //           Icons.delete,
          //           color: Colors.red,
          //         ),
          //       ),
        ),
      ),
      onTap: () {
        // Get.to(() => ViewPlayerProfile(userProfile: widget.userProfile));
        Navigator.pushNamed(
          context,
          '/viewSingleCustomer',
          arguments: ViewSingleCustomerArgs(widget.userProfile, widget.isAdmin),
        );
      },
    );
  }
}
