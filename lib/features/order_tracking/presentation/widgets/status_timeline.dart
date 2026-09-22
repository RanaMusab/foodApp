import 'package:flutter/material.dart';
import 'package:food_app/configs/resources/resources.dart';
import 'package:food_app/configs/resources/sizing.dart';
import 'package:food_app/features/order_tracking/domain/entities/order_status.dart';

class StatusTimeline extends StatelessWidget {
  const StatusTimeline({super.key, required this.current});

  final OrderStatus current;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final status in OrderStatus.values)
          _TimelineRow(
            status: status,
            isDone: status.index < current.index,
            isCurrent: status == current,
            isLast: status == OrderStatus.values.last,
          ),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.status,
    required this.isDone,
    required this.isCurrent,
    required this.isLast,
  });

  final OrderStatus status;
  final bool isDone;
  final bool isCurrent;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final isActive = isDone || isCurrent;
    final color = isActive ? R.colors.primaryColor : R.colors.disableIcon;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 22.w,
                width: 22.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? color : R.colors.white,
                  border: Border.all(color: color, width: 2),
                ),
                child: isDone
                    ? Icon(Icons.check, size: 14.w, color: R.colors.white)
                    : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: EdgeInsets.symmetric(vertical: 2.h),
                    color: isDone ? R.colors.primaryColor : R.colors.disableIcon,
                  ),
                ),
            ],
          ),
          12.wBox,
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 18.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status.title,
                    style: isCurrent
                        ? R.textStyles.font14B
                        : R.textStyles.font14R.copyWith(
                            color: isActive
                                ? R.colors.textColor
                                : R.colors.hintColor,
                          ),
                  ),
                  if (isCurrent) ...[
                    2.hBox,
                    Text(
                      status.subtitle,
                      style: R.textStyles.font12R.copyWith(
                        color: R.colors.lightGreyColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
