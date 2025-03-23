class Booking {
  final String id;
  final String serviceId;
  final String serviceName;
  final String vehicleId;
  final DateTime dateTime;
  final double price;
  final String status; // confirmed, pending, cancelled, completed

  Booking({
    required this.id,
    required this.serviceId,
    required this.serviceName,
    required this.vehicleId,
    required this.dateTime,
    required this.price,
    required this.status,
  });
}

