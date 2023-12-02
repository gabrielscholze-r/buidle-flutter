import './build_path/buildpath.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import './winner/win.dart';
import './guess/guess.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xffb0A1428),
              title: const Text(
                'Buidle',
                style: TextStyle(fontFamily: "BeaufortforLOL"),
              ),
            ),
            body: SuggestionsWidget(
              guessCounter: 0,
            )));
  }
}

class SuggestionsWidget extends StatefulWidget {
  int guessCounter;

  SuggestionsWidget({required this.guessCounter});

  @override
  _SuggestionsWidgetState createState() => _SuggestionsWidgetState();
}

class _SuggestionsWidgetState extends State<SuggestionsWidget> {
  final TextEditingController _controller = TextEditingController();
  var guesses = [];
  bool hasWon = false;
  Map<String, dynamic> sortedItem = {};
  List<dynamic> _items = [];
  List<dynamic> filteredSuggestions = [];

  @override
  void initState() {
    super.initState();
    readJson();
  }

  List<dynamic> getBuildPath() {
    List<dynamic> fromList = sortedItem["from"];
    List<String> idList = fromList.map((id) => id.toString()).toList();
    var items = _items.where((e) => idList.contains(e['id'])).toList();
    print(items);
    return items;
  }

  List<dynamic> getBuildPathInto() {
    List<dynamic> fromList = sortedItem["into"];
    List<String> idList = fromList.map((id) => id.toString()).toList();
    var items = _items.where((e) => idList.contains(e['id'])).toList();
    print(items);
    return items;
  }

