part of 'app_radio_grouped_button.dart';

class AppCheckBoxGroup<T> extends StatefulWidget {
  /// [spacing] Spacing between buttons
  AppCheckBoxGroup({
    super.key,
    this.horizontal = false,
    required this.buttonValuesList,
    this.buttonTextStyle = const ButtonTextStyle(),
    this.height = 35,
    double padding = 3,
    double spacing = 0.0,
    this.autoWidth = false,
    this.width = 100,
    this.enableShape = false,
    this.elevation = 0,
    this.shapeRadius = 50,
    this.radius = 20,
    required this.buttonLables,
    required this.checkBoxButtonValues,
    required this.selectedColor,
    this.selectedBorderColor,
    this.wrapAlignment = WrapAlignment.start,
    this.defaultSelected,
    required this.unSelectedColor,
    this.unSelectedBorderColor,
    this.customShape,
    this.absoluteZeroSpacing = false,
    this.scrollController,
    this.margin,
    this.enableButtonWrap = false,
  })
      : assert(buttonLables.length == buttonValuesList.length,
  "Button values list and button lables list should have same number of eliments "),
        assert(buttonValuesList
            .toSet()
            .length == buttonValuesList.length,
        "Multiple buttons with same value cannot exist") {
    if (absoluteZeroSpacing) {
      this.padding = 0;
      this.spacing = 0;
    } else {
      this.padding = padding;
      this.spacing = spacing;
    }
  }

  ///Orientation of the Button Group
  final bool horizontal;

  final ScrollController? scrollController;

  ///This option will make sure that there is no spacing in between buttons
  final bool absoluteZeroSpacing;

  ///Values of button
  final List<T> buttonValuesList;

  ///Styling class for label
  final ButtonTextStyle buttonTextStyle;

  ///Default value is 35
  final double height;
  late final double padding;

  ///Margins around card
  final EdgeInsetsGeometry? margin;

  ///Spacing between buttons
  late final double spacing;

  ///Only applied when in vertical mode
  ///This will use minimum space required
  ///If enables it will ignore [width] field
  final bool autoWidth;

  ///Use this if you want to keep width of all the buttons same
  final double width;

  ///if true button will have rounded corners
  ///If you want custom shape you can use [customShape] property
  final bool enableShape;
  final double elevation;

  final List<String> buttonLables;

  final void Function(List<T>) checkBoxButtonValues;

  ///Selected Color of button
  final Color selectedColor;

  ///Selected Color of button border
  final Color? selectedBorderColor;

  ///alignment for button when [enableButtonWrap] is true
  final WrapAlignment wrapAlignment;

  ///Default Selected button
  final List<T>? defaultSelected;

  ///Unselected Color of the button
  final Color unSelectedColor;

  ///Unselected Color of the button border
  final Color? unSelectedBorderColor;

  /// A custom Shape can be applied (will work only if [enableShape] is true)
  final ShapeBorder? customShape;

  /// This will enable button wrap (will work only if orientation is vertical)
  final bool enableButtonWrap;

  /// Radius for non-shape radio button
  final double radius;

  /// Radius for shape radio button
  final double shapeRadius;

  _AppCheckBoxGroupState createState() => _AppCheckBoxGroupState();
}

class _AppCheckBoxGroupState extends State<AppCheckBoxGroup> {
  List<dynamic> selectedLables = [];

  Color borderColor(e) =>
      (selectedLables.contains(e)
          ? widget.selectedBorderColor
          : widget.unSelectedBorderColor) ??
          Theme
              .of(context)
              .primaryColor;

  @override
  void initState() {
    super.initState();
    widget.defaultSelected?.where((e) {
      return widget.buttonValuesList.contains(e);
    }).forEach((e) {
      selectedLables.add(e);
    });
  }

