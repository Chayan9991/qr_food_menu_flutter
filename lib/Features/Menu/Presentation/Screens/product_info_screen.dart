// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:readmore/readmore.dart';
// import 'package:self_order_qr_menu/Features/Menu/Domain/entities/add_to_cart_Entity.dart';
// import 'package:self_order_qr_menu/Features/Menu/Domain/entities/category_entity.dart';
// import 'package:self_order_qr_menu/Features/Menu/Domain/entities/product_customization_entity.dart';
// import 'package:self_order_qr_menu/Features/Menu/Domain/entities/product_entity.dart';
// import 'package:self_order_qr_menu/Features/Menu/Presentation/Cubits/cart_cubits/cart_cubit.dart';
// import 'package:self_order_qr_menu/Features/Menu/Presentation/Widgets/veg_nonVeg_Icon.dart';
// import '../../../../Core/Theme/app_palette.dart';
// import '../Widgets/detailed page/variation_customization_widget.dart';
//
// class DetailedItem extends StatefulWidget {
//   final ProductEntity? cardItem;
//   final CategoryEntity? category;
//   final ProductCustomizationEntity? customization;
//
//   const DetailedItem({super.key,
//     required this.cardItem,
//     required this.category,
//     this.customization});
//
//   @override
//   State<DetailedItem> createState() => _DetailedItemState();
// }
//
// class _DetailedItemState extends State<DetailedItem> {
//
//   double customizationPrice = 0;
//   double quantity = 0;
//   final _textController = TextEditingController();
//   late double _itemTotalPrice;
//   late VariationEntity _selectedVariation;
//   late Map<String, OptionsEntity?> _selectedCustomization;
//   late AddToCartEntity _addToCartItem;
//
//   @override
//   void initState() {
//     _itemTotalPrice = widget.cardItem?.basePrice ?? 0;
//     _selectedVariation = VariationEntity(name: "", price: 0, isVeg: false);
//     _selectedCustomization = {};
//     super.initState();
//   }
//
//   void _handleSelectVariation(VariationEntity data) {
//     setState(() {
//       _selectedVariation = data;
//       _itemTotalPrice = _selectedVariation
//           .price; // as Product with variation cannot have BASE PRICE
//     });
//   }
//
//   void _handleSelectCustomization(Map<String, OptionsEntity?> data) {
//     double totalPrice = _itemTotalPrice;
//     setState(() {
//       double price = 0;
//       _selectedCustomization = data;
//       if (_selectedCustomization.isEmpty) {
//         print("customization list is empty");
//       } else {
//         print(_selectedCustomization);
//         final priceList = _selectedCustomization.values.toList();
//         priceList.forEach((values) {
//           price += values!.price;
//         });
//       }
//       totalPrice += price;
//       print(totalPrice);
//       customizationPrice = totalPrice;
//     });
//   }
//
//   AddToCartEntity _itemAddToCart() {
//     double singleItemPrice = customizationPrice == 0
//         ? _itemTotalPrice
//         : customizationPrice;
//     double totalPrice = quantity * singleItemPrice;
//     return AddToCartEntity(productEntity: widget.cardItem!,
//         totalPrice: totalPrice,
//         addInstructions: _textController.text,
//         productVariation: _selectedVariation,
//         selectedCustomization: _selectedCustomization
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Get the CartCubit instance
//     final cartItemCubit = context.read<CartCubit>();
//     final itemList = cartItemCubit.getItems();
//
//     // Find the current AddToCartItem
//     AddToCartEntity? currentAddToCartItem = itemList.firstWhere(
//           (item) => item.productEntity.productId == widget.cardItem?.productId,
//     );
//
//     // if (currentAddToCartItem != null) {
//     //
//     //   quantity = currentAddToCartItem.quantity;
//     //   _textController.text = currentAddToCartItem.addInstructions ?? "";
//     //   _selectedCustomization = currentAddToCartItem.selectedCustomization ?? {};
//     //   _selectedVariation = currentAddToCartItem.productVariation ??
//     //       VariationEntity(name: "", price: 0, isVeg: true);
//     //   _itemTotalPrice = currentAddToCartItem.totalPrice ;
//     //
//     // }
//
//     final screenWidth = MediaQuery
//         .of(context)
//         .size
//         .width;
//     final cardItem = widget.cardItem;
//     final category = widget.category;
//     final customization = widget.customization;
//
//     final paddingData = screenWidth > 600
//         ? EdgeInsets.symmetric(horizontal: screenWidth * .1)
//         : const EdgeInsets.symmetric(horizontal: 0);
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: paddingData,
//         child: CustomScrollView(
//           slivers: [
//             SliverAppBar(
//               expandedHeight: 300,
//               pinned: true,
//               backgroundColor: Colors.teal,
//               flexibleSpace: FlexibleSpaceBar(
//                 background: Stack(
//                   fit: StackFit.expand,
//                   children: [
//                     Image.network(
//                       (widget.cardItem?.imageUrl?.isNotEmpty ?? false)
//                           ? widget.cardItem!.imageUrl.first
//                           : "https://images.pexels.com/photos/3421920/pexels-photo-3421920.jpeg?auto=compress&cs=tinysrgb&w=600",
//                       fit: BoxFit.cover,
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                               colors: [
//                                 Colors.black.withOpacity(0.4),
//                                 Colors.transparent,
//                                 Colors.black.withOpacity(0.4),
//                               ],
//                               begin: Alignment.topCenter,
//                               end: Alignment.bottomCenter)),
//                     )
//                   ],
//                 ),
//               ),
//
//               leading: IconButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   icon: Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.6),
//                         borderRadius: BorderRadius.circular(12)),
//                     child: const Icon(Icons.arrow_back),
//                   )),
//               actions: [
//                 IconButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     icon: Stack(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                                 color: Colors.white.withOpacity(0.6),
//                                 borderRadius: BorderRadius.circular(12)),
//                             child: const Icon(Icons.shopping_bag_outlined,
//                               color: Colors.black,),
//                           ),
//                           Positioned(
//                               right: 2,
//                               top: 0,
//                               child: Container(
//                                 padding: const EdgeInsets.all(4),
//                                 decoration: const BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: Colors.red,
//                                 ),
//                                 child: const Text("1", style: TextStyle(
//                                     fontSize: 14, color: Colors.white),),
//                               ))
//                         ]
//                     ))
//               ],
//             ),
//             SliverToBoxAdapter(
//               child: Container(
//                 decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius:
//                     BorderRadius.vertical(top: Radius.circular(30))),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Row(
//                             children: [
//                               if (cardItem!.isVeg) buildVegNonVegIcon(true),
//                               const SizedBox(
//                                 width: 4,
//                               ), // Veg icon
//                               if (cardItem.isNonVeg)
//                                 buildVegNonVegIcon(false), // Non-Veg icon
//                             ],
//                           ),
//                           const SizedBox(
//                             width: 8,
//                           ),
//                           Expanded(
//                               child: Text(
//                                 cardItem.name,
//                                 maxLines: 2,
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.w700, fontSize: 18),
//                                 overflow: TextOverflow.ellipsis,
//                               )),
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 6, horizontal: 12),
//                             decoration: BoxDecoration(
//                                 color: Colors.teal.shade50,
//                                 borderRadius: BorderRadius.circular(50)),
//                             child: const Row(
//                               children: [
//                                 Icon(
//                                   Icons.star,
//                                   color: Colors.deepOrange,
//                                   size: 20,
//                                 ),
//                                 SizedBox(
//                                   width: 4,
//                                 ),
//                                 Text(
//                                   "4",
//                                   style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w800,
//                                       color: Colors.teal),
//                                 )
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           _buildInfoChip(
//                               Icons.food_bank_outlined, category!.categoryName),
//                           _buildInfoChip(
//                               Icons.local_fire_department_rounded, "450cal"),
//                           _buildInfoChip(Icons.timer_outlined, "10-15 min"),
//                         ],
//                       ),
//                       const SizedBox(
//                         height: 15,
//                       ),
//                       const Text(
//                         "Description",
//                         style: TextStyle(
//                             fontWeight: FontWeight.w700, fontSize: 16),
//                       ),
//                       const Divider(),
//                       ReadMoreText(
//                         cardItem.description,
//                         style: const TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w400,
//                             color: Colors.black54),
//                         trimMode: TrimMode.Line,
//                         trimLines: 2,
//                         colorClickableText: Colors.pink,
//                         trimCollapsedText: 'Show more',
//                         trimExpandedText: ' Show less',
//                         moreStyle: const TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.teal),
//                         lessStyle: const TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.teal),
//                       ),
//                       const SizedBox(
//                         height: 15,
//                       ),
//
//                       // Variation/Customization Widget
//
//                       widget.cardItem!.isCustomizable
//                           ? VariationCustomizationWidget(
//                           customization: customization,
//                           variations: cardItem.variations,
//                           sendSelectedCustomization:
//                           _handleSelectCustomization)
//                           : VariationCustomizationWidget(
//                           variations: cardItem.variations,
//                           sendSelectedVariation: _handleSelectVariation),
//
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       const Text(
//                         "Add Note",
//                         style: TextStyle(
//                             fontWeight: FontWeight.w700, fontSize: 14),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       //Text Field
//                       _customTextField(_textController),
//                       const SizedBox(
//                         height: 100,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: Padding(
//         padding: paddingData,
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           width: double.infinity,
//           height: 80,
//           decoration: BoxDecoration(color: Colors.white, boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               spreadRadius: 1,
//               blurRadius: 10,
//               offset: const Offset(0, -5),
//             )
//           ]),
//           child: Row(
//             children: [
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Total Price",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 14,
//                         color: Colors.grey),
//                   ),
//                   Text(
//                     "\$${customizationPrice == 0
//                         ? _itemTotalPrice
//                         : customizationPrice}",
//                     style: const TextStyle(
//                         fontWeight: FontWeight.w800,
//                         fontSize: 24,
//                         color: Colors.teal),
//                   ),
//                 ],
//               ),
//               const SizedBox(width: 20),
//               Expanded(
//                 child: quantity == 0
//                     ? ElevatedButton(
//                   onPressed: () {
//                     //Add Item to the cart
//                     _addToCartItem = _itemAddToCart();
//                     cartItemCubit.addItemToCart(_addToCartItem);
//
//                     setState(() {
//                       quantity++; // Initialize quantity
//                     });
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.teal,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                   ),
//                   child: const Text(
//                     "Add To Cart",
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
//                   ),
//                 )
//                     : Container(
//                   height: 40,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(16),
//                     color: Colors.teal,
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       IconButton(
//                         onPressed: () {
//                           if (quantity == 0) {
//                             //if quantity == 0 then clear the item from add to cart
//                             cartItemCubit.removeItemFromCart(
//                                 _addToCartItem);
//                           }
//                           setState(() {
//                             if (quantity > 0) {
//                               quantity--;
//                             }
//                           });
//                         },
//                         icon: const Icon(
//                           Icons.remove,
//                           color: Colors.white,
//                           size: 18,
//                         ),
//                       ),
//                       const SizedBox(width: 10,),
//                       Text(
//                         "$quantity", // Display quantity
//                         style: const TextStyle(
//                           fontSize: 16,
//                           color: Colors.white,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                       const SizedBox(width: 10,),
//                       IconButton(
//                         onPressed: () {
//                           setState(() {
//                             quantity++; // Increment quantity
//                           });
//                           cartItemCubit.modifyCartItem(currentAddToCartItem, _itemAddToCart()) ;
//                         },
//                         icon: const Icon(
//                           Icons.add,
//                           color: Colors.white,
//                           size: 18, // Adjusted size for better visibility
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildExtraItem(String name, String price) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Row(
//         children: [
//           Container(
//             width: 27,
//             height: 27,
//             decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey.shade300),
//                 borderRadius: BorderRadius.circular(10)),
//             child: const Icon(
//               Icons.add,
//               color: Colors.teal,
//               size: 19,
//             ),
//           ),
//           const SizedBox(
//             width: 12,
//           ),
//           Text(
//             name,
//             style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
//           ),
//           const Spacer(),
//           Text(
//             "+\$$price",
//             style: const TextStyle(
//                 fontWeight: FontWeight.w500,
//                 fontSize: 14,
//                 color: Colors.black54),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget _customTextField(TextEditingController textController) {
//     return TextField(
//       maxLines: 3,
//       maxLength: 500,
//       controller: textController,
//       style: const TextStyle(
//         fontSize: 16,
//         color: Colors.black87,
//         fontWeight: FontWeight.w400,
//       ),
//       decoration: InputDecoration(
//         hintText: "Add order instructions...",
//         hintStyle: TextStyle(
//             color: Colors.grey.withOpacity(0.8),
//             fontSize: 14,
//             fontWeight: FontWeight.w500),
//         focusedBorder: OutlineInputBorder(
//           borderSide: const BorderSide(color: Colors.teal, width: 2.0),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.grey.shade500, width: 1.5),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         fillColor: AppPalette.offWhite,
//         filled: true,
//       ),
//     );
//   }
//
//   // Widget _buildSizeButton(String size) {
//   //   bool isSelected = selectedSize == size;
//   //   return InkWell(
//   //     onTap: () {
//   //       setState(() {
//   //         selectedSize = size;
//   //       });
//   //     },
//   //     child: Container(
//   //       width: 70,
//   //       padding: const EdgeInsets.symmetric(vertical: 12),
//   //       decoration: BoxDecoration(
//   //         color: isSelected ? Colors.teal.shade600 : AppPalette.offWhite,
//   //         borderRadius: BorderRadius.circular(16),
//   //       ),
//   //       child: Center(
//   //         child: Text(
//   //           size,
//   //           style: TextStyle(
//   //               color: isSelected ? Colors.white : Colors.black54,
//   //               fontSize: 16),
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }
//
//   Widget _allergenInfoChip(IconData icon, String label) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 8),
//       child: Container(
//         constraints: const BoxConstraints(maxWidth: double.infinity),
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           color: Colors.red.shade50,
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               icon,
//               color: Colors.black87,
//             ),
//             const SizedBox(
//               width: 4,
//             ),
//             Flexible(
//               // Wraps the label to avoid overflow
//               child: Text(
//                 label,
//                 style: const TextStyle(
//                   color: Colors.black87,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 overflow:
//                 TextOverflow.ellipsis, // Truncates long text with '...'
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInfoChip(IconData icon, String label) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         color: AppPalette.offWhite,
//       ),
//       child: Row(
//         children: [
//           Icon(
//             icon,
//             color: Colors.grey[700],
//           ),
//           const SizedBox(
//             width: 4,
//           ),
//           Text(
//             label,
//             style:
//             TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w400),
//           )
//         ],
//       ),
//     );
//   }
// }
