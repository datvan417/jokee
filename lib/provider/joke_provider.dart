import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Joke {
  final String id;
  final String contents;
  bool status = false;

  Joke({required this.status, required this.id, required this.contents});
}

class JokeProvider with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Joke> _jokeData = [
    // Joke(
    //     id: 'id1',
    //     contents:
    //         'A child asked his father, "How were people born?" So his father said, "Adam and Eve made babies, then their babies became adults and made babies, and so on.\n"The child then went to his mother, asked her the same question and she told him, "We were monkeys then we evolved to become like we are now."\n The child ran back to his father and said, "You lied to me!" His father replied, "No, your mom was talking about her side of the family."'),
    // Joke(
    //     id: 'id2',
    //     contents:
    //         'Teacher: "Kids,what does the chicken give you?" Student: "Meat!" Teacher: "Very good! Now what does the pig give you?" Student: "Bacon!" \nTeacher: "Great! And what does the fat cow give you?" Student: "Homework!"'),
    // Joke(
    //     id: 'id3',
    //     contents:
    //         'The teacher asked Jimmy, "Why is your cat at school today Jimmy?" Jimmy replied crying, "Because I heard my daddy tell my mommy, \'I am going to eat that pussy once Jimmy leaves for school today!\'"'),
    // Joke(
    //     id: 'id4',
    //     contents:
    //         'A housewife, an accountant and a lawyer were asked "How much is 2+2?" The housewife replies: "Four!". The accountant says: "I think it\'s either 3 or 4. Let me run those figures through my spreadsheet one more time." The lawyer pulls the drapes, dims the lights and asks in a hushed voice, "How much do you want it to be?"')
  ];

  List<Joke> jokeDisplay = [];

  Future<void> initJokeData() async {
    var url =
        Uri.parse('https://joke-57f0e-default-rtdb.firebaseio.com/jokes.json');
    try {
      final response = await http.get(url);
      final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
      List<Joke> loadedData = [];
      extractedData.forEach((jokeId, jokeItem) {
        loadedData.add(
          Joke(
            id: jokeId,
            contents: jokeItem['content'],
            status: jokeItem['isFav'],
          ),
        );
      });
      _jokeData = loadedData;
      jokeDisplay = _jokeData;
    } catch (e) {
      rethrow;
    }
  }

  int getLength() {
    return jokeDisplay.length;
  }

  Future<void> updateStatus(bool isFav, Joke jokeElement) async {
    int jokeIndex =
        _jokeData.indexWhere((element) => element.id == jokeElement.id);
    if (jokeIndex >= 0) {
      var url = Uri.parse(
          'https://joke-57f0e-default-rtdb.firebaseio.com/jokes/${jokeElement.id}.json');
      await http.patch(
        url,
        body: jsonEncode({
          'content': jokeElement.contents,
          'isFav': isFav,
        }),
      );
      _jokeData[jokeIndex].status = isFav;
      jokeDisplay.remove(jokeElement);
      notifyListeners();
    } else {
      print('error');
    }
  }
}
