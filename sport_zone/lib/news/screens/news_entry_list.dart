import 'package:flutter/material.dart';
import 'package:sport_zone/news/models/news_entry.dart';
import 'package:sport_zone/news/screens/news_detail.dart';
import 'package:sport_zone/news/screens/newslist_form.dart';
import 'package:sport_zone/news/widgets/news_entry_card.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class NewsEntryListPage extends StatefulWidget {
  final bool isAdminOrAuthor;
  const NewsEntryListPage({super.key, this.isAdminOrAuthor = false});

  @override
  State<NewsEntryListPage> createState() => _NewsEntryListPageState();
}

class _NewsEntryListPageState extends State<NewsEntryListPage> {
  String filter = "All";
  final List<String> _filterList = ['All','Transfer', 'Update', 'Exclusive',  'Match', 'Rumor', 'Analysis'];

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

        // if (widget.isAdmin == true || widget.isWriter == true)
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
                shape: const CircleBorder(), // Makes the button circular
                padding: const EdgeInsets.all(10), // Adjust padding as needed
                backgroundColor: Colors.black, // Button background color
                foregroundColor: Colors.white, // Icon/text color
            ),
            child: const Icon(Icons.add_circle), // The icon insid
          ),
        )        
      ]
    );
  }
}