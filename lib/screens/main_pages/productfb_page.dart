import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductFbPage extends StatefulWidget {
  const ProductFbPage({super.key});

  @override
  State<ProductFbPage> createState() => _ProductFbPageState();
}

class _ProductFbPageState extends State<ProductFbPage> {
  final CollectionReference _productsRef = FirebaseFirestore.instance.collection('products');
  final CollectionReference _categoriesRef = FirebaseFirestore.instance.collection('categories');

  Future<void> _showProductDialog([DocumentSnapshot? documentSnapshot]) async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    String? selectedCategoryId;

    if (documentSnapshot != null) {
      nameController.text = documentSnapshot['name'];
      priceController.text = documentSnapshot['price'].toString();
      selectedCategoryId = documentSnapshot['categoryId'];
    }

    // Fetch categories for dropdown
    QuerySnapshot categoriesSnapshot = await _categoriesRef.get();
    List<DropdownMenuItem<String>> categoryItems = categoriesSnapshot.docs.map((doc) {
      return DropdownMenuItem<String>(
        value: doc.id,
        child: Text(doc['name']),
      );
    }).toList();

    if (context.mounted) {
      await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setStateDialog) {
              return AlertDialog(
                title: Text(documentSnapshot == null ? 'Thêm Sản Phẩm' : 'Sửa Sản Phẩm'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Tên sản phẩm', border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Giá sản phẩm', border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: selectedCategoryId,
                        decoration: const InputDecoration(labelText: 'Danh mục', border: OutlineInputBorder()),
                        items: categoryItems,
                        onChanged: (value) {
                          setStateDialog(() {
                            selectedCategoryId = value;
                          });
                        },
                      )
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Hủy'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final String name = nameController.text.trim();
                      final double? price = double.tryParse(priceController.text.trim());
                      
                      if (name.isNotEmpty && price != null && selectedCategoryId != null) {
                        if (documentSnapshot == null) {
                          // Create
                          await _productsRef.add({
                            'name': name,
                            'price': price,
                            'categoryId': selectedCategoryId,
                            'createdAt': FieldValue.serverTimestamp()
                          });
                        } else {
                          // Update
                          await _productsRef.doc(documentSnapshot.id).update({
                            'name': name,
                            'price': price,
                            'categoryId': selectedCategoryId,
                          });
                        }
                        if (context.mounted) Navigator.pop(context);
                      }
                    },
                    child: const Text('Lưu'),
                  ),
                ],
              );
            }
          );
        },
      );
    }
  }

  Future<void> _deleteProduct(String id) async {
    await _productsRef.doc(id).delete();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã xóa sản phẩm!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProductDialog(),
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: StreamBuilder(
        stream: _productsRef.orderBy('createdAt', descending: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (streamSnapshot.hasError) {
            return const Center(child: Text('Đã xảy ra lỗi khi tải dữ liệu.'));
          }
          if (!streamSnapshot.hasData || streamSnapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Chưa có sản phẩm nào.'));
          }

          return ListView.builder(
            itemCount: streamSnapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(Icons.inventory, color: Colors.white),
                  ),
                  title: Text(documentSnapshot['name']),
                  subtitle: Text('Giá: ${documentSnapshot['price']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () => _showProductDialog(documentSnapshot),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Xác nhận xóa'),
                            content: const Text('Bạn có chắc muốn xóa sản phẩm này?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Hủy'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _deleteProduct(documentSnapshot.id);
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
