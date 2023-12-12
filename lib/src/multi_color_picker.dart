import 'package:flutter/material.dart';
import 'package:flutter_color_palette/flutter_color_picker.dart';

class MultiColorPicker extends StatefulWidget {
  final void Function(List<Color>) onChangeColors;
  final void Function(GradientStyle)? onChangeStyle;
  final List<Color> colors;
  final GradientStyle? gradientStyle;
  final bool canBeGradient;

  const MultiColorPicker({
    Key? key,
    required this.colors,
    required this.onChangeColors,
    this.gradientStyle,
    this.onChangeStyle,
    this.canBeGradient = true,
  }) : super(key: key);

  @override
  State<MultiColorPicker> createState() => _MultiColorPickerState();
}

class _MultiColorPickerState extends State<MultiColorPicker> {
  List<GradientStyle> styles = [
    GradientStyle(Alignment.topCenter, Alignment.bottomCenter), //transverse |
    GradientStyle(Alignment.topLeft, Alignment.bottomRight), // diagonal \
    GradientStyle(Alignment.centerLeft, Alignment.centerRight), // longitudinal --
  ];
  int currentColorIndex = 0;
  int currentStyleIndex = 0;
  final textController = TextEditingController(text: '#FFFFFF');
  final double _iconSize = 30;

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(4.0),
          child: Text("To delete a color double tap."),
        ),
        Wrap(
          spacing: 5.0,
          runSpacing: 5.0,
          runAlignment: WrapAlignment.spaceBetween,
          children: List.generate(
            widget.colors.length + 1,
                (index) {
              return index < widget.colors.length
                  ? InkWell(
                onDoubleTap: () => _onDoubleTap(index, setState),
                onTap: () => _onSelectColor(index, setState),
                child: index != currentColorIndex
                    ? Container(
                  color: widget.colors[index],
                  width: _iconSize,
                  height: _iconSize,
                )
                    : Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                      color: widget.colors[index],
                      border: index == currentColorIndex
                          ? Border.all(color: Colors.black, width: 2)
                          : null),
                  width: _iconSize,
                  height: _iconSize,
                ),
              )
                  : InkWell(
                onTap: () => _onAddColor(setState),
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.black, width: 2)),
                  width: _iconSize,
                  height: _iconSize,
                  child: const Icon(
                    Icons.add,
                    size: 12,
                    color: Colors.black,
                  ),
                ),
              );
            },
          ),
        ),
        if (widget.colors.length > 1 && widget.canBeGradient)
          const Padding(
            padding: EdgeInsets.all(4.0),
            child: Text("Style"),
          ),
        if (widget.colors.length > 1 && widget.canBeGradient)
          Wrap(
            spacing: 5.0,
            runSpacing: 5.0,
            runAlignment: WrapAlignment.spaceBetween,
            children: List.generate(
              3,
                  (index) {
                return InkWell(
                    onTap: () => _onSelectStyle(index, setState),
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: const [Colors.black, Colors.grey],
                              begin: styles[index].start,
                              end: styles[index].end),
                          border: currentStyleIndex == index
                              ? Border.all(color: Colors.black, width: 2)
                              : null),
                      width: _iconSize,
                      height: _iconSize,
                    ));
              },
            ),
          ),
        ColorPicker(
          portraitOnly: true,
          pickerColor: widget.colors[currentColorIndex],
          onColorChanged: (c) => _onChangeColor(c, setState),
          colorPickerWidth: 300,
          pickerAreaHeightPercent: 0.7,
          enableAlpha: true,
          displayThumbColor: true,
          paletteType: PaletteType.hsl,
          hexInputBar: true,
        ),
      ],
    );
  }

  

  void _onSelectColor(int index, StateSetter dialogSetter) {
    dialogSetter(() {
      currentColorIndex = index;
    });
  }

  _onAddColor(StateSetter dialogSetter) {
    dialogSetter(() {
      widget.colors.insert(widget.colors.length, Colors.redAccent);
      currentColorIndex = widget.colors.length - 1;
    });
    widget.onChangeColors.call(widget.colors);
  }

  void _onChangeColor(Color value, StateSetter dialogSetter) {
    dialogSetter(() {
      widget.colors[currentColorIndex] = value;
    });
    widget.onChangeColors.call(widget.colors);
  }

  void _onDoubleTap(int index, StateSetter dialogSetter) {
    if (widget.colors.length > 1) {
      dialogSetter(() {
        if ((currentColorIndex == index && currentColorIndex != 0) ||
            currentColorIndex == widget.colors.length - 1) {
          currentColorIndex -= 1;
        }
        widget.colors.removeAt(index);
      });
    }
    widget.onChangeColors.call(widget.colors);
  }

  _onSelectStyle(int index, StateSetter dialogSetter) {
    widget.onChangeStyle!.call(styles[index]);
    dialogSetter(() {
      currentStyleIndex = index;
    });
  }
}
