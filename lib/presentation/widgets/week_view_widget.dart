import 'package:flutter/material.dart';
//
import 'package:calendar_view/calendar_view.dart';
import 'package:schedule_when/model/event.dart';
import 'package:schedule_when/presentation/pages/update_event.dart';
import 'package:schedule_when/presentation/screens/main_screen.dart';
import 'package:schedule_when/services/locator.dart';
import 'package:schedule_when/services/navigation_service.dart';

class WeekViewWidget extends StatelessWidget {
  final GlobalKey<WeekViewState>? state;
  final double? width;
  final int clockStart;
  final int clockEnd;
  final bool showLiveTimeLineInAllDays;
  final EventController<Event> eventController;
  final NavigationService _navigationService = locator<NavigationService>();
  //GetIt.instance<NavigationService>()

  WeekViewWidget(
      {Key? key,
      required this.eventController,
      this.clockStart = 0,
      this.clockEnd = 24,
      this.showLiveTimeLineInAllDays = false,
      this.state,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WeekView<Event>(
      key: state,
      width: width,
      //backgroundColor: DefalutTheme.viewBGColor,
      showLiveTimeLineInAllDays: showLiveTimeLineInAllDays, //顯示當下時間線
      controller: eventController,
      timeLineBuilder: _timelineBuilder,
      eventTileBuilder: _eventTileBuilder,
      timeLineOffset: (clockStart) * 60 - 10,
      clockStart: clockStart,
      clockEnd: clockEnd,
      onEventTap: _onEventTileTap,
    );
  }

  /// 左側時間軸線建置器.
  Widget _timelineBuilder(DateTime date) {
    return Transform.translate(
      offset: const Offset(0, -7.5),
      child: Padding(
        padding: const EdgeInsets.only(right: 0.0),
        child: Text(
          "${((date.hour - 1) % 12) + 1} ${date.hour ~/ 12 == 0 ? "am" : "pm"}",
          textAlign: TextAlign.right,
          style: const TextStyle(
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }

  /// 事件方塊建置器.(不使用預設事件方塊建置器)
  Widget _eventTileBuilder<T>(DateTime date, List<CalendarEventData<T>> events,
      Rect boundary, DateTime startDuration, DateTime endDuration) {
    if (events.isNotEmpty) {
      return RoundedEventTile(
        borderRadius: BorderRadius.circular(0.0),
        title: events[0].title,
        titleStyle: TextStyle(
          fontSize: 12,
          color: events[0].color.accent,
        ),
        totalEvents: events.length,
        padding: const EdgeInsets.all(0.0),
        margin:
            const EdgeInsets.fromLTRB(0, 0, 0, 0), // Tile周邊保留區(左, 右) //右邊沒啥作用勒.
        backgroundColor: events[0].color,
        //backgroundColor: Colors.grey,
      );
    } else {
      return Container();
    }
  }

  Future<void> _onEventTileTap<T>(
      List<CalendarEventData<Event>> events, DateTime date) async {
    ///
    // debugPrint("Tapped event: $events");

    ///
    await _navigationService.push(UpdateEventPage(events: events, date: date));
    // debugPrint("event after update : $event");
    _navigationService.push(MainScreen(currentIndex: 0));
  }
}
