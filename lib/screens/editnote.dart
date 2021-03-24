import 'package:flutter/material.dart';

// Plugin imports
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditNote extends StatefulWidget {
  String id;
  String docid;
  EditNote(this.id,this.docid);
  // Controllers for text fields
  @override
  _EditNoteState createState() => _EditNoteState();
  
}


class _EditNoteState extends State<EditNote> {
  TextEditingController title = TextEditingController();

  TextEditingController content = TextEditingController();

  GlobalKey <FormState> titlecheck = GlobalKey <FormState>();

  @override
  void initState(){
    title.text = widget.id;
    
  }


  CollectionReference ref = FirebaseFirestore.instance.collection('notes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Edit note",
            style: GoogleFonts.sourceCodePro(fontWeight: FontWeight.w900),
          ),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => {Navigator.pop(context)}),
            actions: [
              IconButton(icon: Icon(Icons.delete, color: Colors.white,), onPressed: () {
                Firestore.instance.collection('notes').document(widget.docid).delete().then((value) => Navigator.pop(context));
              })
            ],
          backgroundColor: Colors.black,
          brightness: Brightness.dark),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(Icons.check),
          onPressed: () {
            if(titlecheck.currentState.validate()){
            // Adding the data to firestore
          
                // 'title': title.text,
                // 'content': content.text,
                // 'time': DateTime.now()
                Firestore.instance.collection("notes").document(widget.docid).setData({
                'title': title.text,
                'content': content.text,
                'time': DateTime.now()
                }).then((value) => Navigator.pop(context));
              }
           
            
          }),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                                key: titlecheck,
                              child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Title can not be empty';
                    }
                    return null;
                  },
                  controller: title,
                  decoration: InputDecoration(
                    fillColor: Colors.grey.withOpacity(0.4),
                    filled: true,
                    hintText: 'Title',
                  ),
                  style: GoogleFonts.sourceCodePro(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: content,
                  maxLines: null,
                  expands: true,
                  decoration: InputDecoration(
                    fillColor: Colors.grey.withOpacity(0.4),
                    filled: true,
                    hintText: 'Content',
                  ),
                  style: GoogleFonts.sourceCodePro(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
