import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:washee/models/vehicle.dart';
import 'package:washee/providers/auth_provider.dart';
import 'package:washee/screens/auth/login_screen.dart';
import 'package:washee/screens/profile/edit_profile_screen.dart';
import 'package:washee/screens/profile/my_vehicles_screen.dart';
import 'package:washee/widgets/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    if (user == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Mock vehicles - in a real app, you would fetch this from an API
    final vehicles = [
      Vehicle(
        id: 'v1',
        make: 'Toyota',
        model: 'Camry',
        year: 2020,
        licensePlate: 'ABC123',
      ),
      Vehicle(
        id: 'v2',
        make: 'Honda',
        model: 'Civic',
        year: 2019,
        licensePlate: 'XYZ789',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile header
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/profile_placeholder.jpg'),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const EditProfileScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Profile'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // My Vehicles
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Vehicles',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const MyVehiclesScreen(),
                      ),
                    );
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: vehicles.length + 1, // +1 for the "Add Vehicle" card
                itemBuilder: (context, index) {
                  if (index == vehicles.length) {
                    // Add Vehicle card
                    return GestureDetector(
                      onTap: () {
                        // Navigate to add vehicle screen
                      },
                      child: Container(
                        width: 140,
                        margin: const EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_circle_outline,
                              size: 32,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Add Vehicle',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  


                  // Vehicle card
                  final vehicle = vehicles[index];
                  return Container(
                    width: 140,
                    margin: const EdgeInsets.only(right: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.directions_car,
                          size: 32,
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${vehicle.make} ${vehicle.model}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          vehicle.licensePlate,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),

            // Settings
            Text(
              'Settings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildSettingsItem(
              context,
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              onTap: () {
                // Navigate to notifications settings
              },
            ),
            _buildSettingsItem(
              context,
              icon: Icons.payment_outlined,
              title: 'Payment Methods',
              onTap: () {
                // Navigate to payment methods
              },
            ),
            _buildSettingsItem(
              context,
              icon: Icons.help_outline,
              title: 'Help & Support',
              onTap: () {
                // Navigate to help & support
              },
            ),
            _buildSettingsItem(
              context,
              icon: Icons.info_outline,
              title: 'About Us',
              onTap: () {
                // Navigate to about us
              },
            ),
            const SizedBox(height: 32),

            // Logout button
            CustomButton(
              text: 'Logout',
              onPressed: () async {
                await authProvider.logout();
                if (context.mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                }
              },
              color: Colors.red,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
    );
  }
}

