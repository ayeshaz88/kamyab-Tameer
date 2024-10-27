import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kamiyabtameer/paymentpage.dart';

class StoreScreen extends StatefulWidget {
  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  late Future<List<DocumentSnapshot>> _itemsFuture = Future.value([]);
  List<DocumentSnapshot> _selectedItems = [];

  @override
  void initState() {
    super.initState();
    _itemsFuture = _fetchItems();
  }

  Future<List<DocumentSnapshot>> _fetchItems() async {
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('items').get();
    return querySnapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1F2544),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Constructor Store',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CartScreen(selectedItems: _selectedItems),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _itemsFuture,
        builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text('Error fetching items'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final item = snapshot.data![index];
              return _buildListItem(
                item: item,
                onTap: () {
                  _showItemDetailsDialog(
                    context,
                    item['itemName'],
                    item['price'],
                    item['description'],
                    item['sellerName'],
                  );
                },
                onAddToCart: () {
                  setState(() {
                    _selectedItems.add(item);
                  });
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildListItem({
    required DocumentSnapshot item,
    required VoidCallback onTap,
    required VoidCallback onAddToCart,
  }) {
    return Card(
      child: ListTile(
        leading: Image.network(item['imageUrl']),
        title: Text('Name: ${item['itemName']}'),
        subtitle: Text('Price: ${item['price']}'),
        onTap: onTap,
        trailing: IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: onAddToCart,
        ),
      ),
    );
  }

  void _showItemDetailsDialog(
    BuildContext context,
    String name,
    String price,
    String description,
    String sellerName,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Item Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Name: $name'),
              Text('Price: $price'),
              Text('Description: $description'),
              Text('Seller Name: $sellerName'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class CartScreen extends StatefulWidget {
  final List<DocumentSnapshot> selectedItems;

  CartScreen({required this.selectedItems});

  @override
  _CartScreenState createState() =>
      _CartScreenState(selectedItems: selectedItems);
}

class _CartScreenState extends State<CartScreen> {
  late List<DocumentSnapshot> selectedItems;
  late Map<DocumentSnapshot, int> itemQuantities;

  _CartScreenState({required this.selectedItems}) {
    itemQuantities =
        Map.fromIterable(selectedItems, key: (item) => item, value: (_) => 1);
  }

  get key => key;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: ListView.builder(
        itemCount: selectedItems.length,
        itemBuilder: (context, index) {
          final item = selectedItems[index];
          return CartItemWidget(
            item: item,
            quantity: itemQuantities[item]!,
            onIncrement: () {
              setState(() {
                itemQuantities[item] = itemQuantities[item]! + 1;
              });
            },
            onDecrement: () {
              setState(() {
                if (itemQuantities[item]! > 1) {
                  itemQuantities[item] = itemQuantities[item]! - 1;
                }
              });
            },
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: ${_calculateTotal()}',
                style: TextStyle(fontSize: 18.0),
              ),
              ElevatedButton(
                onPressed: () { // Parse to double
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentPage(),
                    ),
                  );
                },
                child: Text('Order Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _calculateTotal() {
    double total = 0;
    for (var item in selectedItems) {
      try {
        if (item['price'] != null && double.tryParse(item['price']) != null) {
          total += double.parse(item['price']) * itemQuantities[item]!;
        } else {
          print('Invalid price for item: ${item['itemName']}');
        }
      } catch (e) {
        print('Error parsing price for item: ${item['itemName']}');
        print(e);
      }
    }
    return total.toStringAsFixed(2); // Return as a string
  }
}

class CartItemWidget extends StatelessWidget {
  final DocumentSnapshot item;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  CartItemWidget({
    required this.item,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item['itemName']),
      subtitle: Text(item['price']),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: onDecrement,
          ),
          Text(quantity.toString()),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: onIncrement,
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: StoreScreen(),
  ));
}
