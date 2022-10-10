import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quntity;
  final String title;

  const CartItem(
    this.id,
    this.productId,
    this.price,
    this.quntity,
    this.title,
  );

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: ValueKey(id),
        direction: DismissDirection.endToStart,
        onDismissed: (direction){
          Provider.of<Cart>(context,listen: false).removeItem(productId);
        },
        confirmDismiss: (direction){
          return showDialog(
            context: context,
             builder: (ctx)=>AlertDialog(
              title: Text('Are you sure ?'),
              content: Text('Do you want to remove item from the cart?'),
              actions: [
                FlatButton(
                  onPressed: ()=>Navigator.of(context).pop(),
                   child: Text('No')),
                FlatButton(
                  onPressed: ()=>Navigator.of(context).pop(true),
                   child: Text('Yes')),
              ],
             ));
        },
        background: Container(
          color: Theme.of(context).errorColor,
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
          margin: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 4
          ),
        ),
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: ListTile(
              title: Text(title),
              subtitle: Text('Total \$ ${(price*quntity)}'),
              trailing: Text('$quntity x'),
              leading: CircleAvatar(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: FittedBox(
                    child: Text('\$$price'),
                  ),
                ),
              ),),
          ),
        ));
  }
}
