import 'package:flutter/material.dart';

class ShimmerWidget extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final EdgeInsets? margin;

  const ShimmerWidget({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
    this.margin,
  });

  @override
  State<ShimmerWidget> createState() => _ShimmerWidgetState();
}

class _ShimmerWidgetState extends State<ShimmerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
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
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
      ),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.grey.shade300,
                  Colors.grey.shade100,
                  Colors.grey.shade300,
                ],
                stops: [
                  0.0,
                  _animation.value,
                  1.0,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Shimmer untuk Profile Avatar
class ProfileAvatarShimmer extends StatelessWidget {
  const ProfileAvatarShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey.shade300,
              width: 3,
            ),
          ),
          child: const ShimmerWidget(
            width: 100,
            height: 100,
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
        ),
        const SizedBox(height: 16),
        const ShimmerWidget(
          width: 150,
          height: 24,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        const SizedBox(height: 8),
        const ShimmerWidget(
          width: 100,
          height: 16,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

// Shimmer untuk Info Card
class InfoCardShimmer extends StatelessWidget {
  const InfoCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const ShimmerWidget(
            width: 36,
            height: 36,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerWidget(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 12,
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                ),
                const SizedBox(height: 8),
                ShimmerWidget(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 16,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Shimmer untuk List Item (Pengeluaran/Pemasukan)
class ListItemShimmer extends StatelessWidget {
  const ListItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerWidget(
            width: 4,
            height: 60,
            borderRadius: BorderRadius.all(Radius.circular(2)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerWidget(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: 12,
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                ),
                const SizedBox(height: 8),
                ShimmerWidget(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 16,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShimmerWidget(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: 14,
                      borderRadius: const BorderRadius.all(Radius.circular(7)),
                    ),
                    ShimmerWidget(
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: 12,
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Shimmer untuk Kategori Item
class KategoriItemShimmer extends StatelessWidget {
  const KategoriItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ShimmerWidget(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 16,
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  const SizedBox(width: 8),
                  const ShimmerWidget(
                    width: 80,
                    height: 12,
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                ],
              ),
              const ShimmerWidget(
                width: 20,
                height: 20,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ShimmerWidget(
            width: MediaQuery.of(context).size.width * 0.35,
            height: 14,
            borderRadius: const BorderRadius.all(Radius.circular(7)),
          ),
        ],
      ),
    );
  }
}

// Shimmer untuk Tagihan Item
class TagihanItemShimmer extends StatelessWidget {
  const TagihanItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerWidget(
                width: MediaQuery.of(context).size.width * 0.4,
                height: 16,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              const ShimmerWidget(
                width: 70,
                height: 20,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ShimmerWidget(
            width: MediaQuery.of(context).size.width * 0.6,
            height: 14,
            borderRadius: const BorderRadius.all(Radius.circular(7)),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerWidget(
                width: MediaQuery.of(context).size.width * 0.3,
                height: 14,
                borderRadius: const BorderRadius.all(Radius.circular(7)),
              ),
              const ShimmerWidget(
                width: 60,
                height: 20,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Shimmer untuk Stats Card
class StatsCardShimmer extends StatelessWidget {
  const StatsCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const ShimmerWidget(
                width: 120,
                height: 16,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              ShimmerWidget(
                width: 60,
                height: 24,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const ShimmerWidget(
                      width: 40,
                      height: 40,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    const SizedBox(height: 8),
                    ShimmerWidget(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: 12,
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const ShimmerWidget(
                      width: 40,
                      height: 40,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    const SizedBox(height: 8),
                    ShimmerWidget(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: 12,
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          ...List.generate(
            2,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ShimmerWidget(
                width: double.infinity,
                height: 50,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
