import 'package:flutter/material.dart';
class Wid1 extends StatefulWidget {
  @override
  _Wid1State createState() => _Wid1State();
}

class _Wid1State extends State<Wid1> {
  @override
  Widget build(BuildContext context) {
    print('widget1 called');
   // return Wid2();
  return Scaffold(
          body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              RaisedButton(
                child: Text('press me'),
                onPressed: (){
                  setState(() {
                    
                  });
                },
              ),
              Wid2()
            ],
          ),
        ),
        
      ),
    );
  }
}



class Wid2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Widget2 called');
    return Widget3();
  }
}


class Widget3 extends StatefulWidget {
  @override
  _Widget3State createState() => _Widget3State();
}

class _Widget3State extends State<Widget3> {
  @override
  Widget build(BuildContext context) {
    print('widget3 called');
    return Container();
  }
}