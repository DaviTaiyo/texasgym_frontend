import 'package:flutter/material.dart';
import 'package:texasgym_1/presentation/configView/aboutAppScreen.dart';
import 'package:texasgym_1/presentation/configView/notificationScreen.dart';
import 'package:texasgym_1/presentation/configView/privacySecurityScreen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: Icon(Icons.security),
            title: Text('Privacidade e Segurança'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrivacySecurityScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notificações'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Sobre o Aplicativo'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutAppScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
