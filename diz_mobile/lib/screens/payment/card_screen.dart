import 'package:diz/models/cart.dart';
import 'package:diz/screens/home/main_page.dart';
import 'package:diz/screens/payment/credit_card.dart';
import 'package:diz/services/compra_service.dart';
import 'package:diz/services/falloCompra.dart';
import 'package:diz/services/realizarCompras.dart';
import 'package:diz/services/registro.dart';
import 'package:diz/widgets/cart_item.dart';
import 'package:diz/widgets/hamburguesita/navDrawerMenuPrincipal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../cart_screen.dart';
import 'package:diz/screens/payment/billScreen.dart';

class CardPyScreen extends StatelessWidget {
  final numeroT;
  final vencM;
  final vencY;

  List<Pedido> pedido = [];

  CardPyScreen({this.numeroT, this.vencM, this.vencY});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
          backgroundColor: Colors.black87,
          elevation: 0,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () =>
                  Navigator.of(context).pushNamed(CartScreen.routeName),
            ),
          ]),
      body: Column(children: <Widget>[
        Expanded(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  new Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: new Text('¿Son correctos tus datos?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20))),
                ],
              ),
              Row(
                children: [
                  new Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: CreditCard(
                          numeroTarjeta: numeroT,
                          vencimientoM: vencM,
                          vencimientoY: vencY))
                ],
              ),
              Row(
                children: [
                  new Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: new Text(
                          'Total productos: ' + cart.items.length.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20))),
                ],
              ),
            ],
          ),
        )),
        Expanded(
          child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) {
                pedido.add(Pedido(
                    codigoProducto: cart.items.values.toList()[i].id.toString(),
                    cantidadProducto:
                        cart.items.values.toList()[i].cantidad.toString(),
                    precioProducto:
                        cart.items.values.toList()[i].cantidad.toString()));
                return CartPdt(
                    cart.items.values.toList()[i].id,
                    cart.items.keys.toList()[i],
                    cart.items.values.toList()[i].price,
                    cart.items.values.toList()[i].cantidad,
                    cart.items.values.toList()[i].name);
              }),
        ),
        Expanded(
          child: Column(
            children: [
              Row(children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    child: Text(
                      "Confimar compra",
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () async {
                      //Codigo, cantidad, precio
                      PurchaseModel purchase = PurchaseModel(
                          id: int.parse(uid),
                          compra: Compra(
                              noTarjeta: nTarjeta,
                              mesTarjeta: mTarjeta,
                              anioTarjeta: aTarjeta,
                              total: '0',
                              calle: calle,
                              numero: telefono,
                              colonia: colonia,
                              ciudad: ciudad,
                              cp: cp,
                              estado: estado,
                              entreCalles: entreCalles),
                          pedido: pedido);
                      print(purchaseModelToJson(purchase));
                      int val =
                          await registrarCompra(purchaseModelToJson(purchase));

                      if (val == 201) {
                        print('success');
                        showDialog(
                            context: context,
                            builder: (buildcontext) {
                              return AlertDialog(
                                title: Text("COMPRA EXITOSA"),
                                //content: Text("Regrese a la página principal"),
                                actions: <Widget>[
                                  RaisedButton(
                                    child: Text(
                                      "Regresar a página principal",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return MainPage();
                                          },
                                        ),
                                      );
                                    },
                                  )
                                ],
                              );
                            });
                      } else {
                        await makePostFail();
                        showDialog(
                            context: context,
                            builder: (buildcontext) {
                              return AlertDialog(
                                title:
                                    Text("Error: No se pudo realizar compra"),
                                //content: Text("Regrese a la página principal"),
                                actions: <Widget>[
                                  RaisedButton(
                                    child: Text(
                                      "Regresar a página principal",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return MainPage();
                                          },
                                        ),
                                      );
                                    },
                                  )
                                ],
                              );
                            });
                      }
                    },
                  ),
                ),
                Expanded(
                  child: RaisedButton(
                    child: Text(
                      "Generar factura",
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return BillScreen();
                          },
                        ),
                      );
                    },
                  ),
                )
              ])
            ],
          ),
        ),
      ]),
    );
  }
}
