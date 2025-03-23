import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:washee/models/booking.dart';
import 'package:washee/providers/booking_provider.dart';
import 'package:washee/widgets/custom_button.dart';

class BookingDetailsScreen extends StatelessWidget {
  final Booking booking;

  const BookingDetailsScreen({
    Key? key,
    required this.booking,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEEE, MMMM d, yyyy');
    final timeFormat = DateFormat('h:mm a');
    final isPastBooking = booking.dateTime.isBefore(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getStatusColor(booking.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _getStatusColor(booking.status).withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getStatusIcon(booking.status),
                      color: _getStatusColor(booking.status),
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _getStatusText(booking.status),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(booking.status),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getStatusDescription(booking.status),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Service details
            Text(
              'Service Details',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Container(
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
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.car_wash,
                          color: Theme.of(context).primaryColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking.serviceName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Booking ID: ${booking.id.substring(0, 8)}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Date',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              dateFormat.format(booking.dateTime),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Time',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              timeFormat.format(booking.dateTime),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Amount',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${booking.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action buttons
            if (!isPastBooking && booking.status.toLowerCase() != 'cancelled')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Actions',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            _showRescheduleDialog(context);
                          },
                          icon: const Icon(Icons.calendar_today),
                          label: const Text('Reschedule'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            _showCancelDialog(context);
                          },
                          icon: const Icon(Icons.cancel_outlined),
                          label: const Text('Cancel'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            foregroundColor: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

            if (isPastBooking && booking.status.toLowerCase() == 'completed')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rate Your Experience',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Container(
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
                      children: [
                        const Text(
                          'How was your car wash experience?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return IconButton(
                              icon: const Icon(Icons.star_border),
                              color: Colors.amber,
                              iconSize: 32,
                              onPressed: () {
                                // Handle rating
                              },
                            );
                          }),
                        ),
                        const SizedBox(height: 16),
                        CustomButton(
                          text: 'Submit Review',
                          onPressed: () {
                            // Handle review submission
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Icons.check_circle;
      case 'pending':
        return Icons.hourglass_empty;
      case 'cancelled':
        return Icons.cancel;
      case 'completed':
        return Icons.verified;
      default:
        return Icons.info;
    }
  }

  String _getStatusText(String status) {
    return status.substring(0, 1).toUpperCase() + status.substring(1);
  }

  String _getStatusDescription(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return 'Your booking has been confirmed. We look forward to serving you!';
      case 'pending':
        return 'Your booking is pending confirmation. We will notify you once it\'s confirmed.';
      case 'cancelled':
        return 'This booking has been cancelled.';
      case 'completed':
        return 'This service has been completed. Thank you for choosing us!';
      default:
        return '';
    }
  }

  void _showRescheduleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reschedule Booking'),
        content: const Text('This feature will be available soon.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
              bookingProvider.cancelBooking(booking.id);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }
}

