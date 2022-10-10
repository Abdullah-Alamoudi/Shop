import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import './edit_product_screen.dart';


class UserProductScreen extends StatelessWidget {
  const UserProductScreen({Key key}) : super(key: key);
  static const routename='/user-product';

  Future<void> _refreashProducts(BuildContext context)async{
    await Provider.of<Products>(context).fetechAndSetProducts();
    // await Provider.of<Products>(context).fetechAndSetProducts(true);  // true for products user just
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('User Product'),
        actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: ()=>Navigator.of(context).pushNamed(EditProductScreen.routename),)
                ],),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreashProducts(context),
        builder: (ctx, AsyncSnapshot snapshot) =>
        snapshot.connectionState==ConnectionState.waiting
        ?Center(child: CircularProgressIndicator(),)
        :RefreshIndicator(
          onRefresh: ()=>_refreashProducts(context),
          child: Consumer<Products>(
            builder: (ctx,productsData,_)=>Padding(
              padding: EdgeInsets.all(8),
              child: ListView.builder(
                itemCount: productsData.items.length,
                itemBuilder: (_, int index) =>Column(
                  children: [
                    UserProductItem(productsData.items[index].id,productsData.items[index].title,productsData.items[index].imageUrl),
                    Divider()
                  ],
                )
              ),
              ),
          ),)
        ,
      ),
      
    );
  }
}