import 'dart:developer';

import 'package:craftybay_ecommerce_application/presentation/state_holders/add_to_cart_controller.dart';
import 'package:craftybay_ecommerce_application/presentation/state_holders/product_details_screen_controller.dart';
import 'package:craftybay_ecommerce_application/presentation/ui/widgets/custom_appbar.dart';
import 'package:craftybay_ecommerce_application/presentation/ui/widgets/product_details/custom_stepper.dart';
import 'package:craftybay_ecommerce_application/presentation/ui/widgets/product_details/product_image_slider.dart';
import 'package:craftybay_ecommerce_application/presentation/ui/widgets/product_details/product_rating_review_wishlist.dart';
import 'package:craftybay_ecommerce_application/presentation/ui/widgets/product_details/select_product_color.dart';
import 'package:craftybay_ecommerce_application/presentation/ui/widgets/section_title.dart';
import 'package:craftybay_ecommerce_application/presentation/ui/widgets/product_details/select_product_size.dart';
import 'package:craftybay_ecommerce_application/presentation/ui/widgets/product_details/bottom_nav_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  void initState() {
    super.initState();
    callData();
  }

  Future<void> callData() async {
    await Get.find<ProductDetailsScreenController>()
        .getProductDetails(widget.productId);
  }

  int _selectedColorIndex = 0;

  int _selectedSizeIndex = 0;
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ProductDetailsScreenController>(
          builder: (productDetailsScreenController) {
        if (productDetailsScreenController.getProductDetailsInProgress) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          ProductImageSlider(
                            imageList: [
                              productDetailsScreenController
                                      .productDetailsData?.img1 ??
                                  '',
                              productDetailsScreenController
                                      .productDetailsData?.img2 ??
                                  '',
                              productDetailsScreenController
                                      .productDetailsData?.img3 ??
                                  '',
                              productDetailsScreenController
                                      .productDetailsData?.img4 ??
                                  '',
                            ],
                          ),
                          const CustomAppBar(
                            title: 'Product Details',
                            elevation: 0,
                            bgColor: Colors.transparent,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  productDetailsScreenController
                                          .productDetailsData.product?.title ??
                                      '',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5),
                                )),
                                CustomStepper(
                                    lowerLimit: 1,
                                    upperLimit: 10,
                                    stepValue: 1,
                                    value: 1,
                                    onChange: (newValue) {
                                      _quantity = newValue;
                                      print(newValue);
                                    })
                              ],
                            ),
                            ProductRatingReviewWishList(
                                productDetailsData:
                                    productDetailsScreenController
                                        .productDetailsData),
                            ProductColorPicker(
                                colors: productDetailsScreenController
                                        .availableColors ??
                                    [],
                                onSelected: (int selectedColor) {
                                  _selectedColorIndex = selectedColor;
                                  log(_selectedColorIndex.toString());
                                  //productDetailsScreenController.updateAllState;
                                  //setState(() {});
                                  log(productDetailsScreenController
                                      .availableColors[_selectedColorIndex]
                                      .toString());
                                },
                                initialSelected: 0),
                            const SizedBox(
                              height: 16,
                            ),
                            ProductSizePicker(
                                sizes: productDetailsScreenController
                                        .availableSizes ??
                                    [],
                                onSelected: (int selectedSize) {
                                  _selectedSizeIndex = selectedSize;
                                  log(_selectedSizeIndex.toString());
                                  //productDetailsScreenController.updateAllState;
                                  //setState(() {});
                                  log(productDetailsScreenController
                                      .availableSizes[_selectedSizeIndex]);
                                },
                                initialSelected: 0),
                            const SizedBox(
                              height: 16,
                            ),
                            const SectionTitle(title: 'Description'),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(productDetailsScreenController
                                    .productDetailsData.des ??
                                ''),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              BottomNavCard(
                productPrice: productDetailsScreenController
                    .productDetailsData.product!.price
                    .toString(),
                onPressed: () {
                  Get.find<AddToCartController>()
                      .addToCart(
                          productDetailsScreenController
                                  .productDetailsData.productId ??
                              0,
                          productDetailsScreenController
                              .availableColors[_selectedColorIndex],
                          productDetailsScreenController
                              .availableSizes[_selectedSizeIndex],
                          _quantity)
                      .then((result) {
                    if (result) {
                      Get.snackbar('Success', 'Add to cart successful.',
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          borderRadius: 10,
                          snackPosition: SnackPosition.BOTTOM);
                    } else {
                      Get.snackbar('Failed', 'Add to cart failed! Try again.',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          borderRadius: 10,
                          snackPosition: SnackPosition.BOTTOM);
                    }
                  });
                },
              )
            ],
          ),
        );
      }),
    );
  }
}
