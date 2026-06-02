import 'package:flutter/material.dart';

class TaskItem {
  final String id;
  final String title;
  final String owner;
  final String duration;
  final String statusLabel;
  String status;
  final Color indicatorColor;
  final Color badgeColor;
  final Color badgeTextColor;
  final bool hasImage;

  TaskItem({
    required this.id,
    required this.title,
    required this.owner,
    required this.duration,
    required this.statusLabel,
    required this.status,
    required this.indicatorColor,
    required this.badgeColor,
    required this.badgeTextColor,
    this.hasImage = false,
  });
}
