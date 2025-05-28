import 'package:flutter/material.dart';

// Theme provider class to manage app theme
class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  
  bool get isDarkMode => _isDarkMode;
  
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
  
  void setDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }
}

class SettingsPage extends StatefulWidget {
  final ThemeProvider? themeProvider;
  
  const SettingsPage({super.key, this.themeProvider});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;
  bool _soundEnabled = true;
  String _selectedLanguage = 'English';
  String _selectedDifficulty = 'Medium';
  
  bool get _darkModeEnabled => widget.themeProvider?.isDarkMode ?? false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        backgroundColor: isDark ? Colors.grey[850] : Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            _buildSectionCard(
              'Profile',
              [
                _buildProfileTile(),
                const Divider(height: 1),
                _buildListTile(
                  Icons.person_outline,
                  'Edit Profile',
                  'Update your personal information',
                  onTap: () => _showEditProfileDialog(),
                ),
                const Divider(height: 1),
                _buildListTile(
                  Icons.security,
                  'Privacy & Security',
                  'Manage your account security',
                  onTap: () => _showPrivacyDialog(),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Preferences Section
            _buildSectionCard(
              'Preferences',
              [
                _buildSwitchTile(
                  Icons.notifications_outlined,
                  'Notifications',
                  'Receive treasure hunt updates',
                  _notificationsEnabled,
                  (value) => setState(() => _notificationsEnabled = value),
                ),
                const Divider(height: 1),
                _buildSwitchTile(
                  Icons.location_on_outlined,
                  'Location Services',
                  'Enable GPS for treasure hunting',
                  _locationEnabled,
                  (value) => setState(() => _locationEnabled = value),
                ),
                const Divider(height: 1),
                _buildSwitchTile(
                  Icons.volume_up_outlined,
                  'Sound Effects',
                  'Play sounds during gameplay',
                  _soundEnabled,
                  (value) => setState(() => _soundEnabled = value),
                ),
                const Divider(height: 1),
                _buildSwitchTile(
                  Icons.dark_mode_outlined,
                  'Dark Mode',
                  'Switch to dark theme',
                  _darkModeEnabled,
                  (value) {
                    widget.themeProvider?.setDarkMode(value);
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Game Settings Section
            _buildSectionCard(
              'Game Settings',
              [
                _buildDropdownTile(
                  Icons.language_outlined,
                  'Language',
                  _selectedLanguage,
                  ['English', 'Spanish', 'French', 'German', 'Chinese'],
                  (value) => setState(() => _selectedLanguage = value!),
                ),
                const Divider(height: 1),
                _buildDropdownTile(
                  Icons.speed_outlined,
                  'Default Difficulty',
                  _selectedDifficulty,
                  ['Easy', 'Medium', 'Hard', 'Expert'],
                  (value) => setState(() => _selectedDifficulty = value!),
                ),
                const Divider(height: 1),
                _buildListTile(
                  Icons.leaderboard_outlined,
                  'Leaderboard Settings',
                  'Manage visibility preferences',
                  onTap: () => _showLeaderboardDialog(),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Support Section
            _buildSectionCard(
              'Support',
              [
                _buildListTile(
                  Icons.help_outline,
                  'Help & FAQ',
                  'Get answers to common questions',
                  onTap: () => _showHelpDialog(),
                ),
                const Divider(height: 1),
                _buildListTile(
                  Icons.feedback_outlined,
                  'Send Feedback',
                  'Share your thoughts with us',
                  onTap: () => _showFeedbackDialog(),
                ),
                const Divider(height: 1),
                _buildListTile(
                  Icons.info_outline,
                  'About',
                  'App version and information',
                  onTap: () => _showAboutDialog(),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Logout Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _showLogoutDialog(),
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  'Log Out',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, List<Widget> children) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Card(
      elevation: 2,
      color: isDark ? Colors.grey[800] : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildProfileTile() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Color(0xFF6C5CE7),
            child: Icon(Icons.person, size: 30, color: Colors.white),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NippoX',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '2560 Points',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, String subtitle, {VoidCallback? onTap}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF6C5CE7)),
      title: Text(
        title, 
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle, 
        style: TextStyle(
          fontSize: 12,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios, 
        size: 16, 
        color: isDark ? Colors.grey[400] : Colors.grey,
      ),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile(IconData icon, String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF6C5CE7)),
      title: Text(
        title, 
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle, 
        style: TextStyle(
          fontSize: 12,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF6C5CE7),
      ),
    );
  }

  Widget _buildDropdownTile(IconData icon, String title, String value, List<String> options, ValueChanged<String?> onChanged) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF6C5CE7)),
      title: Text(
        title, 
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
      trailing: DropdownButton<String>(
        value: value,
        dropdownColor: isDark ? Colors.grey[800] : Colors.white,
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(
              option,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        underline: Container(),
      ),
    );
  }

  void _showEditProfileDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? Colors.grey[800] : Colors.white,
        title: Text(
          'Edit Profile',
          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              decoration: InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
              ),
            ),
            TextField(
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('SAVE'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy & Security'),
        content: const Text('Manage your privacy settings and account security options.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLeaderboardDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leaderboard Settings'),
        content: const Text('Choose who can see your scores and achievements.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & FAQ'),
        content: const Text('Find answers to frequently asked questions about treasure hunting.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Feedback'),
        content: const TextField(
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Tell us what you think...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('SEND'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Trova'),
        content: const Text('Trova v1.0.0\n\nDiscover hidden treasures, explore new places, and compete with friends in the ultimate treasure hunting adventure.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              // Add your logout logic here
            },
            child: const Text('LOG OUT', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}