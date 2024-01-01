import 'package:flutter/material.dart';

class SelectTitleScreen extends StatefulWidget {
  final List<List<String?>> titles;
  final Function(List<String?>) onSelect;

  const SelectTitleScreen({
    required this.titles,
    required this.onSelect,
    super.key,
  });

  @override
  State<SelectTitleScreen> createState() => _SelectTitleScreenState();
}

class _SelectTitleScreenState extends State<SelectTitleScreen> {
  int currentSheetIndex = 0;
  List<String?> selectedTitles = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Title'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height - 200,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.titles[currentSheetIndex].length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(widget.titles[currentSheetIndex][index] ??
                      "Not availible"),
                  onTap: () {
                    selectedTitles.add(widget.titles[currentSheetIndex][index]);
                  },
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: currentSheetIndex > 0
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.end,
            children: [
              if (currentSheetIndex > 0)
                Align(
                    alignment: Alignment.bottomLeft,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          currentSheetIndex -= 1;
                        });
                      },
                      child: Text("Back"),
                    )),
              if (currentSheetIndex < widget.titles.length - 1)
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentSheetIndex += 1;
                      });
                    },
                    child: Text("Next"),
                  ),
                )
              else
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onSelect(selectedTitles);
                      Navigator.of(context).pop();
                    },
                    child: Text("Done"),
                  ),
                )
            ],
          )
        ],
      ),
    );
  }
}
