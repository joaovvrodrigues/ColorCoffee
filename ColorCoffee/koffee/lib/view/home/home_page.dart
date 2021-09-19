import 'package:flutter/material.dart';
import 'package:koffee/model/roast.dart';
import 'package:koffee/theme/theme.dart';
import 'package:koffee/view/home/home_controller.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  HomeController controller = HomeController();
  late ThemeChanger _themeProvider;

  @override
  Widget build(BuildContext context) {
    _themeProvider = context.read<ThemeChanger>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Koffee'),
      ),
      body: ValueListenableBuilder<Roast?>(
          valueListenable: controller.roast,
          builder: (BuildContext context, Roast? value, __) {
            return Center(
              child: value == null
                  ? const Text(
                      'Envie foto',
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'Amostra',
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 180,
                            width: 180,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: controller.color),
                          ),
                        ),
                        const Text('Agtron', style: TextStyle(fontSize: 22)),
                        Text(value.prediction,
                            style: const TextStyle(fontSize: 60)),
                        const SizedBox(height: 20),
                        const Text('confiança'),
                        Text('${value.confidence}%'),
                      ],
                    ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await controller.getRandomColor();
          changeTheme();
        },
        tooltip: 'Send Image',
        child: const Icon(Icons.photo_library_rounded),
      ),
    );
  }

  void changeTheme() {
    _themeProvider.setTheme(koffeTheme.copyWith(
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: controller.color,
        hoverColor: controller.color.withAlpha(100),
        focusColor: controller.color.withAlpha(100),
        splashColor: controller.color.withAlpha(100),
      ),
      scaffoldBackgroundColor: controller.color.withAlpha(210),
      appBarTheme: AppBarTheme(
          shadowColor: controller.color.withAlpha(100),
          centerTitle: true,
          backgroundColor: controller.color),
    ));
  }
}
