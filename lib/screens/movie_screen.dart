import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/movie_controller.dart';
import '../models/movie_model.dart';

class MovieScreen extends StatelessWidget {
  MovieScreen({super.key});
  final MovieController controller = Get.put(MovieController());
  final searchTextField = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(context),
            Expanded(
              child: _buildMovieList(),
            ),
          ],
        ),
      ),
    );
  }

  //-- UI search bar
  Widget _buildSearchBar(context) {
    double _width = MediaQuery.sizeOf(context).width;
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 18),
          child: SizedBox(
            height: 41,
            width: _width * 0.75,
            child: TextField(
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                hintText: 'search movie...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                filled: true,
                // fillColor: Colors.grey[100],
              ),
              onChanged: controller.updateSearchQuery,
              controller: searchTextField,
            ),
          ),
        ),
        InkWell(
            onTap: () {
              // isSearching.value = false;
              searchTextField.clear();
              controller.searchQuery.value = '';
              controller.filterMovies();
            },
            child: Text("Cancel"))
      ],
    );
  }

  //--UI List Movies
  Widget _buildMovieList() {
    return Obx(() {
      //-- UI when  Loading
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }
      //-- UI when error
      else if (controller.hasError.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'เกิดข้อผิดพลาด',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                controller.errorMessage.value,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: controller.fetchMovies,
                child: Text('ลองใหม่'),
              ),
            ],
          ),
        );
      }
      //-- UI when filteredMovies == null
      else if (controller.filteredMovies.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.movie_filter, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'ไม่พบหนังที่ค้นหา',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        );
      } else {
        return RefreshIndicator(
          onRefresh: controller.refreshMovies,
          child: ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: controller.filteredMovies.length,
            itemBuilder: (context, index) {
              final movie = controller.filteredMovies[index];
              return _buildMovieTile(movie);
            },
          ),
        );
      }
      //-- UI when filteredMovies != null
    });
  }

  Widget _buildMovieTile(Movie movie) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Poster
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: movie.poster,
              width: 100,
              height: 148,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  Container(width: 100, height: 148, color: Colors.grey[800]),
              errorWidget: (context, url, error) =>
                  Icon(Icons.error, color: Colors.white),
            ),
          ),
          SizedBox(width: 16),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // "Free" Tag
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.cyanAccent[400],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Free',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                SizedBox(height: 8),

                // Title
                Text(
                  movie.movie,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),

                // Year
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.grey, size: 16),
                    SizedBox(width: 6),
                    Text(
                      movie.year.toString(),
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),

                SizedBox(height: 6),

                // Duration
                Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.grey, size: 16),
                    SizedBox(width: 6),
                    Text(
                      movie.movieDuration.toString(),
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
