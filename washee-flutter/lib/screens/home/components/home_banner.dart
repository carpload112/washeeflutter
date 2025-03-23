import 'package:flutter/material.dart';
import 'package:washee/screens/services/service_booking_screen.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                'assets/images/car_wash_icon.png',
                width: 180,
                height: 180,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Premium Car Wash',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Get 20% off on your first booking',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ServiceBookingScreen(
                          serviceId: 'premium-wash',
                          serviceName: 'Premium Wash',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).primaryColor,
                  ),
                  child: const Text('Book Now'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

