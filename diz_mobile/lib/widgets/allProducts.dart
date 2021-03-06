import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/productsK.dart';
import './productItem.dart';
import 'package:diz/models/productsK.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class AllProducts extends StatefulWidget with ChangeNotifier {
  final int cat;

  AllProducts({
    int cat
  }): this.cat = cat;

  @override
  _AllProductsState createState() => _AllProductsState(cat);
}

class _AllProductsState extends State<AllProducts>{
  _AllProductsState(this.cat);
  final int cat;

  List<Product> _products = List<Product>();

  List<Product> get products {
    return [..._products];
  }
  Future <List<Product>> fetchProducts() async {
    var url = 'https://mod3-jafjdugfba-uc.a.run.app/departamento/'+cat.toString();
    var response = await http.get(url);
    var products = List<Product>();
    if (response.statusCode == 200) {
      print('ok cargo');
      var prodsJson = json.decode(response.body);
      for(var productJson in prodsJson){
        print(productJson);
        products.add(Product.fromJson(productJson));
      }

    } else {
      print('no cargo');
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Product');
    }
    print(products);
    return products;
  }

  Product findById(String id) {
    return _products.firstWhere((pdt) => pdt.id == id);
  }

//return Product.fromJson(jsonDecode(response.body));
  @override
  void initState() {
    fetchProducts().then((value) {
      setState(() {
        _products.addAll(value);
        print("Ya cargo y construyo productos");
        print(_products);
        print(_products[0].name);
      });
    });

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final pdts=_products;
    print("En el build");

    return GridView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: pdts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (ctx, i)=>ChangeNotifierProvider.value(value: pdts[i],
          child: PdtItem(name: pdts[i].name,imageUrl: pdts[i].imgUrl,)),
    );
  }
}