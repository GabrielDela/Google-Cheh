import 'package:objectbox/objectbox.dart';

@Entity()
class PointInfo {
  int id;
  String? const_id;
  double? x;
  double? y;
  String? date;
  String? hour;

  PointInfo({ this.id = 0 , double? pX, double? pY, String? pDate, String? pHour}){
    const_id = "id_" + pX.toString() + "_" + pY.toString();
    x = pX;
    y = pY;
    date = pDate;
    hour = pHour;
  }
}
