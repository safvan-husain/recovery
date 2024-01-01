// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:recovery_app/screens/title_configure/select_titles_screens.dart';

class TitleConfigure extends StatefulWidget {
  final List<List<String?>> titlesOfSheets;
  const TitleConfigure({
    Key? key,
    required this.titlesOfSheets,
  }) : super(key: key);

  @override
  State<TitleConfigure> createState() => _TitleConfigureState();
}

class _TitleConfigureState extends State<TitleConfigure> {
  Map<String, List<String?>> customizedTitles = {};

  List<String> customNames = ["Loan Holder", "Vehichel Number"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customize Titles'),
        actions: [
          ElevatedButton(
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.white)),
            onPressed: () {
              print(customizedTitles);
            },
            child: const Text("Activate custom"),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: customNames.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(customNames[index]),
            trailing: IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () async {
                await Navigator.push<String>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectTitleScreen(
                      titles: widget.titlesOfSheets,
                      onSelect: (selectedTitle) {
                        setState(() {
                          customizedTitles[customNames[index]] = selectedTitle;
                        });
                        print(selectedTitle);
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
