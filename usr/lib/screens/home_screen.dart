import 'package:flutter/material.dart';
import '../models/data_models.dart';
import 'maintenance_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // سيارة افتراضية للتجربة
  Car myCar = Car(
    id: '1',
    make: 'تويوتا',
    model: 'كامري',
    year: 2020,
    currentMileage: 148500,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('سيارتي'),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCarHeader(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'نظرة عامة',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildDashboardGrid(),
                  const SizedBox(height: 20),
                  _buildActionButtons(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.blue[900],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          const Icon(Icons.directions_car, size: 80, color: Colors.white),
          const SizedBox(height: 10),
          Text(
            '${myCar.make} ${myCar.model} ${myCar.year}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'العداد الحالي: ${myCar.currentMileage} كم',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton.icon(
            onPressed: _updateMileageDialog,
            icon: const Icon(Icons.edit, size: 18),
            label: const Text('تحديث العداد'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue[900],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDashboardGrid() {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            icon: Icons.timer,
            title: 'الصيانة القادمة',
            value: 'بعد 1500 كم',
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildInfoCard(
            icon: Icons.check_circle,
            title: 'حالة السيارة',
            value: 'جيدة',
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({required IconData icon, required String title, required String value, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        _buildMenuButton(
          context,
          title: 'جدول الصيانة الوقائية',
          subtitle: 'عرض مواعيد تغيير الزيت والفلاتر',
          icon: Icons.calendar_month,
          color: Colors.blue,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MaintenanceScreen(car: myCar)),
            ).then((_) => setState((){})); // Refresh on back
          },
        ),
        const SizedBox(height: 12),
        _buildMenuButton(
          context,
          title: 'سجل المصاريف',
          subtitle: 'تتبع تكاليف الوقود والإصلاحات',
          icon: Icons.attach_money,
          color: Colors.green,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('قريباً: ميزة تتبع المصاريف')),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildMenuButton(
          context,
          title: 'الإعدادات',
          subtitle: 'تعديل بيانات السيارة والتنبيهات',
          icon: Icons.settings,
          color: Colors.grey,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildMenuButton(BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  void _updateMileageDialog() {
    final controller = TextEditingController(text: myCar.currentMileage.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تحديث عداد الكيلومترات'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'العداد الحالي',
            suffixText: 'كم',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                myCar.currentMileage = int.tryParse(controller.text) ?? myCar.currentMileage;
              });
              Navigator.pop(context);
            },
            child: const Text('تحديث'),
          ),
        ],
      ),
    );
  }
}
