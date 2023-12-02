import 'package:flutter/material.dart';

class BuildPath extends StatefulWidget {
  final List<dynamic> items;
  final List<dynamic> items_into;
  const BuildPath(this.items,this.items_into, {super.key});

  @override
  State<BuildPath> createState() => BuildPathWidget();
}

class BuildPathWidget extends State<BuildPath> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xffb091428),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      content: SizedBox(
        width: 100,
        height: 500,
        child: Column(
          children: [
            Text("Built of:",style:TextStyle(fontSize: 24, color: Colors.white,fontFamily: 'BeaufortforLOL', fontWeight:FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Image.network(
                        'https://ddragon.leagueoflegends.com/cdn/13.21.1/img/item/${widget.items[index]['id']}.png',
                        height: 50,
                        width: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("${widget.items[index]['name']}", style: TextStyle(fontSize: 16, color: Colors.white,fontFamily: 'BeaufortforLOL', fontWeight:FontWeight.bold),),
                      )
                    ],
                  );
                },
              ),
            ),
            Text("Build into:",style:TextStyle(fontSize: 24, color: Colors.white,fontFamily: 'BeaufortforLOL', fontWeight:FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Image.network(
                        'https://ddragon.leagueoflegends.com/cdn/13.21.1/img/item/${widget.items_into[index]['id']}.png',
                        height: 50,
                        width: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("${widget.items_into[index]['name']}", style: TextStyle(fontSize: 16, color: Colors.white,fontFamily: 'BeaufortforLOL', fontWeight:FontWeight.bold),),
                      )
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
