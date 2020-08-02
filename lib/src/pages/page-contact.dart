import 'package:flutter/material.dart';
import 'package:notify/src/global/config.dart';
import 'package:notify/src/widgets/drawer-custom.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class ContactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Notify',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
          margin: EdgeInsets.fromLTRB(
              Config.dw * 0.1, 0, Config.dw * 0.1, Config.dw * 0.06),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[_body(), _devEmail()],
          )),
    );
  }

  Widget _body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _text('Contattaci'),
        _links(),
        _text('Community'),
        _socialIcons(),
      ],
    );
  }

  Widget _devEmail() {
    return GestureDetector(
      onTap: () {
        launcher.launch('mailto:dev.lorenzoconti@gmail.com');
      },
      child: Text(
        'App Developer: dev.lorenzoconti@gmail.com',
        style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
      ),
    );
  }

  Widget _text(String text) {
    return Container(
      margin: EdgeInsets.only(top: Config.dh * 0.025, bottom: Config.dh * 0.05),
      child: Text(
        text,
        style: TextStyle(
            color: Colors.grey.shade200,
            fontSize: 20,
            fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _links() {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _contactRow('notifyrev.com', 'assets/icon/web-grey.png',
            'http://notifyrev.com'),
        _emailRow('dev.contilorenzo@gmail.com'),
      ],
    ));
  }

  Widget _contactRow(String title, String iconpath, [String url]) {
    return Container(
        margin: EdgeInsetsDirectional.only(bottom: Config.dh * 0.025),
        child: GestureDetector(
          onTap: () {
            _launchURL(url);
          },
          child: Row(
            children: <Widget>[
              Image(image: AssetImage(iconpath), height: 25),
              SizedBox(width: Config.dw * 0.065),
              Text(title,
                  style: TextStyle(color: Colors.grey.shade200, fontSize: 15))
            ],
          ),
        ));
  }

  Widget _emailRow(String email) {
    return Container(
        margin: EdgeInsetsDirectional.only(bottom: Config.dh * 0.025),
        child: GestureDetector(
          onTap: () {
            _sendEmail(email);
          },
          child: Row(
            children: <Widget>[
              Icon(
                Icons.email,
                color: Colors.grey.shade200,
                size: 25,
              ),
              SizedBox(width: Config.dw * 0.065),
              Text(email,
                  style: TextStyle(color: Colors.grey.shade200, fontSize: 15))
            ],
          ),
        ));
  }

  Widget _socialIcons() {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _contactRow('Canale Discord', 'assets/icon/discord-grey.png',
            'https://discord.gg/6TzPfaV'),
        _contactRow('Canale Telegram', 'assets/icon/telegram-grey.png',
            'https://t.me/joinchat/AAAAAFHn1PKHi52kIZUNFw'),
        _contactRow('Pagina Facebook', 'assets/icon/facebook-grey.png',
            'https://www.facebook.com/notifyMetin2/')
      ],
    ));
  }

  void _launchURL(String url) async {
    await launcher.launch(url);
  }

  void _sendEmail(String email) async {
    await launcher.launch('mailto:$email');
  }
}
