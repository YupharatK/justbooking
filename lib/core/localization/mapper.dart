import 'package:flutter/widgets.dart';
import 'localization_extension.dart';

class DataMapper {
  /// แปลงชื่อสิ่งอำนวยความสะดวกจาก Database เป็นภาษาปัจจุบัน
  static String getFacilityName(BuildContext context, String facility) {
    switch (facility.trim()) {
      case 'Wi-Fi':
      case 'WiFi':
      case 'wifi':
        return context.l10n.facilityWifi;
      case 'เครื่องทำน้ำอุ่น':
      case 'Water Heater':
        return context.l10n.facilityWaterHeater;
      case 'ระเบียง':
      case 'Balcony':
        return context.l10n.facilityBalcony;
      case 'ทีวี':
      case 'TV':
      case 'tv':
        return context.l10n.facilityTv;
      case 'แอร์':
      case 'Air conditioning':
      case 'AC':
        return context.l10n.addRoomAc;
      case 'พัดลม':
      case 'Fan':
        return context.l10n.addRoomFan;
      default:
        return facility; // fallback to original DB string if not mapped
    }
  }

  /// แปลงประเภทเตียงจาก Database เป็นภาษาปัจจุบัน
  static String getBedTypeName(BuildContext context, String bedType) {
    switch (bedType.trim()) {
      case 'เตียงเดี่ยว':
      case 'Single Bed':
        return context.l10n.addRoomSingleBed;
      case 'เตียงคู่':
      case 'Double Bed':
        return context.l10n.addRoomDoubleBed;
      default:
        return bedType;
    }
  }

  /// แปลงประเภทหอพัก
  static String getDormTypeName(BuildContext context, String dormType) {
    switch (dormType.trim()) {
      case 'หอพักรวม':
      case 'Mixed Dormitory':
        return context.l10n.addDormTypeMixed;
      case 'หอพักชาย':
      case 'Male Dormitory':
        return context.l10n.addDormTypeMale;
      case 'หอพักหญิง':
      case 'Female Dormitory':
        return context.l10n.addDormTypeFemale;
      default:
        return dormType;
    }
  }
}
