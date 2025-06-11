import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourism_app/features/hotel/presentation/widgets/hotel_card_widget.dart';
import '../providers/hotel_provider.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
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
      ref.read(hotelProvider.notifier).clearSearch();
    } else {
      ref.read(hotelProvider.notifier).searchHotels(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hotelState = ref.watch(hotelProvider);

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                cursorColor: Color(0XFF43b0f1),
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search for hotels...',
                  floatingLabelStyle: TextStyle(color: Color(0XFF43b0f1)),
                  prefixIcon: const Icon(Icons.public),
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
              child: hotelState.when(
                data:
                    (hotels) =>
                        hotels.isEmpty
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
                                    'Oops! No hotel found',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: hotels.length,
                              itemBuilder:
                                  (context, index) => HotelCardWidget(
                                    hotel: hotels[index],
                                    ref: ref,
                                  ),
                            ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error:
                    (error, stackTrace) => Center(child: Text('Error: $error')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
