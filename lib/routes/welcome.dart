import 'package:flutter/cupertino.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image(
      image: NetworkImage(
          "https://avatars2.githubusercontent.com/u/20411648?s=460&v=4"),
      width: 100.0,
    );
//    return Image(
//      image: AssetImage("imgs/timg.jpg"),
//      fit: BoxFit.fill,
//    );
//    return Image.network(
//      "http://clubimg.club.vmall.com/data/attachment/album/201509/29/142802dl3i3l99a93ibhc7.jpg",
//      fit: BoxFit.fill,
//    );
  }
}
