import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_pintar/screens/widgets/custom_dialog.dart';
import 'package:jawara_pintar/services/auth_service.dart';
import 'package:jawara_pintar/utils/app_styles.dart';
import 'package:jawara_pintar/utils/util.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {

  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  late GlobalKey _accountButtonKey;

  @override
  void initState() {
    _accountButtonKey = GlobalKey();
    super.initState();
  }

  @override
  void dispose() {
    if (_accountButtonKey.currentState != null) {
      _accountButtonKey.currentState!.dispose();
    }
    super.dispose();
  }

  void onLogout(BuildContext context) {
    CustomDialog.show(
      context: context,
      builder: (context) {
        return CustomDialog.alertDialog(
          title: const Text('Logout'),
          content: const Text("Apakah anda yakin untuk logout?"),
          actions: [
            CustomDialog.actionTextButton(
              onPressed: () => context.pop(),
              textButton: "Cancel",
            ),
            CustomDialog.actionFilledButton(
              onPressed: () async {
                await AuthService.instance.logout();
                if (!context.mounted) return;
                context.goNamed('login');
              },
              textButton: 'OK',
              customButtonColor: AppStyles.errorColor,
            )
          ],
        );
      },
    );
  }

  void showDropdownFloatingMenu(BuildContext context) {
    List<Map<String, dynamic>> dropdownValueList = [
      {
        'icon': Icons.person_2_outlined,
        'value': 'Profile',
        'color': AppStyles.primaryColor.withValues(alpha: 0.6),
        'onTap': () => context.pushNamed('profile'),
      },
      {
        'icon': Icons.logout_rounded,
        'value': 'Logout',
        'color': AppStyles.errorColor.withValues(alpha: 0.6),
        'onTap': () => onLogout(context),
      }
    ];

    Widget menuItem({
      required String value,
      required IconData iconData,
      required Color color,
    }) {
      return SizedBox(
        // width: 150,
        height: 48,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 16),
              child: Icon(iconData, color: color),
            ),
            // const SizedBox(width: 12),
            Text(value),
          ],
        ),
      );
    }

    List<PopupMenuItem> dropdownList = dropdownValueList.map<PopupMenuItem>(
      (Map<String, dynamic> dropdownValue) {
        return PopupMenuItem(
          onTap: dropdownValue['onTap'],
          child: menuItem(
            iconData: dropdownValue['icon'],
            value: dropdownValue['value'],
            color: dropdownValue['color'],
          ),
        );
      },
    ).toList();

    showMenu(
      clipBehavior: Clip.antiAlias,
      context: context,
      position: Util.getRectPositionFromAccountButtom(
        context: context,
        parentKey: _accountButtonKey,
      ),
      elevation: 4,
      menuPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.zero,
          topLeft: Radius.zero,
          bottomRight: Radius.circular(8),
          bottomLeft: Radius.circular(8),
        ),
      ),
      color: Colors.white,
      items: dropdownList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      title: Row(
        children: [
          Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              color: AppStyles.primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(
                Icons.menu_book_rounded,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
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
                key: _accountButtonKey,
                borderRadius: BorderRadius.circular(6),
                onTap: () {
                  showDropdownFloatingMenu(context);
                },
                child: Ink(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Hello, ${AuthService.instance.currentUser!.displayName}!",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
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
                        child: const Icon(
                          Icons.person,
                          size: 16,
                          color: AppStyles.primaryColor,
                        ),
                      ),
                      const Icon(Icons.more_vert_rounded),
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
