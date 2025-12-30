import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/attendance_store.dart';
import 'data/events.dart';
import 'notifications/notification_service.dart';

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
      ),
      home: const OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('¡Hola!', style: textTheme.displayLarge),
              const SizedBox(height: 8),
              Text(
                'Descubre planes a tu medida y guarda tus favoritos.',
                style: textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFF64748B),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cuéntanos qué te gusta',
                      style: textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Selecciona algunas categorías para personalizar tus '
                      'recomendaciones.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: const [
                        _CategoryChip(label: 'Fiestas'),
                        _CategoryChip(label: 'Música'),
                        _CategoryChip(label: 'Gastronomía'),
                        _CategoryChip(label: 'Cultura'),
                        _CategoryChip(label: 'Deportes'),
                        _CategoryChip(label: 'Educación'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const HomeShell(),
                            ),
                          );
                        },
                        child: const Text('Comenzar'),
                      ),
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

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  static const String _favoritesStorageKey = 'favorite_event_ids';
  
  final Set<String> _favoriteIds = {};
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

 Future<void> _bootstrap() async {
  await NotificationService.instance.initialize();
  await NotificationService.instance.requestPermissions();
  await _loadFavorites();
}


  Future<void> _initializeNotifications() async {
    await NotificationService.instance.initialize();
    await NotificationService.instance.requestPermissions();
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
    await NotificationService.instance.updateDailyRecommendations(
      events: kEvents,
      favoriteIds: _favoriteIds,
    );
  }

  Future<void> _toggleFavorite(EventItem event) async {
    final id = eventId(event);
    setState(() {
      if (_favoriteIds.contains(id)) {
        _favoriteIds.remove(id);
      } else {
        _favoriteIds.add(id);
      }
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesStorageKey, _favoriteIds.toList());
    await NotificationService.instance.updateDailyRecommendations(
      events: kEvents,
      favoriteIds: _favoriteIds,
    );
  }

    @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final screens = [
      EventsHomeScreen(
        favoriteIds: _favoriteIds,
        onFavoriteToggle: _toggleFavorite,
      ),
      FavoritesScreen(
        events: kEvents,
        favoriteIds: _favoriteIds,
        onFavoriteToggle: _toggleFavorite,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('TuPlan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => NotificationSettingsScreen(
                    events: kEvents,
                    favoriteIds: _favoriteIds,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (value) => setState(() => _selectedIndex = value),
          backgroundColor: Colors.white,
          selectedItemColor: colorScheme.primary,
          unselectedItemColor: const Color(0xFF94A3B8),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore_rounded),
              label: 'Explorar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              activeIcon: Icon(Icons.favorite),
              label: 'Favoritos',
            ),
          ],
        ),
      ),
    );
  }
}

class EventsHomeScreen extends StatefulWidget {
  const EventsHomeScreen({
    super.key,
    required this.favoriteIds,
    required this.onFavoriteToggle,
  });

  final Set<String> favoriteIds;
  final void Function(EventItem event) onFavoriteToggle;

  @override
  State<EventsHomeScreen> createState() => _EventsHomeScreenState();
}

class _EventsHomeScreenState extends State<EventsHomeScreen> {
    final Set<String> _selectedCategories = {
    'Fiestas',
    'Música en vivo',
    'Comida y ferias gastronómicas',
    'Eventos culturales y artísticos',
    'Eventos Deportivos',
    'Eventos educativos',
    'Lugares Turísticos',
  };
  bool _onlyFree = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Explorar', style: textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Encuentra experiencias que están pasando cerca de ti.',
            style: textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => NotificationService.instance.showTestNow(),
              child: const Text('Enviar notificación de prueba'),
            ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '¿Qué plan quieres hoy?',
                    style: textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(28),
                        ),
                      ),
                      builder: (_) => _FiltersSheet(
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
                      ),
                    );
                  },
                  icon: const Icon(Icons.tune),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Recomendados', style: textTheme.titleLarge),
          const SizedBox(height: 12),
          _EventListSection(
            title: 'Planes destacados',
            events: _filteredEvents.take(3).toList(),
            favoriteIds: widget.favoriteIds,
            onFavoriteToggle: widget.onFavoriteToggle,
          ),
          const SizedBox(height: 24),
          Text('Cerca de ti', style: textTheme.titleLarge),
          const SizedBox(height: 12),
          _EventListSection(
            title: 'Planes disponibles',
            events: _filteredEvents,
            favoriteIds: widget.favoriteIds,
            onFavoriteToggle: widget.onFavoriteToggle,
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  List<EventItem> get _filteredEvents {
    return kEvents.where((event) {
      final matchesCategory = _selectedCategories.contains(event.category);
      final matchesPrice = !_onlyFree || event.price.toLowerCase().contains('libre');
      return matchesCategory && matchesPrice;
    }).toList();
  }
}

