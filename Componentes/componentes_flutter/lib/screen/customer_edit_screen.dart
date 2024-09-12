import 'package:componentes_flutter/widget/edit_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomerEditScreenState extends StatefulWidget {
  const CustomerEditScreenState({super.key});

  @override
  State<CustomerEditScreenState> createState() =>
      _CustomerEditScreenStateState();
}

class _CustomerEditScreenStateState extends State<CustomerEditScreenState> {
  String gender = "man";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(CupertinoIcons.arrow_left_square),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          leadingWidth: 80,
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 10),
                child: IconButton(
                    onPressed: () {},
                    style: IconButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        fixedSize: const Size(60, 50),
                        elevation: 10),
                    icon: const Icon(
                      Icons.check,
                      color: Colors.white,
                    )))
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Account",
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 40,
                ),
                EditItem(
                    title: "Photo",
                    widget: Column(
                      children: [
                        Image.asset(
                          "assets/images/default-avatar.png",
                          height: 100,
                          width: 100,
                        ),
                        TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.lightBlueAccent),
                            child: const Text("Upload Image"))
                      ],
                    )),
                const EditItem(title: "Name", widget: TextField()),
                const SizedBox(height: 40),
                EditItem(
                    title: "Gender",
                    widget: Row(children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            gender = "man";
                          });
                        },
                        style: IconButton.styleFrom(
                            backgroundColor: gender == "man"
                                ? Colors.deepPurple
                                : Colors.grey.shade200,
                            fixedSize: Size(50, 50)),
                        icon: Icon(
                          CupertinoIcons.person_alt,
                          color: gender == "man" ? Colors.white : Colors.black,
                          size: 18,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            gender = "woman";
                          });
                        },
                        style: IconButton.styleFrom(
                            backgroundColor: gender == "woman"
                                ? Colors.deepPurple
                                : Colors.grey.shade200,
                            fixedSize: Size(50, 50)),
                        icon: Icon(
                          CupertinoIcons.person_alt,
                          color:
                              gender == "woman" ? Colors.white : Colors.black,
                          size: 18,
                        ),
                      ),
                    ])),
                const SizedBox(
                  height: 40,
                ),
                const EditItem(widget: TextField(), title: "Age"),
                const SizedBox(
                  height: 40,
                ),
                const EditItem(widget: TextField(), title: "Email")
              ],
            ),
          ),
        ));
  }
}
