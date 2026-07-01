import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryFbPage extends StatefulWidget {
  const CategoryFbPage({super.key});

  @override
  State<CategoryFbPage> createState() => _CategoryFbPageState();
}

class _CategoryFbPageState extends State<CategoryFbPage> {
  final CollectionReference _categoriesRef = FirebaseFirestore.instance.collection('categories');

  Future<void> _showCategoryDialog([DocumentSnapshot? documentSnapshot]) async {
    final TextEditingController nameController = TextEditingController();

    if (documentSnapshot != null) {
      nameController.text = documentSnapshot['name'];
    }

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(documentSnapshot == null ? 'Thêm Danh Mục' : 'Sửa Danh Mục'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Tên danh mục', border: OutlineInputBorder()),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                final String name = nameController.text.trim();
                if (name.isNotEmpty) {
                  if (documentSnapshot == null) {
                    // Create
                    await _categoriesRef.add({'name': name, 'createdAt': FieldValue.serverTimestamp()});
                  } else {
                    // Update
                    await _categoriesRef.doc(documentSnapshot.id).update({'name': name});
                  }
                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteCategory(String id) async {
    await _categoriesRef.doc(id).delete();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã xóa thành công!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryDialog(),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: StreamBuilder(
        stream: _categoriesRef.orderBy('createdAt', descending: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (streamSnapshot.hasError) {
            return const Center(child: Text('Đã xảy ra lỗi khi tải dữ liệu.'));
          }
          if (!streamSnapshot.hasData || streamSnapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Chưa có danh mục nào.'));
          }

          return ListView.builder(
            itemCount: streamSnapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.category, color: Colors.white),
                  ),
                  title: Text(documentSnapshot['name']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () => _showCategoryDialog(documentSnapshot),
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
                                  _deleteCategory(documentSnapshot.id);
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
          );
        },
      ),
    );
  }
}
