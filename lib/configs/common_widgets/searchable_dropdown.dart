import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:food_app/configs/resources/sizing.dart';

import '../resources/resources.dart';

class SearchableDropdownField<T> extends StatefulWidget {
  const SearchableDropdownField({
    super.key,
    required this.name,
    required this.hint,
    required this.items,
    required this.displayText,
    this.onChanged,
    this.initialValue,
    this.validator,
    this.enabled = true,
    this.fillColor,
    this.borderRadius,
    this.suffixIcon,
    this.width = double.infinity,
    this.searchHint = "Search...",
    this.noItemsText = "No items found",
    this.maxHeight = 200,
  });

  final String name;
  final String hint;
  final List<T> items;
  final String Function(T) displayText;
  final T? initialValue;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final bool enabled;
  final Color? fillColor;
  final double? borderRadius;
  final Widget? suffixIcon;
  final double width;
  final String searchHint;
  final String noItemsText;
  final double maxHeight;

  @override
  State<SearchableDropdownField<T>> createState() =>
      _SearchableDropdownFieldState<T>();
}

class _SearchableDropdownFieldState<T>
    extends State<SearchableDropdownField<T>> {
  T? selectedValue;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool isExpanded = false;
  List<T> filteredItems = [];
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _dropdownKey = GlobalKey();
  FormFieldState<T>? _formFieldState;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
    filteredItems = widget.items;
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _removeOverlay();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus && !isExpanded) {
      _showOverlay();
    }
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredItems = widget.items;
      } else {
        filteredItems =
            widget.items
                .where(
                  (item) => widget
                      .displayText(item)
                      .toLowerCase()
                      .contains(query.toLowerCase()),
                )
                .toList();
      }
    });
    _updateOverlay();
  }

  void _showOverlay() {
    if (isExpanded) return;

    setState(() {
      isExpanded = true;
    });

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
    if (isExpanded) {
      setState(() {
        isExpanded = false;
      });
    }
  }

  void _updateOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox =
        _dropdownKey.currentContext!.findRenderObject() as RenderBox;
    Size size = renderBox.size;

    return OverlayEntry(
      builder:
          (context) => Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0.0, size.height),
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 30),
                child: Container(
                  constraints: BoxConstraints(maxHeight: widget.maxHeight),
                  decoration: BoxDecoration(
                    color: widget.fillColor ?? R.colors.whiteColor,
                    borderRadius: BorderRadius.circular(
                      widget.borderRadius ?? 30,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: R.colors.primaryColor15,
                        offset: Offset(0, 5),
                        blurRadius: 10,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Search field
                      Container(
                        padding: EdgeInsets.all(12),
                        child: TextField(
                          controller: _searchController,
                          style: R.textStyles.font16R,
                          onChanged: _filterItems,
                          decoration: InputDecoration(
                            hintText: widget.searchHint,
                            hintStyle: R.textStyles.font16R.copyWith(
                              color: R.colors.blackTextColor50,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: R.colors.primaryColor,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: R.colors.primaryColor15,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: R.colors.primaryColor,
                                width: 1,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: R.colors.primaryColor15,
                                width: 1,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),

                      // Divider
                      Divider(height: 1, color: R.colors.primaryColor15),

                      // Items list
                      Flexible(
                        child:
                            filteredItems.isEmpty
                                ? Container(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.search_off,
                                        size: 32,
                                        color: R.colors.blackTextColor50,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        widget.noItemsText,
                                        style: R.textStyles.font16R.copyWith(
                                          color: R.colors.blackTextColor50,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                : ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemCount: filteredItems.length,
                                  itemBuilder: (context, index) {
                                    final item = filteredItems[index];
                                    final isSelected = item == selectedValue;

                                    return InkWell(
                                      onTap:
                                          () => _selectItem(
                                            item,
                                            _formFieldState!,
                                          ),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 40,
                                          vertical: 14,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              isSelected
                                                  ? R.colors.primaryColor
                                                      .withValues(alpha: 0.1)
                                                  : Colors.transparent,
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                widget.displayText(item),
                                                style: R.textStyles.font16R
                                                    .copyWith(
                                                      color:
                                                          isSelected
                                                              ? R
                                                                  .colors
                                                                  .primaryColor
                                                              : R
                                                                  .colors
                                                                  .blackTextColor,
                                                      fontWeight:
                                                          isSelected
                                                              ? FontWeight.w600
                                                              : FontWeight
                                                                  .normal,
                                                    ),
                                              ),
                                            ),
                                            if (isSelected)
                                              Icon(
                                                Icons.check,
                                                color: R.colors.primaryColor,
                                                size: 20,
                                              ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }

  // void _selectItem(T item) {
  //   setState(() {
  //     selectedValue = item;
  //   });
  //   _searchController.clear();
  //   _removeOverlay();
  //   _focusNode.unfocus();
  //   widget.onChanged?.call(item);
  //   filteredItems = widget.items; // Reset filter
  // }
  void _selectItem(T item, FormFieldState<T> field) {
    setState(() {
      selectedValue = item;
    });
    field.didChange(item); // <- Notify form field of the change
    _searchController.clear();
    _removeOverlay();
    _focusNode.unfocus();
    widget.onChanged?.call(item);
    filteredItems = widget.items; // Reset filter
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        key: _dropdownKey,
        width: widget.width,
        decoration: BoxDecoration(
          color: widget.fillColor ?? R.colors.whiteColor,
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 30),
          boxShadow: [
            BoxShadow(
              color: R.colors.primaryColor15,
              offset: Offset(0, 5),
              blurRadius: 0,
              spreadRadius: 0,
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return FormBuilderField<T>(
              name: widget.name,
              initialValue: selectedValue,
              validator: widget.validator,
              enabled: widget.enabled,
              builder: (FormFieldState<T> field) {
                _formFieldState = field;
                return GestureDetector(
                  onTap:
                      widget.enabled
                          ? () {
                            if (isExpanded) {
                              _removeOverlay();
                            } else {
                              _focusNode.requestFocus();
                              _showOverlay();
                            }
                          }
                          : null,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 25.w,
                      vertical: 17.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        widget.borderRadius ?? 30,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            selectedValue != null
                                ? widget.displayText(selectedValue as T)
                                : widget.hint,
                            style:
                                selectedValue != null
                                    ? R.textStyles.font16R
                                    : R.textStyles.font16R.copyWith(
                                      color: R.colors.blackTextColor50,
                                    ),
                          ),
                        ),
                        widget.suffixIcon ??
                            AnimatedRotation(
                              turns: isExpanded ? 0.5 : 0,
                              duration: Duration(milliseconds: 200),
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: R.colors.primaryColor,
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
      ),
    );
  }
}
