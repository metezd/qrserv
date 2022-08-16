import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:oktoast/oktoast.dart';

class Panel {
  // URL launch management
  void _launchURL(Uri url, BuildContext context) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } else {
      showToast(AppLocalizations.of(context)!.info_exception_linkopenfailed +
          url.toString());
    }
  }

  // Clickable card template
  Widget cardClickable(IconData iconData, String title, String subtitle,
      Uri url, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 1,
      child: ListTile(
        visualDensity: const VisualDensity(horizontal: 0, vertical: -3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        contentPadding: const EdgeInsets.fromLTRB(30, 16, 30, 16),
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              iconData,
              color: const Color.fromRGBO(255, 255, 255, 1.0),
            ),
          ],
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14.8,
          ),
        ),
        subtitle: Column(
          children: [
            const SizedBox(height: 2.0),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
              ),
            )
          ],
        ),
        onTap: () {
          _launchURL(url, context);
        },
      ),
    );
  }

  // Panel header
  Widget panelHeader(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Column(
          children: <Widget>[
            Container(
              height: 45.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 30,
                    height: 5,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12.0))),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Panel interface
  Widget panelInterface(ScrollController sc, BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, AsyncSnapshot<PackageInfo> snapshot) {
        String packageInfo = '';
        String appName = '';
        String version = '';

        if (snapshot.hasError) {
          packageInfo = AppLocalizations.of(context)!.panel_packageinfofail;
        } else if (snapshot.hasData) {
          appName = snapshot.data?.appName ?? '(null)';
          version = snapshot.data?.version ?? '(null)';
          packageInfo = '$appName v$version';
        } else {
          packageInfo = AppLocalizations.of(context)!.info_pending_appinfo;
        }

        return MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView(
            controller: sc,
            padding: const EdgeInsets.only(left: 30.0, right: 30.0),
            children: <Widget>[
              const SizedBox(height: 70.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context)!.panel_title,
                    style: const TextStyle(
                      fontSize: 28.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    packageInfo,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              cardClickable(
                Icons.code,
                AppLocalizations.of(context)!.panel_card_opensource_title,
                AppLocalizations.of(context)!.panel_card_opensource_subtitle,
                Uri(
                    scheme: 'https',
                    host: 'github.com',
                    path: 'uintdev/qrserv'),
                context,
              ),
              const SizedBox(height: 8.0),
              cardClickable(
                Icons.local_cafe,
                AppLocalizations.of(context)!.panel_card_donate_title,
                AppLocalizations.of(context)!.panel_card_donate_subtitle,
                Uri(scheme: 'https', host: 'ko-fi.com', path: 'uintdev'),
                context,
              ),
              const SizedBox(height: 25.0),
            ],
          ),
        );
      },
    );
  }
}
