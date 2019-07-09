import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import '../../widgets/index.dart';

// this defines a stateful widget for random words
class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() {
    return RandomWordsState();
  }
}

// This holds the state of the data in the random words widget
class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = Set<WordPair>();
  final _biggerFont = TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'Random Words page',
      bodyContent: _buildSuggestions(),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.list),
          onPressed: () {
            _gotoSaved();
          },
        )
      ],
    );
  }

  void _gotoSaved() {
    Navigator.pushNamed(
      context,
      '/saved-words',
      arguments: _saved,
    );
  }

  Widget _buildSuggestions() {
    var indexIds = <num>[];

    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) {
          return Divider();
        } else {
          if (!indexIds.contains(i)) {
            indexIds.add(i);
            _suggestions.add(WordPair.random());
          }

          final index = i ~/ 2;
          return _buildRow(_suggestions[index], index);
        }
      },
    );
  }

  Widget _buildRow(WordPair wordPair, num index) {
    final alreadySaved = _saved.contains(wordPair);

    return ListTile(
      title: Text(
        '${index + 1} ${wordPair.asPascalCase}',
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(wordPair);
          } else {
            _saved.add(wordPair);
          }
        });
      },
    );
  }
}
