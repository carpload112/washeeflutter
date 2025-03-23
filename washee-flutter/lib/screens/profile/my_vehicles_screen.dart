import 'package:flutter/material.dart';
import 'package:washee/models/vehicle.dart';
import 'package:washee/widgets/custom_button.dart';

class MyVehiclesScreen extends StatefulWidget {
  const MyVehiclesScreen({Key? key}) : super(key: key);

  @override
  State<MyVehiclesScreen> createState() => _MyVehiclesScreenState();
}

class _MyVehiclesScreenState extends State<MyVehiclesScreen> {
  // Mock vehicles - in a real app, you would fetch this from an API
  final List<Vehicle> _vehicles = [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Vehicles'),
      ),
      body: _vehicles.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.directions_car_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No vehicles added yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add your first vehicle to get started',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _vehicles.length,
              itemBuilder: (context, index) {
                final vehicle = _vehicles[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
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
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.directions_car,
                        color: Theme.of(context).primaryColor,
                        size: 24,
                      ),
                    ),
                    title: Text(
                      '${vehicle.make} ${vehicle.model}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          'Year: ${vehicle.year}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'License Plate: ${vehicle.licensePlate}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _showEditVehicleDialog(context, vehicle);
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddVehicleDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddVehicleDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _makeController = TextEditingController();
    final _modelController = TextEditingController();
    final _yearController = TextEditingController();
    final _licensePlateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Vehicle'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _makeController,
                  decoration: const InputDecoration(
                    labelText: 'Make',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the make';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _modelController,
                  decoration: const InputDecoration(
                    labelText: 'Model',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the model';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _yearController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Year',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the year';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid year';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _licensePlateController,
                  decoration: const InputDecoration(
                    labelText: 'License Plate',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the license plate';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final newVehicle = Vehicle(
                  id: 'v${DateTime.now().millisecondsSinceEpoch}',
                  make: _makeController.text.trim(),
                  model: _modelController.text.trim(),
                  year: int.parse(_yearController.text.trim()),
                  licensePlate: _licensePlateController.text.trim(),
                );

                setState(() {
                  _vehicles.add(newVehicle);
                });

                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditVehicleDialog(BuildContext context, Vehicle vehicle) {
    final _formKey = GlobalKey<FormState>();
    final _makeController = TextEditingController(text: vehicle.make);
    final _modelController = TextEditingController(text: vehicle.model);
    final _yearController = TextEditingController(text: vehicle.year.toString());
    final _licensePlateController = TextEditingController(text: vehicle.licensePlate);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Vehicle'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _makeController,
                  decoration: const InputDecoration(
                    labelText: 'Make',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the make';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _modelController,
                  decoration: const InputDecoration(
                    labelText: 'Model',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the model';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _yearController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Year',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the year';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid year';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _licensePlateController,
                  decoration: const InputDecoration(
                    labelText: 'License Plate',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the license plate';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final updatedVehicle = Vehicle(
                  id: vehicle.id,
                  make: _makeController.text.trim(),
                  model: _modelController.text.trim(),
                  year: int.parse(_yearController.text.trim()),
                  licensePlate: _licensePlateController.text.trim(),
                );

                setState(() {
                  final index = _vehicles.indexWhere((v) => v.id == vehicle.id);
                  if (index != -1) {
                    _vehicles[index] = updatedVehicle;
                  }
                });

                Navigator.of(context).pop();
              }
            },
            child: const Text('Save'),
          ),
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Vehicle'),
                  content: const Text('Are you sure you want to delete this vehicle?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _vehicles.removeWhere((v) => v.id == vehicle.id);
                        });
                        Navigator.of(context).pop(); // Close delete dialog
                        Navigator.of(context).pop(); // Close edit dialog
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

