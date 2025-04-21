import 'package:get/get.dart';

import '../models/movie_model.dart';
import '../services/movie_Api_service.dart';

class MovieController extends GetxController {
  //--servicer connect
  final MovieApiService _apiService = MovieApiService();
  //- state variable
  final RxList<Movie> allMovies =
      <Movie>[].obs; // เอาไว้เก็บ data ทุกครั้งที่มีการfetch (buffer data)
  final RxList<Movie> filteredMovies = <Movie>[].obs; // data ที่ส่งให้ UI
  final RxBool isLoading = true.obs; // state  load data
  final RxBool hasError = false.obs; // state  Error
  final RxString errorMessage = ''.obs; // data in state error
//-- event variable
  final RxString searchQuery = ''.obs; // รับค่าการ Search จาก UI

  @override
  void onInit() {
    super.onInit();
    fetchMovies();
    // ติดตามการเปลี่ยนแปลงของคำค้นหา
    ever(searchQuery, (_) => filterMovies());
  }

  Future<void> fetchMovies() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      final movies = await _apiService.getRandomMovies();
      allMovies.assignAll(movies);
      filteredMovies.assignAll(movies);
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // อัปเดตคำค้นหา
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  // กรองหนังตามคำค้นหา
  void filterMovies() {
    if (searchQuery.isEmpty) {
      filteredMovies.assignAll(allMovies);
      return;
    }

    final query = searchQuery.value.toLowerCase();
    List<Movie> results = allMovies.where((movie) {
      // แปลงให้เป็น LowerCase แล้ว หา
      return movie.movie.toLowerCase().contains(query);
    }).toList();

    filteredMovies.assignAll(results);
  }

  // รีเฟรชข้อมูลใหม่
  Future<void> refreshMovies() async {
    searchQuery.value = '';
    await fetchMovies();
  }
}
