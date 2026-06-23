import 'package:flutter/material.dart';
import 'package:shared/shared/constants/colors.dart';

class DetailRowWidget extends StatelessWidget {
  final String label;
  final String value;
  final bool highlighted;

  const DetailRowWidget(this.label, this.value, {super.key, this.highlighted = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: highlighted ? AppColor.primary : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
