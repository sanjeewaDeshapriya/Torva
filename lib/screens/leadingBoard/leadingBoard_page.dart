import 'package:flutter/material.dart';
import 'package:torva/models/user.dart';
import 'package:torva/services/user_service.dart';
import 'package:torva/screens/home/home_page.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  int _selectedIndex =
      2;
  final UserService _userService = UserService();
  late Stream<List<UserModel>> _usersStream;

  @override
  void initState() {
    super.initState();
    _usersStream = _userService.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Leaderboard',
          style: TextStyle(
            color: Color(0xFF7033FA),
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF7033FA)),
          onPressed: () => Navigator.pushReplacementNamed(context, '/homepage'),
        ),

        centerTitle: true,
      ),
      body: StreamBuilder<List<UserModel>>(
        stream: _usersStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching users: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found.'));
          }

          // Sort users by points in descending order
          final sortedUsers =
              snapshot.data!
                ..sort((a, b) => (b.points ?? 0).compareTo(a.points ?? 0));

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 20),
              itemCount: sortedUsers.length,
              itemBuilder: (context, index) {
                final user = sortedUsers[index];
                return _leaderboardItem(user, index + 1);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _leaderboardItem(UserModel user, int rank) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage:
                user.photoURL != null
                    ? NetworkImage(user.photoURL!)
                    : const AssetImage('assets/profile1.jpg') as ImageProvider,
            
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.username,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "${user.points ?? 0} Points",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                rank <= 3 ? Icons.star_rounded : Icons.star_border_rounded,
                color:
                    rank == 1
                        ? Colors.yellow
                        : rank == 2
                        ? Colors.grey
                        : rank == 3
                        ? Colors.brown
                        : const Color(0xFF7033FA),
                size: 40,
              ),
              Text(
                rank.toString(),
                style: TextStyle(
                  color: rank <= 3 ? Colors.white : const Color(0xFF7033FA),
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
