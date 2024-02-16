import 'package:flutter/material.dart';
import 'package:flutter_news_app/models/new_model.dart';
import 'package:flutter_news_app/widgets/home/all_news.dart';
import 'package:flutter_news_app/services/api_service.dart';

class SearchScreen extends StatefulWidget {
  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<NewModel> _searchResults = [];
  bool _searchTriggered = false;
  bool _loadingMore = false;
  List<Map<String, dynamic>> _filters = [
    {'title': 'Last 30 days', 'duration': Duration(days: 30)},
    {'title': 'Last 7 days', 'duration': Duration(days: 7)},
  ];
  Map<String, dynamic>? _selectedFilter;
  int _currentPage = 1;

  APIService _apiService = APIService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Search'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Enter keywords to search...',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _searchResults.clear();
              _currentPage = 1;
              _searchNews();
            },
            child: const Text('Search'),
          ),
          Expanded(
            child: _searchTriggered
                ? _searchResults.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollInfo) {
                          if (!_loadingMore &&
                              scrollInfo.metrics.pixels ==
                                  scrollInfo.metrics.maxScrollExtent) {
                            _loadMore();
                            return true;
                          }
                          return false;
                        },
                        child: ListView.builder(
                          itemCount:
                              _searchResults.length + (_loadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index < _searchResults.length) {
                              return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: HomeNewItem(
                                    newModel: _searchResults[index],
                                  ));
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          },
                        ),
                      )
                : Container(),
          ),
        ],
      ),
    );
  }

  void _searchNews() async {
    setState(() {
      _searchResults.clear();
      _searchTriggered = true;
    });

    try {
      List<NewModel> searchResults = await _apiService.searchNews(
        _searchController.text,
        duration: _selectedFilter?['duration'],
        page: _currentPage,
      );
      setState(() {
        _searchResults.addAll(searchResults);
      });
    } catch (e) {
      print('Error searching news: $e');
      // Handle error - Display an error message to the user
    }
  }

  void _loadMore() async {
    setState(() {
      _loadingMore = true;
    });

    try {
      _currentPage++;
      List<NewModel> moreResults = await _apiService.searchNews(
        _searchController.text,
        duration: _selectedFilter?['duration'],
        page: _currentPage,
      );
      setState(() {
        _searchResults.addAll(moreResults);
        _loadingMore = false;
      });
    } catch (e) {
      print('Error loading more news: $e');
      // Handle error - Display an error message to the user
      setState(() {
        _loadingMore = false;
      });
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Filter'),
          content: SingleChildScrollView(
            child: Column(
              children: _filters
                  .map(
                    (filter) => ListTile(
                      title: Text(filter['title']),
                      onTap: () {
                        setState(() {
                          _selectedFilter = filter;
                        });
                        Navigator.pop(context);
                      },
                      selected: _selectedFilter == filter,
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}
