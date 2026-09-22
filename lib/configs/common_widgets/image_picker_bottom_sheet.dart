import 'package:flutter/material.dart';
import 'package:food_app/configs/resources/sizing.dart';

import '../resources/resources.dart';

class ImagePickerBottomSheet extends StatelessWidget {
  final Function onCameraClick;
  final Function onGalleryClick;
  final bool showCameraOption;
  final bool showGalleryOption;

  const ImagePickerBottomSheet({
    super.key,
    required this.onCameraClick,
    this.showCameraOption = true,
    this.showGalleryOption = true,
    required this.onGalleryClick,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            Visibility(
              visible: showCameraOption,
              child: ListTile(
                leading: Icon(Icons.photo_camera, color: R.colors.primaryColor),
                title: Text('Camera', style: R.textStyles.font16R),
                onTap: () {
                  Navigator.pop(context);
                  onCameraClick();
                  // profileProvider.pickImage(fromCamera: true);
                },
              ),
            ),
            Visibility(
              visible: showGalleryOption,
              child: ListTile(
                leading: Icon(
                  Icons.photo_library,
                  color: R.colors.primaryColor,
                ),
                title: Text(R.strings.gallery, style: R.textStyles.font16R),
                onTap: () {
                  Navigator.pop(context);
                  onGalleryClick();
                  // profileProvider.pickImage(fromCamera: false);
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.cancel, color: R.colors.primaryColor),
              title: Text(R.strings.cancel, style: R.textStyles.font16R),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
