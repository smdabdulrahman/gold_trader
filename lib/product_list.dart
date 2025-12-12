import 'package:flutter/material.dart';
import 'package:goldtrader/helpers/DatabaseHelper.dart';
import 'package:goldtrader/helpers/TranslateHelper.dart';
import 'package:goldtrader/model/Product.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  List<Map<String, dynamic>>? goldList;
  List<Map<String, dynamic>>? silverList;
  void getProductList() {
    DatabaseHelper.instance.queryProducts().then((val) {
      List<Map<String, dynamic>> tempGoldList = [];
      List<Map<String, dynamic>> tempSilverList = [];
      for (var ele in val) {
        if (ele["isGold"] == 1) {
          tempGoldList.add(ele);
        } else {
          tempSilverList.add(ele);
        }
      }

      setState(() {
        goldList = tempGoldList;
        print(tempGoldList);
        silverList = tempSilverList;
      });
    });
  }

  late Future<List<String>> futureProductListStr;
  @override
  void initState() {
    super.initState();
    futureProductListStr = Translatehelper.translateList([
      "Gold",
      "Silver",
      "Products",
      "Add New Product",
      "Product Name",
      "Price",
      "Products List",
    ]);
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
    getProductList();
  }

  final LinearGradient silverGradient = const LinearGradient(
    colors: [Color(0xFFE8E8E8), Color(0xFFCFCFCF), Color(0xFFB5B5B5)],
    begin: Alignment.topRight,
    end: Alignment.topLeft,
  );
  final LinearGradient goldGradient = const LinearGradient(
    colors: [Color(0xFFE7C76F), Color(0xFFD4AF37), Color(0xFFB28A2B)],
    begin: Alignment.topRight,
    end: Alignment.bottomRight,
  );
  TextEditingController product_name = TextEditingController();
  TextEditingController fixed_price = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureProductListStr,
      builder: (builder, body) {
        if (body.hasData) {
          List<String> tabs = [body.data![0], body.data![1]];
          Center viewProducts(bool isGold) {
            List<Map<String, dynamic>>? currList = isGold
                ? goldList
                : silverList;
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  Padding(padding: EdgeInsets.all(3)),
                  Container(
                    margin: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 0.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            body.data![3],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(4)),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 220,

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 5,
                                children: [
                                  Text(
                                    body.data![4],
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  SizedBox(
                                    width: 200,
                                    height: 32,
                                    child: TextFormField(
                                      controller: product_name,
                                      textInputAction: TextInputAction.next,
                                      style: TextStyle(fontSize: 12),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: const Color.fromARGB(
                                              255,
                                              221,
                                              220,
                                              220,
                                            ),
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.all(8),

                                        prefixIconConstraints: BoxConstraints(
                                          minWidth: 25,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.amber,
                                          ),
                                        ),

                                        isDense: true,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 80,

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 5,
                                children: [
                                  Text(
                                    body.data![5],
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  SizedBox(
                                    width: 80,
                                    height: 32,
                                    child: TextFormField(
                                      controller: fixed_price,
                                      keyboardType: TextInputType.number,

                                      onFieldSubmitted: (value) {
                                        DatabaseHelper.instance
                                            .insertProduct(
                                              Product(
                                                product_name: product_name.text,
                                                fixed_price: double.parse(
                                                  fixed_price.text,
                                                ),
                                                isGold: tabController.index == 0
                                                    ? 1
                                                    : 0,
                                                isSilver:
                                                    tabController.index == 0
                                                    ? 0
                                                    : 1,
                                              ),
                                            )
                                            .then((val) {
                                              product_name.clear();
                                              fixed_price.clear();
                                              getProductList();
                                            });
                                      },
                                      style: TextStyle(fontSize: 12),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: const Color.fromARGB(
                                              255,
                                              221,
                                              220,
                                              220,
                                            ),
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.all(8),

                                        prefixIconConstraints: BoxConstraints(
                                          minWidth: 25,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.amber,
                                          ),
                                        ),

                                        isDense: true,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.center,

                          width: 300,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isGold
                                  ? Colors.amber
                                  : Colors.grey[400],
                              minimumSize: Size(300, 30),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              DatabaseHelper.instance
                                  .insertProduct(
                                    Product(
                                      product_name: product_name.text,
                                      fixed_price: double.parse(
                                        fixed_price.text,
                                      ),
                                      isGold: tabController.index == 0 ? 1 : 0,
                                      isSilver: tabController.index == 0
                                          ? 0
                                          : 1,
                                    ),
                                  )
                                  .then((val) {
                                    product_name.clear();
                                    fixed_price.clear();

                                    getProductList();
                                  });
                            },
                            child: Text("Add"),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: 500,
                    height: MediaQuery.of(context).size.height * 0.55,
                    margin: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 0.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 20, top: 5),
                          child: Text(
                            body.data![6],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(4)),
                        if (currList != null)
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                spacing: 10,
                                crossAxisAlignment: CrossAxisAlignment.center,

                                children: List.generate(currList!.length, (i) {
                                  return Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 110,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Product Name",
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                  Text(
                                                    currList![i]["product_name"],
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 100,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "Fixed Price",
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                  Text(
                                                    currList![i]["fixed_price"]
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            /*      SizedBox(
                                              width: 80,
                                              child: IconButton(
                                                onPressed: () {
                                                  showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder: (builder) {
                                                      return AlertDialog(
                                                        backgroundColor:
                                                            Colors.white,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                        title: Text(
                                                          "Are you sure you want to delete this product: ${currList[i]["product_name"]}?",
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              DatabaseHelper
                                                                  .instance
                                                                  .deleteProduct(
                                                                    currList![i]["id"],
                                                                  )
                                                                  .then((val) {
                                                                    getProductList();
                                                                    Navigator.of(
                                                                      context,
                                                                    ).pop();
                                                                  });
                                                            },
                                                            child: Text("Yes"),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                context,
                                                              ).pop();
                                                            },
                                                            child: Text("No"),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                icon: Icon(
                                                  Icons.delete_rounded,
                                                  size: 22,
                                                  color: Colors.red[800],
                                                ),
                                              ),
                                            ), */
                                          ],
                                        ),
                                        Divider(),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return Scaffold(
            backgroundColor: Color.fromARGB(246, 255, 255, 255),
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Colors.amber[400],

              centerTitle: true,
              title: Text(
                tabs[tabController.index] + " " + body.data![2],
                style: TextStyle(fontSize: 18),
              ),
              bottom: TabBar(
                controller: tabController,
                tabs: [
                  Tab(child: Text(tabs[0])),
                  Tab(child: Text(tabs[1])),
                ],
              ),
            ),
            body: TabBarView(
              controller: tabController,
              children: [viewProducts(true), viewProducts(false)],
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: Color(0xffffffff),
            body: Center(child: Image.asset("assets/images/spinner.gif")),
          );
        }
      },
    );
  }
}
