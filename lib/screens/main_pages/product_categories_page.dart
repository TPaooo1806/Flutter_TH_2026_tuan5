import 'package:flutter/material.dart';

class ProductCategoriesPage extends StatefulWidget {
  const ProductCategoriesPage({super.key});

  @override
  State<ProductCategoriesPage> createState() => _ProductCategoriesPageState();
}

class _ProductCategoriesPageState extends State<ProductCategoriesPage> {
  final List<String> categories = [
    "Điện thoại",
    "Laptop",
    "Máy tính bảng",
    "Phụ kiện",
    "Đồng hồ thông minh",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh mục Hàng hóa"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.category)),
              title: Text(categories[index]),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
          );
        },
      ),
    );
  }
}
