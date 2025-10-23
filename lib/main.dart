import 'package:flutter/material.dart';
import 'segment_clevertap.dart'; // Your bridge file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Segment + CleverTap
  await SegmentCleverTap.init(writeKey: 'xFsG3xwUq9UiOIyeGbtEGLlBE4wBCtEU');

  // // Optional: Identify user at app start
  // await SegmentCleverTap.identify('user12322222', {
  //   'email': 'user2222@example.com',
  //   'name': 'Alice2',
  //   'plan': 'Gold',
  // });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Segment + CleverTap Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Segment-CleverTap Integration Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() => _counter++);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  /// Identify the user
  Future<void> _identifyUser() async {
    await SegmentCleverTap.identify('user5688', {
      'email': 'new_user88@example.com',
      'name': 'John Doe 88',
      'plan': 'Free',
      'age': 29,
    });
    _showSnackBar('User identified!');
  }

  /// Track a purchase event
  Future<void> _trackPurchase() async {
    await SegmentCleverTap.track('Item Purchased', {
      'itemId': 'SKU_1234',
      'price': 19.99,
      'currency': 'USD',
      'category': 'Fitness',
      'payment_method': 'Credit Card',
    });
    _showSnackBar('Purchase event tracked!');
  }

  /// Track product view
  Future<void> _trackProductView() async {
    await SegmentCleverTap.track('Product Viewed', {
      'product_id': 'P_789',
      'product_name': 'Yoga Mat',
      'category': 'Health',
      'price': 25.5,
    });
    _showSnackBar('Product view tracked!');
  }

  /// Track add to cart
  Future<void> _trackAddToCart() async {
    await SegmentCleverTap.track('Added To Cart', {
      'product_id': 'P_789',
      'quantity': 1,
      'price': 25.5,
    });
    _showSnackBar('Add to cart tracked!');
  }



  @override
  Widget build(BuildContext context) {
    final buttons = [
      {'text': 'Identify User', 'action': _identifyUser},
      {'text': 'Track Purchase', 'action': _trackPurchase},
      // {'text': 'Track Screen', 'action': _trackScreen},
      // {'text': 'Track Login', 'action': _trackLogin},
      {'text': 'Track Product View', 'action': _trackProductView},
      {'text': 'Track Add To Cart', 'action': _trackAddToCart},
      // {'text': 'Track Sign Up', 'action': _trackSignUp},
      // {'text': 'Reset (Logout)', 'action': _resetUser},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Counter: $_counter',
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 20),
                ...buttons.map((b) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: ElevatedButton(
                        onPressed: b['action'] as VoidCallback,
                        child: Text(b['text'] as String),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment Counter',
        child: const Icon(Icons.add),
      ),
    );
  }
}

