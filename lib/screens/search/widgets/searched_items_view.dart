import 'package:flutter/material.dart';
import 'package:recovery_app/screens/search/item_screen.dart';
import 'package:recovery_app/services/excel_store.dart';

class SearchedItemsView extends StatelessWidget {
  const SearchedItemsView({
    super.key,
    required this.items,
  });

  final List<FoundItem> items;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 60),
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
              child: items.isEmpty
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      child: const Center(
                        child: Text("NO item"),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () async {
                            var item = await ExcelStore.getRowItems(
                                items.elementAt(index));
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (c) => ItemScreen(details: item)));
                          },
                          child: Card(
                            child: ListTile(
                              title: Text(items.elementAt(index).item),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          )
        ],
      ),
    );
  }
}
