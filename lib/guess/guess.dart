import 'package:flutter/material.dart';

class GuessWidget extends StatefulWidget {
  final Map<String, dynamic> item;
  final Map<String, dynamic> sorted;
  const GuessWidget(this.item, this.sorted, {super.key});

  @override
  State<GuessWidget> createState() => _guessState();
}

class _guessState extends State<GuessWidget> {
  @override
  Widget build(BuildContext context) {
    List<Widget> textWidgets = [];
    List<dynamic> stats = widget.item['stats'];
    for (var stat in widget.item['stats']) {
      String name = stat['name'];
      int value = stat['value'];

      if (name == 'Attack Damage' ||
          name == 'Ability Power' ||
          name == 'Life' ||
          name == 'Gold') {
        textWidgets.add(
          Text(
            '$name: $value',
            style: TextStyle(fontSize: 16),
          ),
        );
      }
    }
    Widget getIcon(stat) {
      List<dynamic> sortedStats = widget.sorted['stats'];
      var cs = sortedStats.firstWhere((element) => stat['name'] == element['name']);
      if (stat['value'] > cs['value'] && cs['value'] != 0) {
        return Icon(Icons.arrow_downward, color: Colors.white);
      } else if (stat['value'] < cs['value'] && cs['value'] != 0) {
        return Icon(Icons.arrow_upward, color: Colors.white);
      } else {
        return SizedBox(); // Retorna um SizedBox para indicar que não há ícone
      }
    }

    Color getColor(stat) {
      List<dynamic> sortedStats = widget.sorted['stats'];
      var cs =
          sortedStats.firstWhere((element) => stat['name'] == element['name']);
      if (cs['value'] == stat['value']) {
        return Color.fromARGB(250, 60, 200, 81); // Cor verde
      } else {
        if (cs['value'] > stat['value'] ||
            (cs['value'] < stat['value'] && cs['value'] > 0)) {
          return Color(0xffbC89B3C); // Cor amarela
        } else {
          return Color.fromARGB(250, 200, 60, 60); // Cor vermelha
        }
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 70,
          width: 70,
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(
                  width: 2.0, color: Colors.white), // Borda à esquerda
              right: BorderSide(
                  width: 2.0, color: Colors.white), // Borda à direita
              bottom:
                  BorderSide(width: 2.0, color: Colors.white), // Borda embaixo
            ),
          ),
          child: Image.network(
            'https://ddragon.leagueoflegends.com/cdn/13.21.1/img/item/${widget.item['id']}.png',
            width: 70,
            height: 70,
          ),
        ),
        for (var stat in stats)
          if (stat['name'] == 'Attack Damage' ||
              stat['name'] == 'Ability Power' ||
              stat['name'] == 'Life' ||
              stat['name'] == 'Gold')
            Container(
              decoration: BoxDecoration(
                color: getColor(stat),
                border: const Border(
                  left: BorderSide(
                      width: 2.0, color: Colors.white), // Borda à esquerda
                  right: BorderSide(
                      width: 2.0, color: Colors.white), // Borda à direita
                  bottom: BorderSide(
                      width: 2.0, color: Colors.white), // Borda embaixo
                ),
              ),
              alignment: Alignment.center,
              height: 70,
              width: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${stat['value']}',
                    style: TextStyle(fontSize: 16, color: Colors.white,fontFamily: 'BeaufortforLOL', fontWeight:FontWeight.bold, shadows: [
              Shadow(
                color: Colors.blue.shade900.withOpacity(1),
                offset: Offset(1, 1),
                blurRadius: 1,
              ),
            ],),
                  ),
                  getIcon(stat)
                ],
              ),
            ),
      ],
    );
  }
}
