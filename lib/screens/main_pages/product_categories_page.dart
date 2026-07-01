import 'package:flutter/material.dart';

class ProductCategoriesPage extends StatefulWidget {
  const ProductCategoriesPage({super.key});

  @override
  State<ProductCategoriesPage> createState() => _ProductCategoriesPageState();
}

class _ProductCategoriesPageState extends State<ProductCategoriesPage> {
  // Dữ liệu mẫu (Mock data) dùng tạm để demo UI CRUD. 
  // Bạn sẽ thay List này bằng Firebase Firestore khi quay video tích hợp Firebase.
  List<Map<String, dynamic>> _categories = [
    {'id': '1', 'name': 'Điện thoại'},
    {'id': '2', 'name': 'Laptop'},
    {'id': '3', 'name': 'Máy tính bảng'},
    {'id': '4', 'name': 'Phụ kiện'},
    {'id': '5', 'name': 'Đồng hồ thông minh'},
  ];

  // Hàm mở Dialog thêm/sửa danh mục
  Future<void> _showCategoryDialog([Map<String, dynamic>? category]) async {
    final TextEditingController nameController = TextEditingController();

    if (category != null) {
      nameController.text = category['name'];
    }

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(category == null ? 'Thêm Danh Mục' : 'Sửa Danh Mục'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Tên danh mục',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                final String name = nameController.text.trim();
                if (name.isNotEmpty) {
                  setState(() {
                    if (category == null) {
                      // Thêm mới
                      _categories.add({
                        'id': DateTime.now().millisecondsSinceEpoch.toString(),
                        'name': name,
                      });
                    } else {
                      // Cập nhật
                      final index = _categories.indexWhere((c) => c['id'] == category['id']);
                      if (index != -1) {
                        _categories[index]['name'] = name;
                      }
                    }
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  // Hàm xóa
  void _deleteCategory(String id) {
    setState(() {
      _categories.removeWhere((c) => c['id'] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã xóa danh mục thành công!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryDialog(),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _categories.isEmpty
          ? const Center(child: Text('Chưa có danh mục nào.'))
          : ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final data = _categories[index];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.category, color: Colors.white),
                    ),
                    title: Text(data['name'] ?? 'Không có tên'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () => _showCategoryDialog(data),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Xác nhận xóa'),
                              content: const Text('Bạn có chắc muốn xóa danh mục này?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Hủy'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _deleteCategory(data['id']);
                                  },
                                  child: const Text('Xóa', style: TextStyle(color: Colors.red)),
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
    );
  }
}
