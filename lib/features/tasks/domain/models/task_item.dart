import 'package:flutter/material.dart';

class TaskItem {
  final String id;
  final String title;
  final String category;
  final String owner;
  final String duration;
  final String statusLabel;
  String status;
  final Color indicatorColor;
  final Color badgeColor;
  final Color badgeTextColor;
  final String requestDate;
  final String contractor;
  final String serialNumber;
  final String revisionNumber;
  final String currentTask;
  final String specialization;
  final String deliveryStatus;
  final String description;

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
    this.category = '',
    this.requestDate = '',
    this.contractor = '',
    this.serialNumber = '',
    this.revisionNumber = '',
    this.currentTask = '',
    this.specialization = '',
    this.deliveryStatus = '',
    this.description = '',
  });
}
