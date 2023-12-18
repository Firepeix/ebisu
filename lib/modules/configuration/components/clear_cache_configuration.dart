import 'package:ebisu/modules/configuration/domain/services/cache_service.dart';
import 'package:flutter/material.dart';

class ClearCacheConfiguration extends StatelessWidget {
  final CacheServiceInterface _cache;

  const ClearCacheConfiguration(this._cache);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: ElevatedButton(
        onPressed: () async {
          _cache.clear();
          ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
          messenger.showSnackBar(SnackBar(
            content: Text('Sucesso'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ));
        },
        child: Text("Limpar Cache"),
      ),
    );
  }
}
