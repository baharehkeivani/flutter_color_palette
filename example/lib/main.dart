import 'package:flutter/material.dart';
import 'package:flutter_color_palette/flutter_color_palette.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Custom Color Picker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.grey, onPrimary: Colors.greenAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Custom Color Picker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Color> colorsList = [Colors.red, Colors.yellow];
  GradientStyle gradientStyle = gradientStyles[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .onPrimary,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
          child: Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            width: MediaQuery
                .sizeOf(context)
                .width * 0.5,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTapUp: (details) => _onPaletteClicked(details),
                    child: Container(
                      height: 14,
                      width: 14,
                      decoration: BoxDecoration(
                        color:
                        colorsList.length == 1 ? colorsList.first : null,
                        gradient: colorsList.length > 1
                            ? LinearGradient(
                            colors: List.from(colorsList),
                            begin: gradientStyle.start,
                            end: gradientStyle.end)
                            : null,
                        border: Border.all(color: Colors.black, width: 0.5),
                      ),
                    ),
                  ),
                  const Spacer(flex: 1),
                  colorsList.length == 1
                      ? Text(colorsList.first == Colors.transparent
                      ? "FFFFFF"
                      : colorsList.first.value
                      .toRadixString(16)
                      .substring(2)
                      .toUpperCase())
                      : const Text("Gradient"),
                  const Spacer(flex: 2),
                  colorsList.length == 1
                      ? Text(
                      "${(colorsList[0].opacity * 100).round()}%")
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          )
      ),
    );
  }

  void _onPaletteClicked(TapUpDetails details) {
    showMenu(
      context: context,
      surfaceTintColor: Colors.transparent,
      color: Colors.white,
      shadowColor: Colors.black,
      position: RelativeRect.fromLTRB(
        details.globalPosition.dx,
        details.globalPosition.dy,
        details.globalPosition.dx,
        details.globalPosition.dy,
      ),
      items: [
        PopupMenuItem(
            padding: const EdgeInsets.all(8.0),
            enabled: false,
            child: StatefulBuilder(
              builder: (context, menuSetState) =>
                  ColorPalette(
                    colors: colorsList,gradientStyle: gradientStyle,
                    onChangeColors: (newColors) {
                      setState(() {
                        colorsList = newColors;
                      });
                    },
                    onChangeStyle: (newStyle) {
                      setState(() {
                        gradientStyle = newStyle;
                      });
                    },
                  ),
            ))
      ],
    );
  }
}
