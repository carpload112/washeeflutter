import 'package:flutter/material.dart';
import 'package:washee/models/service.dart';
import 'package:washee/screens/services/service_booking_screen.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final services = [
      Service(
        id: 'basic-wash',
        name: 'Basic Wash',
        description: 'Exterior wash with soap and water',
        price: 15.99,
        duration: 30,
        imageUrl: 'assets/images/basic_wash.jpg',
      ),
      Service(
        id: 'premium-wash',
        name: 'Premium Wash',
        description: 'Exterior wash with wax and tire shine',
        price: 24.99,
        duration: 45,
        imageUrl: 'assets/images/premium_wash.jpg',
      ),
      Service(
        id: 'interior-clean',
        name: 'Interior Clean',
        description: 'Vacuum, dashboard cleaning, and window cleaning',
        price: 29.99,
        duration: 40,
        imageUrl: 'assets/images/interior_clean.jpg',
      ),
      Service(
        id: 'full-detailing',
        name: 'Full Detailing',
        description: 'Complete interior and exterior detailing',
        price: 99.99,
        duration: 120,
        imageUrl: 'assets/images/full_detailing.jpg',
      ),
      Service(
        id: 'express-wash',
        name: 'Express Wash',
        description: 'Quick exterior wash for when you\'re in a hurry',
        price: 9.99,
        duration: 15,
        imageUrl: 'assets/images/express_wash.jpg',
      ),
      Service(
        id: 'ceramic-coating',
        name: 'Ceramic Coating',
        description: 'Long-lasting protection for your vehicle\'s paint',
        price: 199.99,
        duration: 180,
        imageUrl: 'assets/images/ceramic_coating.jpg',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Services'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ServiceBookingScreen(
                    serviceId: service.id,
                    serviceName: service.name,
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
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
                      service.imageUrl,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              service.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\$${service.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          service.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${service.duration} min',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ServiceBookingScreen(
                                  serviceId: service.id,
                                  serviceName: service.name,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 45),
                          ),
                          child: const Text('Book Now'),
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

