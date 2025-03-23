import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:washee/models/booking.dart';
import 'package:washee/models/service.dart';
import 'package:washee/models/vehicle.dart';
import 'package:washee/providers/booking_provider.dart';
import 'package:washee/screens/bookings/booking_confirmation_screen.dart';
import 'package:washee/widgets/custom_button.dart';

class ServiceBookingScreen extends StatefulWidget {
  final String serviceId;
  final String serviceName;

  const ServiceBookingScreen({
    Key? key,
    required this.serviceId,
    required this.serviceName,
  }) : super(key: key);

  @override
  State<ServiceBookingScreen> createState() => _ServiceBookingScreenState();
}

class _ServiceBookingScreenState extends State<ServiceBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 0);
  String? _selectedVehicleId;
  bool _isLoading = false;

  // Mock service data - in a real app, you would fetch this from an API
  late Service _service;

  // Mock vehicle data - in a real app, you would fetch this from an API
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
  void initState() {
    super.initState();
    // Mock service data - in a real app, you would fetch this based on serviceId
    _service = Service(
      id: widget.serviceId,
      name: widget.serviceName,
      description: 'Professional car wash service',
      price: 24.99,
      duration: 45,
      imageUrl: 'assets/images/premium_wash.jpg',
    );

    if (_vehicles.isNotEmpty) {
      _selectedVehicleId = _vehicles.first.id;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _bookService() async {
    if (!_formKey.currentState!.validate() || _selectedVehicleId == null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Combine date and time
      final bookingDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      // Create booking
      final booking = Booking(
        id: 'booking-${DateTime.now().millisecondsSinceEpoch}',
        serviceId: _service.id,
        serviceName: _service.name,
        vehicleId: _selectedVehicleId!,
        dateTime: bookingDateTime,
        price: _service.price,
        status: 'confirmed',
      );

      // Add booking to provider
      final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
      await bookingProvider.addBooking(booking);

      if (!mounted) return;

      // Navigate to confirmation screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => BookingConfirmationScreen(booking: booking),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEE, MMM d, yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Service'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service details
              Container(
                padding: const EdgeInsets.all(16),
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
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        _service.imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _service.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _service.description,
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
                                    '${_service.duration} min',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '\$${_service.price.toStringAsFixed(2)}',
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
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Vehicle selection
              Text(
                'Select Vehicle',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedVehicleId,
                decoration: const InputDecoration(
                  labelText: 'Vehicle',
                  prefixIcon: Icon(Icons.directions_car),
                ),
                items: _vehicles.map((vehicle) {
                  return DropdownMenuItem<String>(
                    value: vehicle.id,
                    child: Text('${vehicle.make} ${vehicle.model} (${vehicle.licensePlate})'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedVehicleId = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a vehicle';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () {
                  // Navigate to add vehicle screen
                },
                icon: const Icon(Icons.add),
                label: const Text('Add New Vehicle'),
              ),
              const SizedBox(height: 24),

              // Date and time selection
              Text(
                'Select Date & Time',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today),
                            const SizedBox(width: 8),
                            Text(dateFormat.format(_selectedDate)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectTime(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time),
                            const SizedBox(width: 8),
                            Text(_selectedTime.format(context)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Booking button
              CustomButton(
                text: 'Book Now - \$${_service.price.toStringAsFixed(2)}',
                isLoading: _isLoading,
                onPressed: _bookService,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

