import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:pric_assigment/search_history_page.dart';
import 'auth/emailhome.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List images = [];
  bool isLoading = true;
  bool isPaginating = false;
  int page = 1;
  String query = 'Warsaw';
  TextEditingController searchController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  List<String> searchHistory = [];

  @override
  void initState() {
    super.initState();
    fetchImages(query, page);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !isPaginating) {
        loadMoreImages();
      }
    });
  }

  Future<void> fetchImages(String searchQuery, int pageNumber) async {
    setState(() {
      isLoading = pageNumber == 1;
      isPaginating = pageNumber > 1;
    });

    var headers = {
      'Authorization': 'Client-ID a96WsWgL3LDZ28WvTBVv3CFKlfkX9VqgcCN_6voY7ik'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://api.unsplash.com/search/photos?query=$searchQuery&page=$pageNumber&per_page=10'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(await response.stream.bytesToString());
      setState(() {
        if (pageNumber == 1) {
          images = jsonResponse['results'];
        } else {
          images.addAll(jsonResponse['results']);
        }
        isLoading = false;
        isPaginating = false;
      });
      saveSearchQuery(searchQuery);
    } else {
      print(response.reasonPhrase);
      setState(() {
        isLoading = false;
        isPaginating = false;
      });
    }
  }

  Future<void> saveSearchQuery(String query) async {
    await FirebaseFirestore.instance.collection('searchHistory').add({
      'query': query,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  void onSearch() {
    String searchQuery = searchController.text.trim();
    if (searchQuery.isNotEmpty) {
      page = 1;
      fetchImages(searchQuery, page);
    }
  }

  void loadMoreImages() {
    if (!isPaginating) {
      page += 1;
      fetchImages(query, page);
    }
  }

  void navigateToSearchHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchHistoryPage(
          onSearch: (String selectedQuery) {
            searchController.text = selectedQuery;
            onSearch();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Explore Images',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.history, color: Colors.white),
            onPressed: navigateToSearchHistory,
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Logout"),
                    content: Text("Are you sure you want to log out?"),
                    actions: [
                      TextButton(
                        child: Text("Cancel"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text("Logout"),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Authentation()),
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search beautiful images...',
                      prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: onSearch,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                    backgroundColor: Colors.deepPurpleAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.white),
                      SizedBox(width: 5),
                      Text('Search', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : images.isEmpty
                ? Center(
              child: Text(
                "No images found.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
                : CarouselSlider.builder(
              options: CarouselOptions(
                height: 400,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  if (index == images.length - 1) loadMoreImages();
                },
              ),
              itemCount: images.length,
              itemBuilder: (context, index, realIndex) {
                var imageUrl = images[index]['urls']['regular'];
                return AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
          if (isPaginating)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
