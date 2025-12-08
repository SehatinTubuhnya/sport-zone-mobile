import 'package:flutter/material.dart';
import 'package:sport_zone/news/models/news_entry.dart';
import 'package:sport_zone/news/screens/news_detail.dart';
import 'package:sport_zone/news/widgets/news_entry_card.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:sport_zone/news/widgets/addNews.dart';

class NewsEntryListPage extends StatefulWidget {
  const NewsEntryListPage({super.key});

  @override
  State<NewsEntryListPage> createState() => _NewsEntryListPageState();
}

class _NewsEntryListPageState extends State<NewsEntryListPage> {
  
  // final List<String> _filterList = ['Transfer', 'Match', 'Exclusive', 'Rumor', 'Analysis', 'Update'];
  // String? _filter = 'Update';

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
      if (d != null) {
        listNews.add(NewsEntry.fromJson(d));
      }
    }
    return listNews;
  }

  // @override
  // void initState() {
  //   super.initState();
  //   if (!_filterList.contains(_filter)) {
  //     _filter = _filterList.first;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            // title: const Text('News Entry List'),
            actions: [
              // DropdownMenu<String>(
              //   initialSelection: _filter,
              //   onSelected: (String? value) {
              //     setState(() {
              //       _filter = value;
              //     });
              //   },
              //   dropdownMenuEntries: _filterList.map(
              //     (e) => DropdownMenuEntry<String>(
              //       value: e,
              //       label: e,
              //     ),
              //   ).toList(),
              // ),

              // DropdownButton<String>(
              //   value: _filter,
              //   hint: Text('Filter'),
              //   icon: Icon(Icons.arrow_drop_down),
              //   underline: SizedBox(),

              //   onChanged: (String? newValue) {
              //     setState(() {
              //       _filter = newValue;
              //     });
              //   },

              //   items: _filterList
              //       .map((String value) => DropdownMenuItem<String>(
              //             value: value,
              //             child: Text(value),
              //           ))
              //       .toList(),
              // )

              
              // DropdownButton<String>(
              //   value: _filter,
              //   hint: Text('Filter'),
              //   icon: Icon(Icons.arrow_drop_down),
              //   underline: SizedBox(),
              //   onChanged: (String? newValue) {
              //     setState(() {
              //       _filter = newValue;
              //     });
              //   },
              //   items: _filterList.map((String value) {
              //     return DropdownMenuItem<String>(
              //       value: value,
              //       child: Text(value),
              //     );
              //   }).toList(),
              // )

              // DropdownButton<String>(
              //   value: _filterList.contains(_filter) ? _filter : null,,
              //   hint: Text('Filter'),
              //   icon: Icon(Icons.arrow_drop_down),
              //   underline: SizedBox(),

              //   onChanged: (String? newValue) {
              //     setState(() {
              //       _filter = newValue ?? _filterList.first;
              //     });
              //   },

              //   items: _filterList.map<DropdownMenuItem<String>> ((String value) {
              //     return DropdownMenuItem<String>(
              //       value: value,
              //       child: Text(value));
              //   }).toList(),
              // ) 
            ]
          ),
          
          // drawer: const LeftDrawer(),
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
                // // Data exists
                // return ListView.builder(
                //   itemCount: snapshot.data!.length,
                //   itemBuilder: (_, index) => NewsEntryCard(
                //     news: snapshot.data![index],
                //     onTap: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) =>
                //               NewsDetailPage(news: snapshot.data![index]),
                //         ),
                //       );
                //     },
                //   ),
                // );
              },
          ),
        ),

        Positioned(
          bottom: 10,
          right: 10,
          child: AddNews()
        )        
      ]
    );
  }
}