import 'package:cake_it_app/core/route_generator.dart';
import 'package:cake_it_app/features/cakes/presentation/controllers/cake_controller.dart';
import 'package:cake_it_app/features/cakes/presentation/widgets/cached_network_image.dart';
import 'package:cake_it_app/core/extensions.dart';
import 'package:flutter/material.dart';

class CakeListView extends StatefulWidget {
  const CakeListView({
    super.key,
  });

  @override
  State<CakeListView> createState() => _CakeListViewState();
}

class _CakeListViewState extends State<CakeListView> {
  late final CakeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CakeController();
    _controller.loadCakes();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    try {
      await _controller.refreshCakes();
    } catch (e) {
      if (mounted) {
        final l10n = context.l10n;
        // simple error message - controller already sets the error state
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.failedToRefreshCakes),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              AppNavigator.pushSettings(context);
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: _CakeListBody(controller: _controller),
          );
        },
      ),
    );
  }
}

class _CakeListBody extends StatelessWidget {
  const _CakeListBody({
    required this.controller,
  });

  final CakeController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.isLoading && controller.isEmpty) {
      return const _CakeLoadingWidget();
    }

    if (controller.hasError && controller.isEmpty) {
      return _CakeErrorWidget(controller: controller);
    }

    return _CakeListWidget(controller: controller);
  }
}

class _CakeLoadingWidget extends StatelessWidget {
  const _CakeLoadingWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _CakeErrorWidget extends StatelessWidget {
  const _CakeErrorWidget({
    required this.controller,
  });

  final CakeController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.errorLoadingCakes,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            controller.error!.getLocalizedMessage(l10n),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: controller.retry,
            child: Text(l10n.tryAgain),
          ),
        ],
      ),
    );
  }
}

class _CakeListWidget extends StatelessWidget {
  const _CakeListWidget({
    required this.controller,
  });

  final CakeController controller;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      restorationId: 'cakeListView',
      itemCount: controller.cakes.length,
      itemBuilder: (BuildContext context, int index) {
        final cake = controller.cakes[index];
        return ListTile(
          title: Text(cake.title),
          subtitle: Text(cake.description),
          leading: CircleAvatar(
            backgroundColor: Colors.grey[200],
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: cake.imageUrl,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                placeholder: const SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                errorWidget: Icon(
                  Icons.cake,
                  color: Colors.grey[400],
                ),
              ),
            ),
          ),
          onTap: () {
            AppNavigator.pushCakeDetails(context, cake);
          },
        );
      },
    );
  }
}
