import 'package:flutter/material.dart';
import 'package:sport_zone/news/models/news_entry.dart';
import 'package:sport_zone/news/screens/news_detail.dart';
import 'package:sport_zone/news/screens/newslist_form.dart';
import 'package:sport_zone/news/widgets/news_entry_card.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class NewsEntryListPage extends StatefulWidget {
  const NewsEntryListPage({super.key});

  @override
  State<NewsEntryListPage> createState() => _NewsEntryListPageState();
}

class _NewsEntryListPageState extends State<NewsEntryListPage> {
  String filter = "All";
  final List<String> _filterList = ['All','Transfer', 'Update', 'Exclusive',  'Match', 'Rumor', 'Analysis'];
  bool _isAdminOrAuthor = false;
  bool _isLoadingUser = true;
  String username = 'AnonymousUser';

  Future<void> _fetchUser() async {
    final request = context.read<CookieRequest>();
    if (!request.loggedIn) {
      setState(() {
        _isAdminOrAuthor = false;
        _isLoadingUser = false;
        username = 'AnonymousUser';
      });
      return;
    }

    try {
      final response = await request.get(
        "http://localhost:8000/articles/get-user/",
      );

      if (response['status'] == 'success') {
        setState(() {
          _isAdminOrAuthor = (response['auth'] == true);
          _isLoadingUser = false;
          username = response['username'];
        });
      } else {
        setState(() {
          _isAdminOrAuthor = false;
          _isLoadingUser = false;
          username = 'AnonymousUser';
        });
      }
    } catch (_) {
      setState(() {
        _isAdminOrAuthor = false;
        _isLoadingUser = false;
        username = 'AnonymousUser';
      });
    }
  }

  Future<List<NewsEntry>> fetchNews(CookieRequest request) async {
    // TODO: Replace the URL with your app's URL and don't forget to add a trailing slash (/)!
    // To connect Android emulator with Django on localhost, use URL http://10.0.2.2/
    // If you using chrome,  use URL http://localhost:8000
    
    final response = await request.get('http://localhost:8000/articles/json/');
    // Decode response to json format
    var data = response;
    
    // Convert json data to NewsEntry objects
    List<NewsEntry> listNews = [];
    for (var d in data) {
      NewsEntry news = NewsEntry.fromJson(d);
      if (d != null) {
        if (filter == "All") {
          listNews.add(news);
        } else if (filter != "All" && news.fields.category == filter) {
          listNews.add(news);
        }
      }
    }
    return listNews;
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Berita'),
            actions: [
              Padding(
                padding: EdgeInsets.only(right : 10),
                child: PopupMenuButton<String>(
                  padding: EdgeInsets.all(10),
                  tooltip: "Filter",
                  icon: Row(
                    children: [
                      Text(
                        "Filter",
                        style: TextStyle(color: Colors.black),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_drop_down, color: Colors.black),
                    ],
                  ),
                  onSelected: (String value) {
                    setState(() {
                      filter = value;   // update filter value
                    });
                  },
                  itemBuilder: (context) {
                    return _filterList.map((option) {
                      return PopupMenuItem(
                        value: option,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            option,
                            style: TextStyle(
                              color: Colors.black
                            ),
                          )
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
            ]
          ),
          
          body: FutureBuilder(
            future: fetchNews(request),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(
                        'https://cdn-icons-png.flaticon.com/512/4063/4063871.png',
                        fit: BoxFit.cover
                      ),
                      Center(
                        child: Text("Error: ${snapshot.error}")
                      )
                    ],
                  );
                }

                // If data is returned but empty: []
                if (!snapshot.hasData || snapshot.data.isEmpty) {
                  return  Center(
                    child: Column(
                      children: [
                        Image.network(
                          'https://cdn-icons-png.flaticon.com/512/11696/11696730.png',
                          fit: BoxFit.cover
                        ),
                        Text(
                          "Belum ada berita.",
                          style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                        ),
                      ],
                    )
                  );
                }

                // Data exists
                return Padding(
                  padding: EdgeInsets.all(10),
                  child: GridView.builder(
                    itemCount: snapshot.data!.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.6
                    ),
                    itemBuilder: (_, index) {
                      return NewsEntryCard(
                        news: snapshot.data![index], 
                        currentUsername: username,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  NewsDetailPage(news: snapshot.data![index]),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
          ),
        ),

        if (_isAdminOrAuthor == true && _isLoadingUser == false) 
          Positioned(
            bottom: 10,
            right: 10,
            child: ElevatedButton(
              onPressed: ()  {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => NewsFormPage()));
              }, 
              style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(), 
                  padding: const EdgeInsets.all(10), 
                  backgroundColor: Colors.black, 
                  foregroundColor: Colors.white, 
              ),
              child: const Icon(Icons.add_circle), 
            ),
          )        
      ]
    );
  }
}