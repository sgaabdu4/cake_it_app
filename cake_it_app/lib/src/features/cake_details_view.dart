import 'package:cake_it_app/src/features/cake.dart';
import 'package:flutter/material.dart';

/// Displays detailed information about a cake.
class CakeDetailsView extends StatelessWidget {
  const CakeDetailsView({
    super.key,
  });

  // TODO(Abid): Should this be extracted?
  static const routeName = '/cake_detail';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    //TODO(Abid): Should Cake.fromJson be used here? Should it be a separate service class?
    Cake cake = Cake.fromJson(args);
    // TODO(Abid): Should the image be displayed here?
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cake Details'),
      ),
      body: Column(
        children: [
          Center(
            child: Text('${cake.title}', style: Theme.of(context).textTheme.titleLarge),
          ),
          Center(
            child: Text('${cake.description}'),
          ),
        ],
      ),
    );
  }
}
