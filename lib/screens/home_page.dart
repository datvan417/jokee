import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/joke_provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:math';
import '../widgets/description.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var initValue = true;
  var loadedData = true;
  @override
  void didChangeDependencies() {
    if (initValue) {
      Provider.of<JokeProvider>(context).initJokeData().then((_) {
        setState(() {
          loadedData = false;
        });
      });
    }
    initValue = false;
    super.didChangeDependencies();
  }

  AppBar appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              child: Image.asset(
                'assets/images/uchiha.png',
                fit: BoxFit.fitHeight,
              ),
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text(
                      'Handicrafted by',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    Text(
                      'Van HCMUS',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.asset(
                      'assets/images/itachi_icon.png',
                    ),
                  ),
                )
              ],
            ),
          ]),
    );
  }

  int randomIndex = 0;
  var check = false;
  void updateJoke(bool isFav, JokeProvider jokeData) {
    setState(() {
      jokeData.updateStatus(isFav, jokeData.jokeDisplay[randomIndex]).then((_) {
        int lengthNext =
            Provider.of<JokeProvider>(context, listen: false).getLength();
        if (lengthNext == 0) {
          check = true;
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("The end"),
              content: const Text(
                  "That's all the jokes for today! Come back another day!"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text('OK')),
                TextButton(
                    onPressed: () {
                      Provider.of<JokeProvider>(context, listen: false)
                          .initJokeData()
                          .then((_) {
                        check = false;
                        Navigator.pop(context, false);
                      });
                    },
                    child: const Text('Read again')),
              ],
            ),
          ).then((value) {
            setState(() {
              check = value;
            });
          });
        } else {
          randomIndex = 0 + Random().nextInt(lengthNext - 0);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final jokeData = Provider.of<JokeProvider>(context, listen: false);
    final heightScreen = MediaQuery.of(context).size.height -
        appBar().preferredSize.height -
        MediaQuery.of(context).padding.top;
    final isOrientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: appBar(),
      body: loadedData
          ? const SpinKitCircle(
              color: Colors.grey,
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: heightScreen * 0.2,
                    color: const Color.fromARGB(255, 39, 169, 93),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'A joke a day keeps the doctor way',
                          style: TextStyle(color: Colors.white, fontSize: 21.0),
                        ),
                        (isOrientation == Orientation.portrait)
                            ? const SizedBox(height: 17)
                            : const SizedBox(),
                        const Text(
                          'If you joke wrong way, your teeth have to pay. (Serious)',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  (check)
                      ? SizedBox(
                          height: heightScreen * 0.7,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: const Center(
                            child: Text(
                              "That's all the jokes for today! Come back another day!",
                              style: TextStyle(
                                color: Color.fromARGB(255, 125, 124, 124),
                                fontSize: 20.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: heightScreen * 0.6,
                              child: Padding(
                                padding: (isOrientation == Orientation.portrait)
                                    ? const EdgeInsets.only(top: 50.0)
                                    : const EdgeInsets.only(top: 30.0),
                                child: Text(
                                  jokeData.jokeDisplay[randomIndex].contents,
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 125, 124, 124),
                                      fontSize: 16.0),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () => updateJoke(true, jokeData),
                                  style: TextButton.styleFrom(
                                    primary: Colors.white,
                                    backgroundColor: Colors.blue,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.zero),
                                    ),
                                    minimumSize: Size(
                                      MediaQuery.of(context).size.width * 0.35,
                                      heightScreen * 0.06,
                                    ),
                                  ),
                                  child: const Text(
                                    'This is Funny!',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ),
                                SizedBox(
                                    width: (MediaQuery.of(context).size.width) *
                                        0.05),
                                TextButton(
                                  onPressed: () => updateJoke(false, jokeData),
                                  style: TextButton.styleFrom(
                                    primary: Colors.white,
                                    minimumSize: Size(
                                        MediaQuery.of(context).size.width *
                                            0.35,
                                        heightScreen * 0.06),
                                    backgroundColor: Colors.green,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.zero),
                                    ),
                                  ),
                                  child: const Text(
                                    'This is not Funny.',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                  SizedBox(
                    height: (isOrientation == Orientation.portrait)
                        ? heightScreen * 0.4
                        : heightScreen * 0.55,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: const DescriptionWidget(),
                  )
                ],
              ),
            ),
    );
  }
}
