import 'package:flutter/material.dart';
import 'package:washee/models/service.dart';
import 'package:washee/screens/services/service_booking_screen.dart';

class ServiceListScreen extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  const ServiceListScreen({
    Key? key,
    required this.categoryId,
    required this.categoryName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // In a real app, you would filter services based on categoryId
    final services = [
      Service(
        id: '$categoryId-basic',
        name: 'Basic $categoryName',
        description: 'Standard service package',
        price: 15.99,
        duration: 30,
        imageUrl: 'assets/images/basic_wash.jpg',
      ),
      Service(
        id: '$categoryId-premium',
        name: 'Premium $categoryName',
        description: 'Enhanced service with additional features',
        price: 24.99,
        duration: 45,
        imageUrl: 'assets/images/premium_wash.jpg',
      ),
      Service(
        id: '$categoryId-deluxe',
        name: 'Deluxe $categoryName',
        description: 'Our most comprehensive service package',
        price: 34.99,
        duration: 60,
        imageUrl: 'assets/images/full_detailing.jpg',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
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
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                    child: Image.asset(
                      service.imageUrl,
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            service.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
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
                              Text(
                                '\$${service.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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