  List<Widget> _buildButtonsColumn() {
    return widget.buttonValuesList.map((e) {
      int index = widget.buttonValuesList.indexOf(e);
      return Padding(
        padding: EdgeInsets.all(widget.padding),
        child: Card(
          margin: widget.margin ??
              EdgeInsets.all(widget.absoluteZeroSpacing ? 0 : 4),
          color: selectedLables.contains(e)
              ? widget.selectedColor
              : widget.unSelectedColor,
          elevation: widget.elevation,
          shape: widget.enableShape
              ? widget.customShape == null
              ? RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(Radius.circular(widget.shapeRadius)),
          )
              : widget.customShape
              : null,
          child: Container(
            height: widget.height,
            child: MaterialButton(
              shape: widget.enableShape
                  ? widget.customShape == null
                  ? OutlineInputBorder(
                borderSide:
                BorderSide(color: borderColor(e), width: 1),
                borderRadius:
                BorderRadius.all(Radius.circular(widget.radius)),
              )
                  : widget.customShape
                  : OutlineInputBorder(
                borderSide: BorderSide(color: borderColor(e), width: 1),
                borderRadius: BorderRadius.zero,
              ),
              onPressed: () {
                if (selectedLables.contains(e)) {
                  selectedLables.remove(e);
                } else {
                  selectedLables.add(e);
                }
                setState(() {});
                widget.checkBoxButtonValues(selectedLables);
              },
              child: Text(
                widget.buttonLables[index],
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: widget.buttonTextStyle.textStyle.copyWith(
                  color: selectedLables.contains(e)
                      ? widget.buttonTextStyle.selectedColor
                      : widget.buttonTextStyle.unSelectedColor,
                ),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildButtonsRow() {
    return widget.buttonValuesList.map((e) {
      int index = widget.buttonValuesList.indexOf(e);
      return Card(
        margin:
        widget.margin ?? EdgeInsets.all(widget.absoluteZeroSpacing ? 0 : 4),
        color: selectedLables.contains(e)
            ? widget.selectedColor
            : widget.unSelectedColor,
        elevation: widget.elevation,
        shape: widget.enableShape
            ? widget.customShape == null
            ? RoundedRectangleBorder(
          borderRadius:
          BorderRadius.all(Radius.circular(widget.shapeRadius)),
        )
            : widget.customShape
            : null,
        child: Container(
          height: widget.height,
          width: widget.autoWidth ? null : widget.width,
          constraints: widget.autoWidth ? null : BoxConstraints(maxWidth: 250),
          child: MaterialButton(
            shape: widget.enableShape
                ? widget.customShape == null
                ? OutlineInputBorder(
              borderSide: BorderSide(color: borderColor(e), width: 1),
              borderRadius:
              BorderRadius.all(Radius.circular(widget.radius)),
            )
                : widget.customShape
                : OutlineInputBorder(
              borderSide: BorderSide(color: borderColor(e), width: 1),
              borderRadius: BorderRadius.zero,
            ),
            onPressed: () {
              if (selectedLables.contains(e)) {
                selectedLables.remove(e);
              } else {
                selectedLables.add(e);
              }
              setState(() {});
              widget.checkBoxButtonValues(selectedLables);
            },
            child: Text(
              widget.buttonLables[index],
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: widget.buttonTextStyle.textStyle.copyWith(
                color: selectedLables.contains(e)
                    ? widget.buttonTextStyle.selectedColor
                    : widget.buttonTextStyle.unSelectedColor,
              ),
            ),
          ),
        ),
        // ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCheckBoxButtons();
  }

  _buildCheckBoxButtons() {
    if (widget.horizontal)
      return Container(
        height: widget.height * (widget.buttonLables.length * 1.5) +
            widget.padding * 2 * widget.buttonLables.length,
        child: Center(
          child: AppListViewSpacing(
            scrollController: widget.scrollController,
            spacing: widget.spacing,
            scrollDirection: Axis.vertical,
            children: _buildButtonsColumn(),
          ),
        ),
      );
    if (!widget.horizontal && widget.enableButtonWrap)
      return Container(
        child: Center(
          child: Wrap(
            spacing: widget.spacing,
            direction: Axis.horizontal,
            alignment: widget.wrapAlignment,
            children: _buildButtonsRow(),
          ),
        ),
      );
    if (!widget.horizontal && !widget.enableButtonWrap)
      return Container(
        height: widget.height + widget.padding * 2,
        child: Center(
          child: AppListViewSpacing(
            spacing: widget.spacing,
            scrollController: widget.scrollController,
            scrollDirection: Axis.horizontal,
            children: _buildButtonsRow(),
          ),
        ),
      );
  }
}
