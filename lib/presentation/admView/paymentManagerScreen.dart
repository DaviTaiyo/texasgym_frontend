import 'package:flutter/material.dart';

class PaymentManagementScreen extends StatefulWidget {
  @override
  _PaymentManagementScreenState createState() => _PaymentManagementScreenState();
}

class _PaymentManagementScreenState extends State<PaymentManagementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar Pagamentos'),
        backgroundColor: Color(0xFF007BFF),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: Icon(Icons.warning, color: Colors.black),
              child: Text(
                'Pendentes',
                style: TextStyle(color: Colors.black),
              ),
            ),
            Tab(
              icon: Icon(Icons.history, color: Colors.black),
              child: Text(
                'Histórico',
                style: TextStyle(color: Colors.black),
              ),
            ),
            Tab(
              icon: Icon(Icons.notifications, color: Colors.black),
              child: Text(
                'Notificações',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPendingPaymentsTab(),
          _buildPaymentHistoryTab(),
          _buildNotificationsTab(),
        ],
      ),
    );
  }

  Widget _buildPendingPaymentsTab() {
    List<Map<String, dynamic>> pendingPayments = [
      {'name': 'João Silva', 'dueDate': '15/08/2024', 'amount': 150.0},
      {'name': 'Maria Oliveira', 'dueDate': '20/08/2024', 'amount': 200.0},
    ];

    return ListView.builder(
      itemCount: pendingPayments.length,
      itemBuilder: (context, index) {
        final payment = pendingPayments[index];
        return Card(
          margin: EdgeInsets.all(8),
          child: ListTile(
            title: Text(payment['name']),
            subtitle: Text('Data de vencimento: ${payment['dueDate']}\nValor: R\$ ${payment['amount']}'),
            trailing: IconButton(
              icon: Icon(Icons.send, color: Colors.blue),
              onPressed: () {
                _sendReminder(payment['name']);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaymentHistoryTab() {
    List<Map<String, dynamic>> paymentHistory = [
      {'name': 'João Silva', 'date': '01/08/2024', 'amount': 150.0, 'method': 'Cartão'},
      {'name': 'Maria Oliveira', 'date': '05/08/2024', 'amount': 200.0, 'method': 'Dinheiro'},
      {'name': 'Ana Santos', 'date': '10/08/2024', 'amount': 250.0, 'method': 'Pix'},
    ];

    return ListView.builder(
      itemCount: paymentHistory.length,
      itemBuilder: (context, index) {
        final payment = paymentHistory[index];
        IconData iconData;
        Color iconColor = Colors.blue;

        switch (payment['method']) {
          case 'Cartão':
            iconData = Icons.credit_card;
            break;
          case 'Dinheiro':
            iconData = Icons.monetization_on;
            break;
          case 'Pix':
            iconData = Icons.qr_code;
            break;
          default:
            iconData = Icons.payment;
            break;
        }

        return Card(
          margin: EdgeInsets.all(8),
          child: ListTile(
            title: Text(payment['name']),
            subtitle: Text('Data: ${payment['date']}\nValor: R\$ ${payment['amount']}\nMétodo: ${payment['method']}'),
            leading: Icon(iconData, color: iconColor),
          ),
        );
      },
    );
  }

  Widget _buildNotificationsTab() {
    List<String> notifications = [
      'Lembrete enviado para João Silva.',
      'Pagamento de Maria Oliveira recebido.',
    ];

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.notifications, color: Colors.black),
          title: Text(notifications[index]),
        );
      },
    );
  }

  void _sendReminder(String userName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Lembrete Enviado'),
          content: Text('Lembrete de pagamento enviado para $userName.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
