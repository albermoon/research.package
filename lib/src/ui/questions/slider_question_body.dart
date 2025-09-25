part of '../../../ui.dart';

class RPUISliderQuestionBody extends StatefulWidget {
  final RPSliderAnswerFormat answerFormat;
  final void Function(dynamic) onResultChange;

  const RPUISliderQuestionBody(
    this.answerFormat,
    this.onResultChange, {
    super.key,
  });

  @override
  RPUISliderQuestionBodyState createState() => RPUISliderQuestionBodyState();
}

class RPUISliderQuestionBodyState extends State<RPUISliderQuestionBody>
    with AutomaticKeepAliveClientMixin<RPUISliderQuestionBody> {
  double? value;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    RPLocalizations? locale = RPLocalizations.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    final isSmallScreen = screenHeight < 600;
    
    String text = "";
    // prefix
    text += (widget.answerFormat.prefix != null)
        ? (locale?.translate(widget.answerFormat.prefix!) ??
            widget.answerFormat.prefix!)
        : "";
    // value
    text += (value ?? widget.answerFormat.minValue).toString();
    // suffix
    text += (widget.answerFormat.suffix != null)
        ? (locale?.translate(widget.answerFormat.suffix!) ??
            widget.answerFormat.suffix!)
        : "";
    
    return Container(
      padding: EdgeInsets.all(isTablet ? 32 : (isSmallScreen ? 16 : 24)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Column(
        children: <Widget>[
          // Valor actual responsive
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 24 : 20, 
              vertical: isSmallScreen ? 8 : 12,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: isTablet ? 24 : (isSmallScreen ? 18 : 20),
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          SizedBox(height: isSmallScreen ? 8 : 10),
          // Slider con colores del tema
          Slider(
            value: value ?? widget.answerFormat.minValue,
            onChanged: (double newValue) {
              setState(() {
                value = newValue;
              });
              widget.onResultChange(value);
            },
            min: widget.answerFormat.minValue,
            max: widget.answerFormat.maxValue,
            divisions: widget.answerFormat.divisions,
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.answerFormat.minValue.toString(),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: isTablet ? 16 : (isSmallScreen ? 12 : 14),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                widget.answerFormat.maxValue.toString(),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: isTablet ? 16 : (isSmallScreen ? 12 : 14),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
