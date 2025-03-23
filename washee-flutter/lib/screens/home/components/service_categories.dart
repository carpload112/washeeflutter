import 'package:flutter/material.dart';
import 'package:washee/models/service_category.dart';
import 'package:washee/screens/services/service_list_screen.dart';

class ServiceCategories extends StatelessWidget {
  const ServiceCategories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = [
      ServiceCategory(
        id: 'basic',
        name: 'Basic Wash',
        icon: Icons.local_car_wash,
        color: Colors.blue,
      ),
      ServiceCategory(
        id: 'premium',
        name: 'Premium Wash',
        icon: Icons.car_wash,
        color: Colors.green,
      ),
      ServiceCategory(
        id: 'interior',
        name: 'Interior Clean',
        icon: Icons.airline_seat_recline_normal,
        color: Colors.orange,
      ),
      ServiceCategory(
        id: 'detailing',
        name: 'Detailing',
        icon: Icons.auto_awesome,
        color: Colors.purple,
      ),
    ];

    return SizedBox(
      height: 120,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ServiceListScreen(
                    categoryId: category.id,
                    categoryName: category.name,
                  ),
                ),
              );
            },
            child: Container(
              width: 100,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: category.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      category.icon,
                      color: category.color,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
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

