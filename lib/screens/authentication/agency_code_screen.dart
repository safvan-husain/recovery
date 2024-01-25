import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recovery_app/screens/authentication/sign_up_screen_initial.dart';
import 'package:recovery_app/services/auth_services.dart';

class AgencyCodeScreen extends StatefulWidget {
  final String phoneNumber;
  const AgencyCodeScreen({super.key, required this.phoneNumber});

  @override
  State<AgencyCodeScreen> createState() => _AgencyCodeScreenState();
}

class _AgencyCodeScreenState extends State<AgencyCodeScreen> {
  Map<String, dynamic>? agency;
  bool _isLoading = true;
  late Future<List<Map<String, dynamic>>> futureAgencyList;
  @override
  void initState() {
    futureAgencyList = AuthServices.getAgencyList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color.fromARGB(255, 242, 244, 255),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome 👋',
                  style: GoogleFonts.outfit(
                    textStyle: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff2c65d8),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                  width: double.infinity,
                ),
                if (agency == null)
                  FutureBuilder(
                    future: futureAgencyList,
                    builder: (context, snp) {
                      if (snp.connectionState != ConnectionState.done) {
                        return const Center(
                            // child: CircularProgressIndicator(),
                            );
                      }
                      if (!snp.hasData) {
                        return const Center(
                          child: Text("an Error occured"),
                        );
                      }
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          _isLoading = false;
                        });
                      });
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              "Choose the agency you want to work with",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: Colors.grey, width: 1.0),
                            ),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: MediaQuery.of(context).size.width,
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: snp.data!.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        agency = snp.data![index];
                                      });
                                    },
                                    child: Card(
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        alignment: Alignment.center,
                                        child: Text(
                                          snp.data![index]["agency_name"],
                                          style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  )
                else
                  ..._agencyConfirmScreen,
              ],
            ),
          ),
        ),
        if (_isLoading)
          Stack(
            children: [
              ModalBarrier(
                  dismissible: false, color: Colors.grey.withOpacity(0.3)),
              const Center(child: CircularProgressIndicator()),
            ],
          ),
      ],
    );
  }

  List<Widget> get _agencyConfirmScreen {
    return [
      Text(
        'Is it the agency you are looking for?',
        style: GoogleFonts.outfit(
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xff23202a),
          ),
        ),
      ),
      const SizedBox(height: 20),
      Container(
        margin: const EdgeInsets.all(5),

        // width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          // border: Border.all(color: Colors.grey, width: 1.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                agency!["agency_name"]!,
                style: GoogleFonts.oswald(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      agency = null;
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey, width: 1.0),
                    ),
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SignUpScreenInitial(
                                agencyName: agency!["agency_name"],
                                agencyId: agency!['id'],
                                phoneNumber: widget.phoneNumber,
                              )),
                    );
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey, width: 1.0),
                    ),
                    child: Text(
                      "Confirm",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      )
    ];
  }
}
