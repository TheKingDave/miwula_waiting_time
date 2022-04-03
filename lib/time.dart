class Time {
  final int hour;
  final int minute;

  Time(this.hour, this.minute);
  
  factory Time.parse(String str) {
    final split = str.split(':');
    if(split.length != 2) {
      throw ArgumentError.value(str, 'str', 'Doest not contain ONE ":"');
    }
    return Time(int.parse(split[0]), int.parse(split[1]));
  }
  
  bool isAfter(Time time) {
    return time.hour < hour || (time.hour == hour && time.minute < minute); 
  }
  
  bool isBefore(Time time) {
    return time.hour > hour || (time.hour == hour && time.minute > minute);
  }
  
  bool isInBetween(Time start, Time end) {
    return isAfter(start) && isBefore(end);
  }

  @override
  String toString() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}