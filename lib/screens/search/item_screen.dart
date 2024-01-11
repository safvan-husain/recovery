// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recovery_app/screens/search/widgets/single_item.dart';

class ItemScreen extends StatefulWidget {
  final List<int> rowIds;
  final String heroTag;
  const ItemScreen({
    Key? key,
    required this.rowIds,
    required this.heroTag,
  }) : super(key: key);

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  final PageController controller = PageController();
  int currentIndex = 1;
  @override
  void initState() {
    controller.addListener(() {
      var index = controller.page!.round() + 1;
      if (index != currentIndex) {
        setState(() {
          currentIndex = index;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: widget.rowIds.isEmpty
            ? const Center(
                child: Text("No details available"),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              controller.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut);
                            },
                            child: const Icon(Icons.arrow_back_ios_new),
                          ),
                          Text("Item $currentIndex / ${widget.rowIds.length}"),
                          InkWell(
                            onTap: () {
                              controller.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut);
                            },
                            child: const Icon(Icons.arrow_forward_ios),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onHorizontalDragEnd: (details) {
                        if (details.primaryVelocity! > 0) {
                          // Swipe Right
                          print('Swiped Right');
                        } else if (details.primaryVelocity! < 0) {
                          // Swipe Left
                          print('Swiped Left');
                        }
                      },
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height - 50,
                        child: PageView(
                          controller: controller,
                          children: widget.rowIds
                              .map((e) => SingleItemScreen(
                                  rowId: e, heroTag: widget.heroTag))
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      )),
    );
  }
}
