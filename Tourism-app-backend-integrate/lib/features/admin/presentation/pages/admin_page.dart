import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/provider_config.dart';
import '../widgets/destinations_tab.dart';
import '../widgets/hotels_tab.dart';
import '../widgets/destination_dialogs.dart';
import '../widgets/hotel_dialogs.dart';

class AdminPage extends ConsumerStatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends ConsumerState<AdminPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Use Future.microtask to schedule the loading after the current build phase
    Future.microtask(() {
      final provider = ref.read(adminProvider);
      provider.loadDestinations();
      provider.loadHotels();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(adminProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
        title: const Text('Admin Dashboard'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Destinations'),
            Tab(text: 'Hotels'),
          ],
        ),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: ${provider.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          final provider = ref.read(adminProvider);
                          provider.loadDestinations();
                          provider.loadHotels();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : TabBarView(
                  controller: _tabController,
                  children: const [
                    DestinationsTab(),
                    HotelsTab(),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDialog(context, _tabController.index == 0 ? 'Destination' : 'Hotel');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context, String type) {
    showDialog(
      context: context,
      builder: (context) => type == 'Destination' 
        ? const AddDestinationDialog()
        : const AddHotelDialog(),
    );
  }
} 