import 'package:flutter/material.dart';



class CardPage extends StatefulWidget {
  const CardPage({Key? key, required this.title, required this.content,required this.test})
      : super(key: key);

  final String title;
  final String content;
  final ButtonBar test;

  @override
  State<CardPage> createState() => _CardState();
}

class _CardState extends State<CardPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: const Color.fromARGB(255, 170, 219, 80),
              elevation: 10,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    //leading: const Icon(Icons.menu, size: 20),
                    title: Text(widget.title,
                        style: const TextStyle(fontSize: 30.0)),
                    subtitle: Text(widget.content,
                        style: const TextStyle(fontSize: 18.0)),
                  ),
                  widget.test
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


