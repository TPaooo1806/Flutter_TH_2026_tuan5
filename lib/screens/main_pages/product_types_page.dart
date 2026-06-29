import 'package:flutter/material.dart';

class ProductTypesPage extends StatefulWidget {
  const ProductTypesPage({super.key});

  @override
  State<ProductTypesPage> createState() => _ProductTypesPageState();
}

class _ProductTypesPageState extends State<ProductTypesPage> {
  final List<String> types = [
    "Hàng điện tử",
    "Hàng gia dụng",
    "Hàng tiêu dùng",
    "Hàng nhập khẩu",
    "Hàng tồn kho",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Loại Hàng Hóa"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: types.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.list_alt)),
              title: Text(types[index]),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
          );
        },
      ),
    );
  }
}
