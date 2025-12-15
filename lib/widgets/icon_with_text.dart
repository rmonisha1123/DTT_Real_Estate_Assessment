import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../theme/app_theme.dart';

class IconWithText extends StatelessWidget {
  final String iconPath;
  final String text;

  const IconWithText({
    super.key,
    required this.iconPath,
    required this.text,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          iconPath,
          width: 16,
          height: 16,
          colorFilter: const ColorFilter.mode(
            AppColors.textMedium,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: AppTextStyles.detail.copyWith(
              color: AppColors.textMedium,
              fontWeight: FontWeight.w400,
              fontSize: 10),
        ),
      ],
    );
  }
}
