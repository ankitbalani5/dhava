// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:table_calendar/table_calendar.dart';
//
// class ProgressScreen extends StatefulWidget {
//   const ProgressScreen({super.key});
//
//   @override
//   State<ProgressScreen> createState() => _ProgressScreenState();
// }
//
// class _ProgressScreenState extends State<ProgressScreen> {
//   int selectedTab = 0; // 0: Today, 1: Weekly, ...
//   final List<String> tabs = ['Today', 'Weekly', 'Monthly', 'Yearly'];
//   final List<String> activities = ['Walk', 'Run', 'Cycle'];
//   List<bool> selectedActivities = [true, true, true];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: const Text("Progress History"),
//         backgroundColor: Colors.black,
//         actions: [
//           IconButton(icon: Icon(Icons.search), onPressed: () {}),
//           CircleAvatar(radius: 16, backgroundColor: Colors.grey[300]),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // 🔘 Tabs (Today, Weekly, etc.)
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: List.generate(tabs.length, (index) {
//                   return ChoiceChip(
//                     label: Text(tabs[index]),
//                     selected: selectedTab == index,
//                     onSelected: (_) => setState(() => selectedTab = index),
//                     selectedColor: Colors.red,
//                     backgroundColor: Colors.white24,
//                     labelStyle: const TextStyle(color: Colors.white),
//                   );
//                 }),
//               ),
//               const SizedBox(height: 16),
//
//               // 🚴‍♀️ Filter Chips
//               Wrap(
//                 spacing: 10,
//                 children: List.generate(activities.length, (index) {
//                   return FilterChip(
//                     label: Text(activities[index]),
//                     selected: selectedActivities[index],
//                     onSelected: (value) => setState(() {
//                       selectedActivities[index] = value;
//                     }),
//                     selectedColor: Colors.red,
//                     backgroundColor: Colors.white24,
//                     labelStyle: const TextStyle(color: Colors.white),
//                   );
//                 }),
//               ),
//
//               const SizedBox(height: 16),
//
//               // 📊 Line Chart (dummy)
//               Container(
//                 height: 200,
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.white12,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: LineChart(
//                   LineChartData(
//                     lineBarsData: [
//                       LineChartBarData(
//                         isCurved: true,
//                         spots: List.generate(7, (i) => FlSpot(i.toDouble(), (i + 1).toDouble())),
//                         // colors: [Colors.red],
//                         color: Colors.red,
//                         // gradient: LinearGradient(colors: [Colors.red, Colors.transparent]),
//                         barWidth: 2,
//                       )
//                     ],
//                     titlesData: FlTitlesData(show: false),
//                     gridData: FlGridData(show: false),
//                     borderData: FlBorderData(show: false),
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 16),
//
//               // 🔴 Button
//               Center(
//                 child: ElevatedButton(
//                   onPressed: () {},
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red,
//                     padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//                   ),
//                   child: const Text("See More Of Your Progress"),
//                 ),
//               ),
//
//               const SizedBox(height: 16),
//
//               // 📆 Calendar Section
//               Text("July 2025", style: TextStyle(color: Colors.white, fontSize: 18)),
//               const SizedBox(height: 8),
//
//               TableCalendar(
//                 firstDay: DateTime.utc(2020, 1, 1),
//                 lastDay: DateTime.utc(2030, 12, 31),
//                 focusedDay: DateTime.now(),
//                 headerVisible: false,
//                 calendarFormat: CalendarFormat.month,
//                 calendarStyle: CalendarStyle(
//                   todayDecoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
//                   selectedDecoration: BoxDecoration(color: Colors.white30, shape: BoxShape.circle),
//                   weekendTextStyle: TextStyle(color: Colors.grey),
//                   defaultTextStyle: TextStyle(color: Colors.white),
//                 ),
//                 daysOfWeekStyle: DaysOfWeekStyle(
//                   weekdayStyle: TextStyle(color: Colors.white70),
//                   weekendStyle: TextStyle(color: Colors.white70),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:table_calendar/table_calendar.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  int selectedTab = 0;
  final List<String> tabs = ['Today', 'Weekly', 'Monthly', 'Yearly'];
  final List<String> activities = ['Walk', 'Run', 'Cycle'];
  List<bool> selectedActivities = [true, true, true];
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Progress History", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: () {}),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: CircleAvatar(radius: 16, backgroundColor: Colors.white24),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(tabs.length, (index) {
                  return ChoiceChip(
                    label: Text(tabs[index]),
                    selected: selectedTab == index,
                    onSelected: (_) => setState(() => selectedTab = index),
                    selectedColor: Colors.red,
                    backgroundColor: Colors.white24,
                    labelStyle: const TextStyle(color: Colors.white),
                  );
                }),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                children: List.generate(activities.length, (index) {
                  return FilterChip(
                    label: Text(activities[index]),
                    selected: selectedActivities[index],
                    onSelected: (value) => setState(() {
                      selectedActivities[index] = value;
                    }),
                    selectedColor: Colors.red,
                    backgroundColor: Colors.white24,
                    labelStyle: const TextStyle(color: Colors.white),
                  );
                }),
              ),
              const SizedBox(height: 16),
              Container(
                height: 200,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        spots: List.generate(7, (i) => FlSpot(i.toDouble(), (i + 1).toDouble())),
                        color: Colors.red,
                        barWidth: 2,
                      )
                    ],
                    titlesData: FlTitlesData(show: false),
                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text("See More Of Your Progress", style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
              const Text("July 2025", style: TextStyle(color: Colors.white, fontSize: 18)),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white12,
                  gradient: LinearGradient(colors: [Colors.red, Colors.red, Colors.red, Colors.red, Colors.transparent], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: DateTime.now(),
                  headerVisible: false,
                  calendarFormat: CalendarFormat.month,
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    selectedDecoration: BoxDecoration(color: Colors.white30, shape: BoxShape.circle),
                    weekendTextStyle: TextStyle(color: Colors.grey),
                    defaultTextStyle: TextStyle(color: Colors.white),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(color: Colors.white70),
                    weekendStyle: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white12,
                  gradient: LinearGradient(colors: [Colors.red, Colors.transparent]),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(16),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: focusedDay,
                  selectedDayPredicate: (day) => isSameDay(selectedDay, day),
                  onDaySelected: (selected, focused) {
                    setState(() {
                      selectedDay = selected;
                      focusedDay = focused;
                    });
                  },
                  headerVisible: false,
                  calendarFormat: CalendarFormat.month,
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    defaultTextStyle: const TextStyle(color: Colors.white),
                    weekendTextStyle: const TextStyle(color: Colors.white60),
                    selectedTextStyle: const TextStyle(color: Colors.white),
                    todayTextStyle: const TextStyle(color: Colors.white),
                    outsideDaysVisible: false,
                  ),
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(color: Colors.grey),
                    weekendStyle: TextStyle(color: Colors.grey),
                  ),
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, date, events) {
                      if (date.day % 3 == 0) {
                        return Positioned(
                          bottom: 4,
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
