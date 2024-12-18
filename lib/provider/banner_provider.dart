import 'package:biriyan/models/banner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BannerProvider extends StateNotifier<List<BannerModel>> {
  BannerProvider() : super([]);

  // Set banners
  void setBanners(List<BannerModel> banners) {
    state = banners;
  }

  // Add a banner
  void addBanner(BannerModel banner) {
    state = [...state, banner];
  }

  // Remove a banner by ID
  void removeBanner(String id) {
    state = state.where((banner) => banner.id != id).toList();
  }
}

final bannerProvider =
    StateNotifierProvider<BannerProvider, List<BannerModel>>((ref) {
  return BannerProvider();
});
