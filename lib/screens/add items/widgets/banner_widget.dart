import 'package:biriyan/controllers/banner_controller.dart';
import 'package:biriyan/models/banner.dart';
import 'package:biriyan/provider/banner_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BannerWidget extends ConsumerStatefulWidget {
  const BannerWidget({super.key});

  @override
  ConsumerState<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends ConsumerState<BannerWidget> {
  late Future<List<BannerModel>> futureBanners;
  final BannerController bannerController = BannerController();

  Future<void> _fetchBanners() async {
    try {
      final banners = await bannerController.loadBanners();
      ref.read(bannerProvider.notifier).setBanners(banners);
    } catch (e) {
      print('Error fetching banners: $e');
    }
  }

  Future<void> _deleteBanner(String id) async {
    try {
      await bannerController.deleteBanner(id);
      // Refresh banners after deletion
      await _fetchBanners();
    } catch (e) {
      print('Error deleting banner: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    futureBanners = BannerController().loadBanners();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureBanners, // Replace with your future variable
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No banners available'),
          );
        } else {
          final banners =
              snapshot.data!; // Ensure this matches your future's data type
          return ListView.builder(
            shrinkWrap: true,
            itemCount: banners.length,
            itemBuilder: (context, index) {
              final banner = banners[index];
              return ListTile(
                leading: Image.network(
                  banner.image,
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
                title: Text('Banner ID: ${banner.id}',style:  TextStyle(color: Colors.white.withOpacity(0.8)),),
                trailing: IconButton(
                  icon:  Icon(Icons.delete,color: Colors.red.withOpacity(0.8),),
                  onPressed: () async {
                    // Confirm delete action
                    await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Delete Banner'),
                          content: const Text(
                              'Are you sure you want to delete this banner?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                await _deleteBanner(banner.id);
                              },
                              child: const Text('Delete'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        }
      },
    );
  }
}
