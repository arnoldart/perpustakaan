import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LokasiUser extends StatelessWidget {
  const LokasiUser({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/dashboard_user');
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lokasi', style: TextStyle(color: Colors.white)),
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/dashboard_user');
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color(0xFF5271FF),
        ),
        body: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 300,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return Scaffold(
                        backgroundColor: Colors.black,
                        body: Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Hero(
                              tag: 'imageTag',
                              child: InteractiveViewer(
                                transformationController:
                                    TransformationController()
                                      ..value = Matrix4.identity().scaled(0.3),
                                maxScale: 5.0,
                                minScale: 0.05,
                                constrained: false,
                                child: Image.asset(
                                  'img/mapimage.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ));
                },
                child: Hero(
                  tag: 'imageTag',
                  child: Image.asset(
                    'img/mapimage.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                _launchURL('https://maps.app.goo.gl/fh3mxeqshFfRToZr6');
              },
              child: const Text(
                'https://maps.app.goo.gl/fh3mxeqshFfRToZr6',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