  void check_guess() {
    if (guesses.any((element) => element['id'] == sortedItem['id'])) {
      hasWon = true;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Win(sortedItem);
        },
      );
    }
  }

  void sortItem() {
    Random random = Random();
    sortedItem = _items[random.nextInt(_items.length) + 1];
  }

  void updateSuggestions(String text) {
    setState(() {
      _controller.text = text;
    });
    if (text.length >= 3) {
      filteredSuggestions.clear();
      for (var suggestion in _items) {
        if (suggestion['name'].toLowerCase().contains(text.toLowerCase()) &&
            !guesses.contains(suggestion)) {
          filteredSuggestions.add(suggestion);
        }
      }
    } else {
      filteredSuggestions.clear();
    }
  }

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/DATA_enus.json');
    final data = List<dynamic>.from(await json.decode(response));
    //  = (data).where((element) => ,).toList();
    setState(() {
      _items = data.where((item_data) {
        List<dynamic> stats = item_data['stats'];
        return (stats[0]["value"] > 0 ||
            stats[1]["value"] > 0 ||
            stats[2]["value"] > 0);
      }).toList();
    });

    guesses.add(_items[0]);
    guesses.add(_items[1]);
    guesses.add(_items[2]);
    guesses.add(_items[3]);
    sortItem();
    print(sortedItem);
    print(_items);
    // widget.guessCounter = guesses.length;
    widget.guessCounter = 15;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Color(0xffb010A13),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "BUIDLE",
                style: TextStyle(
                    color: Color(0xffbC89B3C),
                    fontSize: 64,
                    fontFamily: 'BeaufortforLOL',
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32, bottom: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Text(
                          "Build Path",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontFamily: 'BeaufortforLOL',
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent),
                            onPressed: (widget.guessCounter >= 5)
                                ? () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return BuildPath(
                                            getBuildPath(), getBuildPathInto());
                                      },
                                    );
                                  }
                                : null,
                            child: Container(
                                alignment: Alignment.center,
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Color(0xffb091428),
                                  border: Border.all(
                                      color: (widget.guessCounter >= 5)
                                          ? Color(0xffbC89B3C)
                                          : Color(0xffb5B5A56)),
                                ),
                                child: Icon(
                                  Icons.account_tree_sharp,
                                  size: 40,
                                  color: (widget.guessCounter >= 5)
                                      ? Color(0xffbC89B3C)
                                      : Color(0xffb5B5A56),
                                )),
                          ),
                        ),
                        Text(
                          "${5 - widget.guessCounter} tries",
                          style: TextStyle(
                              fontSize: 16,
                              color: (widget.guessCounter >= 5)
                                  ? Colors.transparent
                                  : Colors.white,
                              fontFamily: 'BeaufortforLOL',
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Text(
                          "Description",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontFamily: 'BeaufortforLOL'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent),
                            onPressed: (widget.guessCounter >= 10)
                                ? () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                            backgroundColor: Color(0xffb091428),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            content: SizedBox(
                                                width: 100,
                                                height: 500,
                                                child: Column(
                                                  children: [
                                                    Text("DESCRIPTION:",
                                                        style: TextStyle(
                                                            fontSize: 24,
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'BeaufortforLOL',
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 10),
                                                      child: Text(
                                                          "${sortedItem['description']}",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'BeaufortforLOL')),
                                                    ),
                                                  ],
                                                )));
                                      },
                                    );
                                  }
                                : null,
                            child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xffb091428),
                                  border: Border.all(
                                      color: (widget.guessCounter >= 10)
                                          ? Color(0xffbC89B3C)
                                          : Color(0xffb5B5A56)),
                                ),
                                width: 70,
                                height: 70,
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.info,
                                  size: 40,
                                  color: (widget.guessCounter >= 10)
                                      ? Color(0xffbC89B3C)
                                      : Color(0xffb5B5A56),
                                )),
                          ),
                        ),
                        Text(
                          "${10 - widget.guessCounter} tries",
                          style: TextStyle(
                              fontSize: 16,
                              color: (widget.guessCounter >= 10)
                                  ? Colors.transparent
                                  : Colors.white,
                              fontFamily: 'BeaufortforLOL',
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Text(
                          "Picture",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontFamily: 'BeaufortforLOL',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent),
                            onPressed: (widget.guessCounter >= 15)
                                ? () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        int randomRotation = Random().nextInt(
                                            4); // Gera um número aleatório de 0 a 3
                                        return AlertDialog(
                                          backgroundColor: Color(0xffb091428),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          content: SizedBox(
                                            width: 200,
                                            height: 200,
                                            child: ColorFiltered(
                                              colorFilter: const ColorFilter.mode(
                                                Colors
                                                    .grey, // Cor cinza para converter para escala de cinza
                                                BlendMode.saturation,
                                              ),
                                              child: RotatedBox(
                                                quarterTurns: randomRotation *
                                                    1, // Rotaciona 0, 90, 180 ou 270 graus aleatoriamente
                                                child: Image.asset(
                                                  'assets/img/${sortedItem['image']['sprite']}',
                                                  height: 150,
                                                  width: 150,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                                : null,
                            child: Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Color(0xffb091428),
                                  border: Border.all(
                                      color: (widget.guessCounter >= 15)
                                          ? Color(0xffbC89B3C)
                                          : Color(0xffb5B5A56)),
                                ),
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.image,
                                  size: 40,
                                  color: (widget.guessCounter >= 15)
                                      ? Color(0xffbC89B3C)
                                      : Color(0xffb5B5A56),
                                )),
                          ),
                        ),
                        Text(
                          "${15 - widget.guessCounter} tries",
                          style: TextStyle(
                              fontSize: 16,
                              color: (widget.guessCounter >= 15)
                                  ? Colors.transparent
                                  : Colors.white,
                              fontFamily: 'BeaufortforLOL',
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Text("Total tries: ${widget.guessCounter}",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: 'BeaufortforLOL',
                    fontWeight: FontWeight.bold)),
            Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Row(
                  children: [
                    Expanded(
                        child: Opacity(
                      opacity: hasWon ? 0.5 : 1.0,
                      child: TextField(
                        enabled: !hasWon,
                        style: const TextStyle(
                          color: Color(0xffbC89B3C),
                          fontFamily: 'BeaufortforLOL',
                        ),
                        controller: _controller,
                        onChanged: (text) {
                          updateSuggestions(text);
                        },
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xffbC89B3C), width: 2.0),
                          ),
                          hintText: 'Type item... (min. 3 characters)',
                          hintStyle: TextStyle(
                            color: Color.fromARGB(140, 255, 255, 255),
                          ),
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffb1E2328), width: 2.0)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(
                                    0xffbC89B3C), // Cor da borda quando habilitada/desabilitada
                                width: 2.0),
                          ),
                          filled: true,
                          fillColor: Color(0xffb091428),
                        ),
                      ),
                    )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 60,
                        child: Opacity(
                          opacity: hasWon ? 0.5 : 1.0,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xffb0A1428),
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 2,
                                        color: hasWon
                                            ? Color(0xffb1E2328)
                                            : Color(0xffbC89B3C)),
                                    borderRadius: BorderRadius.circular(5))),
                            onPressed: () {
                              if (_items.any((element) =>
                                  element['name'] == _controller.text)) {
                                setState(() {
                                  guesses.add(_items.firstWhere(
                                      (e) => e['name'] == _controller.text));
                                  _controller.text = "";
                                  filteredSuggestions.clear();
                                  check_guess();
                                  widget.guessCounter = guesses.length;
                                });
                              }
                            },
                            child: Icon(
                              Icons.send,
                              color: hasWon
                                  ? Color(0xffb1E2328)
                                  : Color(0xffbC89B3C),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 50, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                alignment: Alignment.center,
                                height: 50,
                                width: 70,
                                decoration: const BoxDecoration(
                                  color: Color(0xffb0A1428),
                                  border: Border(
                                    left: BorderSide(
                                        width: 2.0,
                                        color:
                                            Colors.white), // Borda à esquerda
                                    right: BorderSide(
                                        width: 2.0,
                                        color: Colors.white), // Borda à direita
                                    bottom: BorderSide(
                                        width: 2.0,
                                        color: Colors.white), // Borda embaixo
                                    top: BorderSide(
                                        width: 2.0,
                                        color: Colors.white), // Borda embaixo
                                  ),
                                ),
                                child: const Text(
                                  "ITEM",
                                  style: TextStyle(
                                      color: Color(0xffbC89B3C),
                                      fontFamily: 'BeaufortforLOL',
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                )),
                            Container(
                                alignment: Alignment.center,
                                height: 50,
                                width: 70,
                                decoration: const BoxDecoration(
                                  color: Color(0xffb0A1428),
                                  border: Border(
                                    left: BorderSide(
                                        width: 2.0,
                                        color:
                                            Colors.white), // Borda à esquerda
                                    right: BorderSide(
                                        width: 2.0,
                                        color: Colors.white), // Borda à direita
                                    bottom: BorderSide(
                                        width: 2.0,
                                        color: Colors.white), // Borda embaixo
                                    top: BorderSide(
                                        width: 2.0,
                                        color: Colors.white), // Borda embaixo
                                  ),
                                ),
                                child: const Text(
                                  "ATTACK DAMAGE",
                                  style: TextStyle(
                                      color: Color(0xffbC89B3C),
                                      fontFamily: 'BeaufortforLOL',
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                )),
                            Container(
                                alignment: Alignment.center,
                                height: 50,
                                decoration: const BoxDecoration(
                                  color: Color(0xffb0A1428),
                                  border: Border(
                                    left: BorderSide(
                                        width: 2.0,
                                        color:
                                            Colors.white), // Borda à esquerda
                                    right: BorderSide(
                                        width: 2.0,
                                        color: Colors.white), // Borda à direita
                                    bottom: BorderSide(
                                        width: 2.0,
                                        color: Colors.white), // Borda embaixo
                                    top: BorderSide(
                                        width: 2.0,
                                        color: Colors.white), // Borda embaixo
                                  ),
                                ),
                                width: 70,
                                child: const Text(
                                  "ABILITY POWER",
                                  style: TextStyle(
                                      color: Color(0xffbC89B3C),
                                      fontFamily: 'BeaufortforLOL',
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                )),
                            Container(
                                alignment: Alignment.center,
                                height: 50,
                                decoration: const BoxDecoration(
                                  color: Color(0xffb0A1428),
                                  border: Border(
                                    left: BorderSide(
                                        width: 2.0,
                                        color:
                                            Colors.white), // Borda à esquerda
                                    right: BorderSide(
                                        width: 2.0,
                                        color: Colors.white), // Borda à direita
                                    bottom: BorderSide(
                                        width: 2.0,
                                        color: Colors.white), // Borda embaixo
                                    top: BorderSide(
                                        width: 2.0,
                                        color: Colors.white), // Borda embaixo
                                  ),
                                ),
                                width: 70,
                                child: const Text(
                                  "LIFE",
                                  style: TextStyle(
                                      color: Color(0xffbC89B3C),
                                      fontFamily: 'BeaufortforLOL',
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                )),
                            Container(
                                alignment: Alignment.center,
                                height: 50,
                                decoration: const BoxDecoration(
                                  color: Color(0xffb0A1428),
                                  border: Border(
                                    left: BorderSide(
                                        width: 2.0,
                                        color:
                                            Colors.white), // Borda à esquerda
                                    right: BorderSide(
                                        width: 2.0,
                                        color: Colors.white), // Borda à direita
                                    bottom: BorderSide(
                                        width: 2.0,
                                        color: Colors.white), // Borda embaixo
                                    top: BorderSide(
                                        width: 2.0,
                                        color: Colors.white), // Borda embaixo
                                  ),
                                ),
                                width: 70,
                                child: const Text(
                                  "GOLD",
                                  style: TextStyle(
                                      color: Color(0xffbC89B3C),
                                      fontFamily: 'BeaufortforLOL',
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                )),
                          ],
                        ),
                      ),
                      Stack(children: [
                        Container(
                          height: 275,
                          margin: EdgeInsets.only(top: 100, bottom: 10),
                          child: ListView.builder(
                            itemCount: guesses.length,
                            itemBuilder: (context, index) {
                              return GuessWidget(
                                  List.from(guesses.reversed)[index],
                                  sortedItem);
                            },
                          ),
                        ),
                        Container(
                          height: 180,
                          child: ListView.builder(
                            itemCount: filteredSuggestions.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _controller.text =
                                        filteredSuggestions[index]['name'];
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xffb0A1428),
                                    border:
                                        Border.all(color: Color(0xffbC89B3C)),
                                  ),
                                  child: Row(
                                    children: [
                                      Image.network(
                                        'https://ddragon.leagueoflegends.com/cdn/13.21.1/img/item/${filteredSuggestions[index]['id']}.png',
                                        height: 50,
                                        width: 50,
                                      ),
                                      SizedBox(width: 10),
                                      Container(
                                        child: Text(
                                          filteredSuggestions[index]['name'],
                                          style: TextStyle(
                                              color: Color(0xffbC89B3C)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ]),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
