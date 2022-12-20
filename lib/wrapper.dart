import 'package:flutter/material.dart';
import 'package:mcm/admins/admin_home.dart';
import 'package:mcm/agents/agent_home.dart';
import 'package:mcm/authentication/authentication.dart';
import 'package:mcm/reusable_components/loading.dart';
import 'package:mcm/services/auth_services.dart';
import 'package:mcm/services/database_services.dart';
import 'package:mcm/users/user_home.dart';
import 'package:provider/provider.dart';

import 'models/user_model.dart';

final AuthServices _auth = AuthServices();

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //declare user from provider
    final user = Provider.of<mcmUser?>(context);

    //return either Home or Authentication widget
    if (user == null) {
      return Authentication();
    } else {
      return StreamBuilder<UserDetails>(
        stream: DatabaseServices(uid: user.uid).userDetails,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserDetails userDetails = snapshot.data!;
            if (userDetails.isUser!) {
              return const UserHome();
            } else if (userDetails.isAdmin!) {
              return const AdminHome();
            } else {
              return AgentHome();
            }
          } else {
            return const Loading();
            //     Scaffold(
            //   body: PositiveElevatedButton(
            //     label: 'LOGOUT',
            //     onPressed: () {
            //       _auth.signOut();
            //     },
            //   ),
            // );
          }
        },
      );
    }
  }
}
