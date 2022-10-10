import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/products.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';
import './cart_screen.dart';

enum filterOption{ Favorites,All}

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({Key key}) : super(key: key);

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _isloading=false;
  var _showOnlyFavorites=false;

  @override
  void initState() {
    super.initState();
    _isloading=true;
    Provider.of<Products>(context,listen: false).fetechAndSetProducts().then((_) => setState(()=>_isloading=false)).catchError((error)=> setState(()=>_isloading=false));
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: [
          PopupMenuButton(
            onSelected: (filterOption selectedVal){
              setState(() {
                if(selectedVal==filterOption.Favorites){
                  _showOnlyFavorites=true;
                }else{
                  _showOnlyFavorites=false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_)=>[
              PopupMenuItem(child: Text('Only Favorites'),value: filterOption.Favorites,),
              PopupMenuItem(child: Text('Show All'),value: filterOption.All,),
        ]),
          Consumer<Cart>(
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: ()=>
                  Navigator.of(context).pushNamed(CartScreen.routename),
            ),
            builder: (_,cart,ch)=>
            Badge(value: cart.itemCount.toString(),
             child: ch),
          )
        ],
        ),
      body: _isloading?Center(child: CircularProgressIndicator()):ProductGrid(_showOnlyFavorites),
      drawer: AppDrawer(),
    );
  }
}