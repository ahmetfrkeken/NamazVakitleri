import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:namazvakti/config/routes/routes.dart';
import 'package:namazvakti/screens/compass_screen.dart';

class NamazVaktiDrawer extends StatelessWidget {
  const NamazVaktiDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const UserAccountsDrawerHeader(
            accountName: Text("Ahmet Faruk EKEN"),
            accountEmail: Text("test@osmanli.com"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://www.islamveihsan.com/wp-content/uploads/2017/04/sirpence2-702x336.jpg'),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              // Navigator.pop(context);
              // Navigator.pushReplacement(context,
              //     MaterialPageRoute(builder: (context) => const CompassScreen()));

              context.push(RouteLocation.compass);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
