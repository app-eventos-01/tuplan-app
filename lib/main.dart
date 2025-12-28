import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const TuPlanApp());
}

class TuPlanApp extends StatelessWidget {
  const TuPlanApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.light(
      primary: const Color(0xFF2563EB),
      onPrimary: Colors.white,
      secondary: const Color(0xFF10B981),
      onSecondary: Colors.white,
      surface: Colors.white,
      onSurface: const Color(0xFF0F172A),
      background: const Color(0xFFF1F5F9),
      onBackground: const Color(0xFF0F172A),
      outline: const Color(0xFFE2E8F0),
      surfaceTint: const Color(0xFF93C5FD),
    );

    return MaterialApp(
      title: 'TuPlan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: colorScheme.background,
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ).apply(
          bodyColor: colorScheme.onBackground,
          displayColor: colorScheme.onBackground,
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: TextStyle(
            color: colorScheme.onBackground,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: IconThemeData(color: colorScheme.onBackground),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: colorScheme.surface,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: const Color(0xFFEFF6FF),
          labelStyle: TextStyle(
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF8FAFC),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: colorScheme.outline),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: colorScheme.outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: colorScheme.primary, width: 1.6),
          ),
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: colorScheme.surface,
          surfaceTintColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            side: BorderSide(color: colorScheme.outline),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
      home: const AgeGateScreen(),
    );
  }
}

class AgeGateScreen extends StatelessWidget {
  const AgeGateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  Icons.nightlife_outlined,
                  color: colorScheme.primary,
                  size: 36,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'Antes de empezar',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(
                'Confirma que tienes la edad mínima para acceder a eventos y '
                'experiencias nocturnas en tu ciudad.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF475569),
                      height: 1.4,
                    ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¿Eres mayor de 18 años?',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Necesitamos comprobar tu edad para mostrarte eventos. '
                      'Esta información no se guarda.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF64748B),
                            height: 1.4,
                          ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Necesitas ser mayor de edad para continuar.',
                                  ),
                                ),
                              );
                            },
                            child: const Text('No, salir'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => const EventsHomeScreen(),
                                ),
                              );
                            },
                            child: const Text('Sí, continuar'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                'Al continuar aceptas nuestros términos de uso.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF94A3B8),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EventsHomeScreen extends StatefulWidget {
  const EventsHomeScreen({super.key});

  @override
  State<EventsHomeScreen> createState() => _EventsHomeScreenState();
}

class _EventsHomeScreenState extends State<EventsHomeScreen> {
  static const String _favoritesStorageKey = 'favorite_event_ids';
  final List<EventItem> _events = const [
    EventItem(
      title: 'Sunset Rooftop Session',
      date: 'Vie, 23 Ago · 19:30',
      location: 'Mirador Altura, CDMX',
      category: 'Música',
      price: 'Desde \$250',
      description:
          'Un atardecer con DJ sets, coctelería de autor y vista panorámica.',
      isFeatured: true,
    ),
    EventItem(
      title: 'Noche de Jazz Íntimo',
      date: 'Sáb, 24 Ago · 20:00',
      location: 'Casa Azul, Coyoacán',
      category: 'Live',
      price: 'Entrada libre',
      description:
          'Ensamble en vivo con piezas clásicas y contemporáneas.',
      isFeatured: false,
    ),
    EventItem(
      title: 'Brunch & Beats',
      date: 'Dom, 25 Ago · 12:00',
      location: 'Terraza Roma, CDMX',
      category: 'Gastro',
      price: 'Desde \$180',
      description:
          'Brunch creativo con sets chill y un mercado de diseño local.',
      isFeatured: true,
    ),
    EventItem(
      title: 'Electro Night',
      date: 'Vie, 30 Ago · 22:00',
      location: 'Warehouse Norte, CDMX',
      category: 'Club',
      price: 'Desde \$320',
      description:
          'Line up internacional y visuales inmersivas toda la noche.',
      isFeatured: false,
    ),
  ];

