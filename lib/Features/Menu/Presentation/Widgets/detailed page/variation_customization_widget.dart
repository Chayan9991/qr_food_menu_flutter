import 'dart:collection';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_order_qr_menu/Features/Menu/Domain/entities/product_customization_entity.dart';
import 'package:self_order_qr_menu/Features/Menu/Presentation/Cubits/menu_cubit/menu_cubit.dart';
import '../../../Domain/entities/product_entity.dart';
import '../../Cubits/cart_cubits/cart_cubit.dart';

class VariationCustomizationWidget extends StatefulWidget {
  final String productId;
  final ProductCustomizationEntity? customization;
  final List<VariationEntity> variations;

  //final Function(VariationEntity)? sendSelectedVariation;
  final Function(Map<String, OptionsEntity?>)? sendSelectedCustomization;

  const VariationCustomizationWidget(
      {super.key,
      this.customization,
      required this.variations,
      required this.productId,
      this.sendSelectedCustomization});

  @override
  State<VariationCustomizationWidget> createState() =>
      _VariationCustomizationWidgetState();
}

class _VariationCustomizationWidgetState
    extends State<VariationCustomizationWidget> {
  VariationEntity? selectedVariation;
  Map<String, OptionsEntity?> selectedCustomization = {};

  @override
  Widget build(BuildContext context) {
    if (widget.variations.isNotEmpty) {
      return _variationWidget();
    }
    if (widget.customization != null) {
      return _customizationWidget();
    }
    return const SizedBox.shrink();
  }

  Widget _variationWidget() {
    final menuCubit = context.read<MenuCubit>();
    final cartCubit = context.read<CartCubit>();

    //fetch the product variation item if present
    final prodWithVariation =
        cartCubit.getSingleItemById(widget.productId)?.selectedVariation;
    if (prodWithVariation != null) {
      selectedVariation = prodWithVariation;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Variations",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        const Divider(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.variations.map((variation) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              // Control the gap between tiles
              child: CheckboxListTile(
                activeColor: Colors.cyan.shade800,
                contentPadding: EdgeInsets.zero,
                // Remove internal padding
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      variation.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                    Text(
                      "₹${variation.price}",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Colors.teal.shade700),
                    ),
                  ],
                ),
                value: selectedVariation == variation,
                // Whether this is checked
                onChanged: (isChecked) {
                  setState(() {
                    if (isChecked == true) {
                      // Select this variation
                      selectedVariation = variation;
                      menuCubit.selectVariation(
                          variation); // Emit the new variation to Cubit
                    } else {
                      // Deselect this variation
                      selectedVariation = null;
                      menuCubit.selectVariation(
                          null); // Clear the selection in Cubit
                    }
                  });
                },
              ),
            );
          }).toList(),
        )
      ],
    );
  }

  Widget _customizationWidget() {
    final menuCubit = context.read<MenuCubit>();
    final cartCubit = context.read<CartCubit>();

    //fetch the product customization item if present
    final prodWithCustomization =
        cartCubit.getSingleItemById(widget.productId)?.selectedCustomization;
    if (prodWithCustomization != null) {
      selectedCustomization = prodWithCustomization;
    }

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Customize Your Item",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          const Divider(),
          ...widget.customization!.optionData.map((data) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      data.type,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    const SizedBox(width: 4), // Small gap between texts
                    const Text(
                      "(select any one of these)",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                ...data.options.map((val) {
                  return CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          val.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 13),
                        ),
                        Text(
                          "₹${val.price}",
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Colors.teal),
                        ),
                      ],
                    ),
                    value: selectedCustomization.containsKey(data.type) &&
                        selectedCustomization[data.type] == val,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          // If checked, add the option to the map
                          selectedCustomization[data.type] = val;
                        } else {
                          // If unchecked, remove the option from the map
                          selectedCustomization.remove(data.type);
                        }
                        menuCubit.selectCustomization(selectedCustomization);

                        // widget.sendSelectedCustomization!(selectedCustomization);
                      });
                    },
                    activeColor: Colors.teal.shade700,
                  );
                }).toList(),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}
