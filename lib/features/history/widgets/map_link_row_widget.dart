import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/shared/constants/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class MapLinkRowWidget extends StatelessWidget {
  final String label;
  final double lat;
  final double lng;
  final String address;

  const MapLinkRowWidget({
    super.key,
    required this.label,
    required this.lat,
    required this.lng,
    required this.address,
  });

  Future<void> _openInMaps() async {
    final uri = Uri.parse('https://www.google.com/maps?q=$lat,$lng');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
        const SizedBox(height: 4),
        Text(
          address,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        TextButton.icon(
          onPressed: _openInMaps,
          icon: const Icon(Icons.open_in_new, size: 16),
          label: Text('open_in_maps'.tr),
          style: TextButton.styleFrom(
            foregroundColor: AppColor.primary,
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    );
  }
}
