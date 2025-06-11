import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourism_app/features/destination/presentation/widgets/destination_card_widget.dart';
import '../providers/destination_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      ref.read(destinationProvider.notifier).clearSearch();
    } else {
      ref.read(destinationProvider.notifier).searchDestinations(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final destinationState = ref.watch(destinationProvider);

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(12),
              child: TextField(
                cursorColor: Color(0XFF43b0f1),
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: "Search for destinations...",
                  floatingLabelStyle: TextStyle(color: Color(0XFF43b0f1)),
                  prefixIcon: Icon(Icons.public),
                  suffixIcon:
                      _searchController.text.isNotEmpty
                          ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _onSearchChanged('');
                            },
                          )
                          : const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Color(0XFF43b0f1), width: 2),
                  ),
                ),
              ),
            ),
            Expanded(
              child: destinationState.when(
                data:
                    (destinations) =>
                        destinations.isEmpty
                            ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.sentiment_dissatisfied,
                                    size: 60,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Oops! No destination found',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : ListView.builder(
                              itemCount: destinations.length,
                              itemBuilder: (context, index) {
                                final destination = destinations[index];
                                return DestinationCardWidget(
                                  destination: destination,
                                  ref: ref,
                                );
                              },
                            ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
