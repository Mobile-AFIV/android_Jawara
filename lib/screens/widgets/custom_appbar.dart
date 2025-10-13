import 'package:flutter/material.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              color: AppStyles.primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(
                Icons.menu_book_rounded,
                size: 16,
                color: Colors.white,
                // color: AppStyles.primaryColor,
              ),
            ),
          ),
          SizedBox(width: 8),
          Text(
            "Jawara\nPintar",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {},
                child: Ink(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          Text(
                            "Hello, Admin Jawara",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "admin1@gmail.com",
                            style: TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      // Container(
                      //   height: 32,
                      //   width: 32,
                      //   decoration: BoxDecoration(
                      //     color: AppStyles.primaryColor.withValues(alpha: 0.2),
                      //     borderRadius: BorderRadius.circular(50),
                      //   ),
                      //   child: Center(
                      //     child: Icon(
                      //       Icons.person,
                      //       size: 16,
                      //       color: AppStyles.primaryColor,
                      //     ),
                      //   ),
                      // ),
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: AppStyles.primaryColor.withValues(
                          alpha: 0.2,
                        ),
                        child: Icon(
                          Icons.person,
                          size: 16,
                          color: AppStyles.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
