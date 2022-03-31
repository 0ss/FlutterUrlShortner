// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// st + tap
void main() {
  runApp(const MyApp());
}

String generateRandomString(int len) {
  var r = Random();
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
}

Future<String> shortUrl(String url) async {
  String hash = generateRandomString(5);
  final endPoint = Uri.parse("https://v.ht/processreq.php");

  try {
    await http.post(endPoint,
        headers: {'Content-type': 'application/x-www-form-urlencoded'},
        body: {'txt_url': url, 'txt_name': hash});
  } catch (e) {}
  return '${endPoint.host}/$hash';
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = "My first app";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: _title,
        debugShowCheckedModeBanner: false,
        home: MyUrlShortner());
  }
}

class MyUrlShortner extends StatefulWidget {
  const MyUrlShortner({Key? key}) : super(key: key);

  @override
  State<MyUrlShortner> createState() => _MyUrlShortnerState();
}

class _MyUrlShortnerState extends State<MyUrlShortner> {
  String urlToShort = '';
  List shortUrls = [];
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: MyAppBar(),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Enter URL ",
              textDirection: TextDirection.ltr,
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              children: [for (var link in shortUrls) link],
            ),
            TextFormField(
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: 'https://www.google.com',
                prefixIcon: Icon(Icons.link, color: Colors.white),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: Colors.grey)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: Colors.grey)),
              ),
              onChanged: (value) {
                setState(() {
                  urlToShort = value;
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurple,
                ),
                onPressed: () async {
                  setState(() {
                    isLoading = !isLoading;
                  });

                  final u = await shortUrl(urlToShort);
                  shortUrls.add(Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SelectableText(
                      u,
                      style: TextStyle(color: Colors.white),
                    ),
                  ));

                  setState(() {
                    isLoading = !isLoading;
                  });
                },
                child: (isLoading)
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 1.5,
                        ))
                    : Text(
                        "Shorten URL",
                      ))
          ]),
    );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        "Shorten Your URLs",
      ),
      backgroundColor: Colors.black,
      shape: Border(bottom: BorderSide(color: Colors.white, width: 2)),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.tag_faces_sharp,
            color: Colors.white,
          ),
          onPressed: () {},
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
