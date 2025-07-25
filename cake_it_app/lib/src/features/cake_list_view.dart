import 'dart:convert';

import 'package:cake_it_app/src/features/cake.dart';
import 'package:cake_it_app/src/features/cake_details_view.dart';
import 'package:cake_it_app/src/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Displays a list of cakes.
/// Hmmm Stateful Widget is used here, but it could be a StatelessWidget? // TODO(Abid): No we need the state.
class CakeListView extends StatefulWidget {
  const CakeListView({
    super.key,
  });

  // TODO(Abid): Should this be extracted?
  static const routeName = '/';

  @override
  State<CakeListView> createState() => _CakeListViewState();
}

class _CakeListViewState extends State<CakeListView> {
  List<Cake> cakes = [];

  @override
  void initState() {
    super.initState();
    fetchCakes();
  }

  // TODO(Abid): Should this be a separate service class?
  // TODO(Abid): No separation of concerns... API call in the widget
  // TODO(Abid): No try catch for loading and also failed requests
  Future<void> fetchCakes() async {
    // TODO(Abid): API URL should be moved to config file
    final url = Uri.parse(
        "https://gist.githubusercontent.com/hart88/79a65d27f52cbb74db7df1d200c4212b/raw/ebf57198c7490e42581508f4f40da88b16d784ba/cakeList");
    final response = await http.get(url);
    // TODO(Abid): What's the point of this delay?
    await Future.delayed(const Duration(seconds: 2));
    if (response.statusCode == 200) {
      List<dynamic> decodedResponse = json.decode(response.body);
      setState(() {
        cakes = decodedResponse.map((cake) => Cake.fromJson(cake)).toList();
      });
    }
  }

  // TODO(Abid): Add pull to refresh

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎂CakeItApp🍰'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      // TODO(Abid): No loading state shown when fetching data
      body: ListView.builder(
        restorationId: 'cakeListView',
        itemCount: cakes.length,
        itemBuilder: (BuildContext context, int index) {
          final cake = cakes[index];

          return ListTile(
              title: Text('${cake.title}'),
              subtitle: Text('${cake.description}'),
              // TODO(Abid): Should the image be loading when fetching?
              leading: CircleAvatar(
                // TODO(Abid): Would container with decoration be better?
                child: Image.network(
                  cakes[index]
                      .image!, // TODO(Abid): Why are we using ! here? Need to implement loading or error handling
                  // TODO(Abid): Missing error and loading for network image
                ),
              ),
              onTap: () {
                // TODO(Abid): Should pass actual cake data instead of hardcoded values
                Navigator.restorablePushNamed(
                  context,
                  CakeDetailsView.routeName,
                  arguments: const Cake(
                    title: 'failed cake',
                    description: 'soggy bottom',
                    image: 'https://www.example.com',
                  ).toJson(),
                );
              });
        },
      ),
    );
  }
}
