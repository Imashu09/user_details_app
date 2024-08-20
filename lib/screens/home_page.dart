import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_provider/screens/detail_screen.dart';
import 'package:users_provider/user_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            Provider.of<UserProvider>(context, listen: false).fetchUsers(),
        child: Consumer<UserProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (provider.errorMessage != null) {
              return Center(child: Text(provider.errorMessage!));
            }
            if (provider.users.isEmpty) {
              return Center(child: Text('No users available.'));
            }

            return ListView.builder(
              itemCount: provider.users.length,
              itemBuilder: (context, index) {
                final user = provider.users[index];
                return ListTile(
                  leading: CircleAvatar(child: Text(user.id.toString())),
                  title: Text(user.name,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(user.email),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserDetailScreen(user: user),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
