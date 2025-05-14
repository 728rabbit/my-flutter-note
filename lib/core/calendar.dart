/*
  Map<String, List<Map<String, String>>> _events = {};
  DateTime _focusedMonth = DateTime.now();
  DateTime _currentDate = DateTime.now();

  Future<Map<String, List<Map<String, String>>>> fetchEvents(DateTime newMonth) async {
    // Simulate delay
    await Future.delayed(const Duration(seconds: 1));

    // Simulate the data returned from the API
    if(newMonth.month.toInt() == 5) {
      return {
        '2025-05-14': [
          {
            'title': '看牙醫',
            'description': '下午 3 點在尖沙咀診所',
          }
        ],
        '2025-05-20': [
          {
            'title': '會議',
            'description': '與客戶會議，Zoom ID: 123-456-789',
          },
          {
            'title': '晚餐',
            'description': '與朋友晚餐，在銅鑼灣某餐廳',
          }
        ]
      };
    }
    else if(newMonth.month.toInt() == 6) {
      return {
        '2025-06-01': [
          {
            'title': '旅行',
            'description': '去日本旅行，早上 8 點機',
          }
        ]
      };
    }
    else {
      return {};
    }
  }

  @override
  void initState() {
    super.initState();
    _loadEvents(_focusedMonth);
  }

  Future<void> _loadEvents(DateTime newMonth) async {
    final data = await fetchEvents(newMonth);
    setState(() {
      _events = data;
    });
  }


  @override
  Widget build(BuildContext context) {
    final dateKey = '${_currentDate.year.toString().padLeft(4, '0')}-'
                '${_currentDate.month.toString().padLeft(2, '0')}-'
                '${_currentDate.day.toString().padLeft(2, '0')}'; 
    final todayEvents = _events[dateKey] ?? [];

    ....

    CalendarWidget(
      focusedMonth: _focusedMonth,
      events: _events,
      showLang: 'zh',
      onMonthChanged: (newMonth) {
        setState(() {
          _focusedMonth = newMonth;
        });
        _loadEvents(newMonth);
      },
      onDateSelected: (date) {
        setState(() {
          _currentDate = date;
        });
      },
    ),
    ...[
      const SizedBox(height: 20),
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '${_currentDate.year.toString().padLeft(4, '0')}年${_currentDate.month.toString().padLeft(2, '0')}月${_currentDate.day.toString().padLeft(2, '0')}日',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Divider(),
          if(todayEvents.isEmpty)...[
            const Text('No events today', style: TextStyle(color: Colors.grey))
          ],
          ...todayEvents.map((event) => ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(event['title'] ?? ''),
            subtitle: Text(event['description'] ?? ''),
            onTap: () {
              print(event);
            },
          )),
        ],
      )
    ],
  }
*/
import 'package:flutter/material.dart';

class CalendarWidget extends StatefulWidget {
  final DateTime focusedMonth;
  final Map<String, List<Map<String, String>>> events;
  final void Function(DateTime)? onDateSelected;
  final void Function(DateTime)? onMonthChanged;
  final String? showLang;

  const CalendarWidget({
    super.key,
    required this.focusedMonth,
    required this.events,
    this.onDateSelected,
    this.onMonthChanged,
    this.showLang = 'en',
  });

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final startOfMonth = DateTime(widget.focusedMonth.year, widget.focusedMonth.month, 1);
    final weekdayOffset = (startOfMonth.weekday % 7);
    final daysInMonth = DateTime(widget.focusedMonth.year, widget.focusedMonth.month + 1, 0).day;

    final weekLabels = widget.showLang == 'zh'
        ? ['日', '一', '二', '三', '四', '五', '六']
        : ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Column(
      children: [
        Container(
          color: Colors.blue,
          height: 48,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.white),
                onPressed: () {
                  final newMonth = DateTime(widget.focusedMonth.year, widget.focusedMonth.month - 1);
                  widget.onMonthChanged?.call(newMonth);
                }
              ),
              Text(
                (widget.showLang == 'zh')
                    ? ('${widget.focusedMonth.year.toString().padLeft(2, '0')}年${widget.focusedMonth.month.toString().padLeft(2, '0')}月')
                    : ('${widget.focusedMonth.month.toString().padLeft(2, '0')} / ${widget.focusedMonth.year.toString().padLeft(2, '0')}'),
                style: const TextStyle(color: Colors.white, fontSize: 18)
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: Colors.white),
                onPressed: () {
                  final newMonth = DateTime(widget.focusedMonth.year, widget.focusedMonth.month + 1);
                  widget.onMonthChanged?.call(newMonth);
                },
              )
            ]
          )
        ),
        Table(
          border: TableBorder.all(color: Colors.grey.shade400, width: 0.5),
          children: [
            TableRow(
              children: weekLabels
                  .map(
                    (label) => Container(
                      height: 40,
                      alignment: Alignment.center,
                      color: Colors.blue.shade50,
                      child: Text(
                        label,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    )
                  )
                  .toList()
            ),
            ..._buildCalendarRows(
              startOffset: weekdayOffset,
              daysInMonth: daysInMonth,
              today: today
            )
          ]
        )
      ]
    );
  }

  List<TableRow> _buildCalendarRows({
    required int startOffset,
    required int daysInMonth,
    required DateTime today,
  }) {
    List<TableRow> rows = [];
    List<Widget> cells = [];
    int dayCounter = 1 - startOffset;

    while (dayCounter <= daysInMonth) {
      for (int i = 0; i < 7; i++) {
        if (dayCounter < 1 || dayCounter > daysInMonth) {
          cells.add(Container(height: 40));
        } else {
          final date = DateTime(widget.focusedMonth.year, widget.focusedMonth.month, dayCounter);
          final key = _formatDateKey(date);
          final hasEvent = widget.events[key]?.isNotEmpty ?? false;

          final isToday = _isSameDay(date, today);
          final isSelected = _isSameDay(date, _selectedDate);

          cells.add(
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDate = date;
                });
                widget.onDateSelected?.call(date);
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.blue.shade50
                      : hasEvent
                          ? Colors.orange.shade50
                          : null
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dayCounter.toString(),
                      style: TextStyle(
                        fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                        color: isToday ? Colors.blue : Colors.black87,
                      ),
                    ),
                    if (hasEvent)...[
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Icon(Icons.circle, size: 6, color: Colors.red),
                      )
                    ]
                  ]
                )
              )
            )
          );
        }
        dayCounter++;
      }
      rows.add(TableRow(children: [...cells]));
      cells.clear();
    }

    return rows;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}