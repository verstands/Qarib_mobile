import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Politique de Confidentialité'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'سياسة الخصوصية لتطبيق QARIB',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 10),
            const Text(
              '1. جمع المعلومات الشخصية',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 5),
            const Text(
              'يقوم التطبيق بجمع المعلومات التالية من المستخدمين والمهنيين:\n\n'
              '1. الاسم الكامل.\n'
              '2. رقم الهاتف.\n'
              '3. الموقع الجغرافي (اختياري لتحديد المهنيين القريبين).\n'
              '4. أي معلومات إضافية تُقدم أثناء التسجيل أو استخدام التطبيق.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 10),
            const Text(
              'حالات مشاركة المعلومات:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 5),
            const Text(
              '1. لن تتم مشاركة المعلومات الشخصية مع أي طرف ثالث دون موافقة صريحة من المستخدم، إلا في الحالات التالية:\n'
              '- استجابة لطلب قانوني أو أمر قضائي من السلطات المغربية.\n'
              '- عندما يكون ذلك ضروريًا لضمان الأمن العام أو منع الأنشطة غير القانونية.\n\n'
              '2. يتم تقديم بعض البيانات الضرورية للمستخدمين والمهنيين (مثل الاسم ورقم الهاتف والموقع الجغرافي) عند التفاعل مع بعضهم لضمان تقديم الخدمة.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 10),
            const Text(
              '2. استخدام المعلومات',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 5),
            const Text(
              'تُستخدم المعلومات الشخصية التي يتم جمعها للأغراض التالية:\n\n'
              '1. تحسين تجربة المستخدم على التطبيق.\n'
              '2. عرض المهنيين القريبين من الموقع الجغرافي للمستخدم.\n'
              '3. تسهيل الاتصال بين المستخدمين والمهنيين.\n'
              '4. إرسال إشعارات وتنبيهات متعلقة بالخدمات.\n\n'
              'يتم استخدام البيانات بطرق آمنة ومتوافقة مع القوانين المغربية لحماية خصوصية المستخدمين.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 10),
            const Text(
              '3. حماية البيانات',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 5),
            const Text(
              'يلتزم التطبيق باتخاذ جميع التدابير التقنية والتنظيمية المناسبة لحماية البيانات الشخصية من:\n\n'
              '1. الوصول غير المصرح به.\n'
              '2. الضياع أو التلف أو التسريب.\n\n'
              'مسؤولية المستخدم:\n\n'
              '1. الحفاظ على سرية بيانات تسجيل الدخول (اسم المستخدم وكلمة المرور).\n'
              '2. الإبلاغ الفوري في حالة الاشتباه بأي نشاط غير عادي على الحساب.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 10),
            const Text(
              '4. حقوق المستخدمين',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 5),
            const Text(
              'حق التعديل أو الحذف:\n'
              'يحق للمستخدمين طلب تعديل أو حذف بياناتهم الشخصية في أي وقت من خلال التواصل مع فريق الدعم الفني.\n\n'
              'حق الاطلاع:\n'
              'يمكن للمستخدمين طلب نسخة من بياناتهم المحفوظة على التطبيق.\n\n'
              'حق الاعتراض:\n'
              'يحق للمستخدمين الاعتراض على استخدام بياناتهم لأغراض غير مصرح بها.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 10),
            const Text(
              '5. التحديثات على سياسة الخصوصية',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 5),
            const Text(
              'يحتفظ التطبيق بالحق في تعديل سياسة الخصوصية في أي وقت.\n'
              'سيتم إخطار المستخدمين بالتعديلات عبر إشعار داخل التطبيق أو رسالة إلكترونية.\n'
              'يُنصح المستخدمون بمراجعة السياسة بشكل دوري للتأكد من فهمهم لأي تغييرات.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 10),
            const Text(
              '6. التواصل',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 5),
            const Text(
              'يمكن للمستخدمين التواصل مع فريق الدعم الفني للاستفسارات المتعلقة بسياسة الخصوصية عبر الوسائل التالية:\n\n'
              '- قسم "الاتصال بنا" داخل التطبيق.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 20),
            const Divider(),
            SizedBox(height: 10),
            const Text(
              'Politique de confidentialité de l\'application QARIB',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 10),
            const Text(
              '1. Collecte des informations personnelles',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 5),
            const Text(
              'L\'application collecte les informations suivantes :\n\n'
              '1. Nom complet.\n'
              '2. Numéro de téléphone.\n'
              '3. Localisation géographique (optionnelle pour afficher les professionnels à proximité).\n'
              '4. Toute information supplémentaire fournie lors de l\'inscription ou de l\'utilisation de l\'application.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
