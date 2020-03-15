import 'package:flutter/material.dart';

// class DetailsPage extends StatefulWidget {
//   DetailsPage();
//   // this.country, this.cases, this.todayCases, this.deaths,
//   //     this.todayDeaths, this.recovered, this.critical, this.countryCode);
//   // final String country;
//   // final String cases;
//   // final String todayCases;
//   // final String deaths;
//   // final String todayDeaths;
//   // final String recovered;
//   // final String critical;
//   // final String countryCode;

//   @override
//   _DetailsPageState createState() => _DetailsPageState();
// }

// class _DetailsPageState extends State<DetailsPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("aaaa"),
//       ),
//       body: Center(
//         child: Column(
//           children: <Widget>[Text("abc")],
//         ),
//       ),
//     );
//   }
// }

class DetailScreen extends StatefulWidget {
  DetailScreen(this.country, this.cases, this.todayCases, this.deaths,
      this.todayDeaths, this.recovered, this.critical, this.countryCode);

  final String country;
  final String cases;
  final String todayCases;
  final String deaths;
  final String todayDeaths;
  final String recovered;
  final String critical;
  final String countryCode;
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
            child: Column(
          children: <Widget>[
            SizedBox(
              height: 80,
            ),
            Hero(
              tag: widget.country,
              child: Image.network(
                'https://picsum.photos/250?image=9',
              ),
            ),
            Text(widget.country),
            Text(widget.cases),
            Text(widget.todayCases)
          ],
        )),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
