import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/firebase_options.dart';
import 'package:shop/screens/splash_screen.dart';
import './screens/auth_screen.dart';
import './providers/auth.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/products.dart';
import './screens/edit_product_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_product_screen.dart';
import './screens/cart_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/product_overview_screen.dart';

void main()async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth,Products>(
          create: (_)=>Products(),
          update: (ctx,authValue,previousProducts)=>previousProducts
          ..getData(authValue.token, authValue.userId,previousProducts==null?null: previousProducts.items),
          
          ),
        ChangeNotifierProvider.value(value: Cart()),
        ChangeNotifierProxyProvider<Auth,Orders>(
          create: (_)=>Orders(),
          update: (ctx,authValue,previousOrders)=>previousOrders
          ..gerData(authValue.token, authValue.userId,previousOrders==null?null: previousOrders.orders),
          
          ),
      ],
      child: Consumer<Auth>(
        builder:(ctx,auth,child)=> MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato'
          ),
          // home: auth.isAuth?ProductOverviewScreen():FutureBuilder(
          //   future: auth.tryAutoLogin(),
          //   builder: (ctx,AsyncSnapshot authSnapshot)=>authSnapshot.connectionState==ConnectionState.waiting?SplashScreen():AuthScreen()
          //   ),
          home: ProductOverviewScreen(),
          routes: {
            ProductDetailScreen.routename:(_) =>ProductDetailScreen(),
            CartScreen.routename:(_) =>CartScreen(), 
            OrderScreen.routename:(_) =>OrderScreen(), 
            UserProductScreen.routename:(_) =>UserProductScreen(), 
            EditProductScreen.routename:(_) =>EditProductScreen(),
            //AuthScreen.routename:(_) =>AuthScreen(), 

          },
        ),
      ),
    );
  }
}



