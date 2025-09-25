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
      padding: const EdgeInsets.all(24),
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
          // Valor actual simple
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          const SizedBox(height: 10),
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
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.answerFormat.minValue.toString(),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                widget.answerFormat.maxValue.toString(),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
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
