import 'package:flutter/material.dart';
import 'package:washee/models/offer.dart';
import 'package:washee/screens/services/service_booking_screen.dart';

class SpecialOffers extends StatelessWidget {
  const SpecialOffers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final offers = [
      Offer(
        id: 'weekend-special',
        title: 'Weekend Special',
        description: 'Get 15% off on all services during weekends',
        imageUrl: 'assets/images/weekend_special.jpg',
        discount: 15,
      ),
      Offer(
        id: 'membership',
        title: 'Monthly Membership',
        description: 'Unlimited washes for a fixed monthly fee',
        imageUrl: 'assets/images/membership.jpg',
        discount: 0,
      ),
      Offer(
        id: 'combo-deal',
        title: 'Combo Deal',
        description: 'Interior + Exterior wash at discounted price',
        imageUrl: 'assets/images/combo_deal.jpg',
        discount: 20,
      ),
    ];

    return SizedBox(
      height: 200,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: offers.length,
        itemBuilder: (context, index) {
          final offer = offers[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ServiceBookingScreen(
                    serviceId: offer.id,
                    serviceName: offer.title,
                  ),
                ),
              );
            },
            child: Container(
              width: 280,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Image.asset(
                      offer.imageUrl,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          offer.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          offer.description,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

