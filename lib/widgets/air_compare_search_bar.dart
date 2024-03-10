import 'package:envi_metrix/core/themes/app_colors.dart';
import 'package:envi_metrix/features/app/cubits/app_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AirCompareSearchBar extends StatefulWidget {
  const AirCompareSearchBar({super.key, this.onSelected});

  final Function(String)? onSelected;

  @override
  State<AirCompareSearchBar> createState() => _AirCompareSearchBarState();
}

class _AirCompareSearchBarState extends State<AirCompareSearchBar> {
  late AppCubit _appCubit;

  @override
  void initState() {
    super.initState();

    _appCubit = context.read<AppCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(left: 10.w),
        child: Column(
          children: [
            Gap(10.h),
            Row(
              children: [
                _buildSearchBar(),
                Gap(20.w),
                _buildCloseIcon()
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCloseIcon() {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Icon(Icons.clear, size: 28.w, color: Colors.black,),
    );
  }

  Widget _buildSearchBar() {
    return SizedBox(
        width: 270.w,
        child: Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text == '') {
              return const Iterable<String>.empty();
            }

            return _appCubit.cityNames.where((element) {
              return element.contains(textEditingValue.text);
            });
          },
          onSelected: (selectedText) {
            widget.onSelected?.call(selectedText);
          },

          // optionsViewBuilder: ((context, onSelected, options) {
          //   retur
          // }),
          fieldViewBuilder:
              (context, controller, focusNode, onEditingComplete) {
            return TextFormField(
              controller: controller,
              focusNode: focusNode,
              cursorColor: AppColors.searchBarCursor,
              style: TextStyle(fontSize: 20.w),
              cursorHeight: 22.h,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    fontSize: 17.w,
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 5.w),
                    child: Icon(
                      Icons.search,
                      size: 24.w,
                    ),
                  ),
                  // suffixIcon: _buildSuffixIcon(context),
                  enabledBorder: _getBorder(AppColors.searchBarBorder, 10),
                  focusedBorder:
                      _getBorder(AppColors.searchBarBorderFocused, 10)),
              onTapOutside: (event) => focusNode.unfocus(),
            );
          },
        ));
  }

  OutlineInputBorder _getBorder(Color borderColor, double borderRadius) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(color: borderColor, width: 1.5),
    );
  }

  // Widget _buildSuffixIcon(BuildContext context) {

  // }
}
