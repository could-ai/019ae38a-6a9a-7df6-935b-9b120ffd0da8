class Car {
  final String id;
  final String make; // الشركة المصنعة (تويوتا، فورد...)
  final String model; // الموديل (كامري، موستانج...)
  final int year; // سنة الصنع
  int currentMileage; // العداد الحالي بالكيلومتر

  Car({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.currentMileage,
  });
}

class MaintenanceTask {
  final String id;
  final String title; // اسم الصيانة (تغيير زيت، فلاتر...)
  final int intervalKm; // يتكرر كل كم كيلومتر
  int lastServicedKm; // آخر مرة تم عمل الصيانة عند الكيلومتر
  DateTime? lastServicedDate; // تاريخ آخر صيانة

  MaintenanceTask({
    required this.id,
    required this.title,
    required this.intervalKm,
    required this.lastServicedKm,
    this.lastServicedDate,
  });

  // حساب متى موعد الصيانة القادم
  int get nextServiceKm => lastServicedKm + intervalKm;
  
  // حساب النسبة المئوية للاستهلاك
  double getUsagePercentage(int currentCarMileage) {
    if (currentCarMileage < lastServicedKm) return 0.0;
    int driven = currentCarMileage - lastServicedKm;
    double percent = driven / intervalKm;
    return percent > 1.0 ? 1.0 : percent;
  }

  // حالة الصيانة
  MaintenanceStatus getStatus(int currentCarMileage) {
    int remaining = nextServiceKm - currentCarMileage;
    if (remaining < 0) return MaintenanceStatus.overdue;
    if (remaining < 1000) return MaintenanceStatus.dueSoon;
    return MaintenanceStatus.good;
  }
}

enum MaintenanceStatus {
  good,     // حالة جيدة
  dueSoon,  // اقترب الموعد
  overdue   // تجاوز الموعد
}
