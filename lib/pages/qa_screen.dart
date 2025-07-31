import 'package:flutter/material.dart';

class QAScreen extends StatefulWidget {
  const QAScreen({Key? key}) : super(key: key);

  @override
  _QAScreenState createState() => _QAScreenState();
}

class _QAScreenState extends State<QAScreen> {
  final Color primaryColor = const Color(0xFF224B45);
  final List<FAQItem> _faqItems = [
    FAQItem(
      category: 'การนวด',
      question: 'การนวดแต่ละประเภทแตกต่างกันอย่างไร?',
      answer:
          'การนวดไทย: เน้นการยืดเส้น กดจุด ปรับโครงสร้างร่างกายและกระตุ้นการไหลเวียนของพลังงานในร่างกาย\n\nการนวดน้ำมัน: เน้นการนวดด้วยน้ำมันหอมระเหยเพื่อผ่อนคลายกล้ามเนื้อและความเครียด ช่วยบำรุงผิวและกระตุ้นระบบไหลเวียนโลหิต\n\nการนวดกดจุด: เน้นการกดจุดตามเส้นพลังงานในร่างกาย ช่วยปรับสมดุลและบรรเทาอาการปวดเมื่อย',
      icon: Icons.spa,
    ),
    FAQItem(
      category: 'การนวด',
      question: 'ควรนวดบ่อยแค่ไหน?',
      answer:
          'ขึ้นอยู่กับวัตถุประสงค์ของการนวด:\n\n• เพื่อการผ่อนคลาย: 1-2 ครั้งต่อเดือน\n• เพื่อการรักษา: สัปดาห์ละ 1-2 ครั้ง ตามคำแนะนำของผู้เชี่ยวชาญ\n• เพื่อการฟื้นฟู: 2-3 ครั้งต่อสัปดาห์ในช่วงแรก แล้วค่อยๆ ลดความถี่ลง\n\nทั้งนี้ควรปรึกษาหมอนวดผู้เชี่ยวชาญเพื่อวางแผนการนวดที่เหมาะสมกับสภาพร่างกายของแต่ละบุคคล',
      icon: Icons.schedule,
    ),
    FAQItem(
      category: 'การนวด',
      question: 'การนวดแต่ละครั้งใช้เวลานานเท่าไร?',
      answer:
          'การนวดมีหลายตัวเลือกระยะเวลา ขึ้นอยู่กับความต้องการและเวลาที่มี:\n\n• นวดเร่งด่วน: 30 นาที - เน้นเฉพาะจุด เช่น ไหล่ คอ หลัง\n• นวดมาตรฐาน: 60 นาที - ครอบคลุมทั่วร่างกาย เหมาะสำหรับการผ่อนคลายทั่วไป\n• นวดพรีเมียม: 90-120 นาที - การนวดแบบเต็มรูปแบบพร้อมทรีทเมนต์พิเศษ\n\nระยะเวลาที่แนะนำสำหรับการนวดครั้งแรกคือ 60-90 นาที เพื่อให้หมอนวดได้ประเมินสภาพร่างกายและปรับการนวดให้เหมาะสม',
      icon: Icons.hourglass_bottom,
    ),
    FAQItem(
      category: 'การนวด',
      question: 'การเตรียมตัวก่อนการนวดควรทำอย่างไร?',
      answer:
          'เพื่อให้ได้ประโยชน์สูงสุดจากการนวด ควรเตรียมตัวดังนี้:\n\n• ดื่มน้ำให้เพียงพอก่อนและหลังการนวด\n• หลีกเลี่ยงการรับประทานอาหารหนัก 1-2 ชั่วโมงก่อนการนวด\n• แจ้งหมอนวดหากมีอาการบาดเจ็บหรือโรคประจำตัว\n• อาบน้ำก่อนการนวดเพื่อความสะอาด\n• มาถึงก่อนเวลานัดหมาย 10-15 นาที เพื่อกรอกประวัติและพักผ่อน\n• สวมใส่เสื้อผ้าที่สบายและถอดเครื่องประดับออก',
      icon: Icons.check_circle_outline,
    ),
    FAQItem(
      category: 'การนวด',
      question: 'ควรปฏิบัติตัวอย่างไรหลังการนวด?',
      answer:
          'หลังการนวด ควรปฏิบัติตัวดังนี้เพื่อให้ได้ประโยชน์สูงสุด:\n\n• ดื่มน้ำมากๆ เพื่อช่วยขับสารพิษออกจากร่างกาย\n• หลีกเลี่ยงการออกกำลังกายหนักหรือกิจกรรมที่เครียดอย่างน้อย 12 ชั่วโมง\n• อาบน้ำอุ่นเพื่อช่วยคลายกล้ามเนื้อ\n• พักผ่อนให้เพียงพอในคืนนั้น\n• สังเกตอาการผิดปกติและแจ้งหมอนวดหากมีอาการปวดหรือระคายเคืองผิดปกติ',
      icon: Icons.healing,
    ),
    FAQItem(
      category: 'สุขภาพ',
      question: 'มีข้อห้ามในการนวดหรือไม่?',
      answer:
          'มีข้อห้ามในการนวดดังนี้:\n\n• มีไข้สูงหรือการติดเชื้อ\n• มีอาการอักเสบเฉียบพลัน หรือปวดรุนแรง\n• มีบาดแผลเปิดหรือแผลไหม้\n• มีโรคผิวหนังติดต่อ\n• ตั้งครรภ์ในช่วง 3 เดือนแรก\n• มีภาวะลิ่มเลือดอุดตัน\n• มีกระดูกหัก หรือกระดูกร้าว\n• เพิ่งผ่าตัดมาไม่เกิน 6 สัปดาห์\n• มีโรคหัวใจรุนแรง\n• อยู่ภายใต้อิทธิพลของแอลกอฮอล์หรือยาเสพติด\n\nหากมีโรคประจำตัวหรือข้อกังวลด้านสุขภาพ ควรปรึกษาแพทย์ก่อนรับบริการนวด',
      icon: Icons.medical_services,
    ),
    FAQItem(
      category: 'สุขภาพ',
      question: 'การนวดช่วยบรรเทาอาการปวดหลังได้จริงหรือไม่?',
      answer:
          'การนวดสามารถช่วยบรรเทาอาการปวดหลังได้จริง โดยมีประโยชน์ดังนี้:\n\n• ช่วยคลายกล้ามเนื้อที่ตึงเครียด\n• เพิ่มการไหลเวียนของเลือดไปยังบริเวณที่ปวด\n• ลดการอักเสบของเนื้อเยื่อ\n• กระตุ้นการผลิตสารเอนดอร์ฟินซึ่งเป็นสารบรรเทาปวดตามธรรมชาติ\n• ปรับปรุงความยืดหยุ่นและช่วงการเคลื่อนไหว\n\nการศึกษาทางการแพทย์หลายชิ้นพบว่าการนวดเป็นวิธีบำบัดที่มีประสิทธิภาพสำหรับอาการปวดหลังทั้งเฉียบพลันและเรื้อรัง แต่ควรทำอย่างต่อเนื่องและปรึกษาผู้เชี่ยวชาญเพื่อวางแผนการรักษาที่เหมาะสม',
      icon: Icons.accessibility_new,
    ),
    FAQItem(
      category: 'สุขภาพ',
      question: 'การนวดมีประโยชน์ต่อสุขภาพอย่างไรบ้าง?',
      answer:
          'การนวดมีประโยชน์ต่อสุขภาพหลายด้าน:\n\n• ลดความเครียดและความวิตกกังวล\n• ผ่อนคลายกล้ามเนื้อและบรรเทาอาการปวด\n• ปรับปรุงการไหลเวียนของเลือดและน้ำเหลือง\n• ช่วยให้นอนหลับดีขึ้น\n• เพิ่มความยืดหยุ่นและช่วงการเคลื่อนไหว\n• ลดอาการปวดศีรษะและไมเกรน\n• เสริมสร้างระบบภูมิคุ้มกัน\n• ลดความดันโลหิตและอัตราการเต้นของหัวใจ\n• ช่วยในการเยียวยาจิตใจหลังภาวะเครียด\n• ช่วยฟื้นฟูร่างกายหลังออกกำลังกายหรือการบาดเจ็บ',
      icon: Icons.favorite,
    ),
    FAQItem(
      category: 'สุขภาพ',
      question: 'หลังนวดแล้วรู้สึกปวดเมื่อยเป็นเรื่องปกติหรือไม่?',
      answer:
          'การรู้สึกปวดเมื่อยเล็กน้อยหลังการนวดเป็นเรื่องปกติ มักเรียกว่า "ปวดเมื่อยหลังการนวด" (Post-massage soreness) ซึ่งมีลักษณะดังนี้:\n\n• เกิดขึ้นโดยเฉพาะหลังการนวดลึกหรือการนวดกล้ามเนื้อที่ตึงมาก\n• มักเกิดขึ้นภายใน 24 ชั่วโมงหลังการนวด\n• อาการควรดีขึ้นภายใน 1-2 วัน\n• คล้ายกับอาการปวดเมื่อยหลังออกกำลังกาย\n\nวิธีบรรเทาอาการ:\n• ดื่มน้ำมากๆ\n• ประคบอุ่น\n• พักผ่อนให้เพียงพอ\n• เคลื่อนไหวร่างกายเบาๆ\n\nหากอาการปวดรุนแรง เจ็บมาก หรือไม่ดีขึ้นหลังจาก 2-3 วัน ควรปรึกษาผู้เชี่ยวชาญ',
      icon: Icons.health_and_safety,
    ),
    FAQItem(
      category: 'สุขภาพ',
      question: 'การนวดช่วยลดความเครียดได้อย่างไร?',
      answer:
          'การนวดช่วยลดความเครียดได้ด้วยกลไกทางร่างกายและจิตใจหลายประการ:\n\n• ลดระดับฮอร์โมนความเครียด เช่น คอร์ติซอล\n• เพิ่มการหลั่งสารสื่อประสาทที่ให้ความรู้สึกดี เช่น เซโรโทนินและโดปามีน\n• ลดความตึงตัวของกล้ามเนื้อที่สัมพันธ์กับความเครียด\n• ลดอัตราการเต้นของหัวใจและความดันโลหิต\n• กระตุ้นระบบประสาทพาราซิมพาเทติก (ระบบพักผ่อน)\n• ช่วยให้จิตใจจดจ่อกับปัจจุบัน ลดความวิตกกังวล\n• ปรับปรุงคุณภาพการนอนหลับซึ่งช่วยฟื้นฟูร่างกายและจิตใจ\n\nการนวดเพื่อลดความเครียดที่แนะนำ: การนวดอโรมาเธอราพี นวดสวีดิช หรือนวดไทยแบบผ่อนคลาย',
      icon: Icons.psychology,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // สร้างรายการหมวดหมู่ที่ไม่ซ้ำกัน
    final categories = _faqItems.map((e) => e.category).toSet().toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(
          child: Text(
            'คำถามที่พบบ่อย',
            style: TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.transparent,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        backgroundColor: primaryColor,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 16, bottom: 24),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final categoryItems =
              _faqItems.where((item) => item.category == category).toList();

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 8),
                  child: Text(
                    category,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: primaryColor,
                    ),
                  ),
                ),
                Card(
                  color: Color(0xFF224B45).withOpacity(0.1),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: EdgeInsets.zero,
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: categoryItems.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      color: Colors.grey[200],
                      indent: 16,
                      endIndent: 16,
                    ),
                    itemBuilder: (context, idx) {
                      return ModernFAQTile(
                        item: categoryItems[idx],
                        primaryColor: primaryColor,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ModernFAQTile extends StatefulWidget {
  final FAQItem item;
  final Color primaryColor;

  const ModernFAQTile({
    Key? key,
    required this.item,
    required this.primaryColor,
  }) : super(key: key);

  @override
  _ModernFAQTileState createState() => _ModernFAQTileState();
}

class _ModernFAQTileState extends State<ModernFAQTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _expanded = !_expanded;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  widget.item.icon,
                  color: widget.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    widget.item.question,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: _expanded ? 0.25 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_right,
                    color: _expanded ? widget.primaryColor : Colors.grey,
                  ),
                ),
              ],
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox(height: 0),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 12, left: 40),
                child: Text(
                  widget.item.answer,
                  style: const TextStyle(
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
              ),
              crossFadeState: _expanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 200),
            ),
          ],
        ),
      ),
    );
  }
}

class FAQItem {
  final String category;
  final String question;
  final String answer;
  final IconData icon;

  FAQItem({
    required this.category,
    required this.question,
    required this.answer,
    this.icon = Icons.question_answer,
  });
}
