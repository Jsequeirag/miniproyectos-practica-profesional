import 'package:componentes_flutter/screen/customer_edit_screen.dart';
import 'package:componentes_flutter/widget/forward_button.dart';
import 'package:componentes_flutter/widget/setting_item.dart';
import 'package:componentes_flutter/widget/settings_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AccountConfig extends StatefulWidget {
  const AccountConfig({super.key});

  @override
  State<AccountConfig> createState() => _AccountConfigState();
}

class _AccountConfigState extends State<AccountConfig> {
  bool isDarkMode = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(CupertinoIcons.arrow_left_square),
            onPressed: () {},
          ),
          leadingWidth: 80,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Setting",
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text("Account",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Image.asset(
                      ("assets/images/default-avatar.png"),
                      width: 70,
                      height: 70,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Jose Luis Sequeira",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Youtube channel",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                    const Spacer(),
                    ForwardButton(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const CustomerEditScreenState()));
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const Text(
                "Settings",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 20,
              ),
              setting_item(
                title: "language",
                icon: CupertinoIcons.globe,
                bgColor: Colors.orange.shade100,
                iconColor: Colors.orange,
                value: "English",
                onTap: () {},
              ),
              const SizedBox(
                height: 20,
              ),
              setting_item(
                title: "Notification",
                icon: CupertinoIcons.info,
                bgColor: Colors.blue.shade100,
                iconColor: Colors.blue,
                onTap: () {},
              ),
              const SizedBox(
                height: 20,
              ),
              SettingsSwitch(
                title: "language",
                icon: CupertinoIcons.globe,
                bgColor: Colors.purple.shade100,
                iconColor: Colors.purple,
                value: isDarkMode,
                onTap: (value) {
                  setState(() {
                    isDarkMode = value;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              setting_item(
                title: "Help",
                icon: CupertinoIcons.hand_draw,
                bgColor: Colors.red.shade100,
                iconColor: Colors.red,
                onTap: () {},
              )
            ],
          ),
        ));
  }
}
