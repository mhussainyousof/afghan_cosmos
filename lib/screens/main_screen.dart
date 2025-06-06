import 'package:afghan_cosmos/screens/menu/menu_data.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget{
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('AFGHAN COSMOS'),
        actions: [
          Row(
            children: [
              Icon(Icons.location_on_outlined),
              SizedBox(width: 4),
              Text('Qala-e-Fatullah'),
              SizedBox(width: 12),
            ],
          )
        ],
      ),
        drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 24),
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ...buildMenuItems(menuItems)
          ],
        ),
      ),
       body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Badge
            Container(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                'Welcome to Afghan Cosmos',
                style: TextStyle(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            // Title
            Text(
              'Your Trusted Partner in',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Growth and Innovation',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
            SizedBox(height: 20),
            
            Center(
              child: Image.asset(
                'assets/icons/logo.png',
                height: 200,
              ),
            ),
          ],
        ),
      ),
    );
  }

}