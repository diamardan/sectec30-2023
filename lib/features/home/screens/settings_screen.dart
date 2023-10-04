import 'package:sectec30/config/constants/constants.dart';
import 'package:sectec30/config/router/app_router.dart';
import 'package:sectec30/features/authentication/providers/auth_provider.dart';
import 'package:sectec30/features/profile/data/models/register.dart';
import 'package:sectec30/features/profile/providers/profile_provider.dart';
import 'package:sectec30/utils/cache_image_network.dart';
import 'package:sectec30/utils/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  SettingsScreen({super.key});
  final _reusableWidget = ReusableWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    return Scaffold(
        appBar: AppBar(
            title: const Text(
          'General',
        )),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _createAccountInformation(context, profile, ref),
            _reusableWidget.divider1(),
            _createListMenu(context, 'Acerca', '/about'),
            _reusableWidget.divider1(),
            _reusableWidget.divider1(),
            _createListMenu(context, 'Aviso de privacidad', '/privacy-policy'),
            _reusableWidget.divider1(),
            const SizedBox(
              height: 50,
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 18, 0, 0),
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  ref.read(authProvider.notifier).logout();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.power_settings_new, size: 20, color: red),
                    SizedBox(width: 8),
                    Text('Cerrar sesión',
                        style: TextStyle(fontSize: 15, color: red)),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _createAccountInformation(context, Registration profile, ref) {
    final double profilePictureSize = MediaQuery.of(context).size.width / 4;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: profilePictureSize,
            height: profilePictureSize,
            child: GestureDetector(
              onTap: () {
                context.push('/profile');
              },
              child: CircleAvatar(
                backgroundColor: Colors.grey[200],
                radius: profilePictureSize,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: profilePictureSize - 4,
                  child: Hero(
                    tag: 'profilePicture',
                    child: ClipOval(
                        child: buildCacheNetworkImage(
                            width: profilePictureSize - 4,
                            height: profilePictureSize - 4,
                            url:
                                "https://drive.google.com/uc?id=${profile.studentPhotoPath}")),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${profile.names} ${profile.surnames}',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(profile.email!),
                const SizedBox(
                  height: 8,
                ),

                /*GestureDetector(
                  onTap: () {
                    final appRouter = ref.read(goRouterProvider);
                    appRouter.push('/profile');
                  },
                  child: const Row(
                    children: [
                      Text('Mi perfil',
                          style: TextStyle(fontSize: 14, color: blackGrey)),
                      SizedBox(
                        width: 8,
                      ),
                      Icon(Icons.chevron_right, size: 20, color: softGrey)
                    ],
                  ),
                )*/
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _createListMenu(ref, String menuTitle, String page) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        final appRouter = ref.read(goRouterProvider);
        appRouter.push(page);
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 18, 0, 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(menuTitle,
                style: const TextStyle(fontSize: 15, color: black21)),
            const Icon(Icons.chevron_right, size: 20, color: softGrey),
          ],
        ),
      ),
    );
  }
}
