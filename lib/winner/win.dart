import 'package:flutter/material.dart';

class Win extends StatefulWidget {
  final Map<String, dynamic> item;
  const Win(this.item, {super.key});

  @override
  State<Win> createState() => WinWidget();
}

class WinWidget extends State<Win> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xffb091428),
      shape: RoundedRectangleBorder(
        
        borderRadius: BorderRadius.circular(10.0),
      ),
      contentPadding: EdgeInsets.all(20.0),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('VICTORY',textAlign: TextAlign.center,style: TextStyle(fontSize: 24, color: Color(0xffbC89B3C),fontFamily: 'BeaufortforLOL', fontWeight:FontWeight.w900,)),
          InkWell(
            onTap: () {
              Navigator.of(context).pop(); // Fecha o diálogo
            },
            child: Icon(Icons.close, color:Color(0xffbC89B3C) ,), // Ícone de fechar
          ),
        ],
      ),
      content: SizedBox( 
    width: 100, 
    height: 280,
    
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            
            'Congratulations!\nThe item was: ',textAlign: TextAlign.center, style:const TextStyle(fontSize:18, color: Color(0xffbC89B3C),fontFamily: 'BeaufortforLOL')),
          Text(
            
            '${widget.item['name']}',textAlign: TextAlign.center, style:const TextStyle(fontSize:24, color: Color(0xffbC89B3C),fontFamily: 'BeaufortforLOL',fontWeight: FontWeight.bold)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              'https://ddragon.leagueoflegends.com/cdn/13.21.1/img/item/${widget.item['id']}.png',
              width: 70,
              height: 70,
            ),
          ),
        ],
      ),
    ),
  ),
    
    );
  }
}