  final Set<String> _selectedCategories = {'Música', 'Live', 'Gastro', 'Club'};
  final Set<String> _favoriteIds = {};
  bool _onlyFree = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  String _eventId(EventItem event) {
    return '${event.title.trim().toLowerCase()}|'
        '${event.date.trim().toLowerCase()}|'
        '${event.location.trim().toLowerCase()}';
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIds = prefs.getStringList(_favoritesStorageKey) ?? [];
    if (!mounted) {
      return;
    }
    setState(() {
      _favoriteIds
        ..clear()
        ..addAll(savedIds);
    });
  }

  Future<void> _toggleFavorite(EventItem event) async {
    final eventId = _eventId(event);
    setState(() {
      if (_favoriteIds.contains(eventId)) {
        _favoriteIds.remove(eventId);
      } else {
        _favoriteIds.add(eventId);
      }
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesStorageKey, _favoriteIds.toList());
  }


  List<EventItem> get _filteredEvents {
  final query = _searchQuery.trim().toLowerCase();

  return _events.where((event) {
    final matchesCategory = _selectedCategories.contains(event.category);

    // “Solo gratuitos”: hacemos comparación en minúscula para evitar fallos.
    final priceText = event.price.toLowerCase();
    final matchesPrice = !_onlyFree || priceText.contains('libre');

    // Partimos location: "Venue, Zona"
    final locationParts = event.location.split(',');
    final venue = locationParts.first.trim().toLowerCase();
    final zone = locationParts.length > 1
        ? locationParts.last.trim().toLowerCase()
        : '';

    final titleText = event.title.toLowerCase();
    final locationText = event.location.toLowerCase();

    final matchesSearch = query.isEmpty ||
        titleText.contains(query) ||
        locationText.contains(query) ||
        venue.contains(query) ||
        zone.contains(query);

    return matchesCategory && matchesPrice && matchesSearch;
  }).toList();
}


  void _openFilters() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FilterBottomSheet(
          selectedCategories: _selectedCategories,
          onlyFree: _onlyFree,
          onApply: (categories, onlyFree) {
            setState(() {
              _selectedCategories
                ..clear()
                ..addAll(categories);
              _onlyFree = onlyFree;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('TuPlan'),
        actions: [
          IconButton(
            onPressed: _openFilters,
            icon: const Icon(Icons.tune_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          Text(
            'Encuentra tu siguiente plan',
            style: textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Eventos curados para disfrutar la ciudad con estilo.',
            style: textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 16),
TextField(
  onChanged: (value) {
    setState(() => _searchQuery = value);
  },
  textInputAction: TextInputAction.search,
  decoration: InputDecoration(
    hintText: 'Buscar por evento, venue o zona',
    prefixIcon: const Icon(Icons.search_rounded),
    suffixIcon: _searchQuery.isEmpty
        ? null
        : IconButton(
            tooltip: 'Limpiar',
            onPressed: () => setState(() => _searchQuery = ''),
            icon: const Icon(Icons.close_rounded),
          ),
  ),
),
const SizedBox(height: 16),
Wrap(
  spacing: 10,
  runSpacing: 10,
  children: _selectedCategories
      .map(
        (category) => _Chip(
          label: category,
          icon: Icons.check_circle,
          isSelected: true,
        ),
      )
      .toList(),
),

          const SizedBox(height: 20),
          if (_filteredEvents.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  const Icon(Icons.event_busy, size: 42),
                  const SizedBox(height: 12),
                  Text(
                    'No hay eventos disponibles',
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Ajusta tus filtros o vuelve más tarde.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            )
          else
            ..._filteredEvents.map(
              (event) {
                final isFavorite = _favoriteIds.contains(_eventId(event));
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: EventCard(
                    event: event,
                    isFavorite: isFavorite,
                    onFavoriteToggle: () => _toggleFavorite(event),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => EventDetailScreen(
                            event: event,
                            isFavorite: isFavorite,
                            onFavoriteToggle: () => _toggleFavorite(event),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class EventItem {
  final String title;
  final String date;
  final String location;
  final String category;
  final String price;
  final String description;
  final bool isFeatured;

  const EventItem({
    required this.title,
    required this.date,
    required this.location,
    required this.category,
    required this.price,
    required this.description,
    required this.isFeatured,
  });
}

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.event,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onTap,
  });

  final EventItem event;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      event.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  if (event.isFeatured)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.secondary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'Destacado',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: colorScheme.secondary,
                              fontSize: 12,
                            ),
                      ),
                    ),
                  IconButton(
                    tooltip: isFavorite
                        ? 'Quitar de favoritos'
                        : 'Guardar en favoritos',
                    onPressed: onFavoriteToggle,
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color:
                          isFavorite ? colorScheme.primary : const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                event.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF64748B),
                      height: 1.4,
                    ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _Chip(
                    label: event.category,
                    icon: Icons.local_activity_outlined,
                    isSelected: false,
                  ),
                  _Chip(
                    label: event.date,
                    icon: Icons.calendar_today_outlined,
                    isSelected: false,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.place_outlined, color: colorScheme.primary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      event.location,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    event.price,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.icon,
    required this.isSelected,
  });

  final String label;
  final IconData icon;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final backgroundColor =
        isSelected ? colorScheme.primary.withOpacity(0.12) : const Color(0xFFF1F5F9);
    final foregroundColor =
        isSelected ? colorScheme.primary : const Color(0xFF334155);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: foregroundColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: foregroundColor,
                ),
          ),
        ],
      ),
    );
  }
}

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({
    super.key,
    required this.selectedCategories,
    required this.onlyFree,
    required this.onApply,
  });

