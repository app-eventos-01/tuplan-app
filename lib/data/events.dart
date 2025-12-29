class EventItem {
  final String title;
  final String date;
  final String location;
  final String category;
  final String price;
  final String description;
  final bool isFeatured;
  final DateTime? startsAt;

   EventItem({
    required this.title,
    required this.date,
    required this.location,
    required this.category,
    required this.price,
    required this.description,
    required this.isFeatured,
    this.startsAt,
  });
}

List<EventItem> kEvents = [
  EventItem(
    title: 'Planazo: Fiesta en Sopocachi',
    date: 'Vie, 03 Ene · 22:00',
    location: 'Sopocachi, La Paz',
    category: 'Fiestas',
    price: 'Desde Bs 50',
    description:
        'Noche de fiesta con DJ, ambiente indie y promociones hasta medianoche.',
    isFeatured: true,
  ),
  EventItem(
    title: 'Música en vivo: Jazz en San Miguel',
    date: 'Sáb, 04 Ene · 20:00',
    location: 'San Miguel, La Paz',
    category: 'Música en vivo',
    price: 'Entrada libre',
    description:
        'Sesión íntima de jazz con banda local y coctelería de autor.',
    isFeatured: false,
  ),
  EventItem(
    title: 'Feria gastronómica en El Prado',
    date: 'Dom, 05 Ene · 11:00',
    location: 'El Prado, La Paz',
    category: 'Comida y ferias gastronómicas',
    price: 'Entrada libre',
    description:
        'Comida típica, postres, café y stands de emprendimientos paceños.',
    isFeatured: true,
  ),
  EventItem(
    title: 'Cultura: Noche de museo',
    date: 'Jue, 09 Ene · 18:30',
    location: 'Centro, La Paz',
    category: 'Eventos culturales y artísticos',
    price: 'Entrada libre',
    description:
        'Recorrido por exposiciones y muestras de arte con guías locales.',
    isFeatured: false,
  ),
  EventItem(
    title: 'Deportes: Carrera 10K',
    date: 'Sáb, 11 Ene · 07:00',
    location: 'Achumani, La Paz',
    category: 'Eventos Deportivos',
    price: 'Desde Bs 30',
    description:
        'Carrera recreativa 10K con hidratación y medalla para participantes.',
    isFeatured: false,
  ),
  EventItem(
    title: 'Educativo: Taller de fotografía urbana',
    date: 'Dom, 12 Ene · 15:00',
    location: 'Sopocachi, La Paz',
    category: 'Eventos educativos',
    price: 'Desde Bs 80',
    description:
        'Aprende composición, luz y edición básica con práctica en la calle.',
    isFeatured: false,
  ),
  EventItem(
    title: 'Turístico: Miradores y teleférico',
    date: 'Todos los días · 10:00',
    location: 'Estación Central, La Paz',
    category: 'Lugares Turísticos',
    price: 'Desde Bs 20',
    description:
        'Ruta recomendada por miradores y líneas del teleférico para vistas top.',
    isFeatured: true,
  ),
];


String eventId(EventItem event) {
  return '${event.title.trim().toLowerCase()}|'
      '${event.date.trim().toLowerCase()}|'
      '${event.location.trim().toLowerCase()}';
}
