import 'package:algolia/algolia.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final Algolia _algolia = const Algolia.init(
      applicationId: 'YEMB565LHO', apiKey: 'bf08c51fe4e1a5ac52d503f0ca52330f');
  String _searchTerm = '';

  Future<List<AlgoliaObjectSnapshot>> _operation(String input) async {
    AlgoliaQuery query = _algolia.instance.index("Posts").query(input);
    AlgoliaQuerySnapshot querySnap = await query.getObjects();
    List<AlgoliaObjectSnapshot> results = querySnap.hits;
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
                title: const Text('Learning Algolia',
                    style: TextStyle(color: Colors.black))),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                      onChanged: (val) {
                        setState(() {
                          _searchTerm = val;
                        });
                      },
                      style: const TextStyle(color: Colors.black, fontSize: 20),
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search ...',
                          hintStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(Icons.search, color: Colors.black))),
                  StreamBuilder<List<AlgoliaObjectSnapshot>>(
                      stream: Stream.fromFuture(_operation(_searchTerm)),
                      builder: (context, snapshot) {
                        print('snapshotのエラー');
                        print(snapshot.error);
                        if (snapshot.hasData) {
                          List<AlgoliaObjectSnapshot>? currSearchStuff =
                              snapshot.data;
                          print(currSearchStuff!.length);
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return const CupertinoActivityIndicator();
                            default: // どの「case」にも当てはまらないとき
                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: currSearchStuff.length,
                                  itemBuilder: (context, index) {
                                    return _searchTerm.isNotEmpty
                                        ? DisplaySearchResult(
                                            artDes: currSearchStuff[index]
                                                .data["name"],
                                          )
                                        : Container();
                                  },
                                );
                              }
                          }
                        } else {
                          return const CupertinoActivityIndicator();
                        }
                      })
                ],
              ),
            )));
  }
}

class DisplaySearchResult extends StatelessWidget {
  final String artDes;

  const DisplaySearchResult({Key? key, required this.artDes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        artDes,
        style: const TextStyle(color: Colors.black),
      ),
      const SizedBox(height: 20)
    ]);
  }
}
