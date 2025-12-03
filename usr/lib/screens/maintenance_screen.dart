import 'package:flutter/material.dart';
import '../models/data_models.dart';

class MaintenanceScreen extends StatefulWidget {
  final Car car;
  const MaintenanceScreen({super.key, required this.car});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  // بيانات تجريبية لجدول الصيانة
  List<MaintenanceTask> tasks = [
    MaintenanceTask(id: '1', title: 'تغيير زيت المحرك', intervalKm: 5000, lastServicedKm: 145000),
    MaintenanceTask(id: '2', title: 'فلتر الزيت', intervalKm: 10000, lastServicedKm: 140000),
    MaintenanceTask(id: '3', title: 'فلتر الهواء', intervalKm: 20000, lastServicedKm: 130000),
    MaintenanceTask(id: '4', title: 'الإطارات (تدوير)', intervalKm: 10000, lastServicedKm: 142000),
    MaintenanceTask(id: '5', title: 'سائل الفرامل', intervalKm: 40000, lastServicedKm: 110000),
    MaintenanceTask(id: '6', title: 'البوجيهات (Spark Plugs)', intervalKm: 60000, lastServicedKm: 100000),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('جدول الصيانة'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          final status = task.getStatus(widget.car.currentMileage);
          final remaining = task.nextServiceKm - widget.car.currentMileage;
          final percent = task.getUsagePercentage(widget.car.currentMileage);

          Color statusColor;
          String statusText;
          
          switch (status) {
            case MaintenanceStatus.good:
              statusColor = Colors.green;
              statusText = 'حالة جيدة';
              break;
            case MaintenanceStatus.dueSoon:
              statusColor = Colors.orange;
              statusText = 'اقترب الموعد';
              break;
            case MaintenanceStatus.overdue:
              statusColor = Colors.red;
              statusText = 'تجاوز الموعد!';
              break;
          }

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        task.title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: statusColor),
                        ),
                        child: Text(
                          statusText,
                          style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: percent,
                    backgroundColor: Colors.grey[200],
                    color: statusColor,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('التالي: ${task.nextServiceKm} كم', style: TextStyle(color: Colors.grey[600])),
                      Text(
                        remaining < 0 
                          ? 'متأخر بـ ${remaining.abs()} كم' 
                          : 'متبقي ${remaining} كم',
                        style: TextStyle(
                          color: remaining < 0 ? Colors.red : Colors.grey[800],
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _showUpdateDialog(task);
                      },
                      icon: const Icon(Icons.build_circle_outlined),
                      label: const Text('تسجيل صيانة جديدة'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue[800],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showUpdateDialog(MaintenanceTask task) {
    final mileageController = TextEditingController(text: widget.car.currentMileage.toString());
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تسجيل ${task.title}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('أدخل قراءة العداد الحالية عند إجراء الصيانة:'),
            const SizedBox(height: 10),
            TextField(
              controller: mileageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'العداد (كم)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                int newMileage = int.tryParse(mileageController.text) ?? widget.car.currentMileage;
                task.lastServicedKm = newMileage;
                task.lastServicedDate = DateTime.now();
                // تحديث عداد السيارة أيضاً إذا كان الرقم الجديد أكبر
                if (newMileage > widget.car.currentMileage) {
                  widget.car.currentMileage = newMileage;
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم تحديث سجل الصيانة بنجاح')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[800], foregroundColor: Colors.white),
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }
}
