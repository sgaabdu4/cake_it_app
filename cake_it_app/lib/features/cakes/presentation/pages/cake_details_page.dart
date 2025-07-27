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
    final l10n = context.l10n;

    if (cake == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.cakeDetails)),
        body: Center(child: Text(l10n.noCakeData)),
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
              Text(
                cake.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                cake.description.isNotEmpty ? cake.description : l10n.noDescriptionAvailable,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
