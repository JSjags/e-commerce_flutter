import 'package:e_commerce/pages/UserAccount/ui/user_account.dart';
import 'package:e_commerce/pages/address/ui/address.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Color(0xff4F0000),
                  )),
              centerTitle: true,
              title: Text(
                "Profile",
                style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff4F0000)),
              ),
            ),
            body: Column(
              children: [
                TabBar(tabs: [
                  Tab(
                    icon: Icon(Icons.person, color: const Color(0xff4F0000)),
                  ),
                  Tab(
                    icon: Icon(Icons.location_on_rounded,
                        color: const Color(0xff4F0000)),
                  )
                ]),
                Expanded(
                    child: TabBarView(
                        children: [const UserAccount(), const Address()]))
              ],
            )));
  }
}
