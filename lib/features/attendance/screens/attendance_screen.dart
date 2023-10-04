import 'package:sectec30/features/attendance/data/models/calendar_attendances.dart';
import 'package:sectec30/features/attendance/providers/attendance_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../profile/providers/profile_provider.dart';

class AttendanceScreen extends ConsumerStatefulWidget {
  const AttendanceScreen({super.key});

  @override
  AttendanceScreenState createState() => AttendanceScreenState();
}

class AttendanceScreenState extends ConsumerState<AttendanceScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final kToday = DateTime.now();

  List<CalendarAttendance> _calendarAttendances = [];

  @override
  void initState() {
    super.initState();
    _loadCalendarAttendances();
  }

  Future<void> _loadCalendarAttendances() async {
    try {
      final register = ref.read(profileProvider);

      final repository = ref.read(attendanceRepositoryProvider);
      final idBio = register.idbio; // Reemplaza con el ID correcto
      final calendarAttendances = await repository.getCalendar(idBio);

      setState(() {
        _calendarAttendances = calendarAttendances;
      });
      calendarAttendances
          .map((day) => {print('${day.entrada}  ${day.salida}')});
    } catch (e) {
      print(e);
      // Maneja los errores de carga de datos aquí
    }
  }

  @override
  Widget build(BuildContext context) {
    final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
    final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
    return Scaffold(
      appBar: AppBar(
        title: Text('Accesos'),
      ),
      body: Column(
        children: [
          TableCalendar<ListTile>(
            eventLoader: (day) {
              final eventsForDay = _calendarAttendances
                  .where((event) => isSameDay(event.fecha, day))
                  .toList();

              return eventsForDay.map((event) {
                return ListTile(
                  title: Text(event.entrada
                      .toIso8601String()), // Puedes personalizar esto
                  /* subtitle: Text(event.salida
                      .toIso8601String()), // Puedes personalizar esto */
                );
              }).toList();
            },
            locale: 'es-ES',
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              // Use `selectedDayPredicate` to determine which day is currently selected.
              // If this returns true, then `day` will be marked as selected.

              // Using `isSameDay` is recommended to disregard
              // the time-part of compared DateTime objects.
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                // Call `setState()` when updating the selected day
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                // Call `setState()` when updating calendar format
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              // No need to call `setState()` here
              _focusedDay = focusedDay;
            },
          ),
          Expanded(
            child: _selectedDay != null
                ? ListView.builder(
                    itemCount: _calendarAttendances.length,
                    itemBuilder: (context, index) {
                      final attendance = _calendarAttendances[index];
                      if (isSameDay(attendance.fecha, _selectedDay!)) {
                        return Column(
                          children: [
                            Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 4.0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.green.shade600),
                                    borderRadius: BorderRadius.circular(12)),
                                child: ListTile(
                                  title: Text(
                                      'Entrada: ${attendance.entrada.toString().split(' ')[1].substring(0, 8)}'),
                                )),
                            attendance.salida == null
                                ? Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 4.0),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.red.shade600),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: const ListTile(
                                      title: Text('SIN REGISTRO'),
                                    ))
                                : Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 4.0),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.green.shade600),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: ListTile(
                                      title: Text(
                                          'Salida: ${attendance.salida.toString().split(' ')[1].substring(0, 8)}'),
                                    )),
                          ],
                        );
                      }
                      return SizedBox.shrink();
                    },
                  )
                : const Center(
                    child: Text('Selecciona un día en el calendario'),
                  ),
          ),
        ],
      ),
    );
  }
}
