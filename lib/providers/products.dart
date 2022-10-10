import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import './product.dart';

class Products with ChangeNotifier{
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  String authToken;
  String userId;

  getData(String auToken,String uId,List<Product> products){
    authToken=auToken;
    userId=uId;
    _items=products;
    notifyListeners();
  }
  
  List<Product> get items{
    return [..._items];
    
  }

  List<Product> get favoritesItems{
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id){
    return _items.firstWhere((prod) => prod.id==id);
  }
  
  Future<void> fetechAndSetProducts([bool filterByUser=false])async{

    final filteredString=filterByUser?'orderBy="creatorId"&equalTo="$userId"':'';
    //var url='https://shop-8a230-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filteredString';
    var url='https://shop-8a230-default-rtdb.firebaseio.com/products.json?$filteredString';

    try {
      final res=await http.get(url);
      final extractedData=json.decode(res.body) as Map<String,dynamic>;
      if(extractedData==null){
        return;
      }
      //url='https://shop-8a230-default-rtdb.firebaseio.com/userfavorites/$userId.json?auth=$authToken';
      url='https://shop-8a230-default-rtdb.firebaseio.com/userfavorites/$userId.json';

      final favRes=await http.get(url);
      final favDate=json.decode(favRes.body);
      final List<Product> loadedProduct=[];
      extractedData.forEach((prodId, prodData) { 
        loadedProduct.add(
          Product(
          id: prodId,
          title: prodData['title'],
          description:prodData['description'],
          price: prodData['description'],
          imageUrl: prodData['imageUrl'],
          isFavorite: favDate==null?false:favDate[prodId]??false,
          )
        );
      });
      _items=loadedProduct;
      
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addProduct(Product product)async{
    // final url='https://shop-8a230-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    final url='https://shop-8a230-default-rtdb.firebaseio.com/products.json';

    try {
      final res=await http.post(url,body: json.encode({
        'title':product.title,
        'description':product.description,
        'imageUrl':product.imageUrl,
        'price':product.price,
        'creatorId':userId,
      }));
      final newProduct=Product(
        id: json.decode(res.body)['name'],
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateProduct(String id,Product newproduct)async{
    final prodIndex=_items.indexWhere((prod) => prod.id==id);
    if(prodIndex>=0){
            // final url='https://shop-8a230-default-rtdb.firebaseio.com/products.json?auth=$authToken';
        final url='https://shop-8a230-default-rtdb.firebaseio.com/products/$id.json';
        await http.patch(url,
        body: json.encode({
        'title':newproduct.title,
        'description':newproduct.description,
        'imageUrl':newproduct.imageUrl,
        'price':newproduct.price,
        }));
        _items[prodIndex]=newproduct;
        notifyListeners();
    }else{
      print('...');
    }
  }

  Future deleteProduct(String id)async{
    // final url='https://shop-8a230-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    final url='https://shop-8a230-default-rtdb.firebaseio.com/products/$id.json';
    final prodIndex=_items.indexWhere((prod) => prod.id==id);
    var exitprod=_items[prodIndex];
    _items.removeAt(prodIndex);
    notifyListeners();

    final res=await http.delete(url);
    if(res.statusCode>=400){
      _items.insert(prodIndex, exitprod);
      notifyListeners();
      throw HttpException('Could not delete Product');

    }
    exitprod=null;
  }
}