import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool treinoNotification = false;
  bool hydrationReminder = false;
  bool offersAndPromotions = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notificações'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SwitchListTile(
              title: Text('Notificações de Treino'),
              subtitle: Text('Receber notificações sobre seus treinos'),
              value: treinoNotification,
              onChanged: (bool value) {
                setState(() {
                  treinoNotification = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Lembretes de Hidratação'),
              subtitle: Text('Receber lembretes para beber água'),
              value: hydrationReminder,
              onChanged: (bool value) {
                setState(() {
                  hydrationReminder = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Ofertas e Promoções'),
              subtitle: Text('Receber ofertas e promoções especiais'),
              value: offersAndPromotions,
              onChanged: (bool value) {
                setState(() {
                  offersAndPromotions = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
