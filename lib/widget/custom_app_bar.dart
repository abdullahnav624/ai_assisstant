// import 'package:educatro_pucon/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color? customColor;

  final IconData? leftIcon;
  final VoidCallback? onLeftIconTap;

  final IconData? rightIcon;
  final VoidCallback? onRightIconTap;

  final Color? iconColor;

  const CustomAppBar({
    super.key,
    required this.title,
    this.customColor,
    this.leftIcon,
    this.onLeftIconTap,
    this.rightIcon,
    this.onRightIconTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: kToolbarHeight,
        decoration: BoxDecoration(
          color: customColor ?? Colors.white,
          // AppColors.backgroundLight,
        ),
        child: Row(
          children: [
            // Left Icon
            SizedBox(
              width: 56,
              child:
                  leftIcon != null
                      ? IconButton(
                        icon: Icon(leftIcon, color: iconColor ?? Colors.black),
                        onPressed: onLeftIconTap,
                      )
                      : null,
            ),

            // Title
            Expanded(
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            // Right Icon
            SizedBox(
              width: 56,
              child:
                  rightIcon != null
                      ? IconButton(
                        icon: Icon(rightIcon, color: iconColor ?? Colors.black),
                        onPressed: onRightIconTap,
                      )
                      : null,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 10);
}
