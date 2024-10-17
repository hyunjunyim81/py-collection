import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends StatefulWidget {
  CalendarView({super.key});

  @override
  State createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  // 초기 선택 날짜를 현재 날짜로 설정
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TableCalendar(
        // 캘린더에서 날짜가 선택될때 이벤트
          onDaySelected: onDaySelected,
          // 특정 날짜가 선택된 날짜와 동일한지 여부 판단
          selectedDayPredicate: (date) {
            return isSameDay(selectedDate, date);
          },
          focusedDay: selectedDate,
          firstDay: DateTime(2020),
          lastDay: DateTime(2030),
      ),
    );
  }

  // 달력에서 날짜가 선택됐을 때 호출되는 콜백 함수
  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;
    });
  }
}