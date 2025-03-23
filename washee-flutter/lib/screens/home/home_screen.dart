import 'package:flutter/material.dart';
import 'package:washee/screens/bookings/bookings_screen.dart';
import 'package:washee/screens/home/components/home_banner.dart';
import 'package:washee/screens/home/components/service_categories.dart';
import 'package:washee/screens/home/components/special_offers.dart';
import 'package:washee/screens/home/components/upcoming_booking.dart';
import 'package:washee/screens/profile/profile_screen.dart';
import 'package:washee/screens/services/services_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const HomeContent(),
    const ServicesScreen(),
    const BookingsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.car_wash_outlined),
            activeIcon: Icon(Icons.car_wash),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 30,
                    fit: BoxFit.contain,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {
                      // Navigate to notifications
                    },
                  ),
                ],
              ),
            ),
            const HomeBanner(),
            const SizedBox(height: 24),
            const UpcomingBooking(),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Our Services',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 16),
            const ServiceCategories(),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Special Offers',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 16),
            const SpecialOffers(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

