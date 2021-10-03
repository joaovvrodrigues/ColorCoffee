import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/theme.dart';

class DescriptionPage extends StatefulWidget {
  const DescriptionPage({Key? key}) : super(key: key);

  @override
  _DescriptionPageState createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  static String letra = '''
  Meu chapa eu tô em outro estágio
Fácil, sem pagar pedágio
Ágil, eu desmontei seu raciocínio frágil
É lógico, não vim te dar diagnóstico (Não)
Porque eu me mantenho sarcástico
Esse rap não é de plástico, numeração raspada
Adesivo do Flamengo, rasgando nas madrugada
O copo é de veneno, mas a alma tá lavada
Eu conheço desde pequeno, essas ruas não passa nada
Firma de demolição, vim pra derrubar a casa
Não pra me adequar à cena, rebolar e falar água
Vim com as rimas pesada
Cheiro de prensado com cevada
Daquelas que tu não encontra na tua área
Uma rajada engatilhada, é tapa por dentro da cara
É o Iori incorporado de Kenner e Polo listrada
Eu tô com a minha tropa na estrada pra não faltar nada em casa
Só peço é por saúde pra nóis não cair na vala
Mas tem noites que eu nem durmo (Não)
Não é tão simples quanto parece (Fala)
Relações, intrigas, estresse, blasfêmias e preces
Espero que o julgamento se apresse, poucos têm o que merece
Sempre pronto pra guerra porque o jogo é desleal
Tomando decisões equilibrando o bem e o mal
O peso nos meus ombros já é mais do que o normal
Eu tô correndo atrás das notas antes que chegue no final
Vida adulta soprando, grana e problema sobrando
Tô com esse beat batendo com a caneta sangrando
Eles não sabem a metade, continuam falando
Mas eu escrevo a minha história, por isso eu sigo meu plano
Minha mãe já me dizia, quem não pode errar sou eu
E de cabeça vazia eu já vi o que aconteceu (Fala)
Falar de mim é fácil, eu quero ver fazer o que eu faço
Eu rimo sem perder o compasso enquanto o mundo se perdeu (Fala)''';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        extendBody: true,
        // appBar:
        body: Scrollbar(
          showTrackOnHover: true,
          child: ListView(
            children: [
              AppBar(
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.chevron_left_rounded,
                      color: Colors.black,
                    )),
                title: RichText(
                  text: TextSpan(
                    text: 'Color',
                    style: AppTheme.appBarText,
                    children: const <TextSpan>[
                      TextSpan(
                          text: 'coffee',
                          style: TextStyle(
                              color: Color(0xFFD4A056))) //Colors.brown)),
                    ],
                  ),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
                child: Text('Titulo',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.sourceSansPro(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w600)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ClipPath(
                        clipper: BackgroundClipper(),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.width * 0.4,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xff7f5539),
                                Color(0xffddb892),
                              ],
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomRight,
                        widthFactor: 3.3,
                        heightFactor: 1.3,
                        child: Image.asset(
                          'assets/logo/logo.png',
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.25,
                        )),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24),
                child: Text(letra,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.sourceSansPro(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ));
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
