import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationNotifier extends AutoDisposeNotifier<int> {
  @override
  int build() {
    return 0;
  }

  void setIndex(int index) {
    state = index;
  }

  void goToHome() {
    state = 0;
  }

  void goToFavorites() {
    state = 1;
  }

  void goToProfile() {
    state = 2;
  }
}

final navigationProvider =
    AutoDisposeNotifierProvider<NavigationNotifier, int>(() {
  return NavigationNotifier();
});
