import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:home_widget_counter/api_key.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Set AppGroup Id. This is needed for iOS Apps to talk to their WidgetExtensions
  await HomeWidget.setAppGroupId('group.es.antonborri.homeWidgetCounter');
  // Register an Interactivity Callback. It is necessary that this method is static and public
  await HomeWidget.registerInteractivityCallback(interactiveCallback);
  runApp(const MyApp());
}

/// hehe

/// Callback invoked by HomeWidget Plugin when performing interactive actions
/// The @pragma('vm:entry-point') Notification is required so that the Plugin can find it
@pragma('vm:entry-point')
Future<void> interactiveCallback(Uri? uri) async {
  // Set AppGroup Id. This is needed for iOS Apps to talk to their WidgetExtensions
  await HomeWidget.setAppGroupId('group.es.antonborri.homeWidgetCounter');

  // We check the host of the uri to determine which action should be triggered.
  if (uri?.host == 'increment') {
    updateQuote();
  } else if (uri?.host == 'clear') {
    await _clear();
  }
}

void updateQuote() async {
  final quote = await fetchQuote();
  HomeWidget.saveWidgetData<String>('quote', quote.quote);
  HomeWidget.saveWidgetData<String>('author', quote.author.author);
  HomeWidget.updateWidget(
    name: 'QuoteWidget',
    iOSName: 'QuoteWidget',
    androidName: 'CounterWidgetProvider',
  );
}

class Quote {
  final String quote;
  final Author author;

  const Quote({required this.quote, required this.author});
  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
        quote: json['content'] ?? 'Null',
        author: Author.fromJson(json['originator']));
  }
}

class Author {
  final String author;

  Author({required this.author});
  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(author: json['name'] ?? 'Null');
  }
}

Future<Quote> fetchQuote() async {
  final response = await http.get(
      Uri.parse('https://quotes15.p.rapidapi.com/quotes/random/?'),
      headers: {
        "x-rapidapi-host": "quotes15.p.rapidapi.com",
        "x-rapidapi-key": apikey
      });
  if (response.statusCode == 200) {
    return Quote.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load quote');
  }
}

Future<void> _clear() async {}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quote Widget',
      theme: ThemeData.light(
        useMaterial3: false,
      ),
      home: const MyHomePage(title: 'Transparent Quote Widget'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Set Widget and Enjoy!',
            ),
            Text("Nothing's here! :) "),
          ],
        ),
      ),
    );
  }
}
