import 'package:flutter/material.dart';
import 'store_cart.dart';
import 'store_productlist_detail.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<Map<String, dynamic>> cartItems = [];
  final List<Map<String, dynamic>> products = [
    {
      "id": 1,
      "name": "น้ำมันนวดสมุนไพร",
      "price": 150,
      "stock": 30,
      "image":
          "https://media.allonline.7eleven.co.th/pdmain/541548-00-sukaya.jpg",
      "description": "น้ำมันนวดสมุนไพร สูตรผ่อนคลาย ใช้สำหรับนวดแผนไทยและสปา"
    },
    {
      "id": 2,
      "name": "เตียงนวดพกพา",
      "price": 3200,
      "stock": 10,
      "image":
          "https://i5.walmartimages.com/seo/BestMassage-Massage-Table-Portable-Massage-Bed-Spa-Bed-84-Inches-Long-28-Inchs-Wide-Hight-Adjustable-2-Folding-W-Carry-Case-Black_33315652-970c-45d7-a77c-74ca34895b53.b205e076b90f15371e0714d72eec4b30.jpeg",
      "description": "เตียงนวดพับได้ น้ำหนักเบา เหมาะสำหรับหมอนวดที่ต้องเดินทาง"
    },
    {
      "id": 3,
      "name": "สมุนไพรลูกประคบ",
      "price": 250,
      "stock": 50,
      "image": "https://inwfile.com/s-cw/y7m4ms.jpg",
      "description": "ลูกประคบสมุนไพรแท้ บรรเทาอาการปวดเมื่อย ฟื้นฟูร่างกาย"
    },
  ];

  void addToCart(Map<String, dynamic> product, int quantity) {
    setState(() {
      int index = cartItems.indexWhere((item) => item['id'] == product['id']);
      if (index != -1) {
        cartItems[index]['quantity'] += quantity;
      } else {
        Map<String, dynamic> cartItem = Map.from(product);
        cartItem['quantity'] = quantity;
        cartItems.add(cartItem);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'สินค้าทั้งหมด',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined,
                    color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartPage(
                        cartItems: cartItems,
                        onCartUpdated: () {
                          setState(() {});
                        },
                      ),
                    ),
                  );
                },
              ),
              if (cartItems.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${cartItems.length}',
                      style: TextStyle(
                        color: Color(0XFF224B45),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
        backgroundColor: Color(0XFF224B45),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            var product = products[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailPage(
                      product: product,
                      onAddToCart: (int quantity) {
                        addToCart(product, quantity);
                      },
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(15)),
                        child: Image.network(
                          product['image'],
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "฿${product['price']}",
                                  style: TextStyle(
                                    color: Color(0XFF224B45),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0XFF224B45).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    "${product['stock']} ชิ้น",
                                    style: TextStyle(
                                      color: Color(0XFF224B45),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
