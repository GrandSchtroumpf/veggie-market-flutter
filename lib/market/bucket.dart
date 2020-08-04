import 'package:flutter/material.dart';
import 'package:veggie_market/service.dart';

class MarketBucket extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bucket = ServiceProvider.of(context).bucket;
    return Scaffold(
      appBar: AppBar(
        title: Text('Bucket'),
      ),
      body: ListView.builder(
        itemCount: bucket.items.length,
        itemBuilder: (context, i) => Text(bucket.items.keys.elementAt(i)),
      ),
    );
  }
}
