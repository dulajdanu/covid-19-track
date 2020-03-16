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
  var cCode;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cCode = widget.countryCode;
  }

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
            Text(
              widget.country,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            Hero(
                tag: widget.country,
                child: Container(
                    height: 150,
                    width: 180,
                    child: (cCode != "")
                        ? Image.network(
                            "https://www.countryflags.io/$cCode/flat/64.png",
                            fit: BoxFit.contain,
                          )
                        : Container(
                            color: Colors.green,
                          ))),
            Text(
              "Total Number Of Cases",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.cases,
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Total Number Of Cases Today",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.todayCases,
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Total Number Of Deaths",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.deaths,
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Total Number Of Today Deaths",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.todayDeaths,
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Total Number Of Recovered",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.recovered,
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Total Number Of Critical",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.critical != "null" ? widget.critical : 0.toString(),
              style: TextStyle(fontSize: 15),
            )
          ],
        )),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
