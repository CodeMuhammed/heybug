import 'package:flutter/material.dart';
import '../../widgets/index.dart';
import 'package:english_words/english_words.dart';

class SavedWordsScreen extends StatelessWidget {
  final _biggerFont = TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    final Set<WordPair> inputList = ModalRoute.of(context).settings.arguments;
    final list = inputList.toList();

    return AppShell(
      title: 'Saved Words',
      bodyContent: ListView.separated(
        itemBuilder: (context, i) {
          var wordPair = list[i];
          return _buildRow(wordPair, i, list.contains(wordPair));
        },
        separatorBuilder: (context, i) {
          return Divider();
        },
        itemCount: list.length,
      ),
    );
  }

  Widget _buildRow(WordPair wordPair, num index, bool alreadySaved) {
    return ListTile(
      title: Text(
        '${index + 1} ${wordPair.asPascalCase}',
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
    );
  }
}
