import 'package:flutter/material.dart';
import 'package:jellytics/utils/secure_storage.dart';
import 'package:jellytics/views/activity/get_activity.dart';
import 'package:jellytics/utils/screens.dart';

class _ActivityDetailWidget extends StatefulWidget {
  const _ActivityDetailWidget();

  @override
  State<_ActivityDetailWidget> createState() => _ActivityDetailWidgetState();
}

class _ActivityDetailWidgetState extends State<_ActivityDetailWidget> {
  @override
  Widget build(BuildContext context) {
    return const Text("Activity Detail");
  }
}

const Widget activityContent = _ActivityDetailWidget();
