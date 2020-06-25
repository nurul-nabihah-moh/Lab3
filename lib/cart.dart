import 'dart:async';
import 'dart:convert';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:random_string/random_string.dart';
import 'product.dart';
import 'payment.dart';
import 'package:intl/intl.dart';

class CartScreen extends StatefulWidget {
  final User user;

  const CartScreen({Key key, this.user}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String server = "https://saujanaeclipse.com/fastingHealth";
  List cartData;
  double screenHeight, screenWidth;
  bool _selfPickup = true;
  bool _storeCredit = false;
  bool _homeDelivery = false;
  double _weight = 0.0, _totalprice = 6.0;
  String curaddress;
  //TextEditingController _addressController = new TextEditingController();

  double latitude, longitude;
  String label;

  double deliverycharge;
  double amountpayable;
  String titlecenter = "Loading your cart";

  @override
  void initState() {
    super.initState();
    //_getLocation();
    //_getCurrentLocation();
    _loadCart();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(title: Text('Cart'), actions: <Widget>[
          IconButton(
            icon: Icon(MdiIcons.deleteEmpty),
            onPressed: () {
              deleteAll();
            },
          ),
        ]),
        body: Container(
            child: Column(
          children: <Widget>[
            Text(
              "Content of your Cart",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            cartData == null
                ? Flexible(
                    child: Container(
                        child: Center(
                            child: Text(
                    titlecenter,
                    style: TextStyle(
                        color: Color.fromRGBO(101, 255, 218, 50),
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ))))
                : Expanded(
                    child: ListView.builder(
                        itemCount: cartData.length + 2,
                        itemBuilder: (context, index) {
                          if (index == cartData.length) {
                            return Container(
                                height: screenHeight / 2.4,
                                width: screenWidth / 2.5,
                                child: InkWell(
                                  child: Card(
                                    //color: Colors.yellow,
                                    elevation: 5,
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text("Delivery Option",
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black)),
                                        Expanded(
                                            child: Row(
                                          children: <Widget>[
                                            Container(
                                              // color: Colors.red,
                                              width: screenWidth / 2,
                                              // height: screenHeight / 3,
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        value: _selfPickup,
                                                        onChanged:
                                                            (bool value) {
                                                          _onSelfPickUp(value);
                                                        },
                                                      ),
                                                      Text(
                                                        "Self Pickup",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    2, 1, 2, 1),
                                                child: SizedBox(
                                                    width: 2,
                                                    child: Container(
                                                      // height: screenWidth / 2,
                                                      color: Colors.grey,
                                                    ))),
                                            Expanded(
                                                child: Container(
                                              //color: Colors.blue,
                                              width: screenWidth / 2,
                                              //height: screenHeight / 3,
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        value: _homeDelivery,
                                                        onChanged:
                                                            (bool value) {
                                                         // _onHomeDelivery(
                                                          //    value);
                                                        },
                                                      ),
                                                      Text(
                                                        "Home Delivery",
                                                        // style: TextStyle(
                                                        //   color: Colors.white,
                                                        // ),
                                                      ),
                                                    ],
                                                  ),
                                                  /* FlatButton(
                                                    color: Color.fromRGBO(
                                                        101, 255, 218, 50),
                                                    onPressed: () =>
                                                        {_loadMapDialog()},
                                                    child: Icon(
                                                      MdiIcons.locationEnter,
                                                      color: Colors.black,
                                                    ),
                                                  ),*/
                                                   Text("NOT AVAILABLE AT THE MOMENT",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black)),
                                                 /* Text("Current Address:",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black)),*/
                                                  /*Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: 100.0,
                                                          child: TextField(
                                                            controller:
                                                                _addressController,
                                                                
                                                            textAlign: TextAlign
                                                                .center,
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  'Insert your delivery address',
                                                              hintStyle: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                              icon: Icon(
                                                                Icons.email,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              filled: true,
                                                              fillColor:
                                                                  Colors.white,
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .all(1),
                                                              border:
                                                                  new OutlineInputBorder(
                                                                      borderRadius:
                                                                          const BorderRadius
                                                                              .all(
                                                                const Radius
                                                                        .circular(
                                                                    2.0),
                                                                    
                                                              )),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    /*  Flexible(
                                                        child: Text(
                                                          curaddress ??
                                                              "Address not set",
                                                          maxLines: 3,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      )*/
                                                    ],
                                                  ),*/
                                                ],
                                              ),
                                            )),
                                          ],
                                        ))
                                      ],
                                    ),
                                  ),
                                ));
                          }

                          if (index == cartData.length + 1) {
                            return Container(
                                //height: screenHeight / 3,
                                child: Card(
                              elevation: 5,
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("Payment",
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                  SizedBox(height: 10),
                                  Container(
                                      padding:
                                          EdgeInsets.fromLTRB(50, 0, 50, 0),
                                      //color: Colors.red,
                                      child: Table(
                                          defaultColumnWidth:
                                              FlexColumnWidth(1.0),
                                          columnWidths: {
                                            0: FlexColumnWidth(7),
                                            1: FlexColumnWidth(3),
                                          },
                                          //border: TableBorder.all(color: Colors.white),
                                          children: [
                                            TableRow(children: [
                                              TableCell(
                                                child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    height: 20,
                                                    child: Text(
                                                        "Total Item Price ",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black))),
                                              ),
                                              TableCell(
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  height: 20,
                                                  child: Text(
                                                      "RM6.00",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
                                                          color: Colors.black)),
                                                ),
                                              ),
                                            ]),
                                            TableRow(children: [
                                              TableCell(
                                                child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    height: 20,
                                                    child: Text(
                                                        "Delivery Charge ",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black))),
                                              ),
                                              TableCell(
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  height: 20,
                                                  child: Text(
                                                      "RM" +
                                                              deliverycharge
                                                                  .toStringAsFixed(
                                                                      2) ??
                                                          "0.0",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
                                                          color: Colors.black)),
                                                ),
                                              ),
                                            ]),
                                            /*TableRow(children: [
                                              TableCell(
                                                child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    height: 20,
                                                    child: Text(
                                                        "Store Credit RM" +
                                                            widget.user.credit,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black))),
                                              ),
                                              TableCell(
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  height: 20,
                                                  child: Checkbox(
                                                    value: _storeCredit,
                                                    onChanged: (bool value) {
                                                      _onStoreCredit(value);
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ]),*/
                                            TableRow(children: [
                                              TableCell(
                                                child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    height: 20,
                                                    child: Text("Total Amount ",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black))),
                                              ),
                                              TableCell(
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  height: 20,
                                                  child: Text(
                                                      "RM6.00",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black)),
                                                ),
                                              ),
                                            ]),
                                          ])),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    minWidth: 200,
                                    height: 40,
                                    child: Text('Make Payment'),
                                    color: Color.fromRGBO(101, 255, 218, 50),
                                    textColor: Colors.black,
                                    elevation: 10,
                                    onPressed: makePayment,
                                  ),
                                ],
                              ),
                            ));
                          }
                          index -= 0;

                          return Card(
                              elevation: 10,
                              child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Row(children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Container(
                                          height: screenHeight / 8,
                                          width: screenWidth / 5,
                                          child: ClipOval(
                                              child: CachedNetworkImage(
                                            fit: BoxFit.scaleDown,
                                            imageUrl: server +
                                                "/productImage/${cartData[index]['name']}.jpg",
                                            placeholder: (context, url) =>
                                                new CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    new Icon(Icons.error),
                                          )),
                                        ),
                                        Text("Total RM" +
                                          cartData[index]['price'],
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 1, 10, 1),
                                        child: SizedBox(
                                            width: 2,
                                            child: Container(
                                              height: screenWidth / 3.5,
                                              color: Colors.grey,
                                            ))),
                                    Container(
                                        width: screenWidth / 1.45,
                                        //color: Colors.blue,
                                        child: Row(
                                          //crossAxisAlignment: CrossAxisAlignment.center,
                                          //mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Flexible(
                                              child: Column(
                                                children: <Widget>[
                                                  Text(
                                                    cartData[index]['name'],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.black),
                                                    maxLines: 1,
                                                  ),
                                                  Text(
                                                    "Available " +
                                                        cartData[index]
                                                            ['quantity'] +
                                                        " unit",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Your Quantity " +
                                                        cartData[index]
                                                            ['cquantity'],
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Container(
                                                      height: 20,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          FlatButton(
                                                            onPressed: () {
                                                             // _updateCart(
                                                             //     index, "add");
                                                            },
                                                            child: Icon(
                                                              MdiIcons.plus,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      101,
                                                                      255,
                                                                      218,
                                                                      50),
                                                            ),
                                                          ),
                                                          Text(
                                                            cartData[index]
                                                                ['cquantity'],
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          FlatButton(
                                                            onPressed: () {
                                                             // _updateCart(index,
                                                             //     "remove");
                                                            },
                                                            child: Icon(
                                                              MdiIcons.minus,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      101,
                                                                      255,
                                                                      218,
                                                                      50),
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Text(
                                                          "Total " +
                                                              cartData[index]
                                                                  ['price'],
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .black)),
                                                      FlatButton(
                                                        onPressed: () {
                                                          _deleteCart(index);
                                                        },
                                                        child: Icon(
                                                          MdiIcons.delete,
                                                          color: Color.fromRGBO(
                                                              101,
                                                              255,
                                                              218,
                                                              50),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        )),
                                  ])));
                        })),
          ],
        )));
  }
