import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared/shared/constants/colors.dart';
import 'package:shared/utils/parsing.dart';
import 'package:tajwal_rider/utils/map_utils.dart';

class LocationSearchWidget extends StatefulWidget {
  final String hintText;
  final TextEditingController textController;
  final void Function(String title, double lat, double lng) onLocTap;

  const LocationSearchWidget({
    super.key,
    required this.hintText,
    required this.textController,
    required this.onLocTap,
  });

  @override
  State<LocationSearchWidget> createState() => _LocationSearchWidgetState();
}

class _LocationSearchWidgetState extends State<LocationSearchWidget> {
  final List<_PlaceResult> _results = [];
  bool _isSearching = false;
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onTextChanged() {
    _debounce?.cancel();
    final query = widget.textController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _results.clear();
        _isSearching = false;
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 500), () => _search(query));
  }

  Future<void> _search(String query) async {
    setState(() => _isSearching = true);
    try {
      final places = await getNearbyPlacesWithDetails(query);
      final parsed = places
          .map((p) => _PlaceResult(
                title: (p['name'] ?? '').toString(),
                lat: toDouble(p['lat']),
                lng: toDouble(p['lng']),
              ))
          .toList();
      if (mounted) {
        setState(() => _results
          ..clear()
          ..addAll(parsed));
      }
    } catch (_) {
      // ignore search failures; keep last results
    }
    if (mounted) setState(() => _isSearching = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              controller: widget.textController,
              onChanged: (_) => _onTextChanged(),
              decoration: InputDecoration(
                hintText: widget.hintText,
                prefixIcon: const Icon(Icons.search, color: AppColor.primary),
                suffixIcon: _isSearching
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColor.primary,
                          ),
                        ),
                      )
                    : widget.textController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              widget.textController.clear();
                              setState(() => _results.clear());
                            },
                          )
                        : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          if (_results.isNotEmpty)
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 220),
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: _results.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, indent: 16),
                itemBuilder: (_, i) {
                  final r = _results[i];
                  return ListTile(
                    dense: true,
                    leading: const Icon(Icons.place, color: AppColor.primary),
                    title: Text(
                      r.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13),
                    ),
                    onTap: () {
                      widget.onLocTap(r.title, r.lat, r.lng);
                      setState(() => _results.clear());
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _PlaceResult {
  final String title;
  final double lat;
  final double lng;
  const _PlaceResult({required this.title, required this.lat, required this.lng});
}
