import 'package:flutter/material.dart';
import 'package:untitled/models/account.dart';
import 'package:untitled/models/message.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:another_telephony/telephony.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key, required this.account});
  final Account account;

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final Telephony telephony = Telephony.instance;

  @override
  void initState() {
    super.initState();
    requestSmsPermission();
  }

  Future<void> requestSmsPermission() async {
    if (await Permission.sms.request().isGranted) {
      print("SMS Permission Granted");
    } else {
      print("SMS Permission Denied");
    }
  }

  void sendSms() async {
    bool? permissionsGranted = await telephony.requestSmsPermissions;
    if (permissionsGranted ?? false) {
      telephony.sendSms(
        to: "+447446433734",
        message: "Hello from Flutter!",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("SMS Advanced Example")),
        body: Column(
          children: [
            ElevatedButton(
              onPressed: sendSms,
              child: Text("Send SMS"),
            ),
          ],
        ),
      ),
    );
  }
}
