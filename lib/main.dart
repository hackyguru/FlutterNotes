import 'package:flutter/material.dart';
import 'dart:async';

// Plugin imports
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



// Page imports
import 'screens/addnote.dart';
import 'screens/editnote.dart';


void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
   runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Notes', home: HomeScreen());
  }
}


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ref = Firestore.instance.collection('notes');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Flutter notes",
            style: GoogleFonts.sourceCodePro(fontWeight: FontWeight.w900),
          ),
          backgroundColor: Colors.black,
          brightness: Brightness.dark),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => AddNote()));
          }),
      body: StreamBuilder(
        stream: Firestore.instance.collection('notes').orderBy("time").snapshots(),
        builder: (context, snapshot) {
          return ListView.builder(
         itemCount: snapshot.hasData?snapshot.data.documents.length:0,
          itemBuilder: (_,index){
            var notes = snapshot.data.documents[index];
            return snapshot.data.documents.length == 0 ? Text("No notes found") : GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => EditNote(notes['title'],notes.id)));
                          },
                          child: Container(
                margin: EdgeInsets.all(10),
                constraints: BoxConstraints(
                  minHeight: 150
                ),
                color: Colors.grey.withOpacity(0.4),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(notes['title'],
                      style: GoogleFonts.sourceCodePro(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    Text(notes['content'], style: GoogleFonts.sourceCodePro(fontSize: 15),)
                  ]
                ),
              ),
            );
          }
          );
        }
      )
    );
  }
}
