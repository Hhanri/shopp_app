import 'package:flutter/material.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);

  static const String routeName = 'editProduct';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {

  bool _isInit = true;
  bool _isLoading = false;

  ProductModel editedProduct = ProductModel(id: '', title: '', description: '', price: 0, imageUrl: '', isFavorite: false);

  final TextEditingController imageController = TextEditingController();

  final FocusNode titleFocusNode = FocusNode();
  final FocusNode priceFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();
  final FocusNode imageFocusNode = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void focus(FocusNode newNode) => FocusScope.of(context).requestFocus(newNode);

  var _initValues = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': ''
  };

  void updateUrl() {
    if (!imageFocusNode.hasFocus) {
      setState(() {});
    }
  }
  Future<void>  saveForm() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      if  (editedProduct.id != '') {
        await context.read<ProductsProvider>().updateProduct(id: editedProduct.id, product: editedProduct);
      } else {
        try {
          await context.read<ProductsProvider>().addProduct(editedProduct);
        } catch(error) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('error'),
                content: const Text("Something went wrong"),
                actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('ok'))],
              );
            }
          );
        }
      }
    }
    setState(() {
      _isLoading = false;
    });
    Future.microtask(() => Navigator.of(context).pop());
  }

  @override
  void initState() {
    imageFocusNode.addListener(() {updateUrl();});
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final String? productId = ModalRoute.of(context)!.settings.arguments as String?;
      if (productId != null) {
        editedProduct = context.read<ProductsProvider>().productById(productId);
        imageController.text = editedProduct.imageUrl;
        _initValues = {
          'title': editedProduct.title,
          'price': editedProduct.price.toString(),
          'description': editedProduct.description,
        };
      }
    }
     _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    imageController.dispose();
    descriptionFocusNode.dispose();
    titleFocusNode.dispose();
    priceFocusNode.dispose();
    imageFocusNode.removeListener(() { });
    imageFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
        actions: [
          IconButton(
            onPressed: saveForm,
            icon: const Icon(Icons.save))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: _isLoading
          ? const Center(child: CircularProgressIndicator(),)
          : Form(
            key: formKey,
            child: ListView(
              children: [
                TextFormField(
                  focusNode: titleFocusNode,
                  initialValue: _initValues['title'],
                  decoration: const InputDecoration(
                    labelText: "Title",
                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => focus(priceFocusNode),
                  onSaved: (value) {
                    editedProduct = ProductModel(
                      id: editedProduct.id,
                      title: value ?? '',
                      description: editedProduct.description,
                      price: editedProduct.price,
                      imageUrl: editedProduct.imageUrl,
                      isFavorite: editedProduct.isFavorite
                    );
                  },
                  validator: (value) {
                    if (value!.isEmpty) return 'needs to be filled';
                    return null;
                  },
                ),
                TextFormField(
                  focusNode: priceFocusNode,
                  initialValue: _initValues['price'],
                  decoration: const InputDecoration(
                    labelText: "Price",
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => focus(descriptionFocusNode),
                  onSaved: (value) {
                    editedProduct = ProductModel(
                      id: editedProduct.id,
                      title: editedProduct.title,
                      description: editedProduct.description,
                      price: double.parse(value ?? '0.0'),
                      imageUrl: editedProduct.imageUrl,
                      isFavorite: editedProduct.isFavorite
                    );
                  },
                  validator: (value) {
                    if (value!.isEmpty) return 'needs to be filled';
                    if (double.tryParse(value) == null) return 'needs to be number';
                    if (double.parse(value) < 0 ) return 'needs to be greater than 0';
                    return null;
                  },
                ),
                TextFormField(
                  focusNode: descriptionFocusNode,
                  initialValue: _initValues['description'],
                  decoration: const InputDecoration(
                    labelText: "Description",
                  ),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    editedProduct = ProductModel(
                      id: editedProduct.id,
                      title: editedProduct.title,
                      description: value ?? '',
                      price: editedProduct.price,
                      imageUrl: editedProduct.imageUrl,
                      isFavorite: editedProduct.isFavorite
                    );
                  },
                  validator: (value) {
                    if (value!.isEmpty) return 'needs to be filled';
                    if (value.length < 10) return 'description need to be at least 10 characters long';
                    return null;
                  },
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: const EdgeInsets.only(top: 8, right: 12),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey)
                      ),
                      child: imageController.text.isEmpty ? const Text("enter the url") : FittedBox(child: Image.network(imageController.text),),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Image URL",
                        ),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        onEditingComplete: () {
                          setState(() {});
                        },
                        onFieldSubmitted: (_) => saveForm(),
                        onSaved: (value) {
                          editedProduct = ProductModel(
                            id: editedProduct.id,
                            title: editedProduct.title,
                            description: editedProduct.description,
                            price: editedProduct.price,
                            imageUrl: value ?? '',
                            isFavorite: editedProduct.isFavorite
                          );
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
      ),
    );
  }
}
