class EventItem {
  final int id;
  final String title;
  final String date;
  final String location;
  final String category;
  final String price;
  final String description;
  final bool isFeatured;
  final DateTime startsAt;

   const EventItem({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    required this.category,
    required this.price,
    required this.description,
    required this.isFeatured,
    required this.startsAt,
  });

  factory EventItem.fromJson(Map<String, dynamic> json) {
    final startsAt = DateTime.parse(json['fecha_inicio'] as String);
    return EventItem(
      id: json['id'] as int,
      title: json['titulo'] as String,
      date: _formatDate(startsAt),
      location: json['ubicacion'] as String,
      category: json['categoria'] as String,
      price: json['precio'] as String,
      description: json['descripcion'] as String,
      isFeatured: json['destacado'] as bool? ?? false,
      startsAt: startsAt,
    );
  }
}

String eventId(EventItem event) {
  return event.id.toString();
}

String _formatDate(DateTime dateTime) {
  const weekdays = [
    'Lun',
    'Mar',
    'Mié',
    'Jue',
    'Vie',
    'Sáb',
    'Dom',
  ];
  const months = [
    'Ene',
    'Feb',
    'Mar',
    'Abr',
    'May',
    'Jun',
    'Jul',
    'Ago',
    'Sep',
    'Oct',
    'Nov',
    'Dic',
  ];

  final weekday = weekdays[dateTime.weekday - 1];
  final month = months[dateTime.month - 1];
  final day = dateTime.day.toString().padLeft(2, '0');
  final hour = dateTime.hour.toString().padLeft(2, '0');
  final minute = dateTime.minute.toString().padLeft(2, '0');

  return '$weekday, $day $month · $hour:$minute';
}
