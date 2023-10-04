import 'package:sectec30/config/constants/constants.dart';
import 'package:sectec30/features/home/data/models/menu.dart';
import 'package:sectec30/features/notification/providers/notification_provider.dart';
import 'package:sectec30/features/profile/data/models/register.dart';
import 'package:sectec30/features/profile/providers/profile_provider.dart';
import 'package:sectec30/utils/alert_dialog.dart';
import 'package:sectec30/utils/cache_image_network.dart';
import 'package:sectec30/utils/key_value_storage_service_impl.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sectec30/utils/reusable_widget.dart';
import 'package:universal_io/io.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends ConsumerStatefulWidget {
  HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  final _globalWidget = ReusableWidget();
  List<Menu> menu = [];
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  late String _devicePlatform = '';

  @override
  void initState() {
    _getPlatform();
    initPlatformState();

    menu.add(Menu(
        id: 1,
        path: '/precense',
        name: 'Accesos',
        image: 'assets/images/calendar.png'));
    menu.add(Menu(
        id: 2,
        path: '/identity-card',
        name: 'Credencial\nInteligente',
        image: 'assets/images/cards.png'));
    menu.add(Menu(
        id: 4,
        path: '/notifications',
        name: 'Notificaciones',
        image: 'assets/images/notifications.png'));
    super.initState();
  }

  void _getPlatform() {
    if (kIsWeb) {
      _devicePlatform = 'Web Browser';
    } else {
      if (Platform.isAndroid) {
        _devicePlatform = 'Android Device';
      } else if (Platform.isIOS) {
        _devicePlatform = 'iOS Device';
      } else if (Platform.isLinux) {
        _devicePlatform = 'Linux Device';
      } else if (Platform.isMacOS) {
        _devicePlatform = 'MacOS Device';
      } else if (Platform.isWindows) {
        _devicePlatform = 'Windows Device';
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};
    final keyValueStorageService = KeyValueStorageServiceImpl();
    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosBuildData(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    await keyValueStorageService.setKeyValue(
        'info.deviceId', deviceData['deviceId'].toString());
    await keyValueStorageService.setKeyValue(
        'info.brand', deviceData['brand'].toString());
    await keyValueStorageService.setKeyValue(
        'info.model', deviceData['model'].toString());
    await keyValueStorageService.setKeyValue(
        'info.os', Platform.isAndroid ? 'android' : 'ios');
    await keyValueStorageService.setKeyValue(
        'info.version', deviceData['version'].toString());
    ref.read(saveTokenDeviceProvider);
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo androidInfo) {
    return <String, String>{
      "deviceId": androidInfo.id,
      "brand": androidInfo.brand,
      "model": androidInfo.model,
      "os": androidInfo.serialNumber,
      "version": androidInfo.version.release,
    };
  }

  Map<String, dynamic> _readIosBuildData(IosDeviceInfo iosDeviceInfo) {
    return <String, String>{
      "deviceId": iosDeviceInfo.identifierForVendor!,
      "brand": 'Apple',
      "model": iosDeviceInfo.model,
      "os": iosDeviceInfo.systemName,
      "version": iosDeviceInfo.systemVersion,
    };
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          title: const Text('SECTEC 30'),
          leading: Image.asset('assets/images/logo.png', height: 24),
          actions: <Widget>[
            /* IconButton(
                icon: _globalWidget.customNotifIcon(
                    count: 0, notifColor: Colors.red),
                onPressed: null), */
            IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => context.push('/settings'))
          ]),
      body: Stack(
        children: [
          const Positioned.fill(
            //
            child: Image(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.fill,
            ),
          ),
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [_buildTop(profile), _createMenu()],
          )
        ],
      ),
    );
  }

  Widget _buildTop(Registration profile) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              context.push('/profile');
            },
            child: Hero(
                tag: 'profilePicture',
                child: profile.studentPhotoPath == null
                    ? ClipOval(
                        child: Image.asset(
                        'assets/images/icon_man.png',
                        width: 50,
                      ))
                    : ClipOval(
                        child: buildCacheNetworkImage(
                            width: 50,
                            height: 50,
                            url:
                                "https://drive.google.com/uc?id=${profile.studentPhotoPath}"))),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      profile.names == null
                          ? 'Cargando...'
                          : '${profile.names!} ${profile.surnames!}',
                      style: const TextStyle(
                          color: black21,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            width: 1,
            height: 40,
            color: Colors.grey[300],
          ),
          IconButton(
              // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
              icon: FaIcon(
                FontAwesomeIcons.whatsapp,
                size: 40,
                color: softGreen,
              ),
              onPressed: () async {
                final Uri url = Uri.parse(
                    "whatsapp://send?phone=$whatsappNumber&text=$whatsappText, ");
                try {
                  launchUrl(url);
                } catch (e) {
                  await NotifyUI.showBasic(
                      context, 'Aviso', 'WhatsApp no instalado');
                }
              })
        ],
      ),
    );
  }

  Widget _createMenu() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      children: List.generate(menu.length, (index) {
        return GestureDetector(
            onTap: () {
              context.push(menu[index].path);
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  border: Border.all(color: softGrey, width: 2)),
              padding: const EdgeInsets.all(8),
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Image.asset(
                      menu[index].image,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Text(
                        menu[index].name,
                        style: const TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ])),
            ));
      }),
    );
  }
}
