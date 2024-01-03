// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recovery_app/models/detail_model.dart';

import 'package:recovery_app/resources/drop_down.dart';
import 'package:recovery_app/screens/HomePage/cubit/home_cubit.dart';
import 'package:recovery_app/services/excel_store.dart';

class FilterBottomSheet extends StatefulWidget {
  final void Function(List<DetailsModel>) onFilter;
  const FilterBottomSheet({
    Key? key,
    required this.onFilter,
  }) : super(key: key);

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? currentValue;
  String? areaValue;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                getDropDown<String>(
                  areaValue,
                  hint: "Area",
                  values: [],
                  // values: FilterValues.areaValues.toList(),
                  onChanged: (v) {
                    setState(() {
                      areaValue = v;
                    });
                  },
                ),
                getDropDown<String>(
                  currentValue,
                  hint: "Category",
                  values: [],
                  // values: FilterValues.catValues.toList(),
                  onChanged: (v) {
                    setState(() {
                      currentValue = v;
                    });
                  },
                ),
              ]
                  .map(
                    (e) => SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: e,
                    ),
                  )
                  .toList(),
            ),
            Spacer(),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      widget.onFilter([]);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Reset",
                        style: GoogleFonts.poppins(
                            color: Colors.blue, fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      // widget.onFilter(
                      //   ExcelStore.filtered(
                      //     context.read<HomeCubit>().state.vehichalOwnerList,
                      //     areaValue,
                      //     currentValue,
                      //   ),
                      // );
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Filter",
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
