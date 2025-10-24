import 'package:flutter/material.dart';

class ReviewPage extends StatefulWidget {
  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final List<Map<String, dynamic>> reviews = [
    {"name": "ลูกค้า A", "avatar": "https://i.pravatar.cc/100?img=1", "rating": 5, "comment": "บรรยากาศดีมาก พนักงานบริการดี นวดสบายสุดๆ"},
    {"name": "ลูกค้า B", "avatar": "https://i.pravatar.cc/100?img=2", "rating": 4, "comment": "บริการดี แต่รอคิวนานไปนิด"},
    {"name": "ลูกค้า C", "avatar": "https://i.pravatar.cc/100?img=3", "rating": 5, "comment": "ชอบมาก กลับมาใช้บริการอีกแน่นอน"},
    {"name": "ลูกค้า D", "avatar": "https://i.pravatar.cc/100?img=4", "rating": 1, "comment": "ไม่โอเคเลย"},
  ];

  int selectedFilter = 0; // 0 = ทั้งหมด, 1-5 = เฉพาะดาว

  @override
  Widget build(BuildContext context) {
    // นับจำนวนรีวิวแต่ละดาว
    Map<int, int> ratingCount = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (var r in reviews) {
      ratingCount[r["rating"]] = (ratingCount[r["rating"]] ?? 0) + 1;
    }
    int total = reviews.length;

    // กรองรีวิวตาม filter
    List<Map<String, dynamic>> filteredReviews = selectedFilter == 0
        ? reviews
        : reviews.where((r) => r["rating"] == selectedFilter).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("รีวิวร้าน"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // 🔹 ปุ่ม filter
          Padding(
            padding: const EdgeInsets.all(10),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildFilterButton("ทั้งหมด", 0, total, Colors.green),
                _buildFilterButton("5 ดาว", 5, ratingCount[5]!, Colors.grey.shade300),
                _buildFilterButton("4 ดาว", 4, ratingCount[4]!, Colors.grey.shade300),
                _buildFilterButton("3 ดาว", 3, ratingCount[3]!, Colors.grey.shade300),
                _buildFilterButton("2 ดาว", 2, ratingCount[2]!, Colors.grey.shade300),
                _buildFilterButton("1 ดาว", 1, ratingCount[1]!, Colors.grey.shade300),
              ],
            ),
          ),

          Divider(),

          // 🔹 รายการรีวิว
          Expanded(
            child: filteredReviews.isEmpty
                ? Center(child: Text("ยังไม่มีรีวิว"))
                : ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: filteredReviews.length,
                    itemBuilder: (context, index) {
                      final review = filteredReviews[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(review["avatar"]),
                          ),
                          title: Text(review["name"], style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: List.generate(
                                  5,
                                  (starIndex) => Icon(
                                    Icons.star,
                                    color: starIndex < review["rating"] ? Colors.amber : Colors.grey,
                                    size: 18,
                                  ),
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(review["comment"]),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // 🔹 ปุ่ม Filter
  Widget _buildFilterButton(String label, int value, int count, Color defaultColor) {
    bool isSelected = selectedFilter == value;
    return ChoiceChip(
      label: Text("$label ($count)"),
      selected: isSelected,
      selectedColor: Colors.green,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
        fontWeight: FontWeight.bold,
      ),
      onSelected: (_) {
        setState(() {
          selectedFilter = value;
        });
      },
    );
  }
}
