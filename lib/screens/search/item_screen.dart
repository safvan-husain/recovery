// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recovery_app/screens/search/widgets/single_item.dart';

class ItemScreen extends StatefulWidget {
  final int rowId;
  final String heroTag;
  const ItemScreen({
    Key? key,
    required this.rowId,
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
          child: SingleItemScreen(rowId: widget.rowId, heroTag: widget.heroTag),
        ),
      ),
    );
  }
}
