import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';
import '../providers/orders.dart' show Orders;

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key key}) : super(key: key);
  static const routename='/order';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Order')),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future:Provider.of<Orders>(context,listen: false).fetechAndSetProducts(),
        builder: (ctx, AsyncSnapshot snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return CircularProgressIndicator();
          }
          else{
            if(snapshot.error!=null){
              return Center(child: Text('An error ocurred!'),);
            }
            else{
             return Consumer<Orders>(
              builder: (ct, orderData, child) => ListView.builder(
                itemCount: orderData.orders.length,
                itemBuilder: (BuildContext context, int index) =>OrderItem(orderData.orders[index])
              ),
             );
            }
          }
        },
      ),
    );
  }
}