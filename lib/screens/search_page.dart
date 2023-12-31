import 'package:gudang/app_properties.dart';
import 'package:gudang/models/product.dart';
import 'package:gudang/screens/product/view_product_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rubber/rubber.dart';
import 'package:gudang/fetch_data.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  String selectedPeriod = "";
  String selectedCategory = "";
  String selectedPrice = "";

  List<Product> searchResults = [];

  List<String> timeFilter = [
    'New Arrivals',
    'Featured Products',
    'Best Sellers',
    'On Sale',
    'Clearance',
  ];

  List<String> categoryFilter = [
    'Storage Racks',
    'Forklift Machines',
    'Shipping Supplies',
    'Packing Materials',
    'Safety Equipment',
  ];

  List<String> priceFilter = [
    '\Rp 50-200',
    '\Rp 200-400',
    '\Rp 400-800',
    '\Rp 800-1000',
  ];

  TextEditingController searchController = TextEditingController();

  late RubberAnimationController _controller;

  @override
  void initState() {
    _controller = RubberAnimationController(
      vsync: this,
      halfBoundValue: AnimationControllerValue(percentage: 0.4),
      upperBoundValue: AnimationControllerValue(percentage: 0.4),
      lowerBoundValue: AnimationControllerValue(pixel: 50),
      duration: Duration(milliseconds: 200),
    );

    fetchData();
    super.initState();
  }

  void fetchData() async {
    try {
      List<Product> fetchedProducts = await Repository().fetchDataPlaces();
      setState(() {
        searchResults = fetchedProducts;
      });
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _expand() {
    _controller.expand();
  }

  Widget _getLowerLayer() {
    return Container(
      margin: const EdgeInsets.only(top: kToolbarHeight),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Search',
                  style: TextStyle(
                    color: darkGrey,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CloseButton()
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: Colors.orange, width: 1)),
            ),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  List<Product> tempList = [];
                  searchResults.forEach((product) {
                    if (product.name.toLowerCase().contains(value)) {
                      tempList.add(product);
                    }
                  });
                  setState(() {
                    searchResults.clear();
                    searchResults.addAll(tempList);
                  });
                  return;
                } else {
                  fetchData(); // Fetch all products again when search is cleared
                }
              },
              cursorColor: darkGrey,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                prefixIcon: SvgPicture.asset(
                  'assets/icons/search_icon.svg',
                  fit: BoxFit.scaleDown,
                ),
                suffix: TextButton(
                  onPressed: () {
                    searchController.clear();
                    searchResults.clear();
                    fetchData(); // Fetch all products again when search is cleared
                  },
                  child: Text(
                    'Clear',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            child: Container(
              color: Colors.orange[50],
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (_, index) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListTile(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ViewProductPage(
                          product: searchResults[index],
                        ),
                      ),
                    ),
                    title: Text(searchResults[index].name),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _getUpperLayer() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            offset: Offset(0, -3),
            blurRadius: 10,
          )
        ],
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          topLeft: Radius.circular(24),
        ),
        color: Colors.white,
      ),
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Filters',
                style: TextStyle(color: Colors.grey[300]),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 32.0, top: 16.0, bottom: 16.0),
              child: Text(
                'Sort By',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            height: 50,
            child: ListView.builder(
              itemBuilder: (_, index) => Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedPeriod = timeFilter[index];
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 4.0,
                        horizontal: 20.0,
                      ),
                      decoration: selectedPeriod == timeFilter[index]
                          ? BoxDecoration(
                              color: Color(0xffFDB846),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(45)),
                            )
                          : BoxDecoration(),
                      child: Text(
                        timeFilter[index],
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                ),
              ),
              itemCount: timeFilter.length,
              scrollDirection: Axis.horizontal,
            ),
          ),
          Container(
            height: 50,
            child: ListView.builder(
              itemBuilder: (_, index) => Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedCategory = categoryFilter[index];
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 4.0,
                        horizontal: 20.0,
                      ),
                      decoration: selectedCategory == categoryFilter[index]
                          ? BoxDecoration(
                              color: Color(0xffFDB846),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(45)),
                            )
                          : BoxDecoration(),
                      child: Text(
                        categoryFilter[index],
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                ),
              ),
              itemCount: categoryFilter.length,
              scrollDirection: Axis.horizontal,
            ),
          ),
          Container(
            height: 50,
            child: ListView.builder(
              itemBuilder: (_, index) => Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedPrice = priceFilter[index];
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 4.0,
                        horizontal: 20.0,
                      ),
                      decoration: selectedPrice == priceFilter[index]
                          ? BoxDecoration(
                              color: Color(0xffFDB846),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(45)),
                            )
                          : BoxDecoration(),
                      child: Text(
                        priceFilter[index],
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                ),
              ),
              itemCount: priceFilter.length,
              scrollDirection: Axis.horizontal,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        top: true,
        bottom: false,
        child: Scaffold(
          body: RubberBottomSheet(
            lowerLayer: _getLowerLayer(),
            upperLayer: _getUpperLayer(),
            animationController: _controller,
          ),
        ),
      ),
    );
  }
}