  final Set<String> selectedCategories;
  final bool onlyFree;
  final void Function(Set<String> categories, bool onlyFree) onApply;

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late final Set<String> _localCategories;
  late bool _onlyFree;

  @override
  void initState() {
    super.initState();
    _localCategories = {...widget.selectedCategories};
    _onlyFree = widget.onlyFree;
  }

  void _toggleCategory(String category) {
    setState(() {
      if (_localCategories.contains(category)) {
        _localCategories.remove(category);
      } else {
        _localCategories.add(category);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Filtrar eventos',
                    style: textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Categorías', style: textTheme.titleMedium),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    'Música',
                    'Live',
                    'Gastro',
                    'Club',
                  ]
                      .map(
                        (category) => GestureDetector(
                          onTap: () => _toggleCategory(category),
                          child: _Chip(
                            label: category,
                            icon: Icons.label_outline,
                            isSelected: _localCategories.contains(category),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.money_off_csred_outlined),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Solo eventos gratuitos',
                          style: textTheme.bodyMedium,
                        ),
                      ),
                      Switch.adaptive(
                        value: _onlyFree,
                        onChanged: (value) {
                          setState(() => _onlyFree = value);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _localCategories
                          ..clear()
                          ..addAll(['Música', 'Live', 'Gastro', 'Club']);
                        _onlyFree = false;
                      });
                    },
                    child: const Text('Restablecer'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onApply(_localCategories, _onlyFree);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Aplicar'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({
    super.key,
    required this.event,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  final EventItem event;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  @override
  void didUpdateWidget(covariant EventDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFavorite != widget.isFavorite) {
      _isFavorite = widget.isFavorite;
    }
  }

  void _handleFavoriteToggle() {
    widget.onFavoriteToggle();
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del evento'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary.withOpacity(0.9),
                  colorScheme.secondary.withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  widget.event.title,
                  style: textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Resumen', style: textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            widget.event.description,
            style: textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF64748B),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          _DetailSection(
            title: 'Horario',
            icon: Icons.calendar_today_outlined,
            content: widget.event.date,
          ),
          _DetailSection(
            title: 'Ubicación',
            icon: Icons.place_outlined,
            content: widget.event.location,
          ),
          _DetailSection(
            title: 'Categoría',
            icon: Icons.local_activity_outlined,
            content: widget.event.category,
          ),
          _DetailSection(
            title: 'Precio',
            icon: Icons.confirmation_number_outlined,
            content: widget.event.price,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.event_available),
            label: const Text('Reservar ahora'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _handleFavoriteToggle,
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
            label: Text(
              _isFavorite ? 'Quitar de favoritos' : 'Guardar en favoritos',
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({
    required this.title,
    required this.icon,
    required this.content,
  });

  final String title;
  final IconData icon;
  final String content;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: colorScheme.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    content,
                    style: textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
