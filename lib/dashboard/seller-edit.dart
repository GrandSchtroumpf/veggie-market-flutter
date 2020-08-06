import 'package:flutter/material.dart';
import '../service-provider.dart';
import '../seller/model.dart';
import '../seller/form.dart';

class SellerEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final service = ServiceProvider.of(context).seller;

    return Scaffold(
      appBar: AppBar(
        title: Text('Modify your company'),
      ),
      body: FutureBuilder<Seller>(
          future: service.getCurrent(),
          builder: (context, snaphot) {
            if (!snaphot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            final seller = snaphot.data;
            return SellerForm(
              seller: seller,
              onSubmit: (Seller seller) async {
                if (seller.file != null) {
                  final task = await service.upload(seller.id, seller.file);
                  final snapshot = await task.onComplete;
                  seller.image = await snapshot.ref.getDownloadURL();
                }
                await service.updateDoc(seller);
                Navigator.pop(context);
              },
            );
          }),
    );
  }
}
