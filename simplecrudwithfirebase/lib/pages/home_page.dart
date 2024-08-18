import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:simplecrudwithfirebase/services/firestore.dart';

void main() => runApp(const HomePage());

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreServices firestoreServices = FirestoreServices();

  final TextEditingController textController = TextEditingController();

  void openNoteBox({String? docID}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: textController,
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      if (docID != null) {
                        firestoreServices.updateNote(
                            docID, textController.text);
                      } else {
                        firestoreServices.addNote(textController.text);
                      }
                      textController.clear();
                      Navigator.pop(context);
                    },
                    child: const Text("Add")),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: firestoreServices.getNotesStrean(),
          builder: (context, snapshot) {
            //if we have data, get all the docs
            if (snapshot.hasData) {
              List notesList = snapshot.data!.docs;
              //display as a list
              return ListView.builder(
                  itemCount: notesList.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = notesList[index];
                    String docID = document.id;
                    //get note from each doc
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    String noteText = data['note'];
                    return ListTile(
                      title: Text(noteText),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              openNoteBox(docID: docID);
                            },
                            icon: const Icon(Icons.settings),
                          ),
                          IconButton(
                            onPressed: () {
                              firestoreServices.deleteNote(docID);
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    );
                  });
            } else {
              return const Text('No notes...');
            }
          }),
    );
  }
}
