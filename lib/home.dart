import 'package:flutter/material.dart';
import 'package:map/app/map/%20view/map_view.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child:  TextButton(onPressed: (){
          Navigator.push(context,MaterialPageRoute(builder: (context) =>MapPage()));
        },
            child: Center(child: Text("Map")) )
      ),
    );
  }
}
