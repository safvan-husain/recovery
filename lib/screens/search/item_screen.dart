// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recovery_app/screens/HomePage/cubit/home_cubit.dart';
import 'package:recovery_app/screens/search/widgets/single_item.dart';
import 'package:recovery_app/storage/database_helper.dart';

class ItemScreen extends StatefulWidget {
  final int rowId;
  final List<int>? rowIds;
  final String heroTag;
  const ItemScreen({
    Key? key,
    required this.rowId,
    this.rowIds,
    required this.heroTag,
  }) : super(key: key);

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  final PageController controller = PageController();
  int currentIndex = 1;
  Future<List<String>>? futureBranches;
  int? itemCount;
  late int currentRowId;
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
    if (widget.rowIds != null) {
      show();
    }
    currentRowId = widget.rowId;
    super.initState();
  }

  void show() async {
    var nullebleBranches = await DatabaseHelper.getBranches(widget.rowIds!);
    List<String> branches = nullebleBranches.whereType<String>().toList();
    if (context.mounted) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          if (branches.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Found in Branches",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const Text("No branches detected"),
                ],
              ),
            );
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Found in Branches",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue,
                  ),
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        currentRowId = widget.rowIds!.elementAt(
                            nullebleBranches.indexOf(branches[index]));
                      });
                      Navigator.of(context).pop();
                    },
                    child: ListTile(
                      title: Text(
                        branches[index],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemCount: branches.length,
              ),
            ],
          );
        },
      );
    }
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
          child: SingleItemScreen(rowId: currentRowId, heroTag: widget.heroTag),
        ),
      ),
    );
  }
}