/*void _onRegister() {
    String address = _addressController.text;
  String addAddress =
      "https://www.saujanaeclipse.com/fastingHealth/php/login_user.php";
 
   /* showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          Toast.show("Please Enter Password", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM),
          title: new Text("Registration Confirmation"),
          content: new Container(
            height: screenHeight / 12,
            child: Column(
              children: <Widget>[
                Text(
                  "Do you want to continue with the registration?",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
                child: new Text("Continue"),
                onPressed: () {
                  Navigator.of(context).pop();
                  
                  return;
                }),
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
                return;
              },
            )
          ],
        );
      },
    ); */
    http.post(addAddress, body: {
      "address": address,
      
    }).then((res) {
      print(res.body);
      
    }).catchError((err) {
      print(err);
    });
    
  }*/
  void _loadCart() {
    _weight = 0.0;
    _totalprice = 0.0;
    amountpayable = 0.0;
    deliverycharge = 0.0;
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Updating cart...");
    pr.show();
    String urlLoadJobs = server + "/php/load_cart.php";
    http.post(urlLoadJobs, body: {
      "email": widget.user.email,
    }).then((res) {
      print(res.body);
      pr.hide().then((isHidden) {
        print(isHidden);
      });
      if (res.body == "Cart Empty") {
        //Navigator.of(context).pop(false);
        widget.user.quantity = "0";
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MainScreen(
                      user: widget.user,
                    )));
      }

      setState(() {
        var extractdata = json.decode(res.body);
        cartData = extractdata["cart"];
        for (int i = 0; i < cartData.length; i++) {
          _totalprice = cartData[i]['yourprice'] + _totalprice;
        }
        //_weight = _weight / 1000;
        amountpayable = _totalprice;

       // print(_weight);
        print(_totalprice);
      });
    }).catchError((err) {
      print(err);
      pr.hide().then((isHidden) {
        print(isHidden);
      });
    });
    pr.hide().then((isHidden) {
      print(isHidden);
    });
  }

  /*_updateCart(int index, String op) {
    
    int curquantity = int.parse(cartData[index]['quantity']);
    int quantity = cartData[index]['cquantity'];
    if (op == "add") {
      quantity++;
      if (quantity > (curquantity - 2)) {
        Toast.show("Quantity not available", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      }
    }
    if (op == "remove") {
      quantity--;
      if (quantity == 0) {
        _deleteCart(index);
        return;
      }
    }
    String urlLoadJobs = server + "/php/update_cart.php";
    http.post(urlLoadJobs, body: {
      "email": widget.user.email,
      "prodid": cartData[index]['id'],
      "quantity": quantity.toString()
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show("Cart Updated", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _loadCart();
      } else {
        Toast.show("Failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });
  }*/

  _deleteCart(int index) {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Delete item?',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                http.post(server + "/php/delete_cart.php", body: {
                  "email": widget.user.email,
                  "prodid": cartData[index]['id'],
                }).then((res) {
                  print(res.body);

                  if (res.body == "success") {
                    _loadCart();
                  } else {
                    Toast.show("Failed", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                }).catchError((err) {
                  print(err);
                });
              },
              child: Text(
                "Yes",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              )),
        ],
      ),
    );
  }

  void _onSelfPickUp(bool newValue) => setState(() {
        _selfPickup = newValue;
        if (_selfPickup) {
          _homeDelivery = false;
          _updatePayment();
        } else {
          //_homeDelivery = true;
          _updatePayment();
        }
      });

  void _onStoreCredit(bool newValue) => setState(() {
        _storeCredit = newValue;
        if (_storeCredit) {
          _updatePayment();
        } else {
          _updatePayment();
        }
      });

 /* void _onHomeDelivery(bool newValue) {
    //_getCurrentLocation();
    //_getLocation();
    setState(() {
      _homeDelivery = newValue;
      if (_homeDelivery) {
        _updatePayment();
        _selfPickup = false;
      } else {
        _updatePayment();
      }
    });
  }*/

  void _updatePayment() {
    _weight = 0.0;
    _totalprice = 0.0;
    amountpayable = 0.0;
    setState(() {
      for (int i = 0; i < cartData.length; i++) {
        
        _totalprice = cartData[i]['yourprice'] + _totalprice;
      }
      //_weight = _weight / 1000;
      print(_selfPickup);
      if (_selfPickup) {
        deliverycharge = 0.0;
      } else {
        if (_totalprice > 100) {
          deliverycharge = 5.00;
        } else {
          deliverycharge = _weight * 0.5;
        }
      }
      if (_homeDelivery) {
        if (_totalprice > 100) {
          deliverycharge = 5.00;
        } else {
          deliverycharge = _weight * 0.5;
        }
      }
      if (_storeCredit) {
        amountpayable =
            deliverycharge + _totalprice - double.parse(widget.user.credit);
      } else {
        amountpayable = deliverycharge + _totalprice;
      }
      _totalprice =6.0;
      print("Dev Charge:" + deliverycharge.toStringAsFixed(3));
      print(_weight);
      print(_totalprice);
    });
  }

  Future<void> makePayment() async {
    if (_selfPickup) {
      print("PICKUP");
      Toast.show("Self Pickup", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else if (_homeDelivery) {
      print("HOME DELIVERY");
      Toast.show("Home Delivery", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else {
      Toast.show("Please select delivery option", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
    var now = new DateTime.now();
    var formatter = new DateFormat('ddMMyyyy-');
    String orderid = widget.user.email.substring(1, 4) +
        "-" +
        formatter.format(now) +
        randomAlphaNumeric(6);
    print(orderid);
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => PaymentScreen(
                  user: widget.user,
                  val: _totalprice.toStringAsFixed(2),
                  orderid: orderid,
                )));
    _loadCart();
  }

  void deleteAll() {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Delete all items?',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                http.post(server + "/php/delete_cart.php", body: {
                  "email": widget.user.email,
                }).then((res) {
                  print(res.body);

                  if (res.body == "success") {
                    _loadCart();
                  } else {
                    Toast.show("Failed", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                }).catchError((err) {
                  print(err);
                });
              },
              child: Text(
                "Yes",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              )),
        ],
      ),
    );
  }
}

class User {
  String name, email, phone, password, credit, quantity;

  User(
      {this.name,
      this.email,
      this.password,
      this.phone,
      this.credit,
      this.quantity});
}


