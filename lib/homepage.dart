import 'dart:async';
import 'dart:math';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StreamController<InputObject> streamController =
      StreamController.broadcast();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ElevatedButton(
        child: const Text('Add 2 numbers'),
        onPressed: () {
          List a = [36, 17, 48, 29];
          List b = [1, 2, 3, 4, 5, 6];

          streamController.sink.add(InputObject(
              a[Random().nextInt(a.length)], b[Random().nextInt(b.length)]));
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            get(),
          ],
        ),
      ),
    );
  }

  Stream<int> counts(InputObject x) async* {
    for (int i = 0; i < x.a; i += x.b) {
      print(i);

      yield i;
    }
  }

  Stream<List<int>> _getStream(Stream<InputObject> x) {
    List v = [];
    return x
        .asyncExpand((event) => counts(event))
        .map((event) => [event])
        .scan((accumulated, value, index) => accumulated..addAll(value), []);
  }

  StreamBuilder<List<int>> get() {
    return StreamBuilder(
        stream: _getStream(streamController.stream),
        builder: (context, AsyncSnapshot<List<int>> snapshot) {
          final a = snapshot.data ?? [];

          print(a.toString());

          return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: a.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(title: Text(a[i].toString())),
                );
              });

          // Text(a.toString());
        });
  }
}

class InputObject {
  final int a;
  final int b;
  InputObject(this.a, this.b);
}
