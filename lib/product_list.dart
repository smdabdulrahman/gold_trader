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

  @override
  Widget build(BuildContext context) {
    TextEditingController product_name = TextEditingController();
    TextEditingController fixed_price = TextEditingController();
    return FutureBuilder(
      future: futureProductListStr,
      builder: (builder, body) {
        if (body.hasData) {
          List<String> tabs = [body.data![0], body.data![1]];
          Center viewProducts(
            TextEditingController product_name,
            TextEditingController fixed_price,
            bool isGold,
          ) {
            List<Map<String, dynamic>>? currList = isGold
                ? goldList
                : silverList;
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  Padding(padding: EdgeInsets.all(8)),
                  Text(body.data![3], style: TextStyle(fontSize: 20)),
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
                            Text(body.data![4]),
                            TextFormField(
                              controller: product_name,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),

                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.amber),
                                ),
                                isDense: true,
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
                            Text(body.data![5]),
                            TextFormField(
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
                                        isSilver: tabController.index == 0
                                            ? 0
                                            : 1,
                                      ),
                                    )
                                    .then((val) {
                                      getProductList();
                                    });
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.amber),
                                ),
                                isDense: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(top: 20),
                        child: IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: isGold
                                ? Color(0xFFD4AF37)
                                : Colors.grey[400],
                          ),
                          onPressed: () {
                            DatabaseHelper.instance
                                .insertProduct(
                                  Product(
                                    product_name: product_name.text,
                                    fixed_price: double.parse(fixed_price.text),
                                    isGold: tabController.index == 0 ? 1 : 0,
                                    isSilver: tabController.index == 0 ? 0 : 1,
                                  ),
                                )
                                .then((val) {
                                  getProductList();
                                });
                          },
                          icon: Icon(Icons.check_rounded, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(8)),
                  Text(body.data![6], style: TextStyle(fontSize: 20)),
                  Padding(padding: EdgeInsets.all(4)),
                  if (currList != null)
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          spacing: 10,
                          children: List.generate(currList!.length, (i) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  width: 230,
                                  decoration: BoxDecoration(
                                    color: isGold
                                        ? Colors.amber[50]
                                        : Colors.grey[100],
                                    borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(4),
                                    ),
                                  ),
                                  child: Text(
                                    currList![i]["product_name"],
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  width: 80,
                                  decoration: BoxDecoration(
                                    gradient: isGold
                                        ? goldGradient
                                        : silverGradient,

                                    borderRadius: BorderRadius.horizontal(
                                      right: Radius.circular(4),
                                    ),
                                  ),
                                  child: Text(
                                    currList![i]["fixed_price"].toString(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: isGold
                                          ? Colors.white
                                          : Color(0xFF2B2B2B),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    DatabaseHelper.instance
                                        .deleteProduct(currList![i]["id"])
                                        .then((val) {
                                          getProductList();
                                        });
                                  },
                                  icon: Icon(Icons.delete),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }

          return Scaffold(
            backgroundColor: Color(0xffffffff),

            appBar: AppBar(
              centerTitle: true,
              title: Text(tabs[tabController.index] + " " + body.data![2]),
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
              children: [
                viewProducts(product_name, fixed_price, true),
                viewProducts(product_name, fixed_price, false),
              ],
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