class _EventListSection extends StatelessWidget {
  const _EventListSection({
    required this.title,
    required this.events,
    required this.favoriteIds,
    required this.onFavoriteToggle,
  });

  final String title;
  final List<EventItem> events;
  final Set<String> favoriteIds;
  final void Function(EventItem event) onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    if (events.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          'No encontramos eventos con esos filtros.',
          style: textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF64748B),
          ),
        ),
      );
    }

    return Column(
      children: events.map((event) {
        final isFavorite = favoriteIds.contains(eventId(event));
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: EventCard(
            event: event,
            isFavorite: isFavorite,
            onFavoriteToggle: () => onFavoriteToggle(event),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => EventDetailScreen(
                    event: event,
                    isFavorite: isFavorite,
                    onFavoriteToggle: () => onFavoriteToggle(event),
                  ),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }
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
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      event.title,
                      style: textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    onPressed: onFavoriteToggle,
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.redAccent : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      event.date,
                      style: textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.place_outlined, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      event.location,
                      style: textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                children: [
                  Chip(label: Text(event.category)),
                  Chip(label: Text(event.price)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({
    super.key,
    required this.events,
    required this.favoriteIds,
    required this.onFavoriteToggle,
  });

  final List<EventItem> events;
  final Set<String> favoriteIds;
  final void Function(EventItem event) onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    final favorites = events
        .where((event) => favoriteIds.contains(eventId(event)))
        .toList();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Favoritos',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Guarda tus eventos preferidos para volver a verlos rápido.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF64748B),
                ),
          ),
          const SizedBox(height: 20),
          if (favorites.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Aún no tienes favoritos. Explora y guarda planes.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF64748B),
                    ),
              ),
            ),
          if (favorites.isNotEmpty)
            ...favorites.map((event) {
              final isFavorite = favoriteIds.contains(eventId(event));
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: EventCard(
                  event: event,
                  isFavorite: isFavorite,
                  onFavoriteToggle: () => onFavoriteToggle(event),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => EventDetailScreen(
                          event: event,
                          isFavorite: isFavorite,
                          onFavoriteToggle: () => onFavoriteToggle(event),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatefulWidget {
  const _CategoryChip({required this.label});

  final String label;

  @override
  State<_CategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends State<_CategoryChip> {
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(widget.label),
      selected: _selected,
      onSelected: (value) {
        setState(() {
          _selected = value;
        });
      },
    );
  }
}

class _FiltersSheet extends StatefulWidget {
  const _FiltersSheet({
    required this.selectedCategories,
    required this.onlyFree,
    required this.onApply,
  });

  final Set<String> selectedCategories;
  final bool onlyFree;
  final void Function(Set<String> categories, bool onlyFree) onApply;

  @override
  State<_FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends State<_FiltersSheet> {
  late Set<String> _localCategories;
  late bool _onlyFree;

  @override
  void initState() {
    super.initState();
    _localCategories = Set<String>.from(widget.selectedCategories);
    _onlyFree = widget.onlyFree;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Filtros', style: textTheme.titleLarge),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Categorías', style: textTheme.titleMedium),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _FilterChip(
                label: 'Fiestas',
                selected: _localCategories.contains('Fiestas'),
                onSelected: (selected) {
                  setState(() {
                    selected
                        ? _localCategories.add('Fiestas')
                        : _localCategories.remove('Fiestas');
                  });
                },
              ),
              _FilterChip(
                label: 'Música en vivo',
                selected: _localCategories.contains('Música en vivo'),
                onSelected: (selected) {
                  setState(() {
                    selected
                        ? _localCategories.add('Música en vivo')
                        : _localCategories.remove('Música en vivo');
                  });
                },
              ),
              _FilterChip(
                label: 'Comida y ferias gastronómicas',
                selected: _localCategories.contains('Comida y ferias gastronómicas'),
                onSelected: (selected) {
                  setState(() {
                    selected
                        ? _localCategories.add('Comida y ferias gastronómicas')
                        : _localCategories.remove('Comida y ferias gastronómicas');
                  });
                },
              ),
              _FilterChip(
                label: 'Eventos culturales y artísticos',
                selected:
                    _localCategories.contains('Eventos culturales y artísticos'),
                onSelected: (selected) {
                  setState(() {
                    selected
                        ? _localCategories.add('Eventos culturales y artísticos')
                        : _localCategories.remove('Eventos culturales y artísticos');
                  });
                },
              ),
              _FilterChip(
                label: 'Eventos Deportivos',
                selected: _localCategories.contains('Eventos Deportivos'),
                onSelected: (selected) {
                  setState(() {
                    selected
                        ? _localCategories.add('Eventos Deportivos')
                        : _localCategories.remove('Eventos Deportivos');
                  });
                },
              ),
              _FilterChip(
                label: 'Eventos educativos',
                selected: _localCategories.contains('Eventos educativos'),
                onSelected: (selected) {
                  setState(() {
                    selected
                        ? _localCategories.add('Eventos educativos')
                        : _localCategories.remove('Eventos educativos');
                  });
                },
              ),
              _FilterChip(
                label: 'Lugares Turísticos',
                selected: _localCategories.contains('Lugares Turísticos'),
                onSelected: (selected) {
                  setState(() {
                    selected
                        ? _localCategories.add('Lugares Turísticos')
                        : _localCategories.remove('Lugares Turísticos');
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          SwitchListTile(
            value: _onlyFree,
            onChanged: (value) => setState(() => _onlyFree = value),
            title: const Text('Solo eventos gratuitos'),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _localCategories = {
                        'Fiestas',
                        'Música en vivo',
                        'Comida y ferias gastronómicas',
                        'Eventos culturales y artísticos',
                        'Eventos Deportivos',
                        'Eventos educativos',
                        'Lugares Turísticos',
                      };

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
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
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
  bool _isAttending = false;
  bool _attendanceRemindersEnabled = true;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
    _loadAttendanceState();
  }

  @override
  void didUpdateWidget(covariant EventDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFavorite != widget.isFavorite) {
      _isFavorite = widget.isFavorite;
    }
  }

  Future<void> _loadAttendanceState() async {
    final attending = await isAttending(eventId(widget.event));
    final prefs = await SharedPreferences.getInstance();
    final remindersEnabled =
        prefs.getBool(NotificationService.attendanceRemindersKey) ?? true;
    if (!mounted) {
      return;
    }
    setState(() {
      _attendanceRemindersEnabled = remindersEnabled;
      _isAttending = attending;
    });
  }

  void _handleFavoriteToggle() {
    widget.onFavoriteToggle();
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  Future<void> _handleAttendanceToggle() async {
    final id = eventId(widget.event);
    final updatedIds = await toggleAttending(id);
    final isAttendingNow = updatedIds.contains(id);

    setState(() {
      _isAttending = isAttendingNow;
    });

    if (isAttendingNow) {
      if (_attendanceRemindersEnabled) {
        await NotificationService.instance.scheduleEventNotifications(
          widget.event,
        );
      }
    } else {
      await NotificationService.instance.cancelEventNotifications(
        widget.event,
      );
    }
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
            onPressed: _handleAttendanceToggle,
            icon: Icon(
              _isAttending ? Icons.event_busy : Icons.event_available,
            ),
            label: Text(
              _isAttending ? 'Cancelar asistencia' : 'Confirmar asistencia',
            ),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF94A3B8)),
          const SizedBox(width: 8),
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(
              color: const Color(0xFF334155),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              content,
              style: textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF64748B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({
    super.key,
    required this.events,
    required this.favoriteIds,
  });

  final List<EventItem> events;
  final Set<String> favoriteIds;

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _dailyRecommendations = false;
  bool _attendanceReminders = true;
  Set<String> _attendanceIds = {};

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) {
      return;
    }
    setState(() {
      _dailyRecommendations =
          prefs.getBool(NotificationService.dailyRecommendationsKey) ?? false;
      _attendanceReminders =
          prefs.getBool(NotificationService.attendanceRemindersKey) ?? true;
      _attendanceIds =
          (prefs.getStringList(attendingEventIdsKey) ?? []).toSet();
    });
  }

  Future<void> _toggleDailyRecommendations(bool value) async {
    setState(() => _dailyRecommendations = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(NotificationService.dailyRecommendationsKey, value);
    if (value) {
      await NotificationService.instance.updateDailyRecommendations(
        events: widget.events,
        favoriteIds: widget.favoriteIds,
      );
    } else {
      await NotificationService.instance.cancelDailyRecommendations();
    }
  }

  Future<void> _toggleAttendanceReminders(bool value) async {
    setState(() => _attendanceReminders = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(NotificationService.attendanceRemindersKey, value);
    if (!value) {
      await NotificationService.instance
          .cancelAttendanceNotificationsForIds(_attendanceIds);
      return;
    }

    final eventsById = {
      for (final event in widget.events) eventId(event): event,
    };
    for (final id in _attendanceIds) {
      final event = eventsById[id];
      if (event != null) {
        await NotificationService.instance.scheduleEventNotifications(
          event,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SwitchListTile(
            value: _dailyRecommendations,
            onChanged: _toggleDailyRecommendations,
            title: const Text('Recomendaciones diarias'),
            subtitle: const Text('Recibe sugerencias de eventos cada mañana.'),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            value: _attendanceReminders,
            onChanged: _toggleAttendanceReminders,
            title: const Text('Recordatorios de asistencia'),
            subtitle: const Text(
              'Recibe avisos antes de los eventos confirmados.',
            ),
          ),
        ],
      ),
    );
  }
}
