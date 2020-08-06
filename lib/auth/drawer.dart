import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../service-provider.dart';
import '../seller/service.dart';
import './avatar.dart';

class AuthDrawer extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseUser user;
  AuthDrawer(this.user);
  @override
  Widget build(BuildContext context) {
    SellerService service = ServiceProvider.of(context).seller;
    return StreamBuilder<bool>(
      initialData: false,
      stream: service.isSellerChange(user.uid),
      builder: (context, snapshot) {
        bool isSeller = snapshot.data;
        return isSeller
            ? sellerDrawer(context, service)
            : buyerDrawer(context, service);
      },
    );
  }

  Drawer buyerDrawer(BuildContext context, SellerService service) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                avatar(user),
                Text(user.email),
                FlatButton(
                  onPressed: () => service.becomeSeller(),
                  child: Text('Click here to become a Seller'),
                )
              ],
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
            ),
          ),
          ListTile(
            title: Text('My Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_basket),
            title: Text('Market'),
            onTap: () => Navigator.pushReplacementNamed(context, '/m/list'),
          ),
          ListTile(
            leading: Icon(Icons.store),
            title: Text('My orders'),
            onTap: () => Navigator.pushReplacementNamed(context, '/m/order'),
          )
        ],
      ),
    );
  }

  Drawer sellerDrawer(BuildContext context, SellerService service) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [avatar(user), Text(user.email)],
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
            ),
          ),
          ListTile(
            title: Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('My products'),
            onTap: () => Navigator.pushReplacementNamed(context, '/d/list'),
          ),
          ListTile(
            leading: Icon(Icons.store),
            title: Text('Current orders'),
            onTap: () => Navigator.pushReplacementNamed(context, '/d/order'),
          ),
          ListTile(
            leading: Icon(Icons.shopping_basket),
            title: Text('Market'),
            onTap: () => Navigator.pushReplacementNamed(context, '/m/list'),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Signout'),
            onTap: () {
              Navigator.pop(context);
              _auth.signOut();
            },
          ),
        ],
      ),
    );
  }
}
