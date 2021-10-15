import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../model/card_info.dart';

import '../../theme/theme.dart';

class DescriptionPage extends StatefulWidget {
  const DescriptionPage({
    Key? key,
    required this.cardInfo,
  }) : super(key: key);
  final CardInfo cardInfo;

  @override
  State<DescriptionPage> createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  late ScrollController _scrollController;
  Color _textColor = Colors.white;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _textColor = _isSliverAppBarExpanded ? AppTheme.black : Colors.white;
        });
      });
  }

  bool get _isSliverAppBarExpanded {
    return _scrollController.hasClients &&
        _scrollController.offset > (200 - kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            floating: false,
            pinned: true,
            leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Platform.isAndroid
                      ? Icons.arrow_back
                      : Icons.arrow_back_ios_new_rounded,
                  color: _textColor,
                )),
            expandedHeight: 250.0,
            flexibleSpace: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
              child: FlexibleSpaceBar(
                title: Hero(
                  tag: 'teste',
                  child: Text(
                      '${widget.cardInfo.title} ${widget.cardInfo.subtitle}',
                      style: GoogleFonts.sourceSansPro(
                          color: _textColor, fontWeight: FontWeight.w600),
                      textScaleFactor: 1),
                ),
                background: Image.asset(
                  widget.cardInfo.imagePath,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 24),
                  child: Text(widget.cardInfo.text,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.sourceSansPro(
                          color: AppTheme.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w600)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 24),
                  child: Text(widget.cardInfo.text,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.sourceSansPro(
                          color: AppTheme.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w600)),
                ),
                Center(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 2, bottom: 12.0),
                  child: Text(
                      'Fundo foto criado por ${widget.cardInfo.imageAuthor}',
                      style: GoogleFonts.sourceSansPro(
                        color: AppTheme.black,
                        fontSize: 12,
                      )),
                ))
              ],
            ),
          )
        ],
      ),
    );

    // Padding(
    //   padding: const EdgeInsets.symmetric(vertical: 8.0),
    //   child: Stack(
    //     children: [
    //       // Align(
    //       //   alignment: Alignment.bottomRight,
    //       //   child: ClipPath(
    //       //     clipper: BackgroundClipper(),
    //       //     child: Container(
    //       //       width: MediaQuery.of(context).size.width * 0.5,
    //       //       height: MediaQuery.of(context).size.width * 0.4,
    //       //       decoration: const BoxDecoration(
    //       //         gradient: LinearGradient(
    //       //           colors: [
    //       //             Color(0xff7f5539),
    //       //             Color(0xff7f5500),
    //       //           ],
    //       //           begin: Alignment.topRight,
    //       //           end: Alignment.bottomLeft,
    //       //         ),
    //       //       ),
    //       //     ),
    //       //   ),
    //       // ),
    //       Align(
    //           alignment: Alignment.bottomRight,
    //           widthFactor: 1.2,
    //           // heightFactor: 1,
    //           child: ClipRRect(
    //             borderRadius: BorderRadius.circular(AppTheme.radius),
    //             child: Image.asset(
    //               widget.cardInfo.imagePath,
    //               alignment: Alignment.center,
    //               width: MediaQuery.of(context).size.width * 0.7,
    //             ),
    //           )

    //           // Image.asset(
    //           //   'assets/logo/logo.png',
    //           //   alignment: Alignment.center,
    //           //   width: MediaQuery.of(context).size.width * 0.25,
    //           // )

    //           ),
    //     ],
    //   ),
    // ),
  }
}

class BackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var roundnessFactor = 20.0;

    var path = Path();

    path.moveTo(0, size.height * 0.60);
    path.lineTo(0, size.height - roundnessFactor);
    path.quadraticBezierTo(0, size.height, roundnessFactor, size.height);

    path.lineTo(size.width, size.height);

    path.lineTo(size.width, roundnessFactor * 2);
    path.quadraticBezierTo(size.width - 10, roundnessFactor,
        size.width - roundnessFactor * 2, roundnessFactor * 1.5);

    path.lineTo(
        roundnessFactor * 0.6, size.height * 0.60 - roundnessFactor * 0.3);
    path.quadraticBezierTo(
        0, size.height * 0.60, 0, size.height * 0.60 + roundnessFactor);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
