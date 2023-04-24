import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/bars.dart';
import '../screens/price_list_screen.dart';
import '../screens/edit_bar_screen.dart';

class BarWidget extends StatelessWidget {
  final String id;
  final String name;
  final String location;
  final String image;
  final bool viewOnly;

  BarWidget({
    Key? key,
    required this.id,
    required this.name,
    required this.location,
    required this.image,
    required this.viewOnly,
  }) : super(key: key);

  void _delete(context, String id) {
    Provider.of<Bars>(context, listen: false)
        .deleteBar(id)
        .then((_) => Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(name),
          ),
          subtitle: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(location),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => PriceListScreen(
                      barId: id,
                      barName: name,
                      viewOnly: viewOnly,
                    )));
          },
          onLongPress: () {
            if (!viewOnly) {
              showDialog(
                  context: context,
                  builder: (context) => Container(
                        child: AlertDialog(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          backgroundColor: Colors.black54,
                          title: Text(
                            'Do you want to delete or edit $name?',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.yellow,
                            ),
                          ),
                          content: Container(
                            height: 120,
                            child: Column(
                              children: [
                                const Divider(),
                                SizedBox(
                                  child: SizedBox(
                                    height: 25,
                                    width: 120,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.amber),
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30))),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (ctx) => EditBarScreen(
                                                      barId: id,
                                                      barName: name,
                                                      barLocation: location,
                                                      barImage: image,
                                                    )));
                                      },
                                      child: const Text(
                                        'Edit',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Divider(),
                                SizedBox(
                                  height: 25,
                                  width: 120,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(Colors.red),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30))),
                                    ),
                                    onPressed: () {
                                      _delete(context, id);
                                    },
                                    child: const Text(
                                      'Delete',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ));
            }
          },
          child: Image.network(
            image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
