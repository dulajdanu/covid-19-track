import 'package:covid19countrytracker/countryModel.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class favourites extends StatefulWidget {
  favourites({Key key}) : super(key: key);

  @override
  _favouritesState createState() => _favouritesState();
}

class _favouritesState extends State<favourites> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("inside fav page");
    // Hive.box('countries').clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favourites"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            WatchBoxBuilder(
              box: Hive.box('countries'),
              builder: (context, box) {
                Map<dynamic, dynamic> raw = box.toMap();
                List list = raw.values.toList();

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    CountryModel cModel = list[index];
                    var cde = cModel.code.toString();
                    return ListTile(
                        title: Text(cModel.name),
                        leading: Text(cde),
                        trailing: (cModel.code.toString() != 'null'
                            ? Image.network(
                                'https://www.countryflags.io/$cde/flat/64.png',
                              )
                            : Container(
                                height: 50,
                                width: 60,
                                color: Colors.green,
                              ))
                        // subtitle: Text(
                        //     personModel.birthDate.toLocal().toString()),
                        );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
