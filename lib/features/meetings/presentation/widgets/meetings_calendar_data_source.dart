import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../data/models/meeting_models.dart';

class MeetingAppointment extends Appointment {
  MeetingAppointment({
    required this.meeting,
    required super.startTime,
    required super.endTime,
    required super.subject,
    super.color,
    super.notes,
  });

  final MeetingItem meeting;
}

class MeetingsCalendarDataSource extends CalendarDataSource {
  MeetingsCalendarDataSource(List<MeetingItem> meetings) {
    appointments = meetings
        .map(
          (meeting) => MeetingAppointment(
            meeting: meeting,
            startTime: meeting.startDate,
            endTime: meeting.endDate,
            subject: meeting.title,
            color: const Color(0xFFE91E8C),
            notes: meeting.presenter,
          ),
        )
        .toList();
  }
}
