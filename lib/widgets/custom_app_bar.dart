import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drawer Header for Profile
          UserAccountsDrawerHeader(
            accountName: Text(
              'Sibi Sebastian', // Placeholder for user's name
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail:
                Text('sibisebastian013@gmail.com'), // Placeholder for email
            currentAccountPicture: CircleAvatar(
              backgroundImage:
                  AssetImage('assets/profile.png'), // User profile image
            ),
            decoration: BoxDecoration(
              color: Colors.blue, // Same as AppBar color
            ),
          ),
          // Navigation Items
          ListTile(
            leading: Icon(Icons.home),
            title: Text(
              'Home',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              Navigator.pop(context); // Close drawer
              // Add logic to navigate to Home page
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              'Settings',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              Navigator.pop(context); // Close drawer
              // Add logic to navigate to Settings page
            },
          ),
          ListTile(
            leading: Icon(Icons.help_outline),
            title: Text(
              'Help & Support',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              Navigator.pop(context); // Close drawer
              // Add logic to navigate to Help & Support page
            },
          ),
          Spacer(), // Push Logout button to the bottom
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text(
              'Logout',
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
            onTap: () {
              Navigator.pop(context); // Close drawer
              _confirmLogout(context); // Show logout confirmation dialog
            },
          ),
        ],
      ),
    );
  }

  // Method to show a confirmation dialog for logout
  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text('Logout'),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                // Add logic to handle logout (e.g., clearing session data, navigating to login page)
              },
            ),
          ],
        );
      },
    );
  }
}
