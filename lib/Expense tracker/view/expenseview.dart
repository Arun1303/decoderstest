import 'package:decoderstest/Expense%20tracker/model/sqlitemodel.dart';
import 'package:decoderstest/Expense%20tracker/sqlite/sqliteclass.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class ExpenseTracker extends StatefulWidget {
  const ExpenseTracker({super.key});

  @override
  State<ExpenseTracker> createState() => _ExpenseTrackerState();
}

class _ExpenseTrackerState extends State<ExpenseTracker> {
  // amount, category, and date

  late TextEditingController amountl;
  late TextEditingController category;

  NotesDatabase noteDatabase = NotesDatabase.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    amountl = TextEditingController();
    category = TextEditingController();
  }

  List<DownloadsModel> notes = [];

  @override
  void dispose() {
    //close the database
    noteDatabase.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(children: [
                    TextFormField(
                      controller: amountl,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        hintText: "Amount",
                        fillColor: Colors.white70,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: category,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        hintText: "Category",
                        fillColor: Colors.white70,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (amountl.text != '' && category.text != '') {
                             int i = 0;
                        var getData = await noteDatabase.readAllNotes();
                        i = getData.length;

                        DownloadsModel data = DownloadsModel(
                            id: (i + 1).toString(),
                            amount: amountl.text,
                            category: category.text,
                            timestamp: DateTime.now().millisecondsSinceEpoch);
                        await noteDatabase.create(data, (i + 1).toString());
                        
                        showAlertDialog(context, 'Success!!!', 'Expenses successfully added');
                        setState(() {
                           amountl.clear();
                           category.clear();
                        });
                        } else {
                          showAlertDialog(context, 'Missing!!!', 'Please enter the amount & category');
                        }
                       
                      },
                      child: const Text('Submit'),
                    ),
                  ]),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              FutureBuilder(
                  future: noteDatabase.readAllNotes(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var data = snapshot.data?.length;
                      return data == 0
                          ? const Text('No Expenses Spent Yet')
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'My Expenses',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                                Column(
                                    children: snapshot.data!
                                        .map((DownloadsModel document) {
                                          var timestamp = document.timestamp;
                                          String date = '';
                                          if (timestamp != 0) {
                                              var dt = DateTime.fromMillisecondsSinceEpoch(timestamp!);
                                              date = DateFormat('dd/MM/yyyy, hh:mm a').format(dt);
                                          } 
                                  return SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('₹${document.amount ?? ''}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                                              SizedBox(height: 8,),
                                              Text(document.category ?? '', style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),),
                                               SizedBox(height: 8,),
                                              Text(date, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList()),
                              ],
                            );
                    } else if (snapshot.hasError) {
                      return const Text('Error Retriving Data');
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, String title, String content) {

  
  Widget continueButton = TextButton(
    child: Text("Ok"),
    onPressed:  () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: [
      
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
}
