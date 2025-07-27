import 'package:flutter/material.dart';
import 'package:cake_it_app/core/extensions.dart';
import 'package:cake_it_app/features/cakes/domain/entities/cake.dart';
import 'package:cake_it_app/features/cakes/presentation/widgets/cached_network_image.dart';

/// Displays detailed information about a cake.
class CakeDetailsView extends StatelessWidget {
  const CakeDetailsView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cake = context.routeArguments<Cake>();

    if (cake == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Cake Details')),
        body: const Center(child: Text('No cake data provided')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(cake.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: cake.imageUrl,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),
              // Title
              Text(
                cake.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Description
              Text(
                cake.description.isNotEmpty ? cake.description : 'No description available',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
