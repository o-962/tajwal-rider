import 'package:flutter/material.dart';
import 'package:shared/shared/constants/colors.dart';

class SearchingAnimationWidget extends StatefulWidget {
  const SearchingAnimationWidget({super.key});

  @override
  State<SearchingAnimationWidget> createState() =>
      _SearchingAnimationWidgetState();
}

class _SearchingAnimationWidgetState extends State<SearchingAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColor.primary.withOpacity(0.1),
            blurRadius: 30,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Animated circles
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColor.primary.withOpacity(0.3 * _animation.value),
                    width: 2,
                  ),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColor.primary
                        .withOpacity(0.5 * (1 - _animation.value)),
                    width: 2,
                  ),
                ),
              );
            },
          ),
          
          // Center icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColor.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search,
              size: 50,
              color: AppColor.primary,
            ),
          ),
        ],
      ),
    );
  }
}
