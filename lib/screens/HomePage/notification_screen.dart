import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> notifications = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // phone = context.read<GlobalAccountCubit>().state.user!.phone;
    _getNotifications();
  }

  late String phone;
  void _getNotifications() async {
    // var response = await http.get(
    //   Uri.parse("$baseUri/notifications?phone=$phone"),
    //   headers: {"Content-Type": "application/json"},
    // );
    // if (response.statusCode == 200) {
    //   var result = jsonDecode(response.body);
    //   for (var element in result) {
    //     notifications.add(element);
    //   }
    //   setState(() {});
    // } else {
    //   if (context.mounted) {
    //     showSnackbar("Unable to show Notifications", context);
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
        ),
        backgroundColor: Colors.grey[200],
        elevation: 1,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: Text(
          "Notifications",
          style: GoogleFonts.poppins(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.all(10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  // contentPadding: EdgeInsets.all(10),
                  leading: Icon(FontAwesomeIcons.solidBell),
                  title: Text(
                    notifications.elementAt(index)['title'] ?? "",
                    style: GoogleFonts.poppins(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    notifications.elementAt(index)['description'] ?? "",
                    style: GoogleFonts.poppins(color: Colors.black),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
