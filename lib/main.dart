import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List movieList = [];

  // List myList = [
  //   {
  //     "a": [
  //       {
  //         "1": "Arsenal",
  //         "2": "Manchester City",
  //         "3": "Tottham",
  //         "4": "Brighton",
  //         "5": "Manchester United",
  //       }
  //     ],
  //   },
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Movies")),
     
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  var response = await http.get(
                    Uri.parse(
                      'https://api.themoviedb.org/3/movie/now_playing?api_key=050c28541f900007285c3020069bfd62&language=en-US&page=1',
                    ),
                  );
                  if (response.statusCode == 200) {
                    var movieResponse =
                        jsonDecode(response.body) as Map<String, dynamic>;
                    setState(() {
                      for (var i = 0;
                          i < movieResponse['results'].length;
                          i++) {
                        movieList.add({
                          "title": movieResponse['results'][i]
                              ['original_title'],
                          "image":
                              "https://image.tmdb.org/t/p/w500${movieResponse['results'][i]['poster_path']}",
                          "id": movieResponse['results'][i]['id'],
                        });
                        setState(() {});
                      }
                      print(">>>>>>>>>>>>>>>>>>> movielist : $movieList");
                    });
                  } else {
                    print("something wrong....");
                    print(response.statusCode);
                  }
                },
                child: const Text("Get Movies"),
              ),
              movieList.isEmpty
                  ? Container()
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: movieList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Image.network(movieList[index]["image"]),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              movieList[index]["title"],
                              style: const TextStyle(fontSize: 25),
                            ),
                            Text(
                              movieList[index]["id"].toString(),
                              style: const TextStyle(fontSize: 25),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                          ],
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
