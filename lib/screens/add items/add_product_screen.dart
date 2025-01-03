import 'dart:io';
import 'package:biriyan/controllers/category_controller.dart';
import 'package:biriyan/controllers/productController.dart';
import 'package:biriyan/models/category.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final ProductController _productController = ProductController();
  late Future<List<Category>> futureCategories;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController isAdditionalController = TextEditingController();

  Category? selectedCategory;
  bool isAdditional = false; // Initial value of the checkbox
  late String productName;
  late int productPrice;
  late String description;

  @override
  void initState() {
    super.initState();
    futureCategories =
        CategoryController().loadCategories(); // Load categories from backend
  }

  final ImagePicker picker = ImagePicker();

  List<File> images = [];

  chooseImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      print('No image selected');
    } else {
      setState(() {
        images.add(File(pickedFile.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: Form(
        key: _formkey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              GridView.builder(
                shrinkWrap: true,
                itemCount: images.length + 1,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 3,
                    mainAxisSpacing: 3,
                    childAspectRatio: 1),
                itemBuilder: (context, index) {
                  return index == 0
                      ? Center(
                          child: IconButton(
                              onPressed: () {
                                chooseImage();
                              },
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                              )),
                        )
                      : SizedBox(
                          width: 50,
                          height: 40,
                          child: Image.file(images[index - 1]),
                        );
                },
              ),

              // TextForm fields
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    // Product name
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        controller: nameController,
                        onChanged: (value) {
                          productName = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Product Name';
                          } else {
                            null;
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Product Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Price & quantity
                    Row(
                      children: [
                        // Price
                        Expanded(
                          child: TextFormField(
                            controller: priceController,
                            onChanged: (value) {
                              productPrice = int.parse(value);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter Product Price';
                              } else {
                                null;
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Price',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Quantity
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Categories
                    FutureBuilder(
                      future: futureCategories,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error:${snapshot.error}'),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text('No category'),
                          );
                        } else {
                          return DropdownButton<Category>(
                            value: selectedCategory,
                            hint: const Text('Select Category'),
                            items: snapshot.data!.map((Category category) {
                              return DropdownMenuItem<Category>(
                                value: category,
                                child: Text(category.name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCategory = value;
                              });
                              print(selectedCategory!.name);
                            },
                          );
                        }
                      },
                    ),

                    Row(
                      children: [
                        Checkbox(
                          value: isAdditional,
                          onChanged: (bool? value) {
                            setState(() {
                              isAdditional = value ?? false; // Update the value
                            });
                          },
                          side: const BorderSide(
                              color: Colors.white), // Set border color to white
                        ),
                        const Text(' Additional'),
                      ],
                    ),
                    // ignore: prefer_const_constructors
                    SizedBox(height: 10),
                    // Description
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        controller: descriptionController,
                        onChanged: (value) {
                          description = value;
                        },
                        maxLength: 500,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),

                    // Upload Button
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade900),
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            _productController.uploadProduct(
                                productName: productName,
                                productPrice: productPrice,
                                isAdditional: isAdditional,
                                description: description,
                                category: selectedCategory!.name,
                                pickedImages: images,
                                isAvailable: true,
                                context: context);

                            // Clear all fields after successful upload
                            setState(() {
                              nameController.clear();
                              priceController.clear();

                              descriptionController.clear();
                              selectedCategory = null;
                              images.clear();
                            });
                          } else {
                            print('Please enter all Input fields');
                          }
                        },
                        child: const Text(
                          'Submit',
                          style:
                              TextStyle(color: Color.fromARGB(255, 10, 5, 5)),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
