import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchHistoryPage extends StatefulWidget {
  final Function(String) onSearch;

  SearchHistoryPage({required this.onSearch});

  @override
  _SearchHistoryPageState createState() => _SearchHistoryPageState();
}

class _SearchHistoryPageState extends State<SearchHistoryPage> {
  List<String> searchHistory = [];
  List<String> filteredHistory = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchSearchHistory();
  }

  Future<void> fetchSearchHistory() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('searchHistory')
        .orderBy('timestamp', descending: true)
        .get();

    setState(() {
      searchHistory = snapshot.docs
          .map((doc) => doc['query'] as String)
          .toList();
      filteredHistory = searchHistory;
    });
  }

  // Filter the  history based on user input
  void filterSearchHistory(String query) {
    setState(() {
      filteredHistory = searchHistory
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Search History',style: TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              onChanged: filterSearchHistory,
              decoration: InputDecoration(
                hintText: 'Search history...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredHistory.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        filteredHistory[index],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      leading: Icon(Icons.history, color: Colors.blue),
                      onTap: () {
                        widget.onSearch(filteredHistory[index]);
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}