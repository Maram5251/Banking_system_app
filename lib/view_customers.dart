import 'package:flutter/material.dart';

class ViewCustomersScreen extends StatefulWidget {
  const ViewCustomersScreen({super.key});

  @override
  _ViewCustomersScreenState createState() => _ViewCustomersScreenState();
}

class _ViewCustomersScreenState extends State<ViewCustomersScreen> {
  bool _isPressed = false;
  List<bool> selectedList = List.generate(10, (index) => false);
  List<double> bankBalances = [1250.75, 2340.50, 987.30, 155.22, 1660.10, 1400.00, 1556.32, 7780.22, 4450.00, 10000.22];
  final TextEditingController _amountController = TextEditingController();

  void _updateSelectedListTile(int index) {
    setState(() {
      if (selectedList[index]) {
        selectedList[index] = false;
      } else {
        selectedList[index] = true;
      }
    });
  }

  void _transferMoney() {
    final double? amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      // Show error message if the amount is invalid
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Invalid Amount'),
          content: const Text('Please enter a valid amount.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      return;
    }

    setState(() {
      for (int i = 0; i < selectedList.length; i++) {
        if (selectedList[i]) {
          // Update the bank balance for selected customers
          bankBalances[i] += amount;
        }
      }
      _amountController.clear();
      _isPressed = false;  // Optionally hide the input and button again
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> customers = ['Customer 1', 'Customer 2', 'Customer 3', 'Customer 4', 'Customer 5', 'Customer 6', 'Customer 7', 'Customer 8', 'Customer 9', 'Customer 10'];
    List<String> emails = ['customer1@gmail.com', 'customer2@gmail.com', 'customer3@gmail.com', 'customer4@gmail.com', 'customer5@gmail.com', 'customer6@gmail.com', 'customer7@gmail.com', 'customer8@gmail.com', 'customer9@gmail.com', 'customer10@gmail.com'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.person, color: Colors.blueAccent),
                  title: Text(customers[index]),
                  subtitle: Text(emails[index]),
                  trailing: Text(
                    '\$${bankBalances[index].toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  selectedTileColor: const Color.fromARGB(255, 221, 194, 120),
                  selected: selectedList[index],
                  onLongPress: () {
                    _updateSelectedListTile(index);
                  },
                  onTap: _isPressed
                      ? () {
                          _updateSelectedListTile(index);
                        }
                      : null,
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isPressed = !_isPressed;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 253, 253, 253),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            child: const Text(
              'Select Customers',
              style: TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(height: 8),
          if (_isPressed) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  labelStyle: TextStyle(fontSize: 15, color: Colors.green),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _transferMoney,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 253, 253, 253),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: const Text(
                'Transfer Money',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
