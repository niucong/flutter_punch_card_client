import 'package:flutter/cupertino.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetImage("imgs/timg.jpg"),
      fit: BoxFit.fill,
    );
//    return Image.network(
//      "http://clubimg.club.vmall.com/data/attachment/album/201509/29/142802dl3i3l99a93ibhc7.jpg",
//      fit: BoxFit.fill,
//    );
  }
}
