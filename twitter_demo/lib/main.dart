import 'package:data_r_us/add_tweet.dart';
import 'package:data_r_us/charity_fetcher.dart';
import 'package:data_r_us/tweet.dart';
import 'package:data_r_us/tweets_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(29, 161, 242, 1)),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Twitter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  List<Widget> tweets = List.empty(growable: true);
  final CharityProvider charityFetcher = CharityProvider();
  final myUser = "Ben James";
  final myUserName = "benJames9";

  MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool addTweet = false;

  @override
  void initState() {
    super.initState();
    addDummyTweets();
  }

  @override
  Widget build(BuildContext context) {
    InputTweet? textField;
    TweetsView? tweetsView;

    if (addTweet) {
      textField = InputTweet();
    } else {
      tweetsView = TweetsView(tweets: widget.tweets.reversed.toList());
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: addTweet ? textField! : Center(child: tweetsView!),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addTweet ? finishAdding(textField!) : addNewTweet();
        },
        tooltip: 'Increment',
        child: addTweet ? const Icon(Icons.done) : const Icon(Icons.add),
      ),
    );
  }

  void addNewTweet() {
    setState(() {
      addTweet = true;
    });
  }

  void finishAdding(InputTweet textField) {
    String text = textField.getText();
    widget.tweets.add(tweetFromText(text, widget.myUser, widget.myUserName));

    setState(() {
      addTweet = false;
    });
  }

  Widget tweetFromText(String text, String user, String userName) {
    return FutureBuilder(
        future: widget.charityFetcher.getCharity(text),
        builder: (context, snapshot) {
          InlineSpan? charity;

          if (snapshot.hasData) {
            charity = snapshot.data!;
          }

          if (charity == null) {
            return Tweet(text, user, userName);
          } else {
            return Tweet(text, user, userName, charity: charity);
          }
        });
  }

  void addDummyTweets() {
    widget.tweets.add(tweetFromText(
        "I'm so gutted about the England vs South Africa game. Keep your heads up lads!",
        "Alex Timms",
        "TDogAle"));
    widget.tweets.add(tweetFromText(
        "What'll they think of next? “Forbes just found out about marijuana edibles”",
        "Matt Gummow",
        "zOS_lover20"));
    widget.tweets.add(tweetFromText(
        "The entire conflict happening in Palestine and Israel right now is horrific.",
        "Sarah",
        "Salmond"));
    widget.tweets
        .add(tweetFromText("I like ping pong", "Alex Timms", "TDogAle"));
    widget.tweets.add(tweetFromText(
        "Trump Eases Combat Rules in Somalia Intended to Protect Civilians - The New York Times",
        "Matt Gummow",
        "zOS_lover20"));
  }
}
