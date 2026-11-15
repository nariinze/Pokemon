import 'package:get/get.dart';

import '../config.dart';
import '../models/item.dart';

class EntryController extends GetxController {
  final entries = <Entry>[].obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchEntries();
  }

  Future<void> fetchEntries() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      entries.assignAll(await appConfig.fetchEntries());
    } catch (e) {
      errorMessage.value =
          'Gagal memuat data. Periksa koneksi internetmu lalu coba lagi.';
    } finally {
      isLoading.value = false;
    }
  }
}
