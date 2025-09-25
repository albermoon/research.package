part of '../../../ui.dart';

/// The UI representation of [RPChoiceAnswerFormat]. This UI part appears embedded in a [RPUIQuestionStep].
/// Depending on the [RPChoiceAnswerFormat]'s [ChoiceAnswerStyle] property, the user can select only one or multiple options.
class RPUIChoiceQuestionBody extends StatefulWidget {
  final RPChoiceAnswerFormat answerFormat;
  final void Function(dynamic) onResultChange;

  const RPUIChoiceQuestionBody(
    this.answerFormat,
    this.onResultChange, {
    super.key,
  });

  @override
  RPUIChoiceQuestionBodyState createState() => RPUIChoiceQuestionBodyState();
}

class RPUIChoiceQuestionBodyState extends State<RPUIChoiceQuestionBody>
    with AutomaticKeepAliveClientMixin<RPUIChoiceQuestionBody> {
  List<RPChoice> selectedChoices = [];

  @override
  void initState() {
    super.initState();
    selectedChoices = [];
  }

  void _buttonCallBack(RPChoice selectedChoice) {
    if (widget.answerFormat.answerStyle == RPChoiceAnswerStyle.SingleChoice) {
      // Setting the state here is calling the build method so the check marks can be rendered.
      // Only one choice can be selected.
      if (selectedChoices.contains(selectedChoice)) {
        setState(() {
          selectedChoices.remove(selectedChoice);
        });
      } else {
        setState(() {
          selectedChoices = [];
          selectedChoices.add(selectedChoice);
        });
      }
    }
    if (widget.answerFormat.answerStyle == RPChoiceAnswerStyle.MultipleChoice) {
      // Setting the state here is calling the build method so the check marks can be rendered.
      // Multiple choice can be selected.
      if (selectedChoices.contains(selectedChoice)) {
        setState(() {
          selectedChoices.remove(selectedChoice);
        });
      } else {
        setState(() {
          selectedChoices.add(selectedChoice);
        });
      }
    }

    selectedChoices.isNotEmpty
        ? widget.onResultChange(selectedChoices)
        : widget.onResultChange(null);
  }

  Widget _choiceCellBuilder(BuildContext context, int index) {
    return _ChoiceButton(
      choice: widget.answerFormat.choices[index],
      selectedCallBack: _buttonCallBack,
      selected: selectedChoices.contains(widget.answerFormat.choices[index])
          ? true
          : false,
      currentChoices: selectedChoices,
      index: index,
      isLastChoice: index == widget.answerFormat.choices.length - 1,
      answerStyle: widget.answerFormat.answerStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    final isSmallScreen = screenHeight < 600;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Instrucciones responsive
        Container(
          margin: EdgeInsets.only(bottom: isSmallScreen ? 12 : 16),
          child: Row(
            children: [
              Icon(
                widget.answerFormat.answerStyle == RPChoiceAnswerStyle.MultipleChoice
                    ? Icons.checklist_rtl
                    : Icons.radio_button_checked,
                color: Colors.grey[600],
                size: isTablet ? 20 : 18,
              ),
              SizedBox(width: isTablet ? 12 : 8),
              Text(
                widget.answerFormat.answerStyle == RPChoiceAnswerStyle.MultipleChoice
                    ? "Selección múltiple"
                    : "Selección única",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: isTablet ? 16 : (isSmallScreen ? 12 : 14),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        // Opciones con diseño fluido
        ListView.builder(
          shrinkWrap: true,
          itemCount: widget.answerFormat.choices.length,
          itemBuilder: _choiceCellBuilder,
          physics: const NeverScrollableScrollPhysics(),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _ChoiceButton extends StatefulWidget {
  final RPChoice choice;
  final Function selectedCallBack;
  final List<RPChoice> currentChoices;
  final bool selected;
  final bool isLastChoice;
  final int index;
  final RPChoiceAnswerStyle answerStyle;

  const _ChoiceButton(
      {required this.choice,
      required this.selectedCallBack,
      required this.currentChoices,
      required this.index,
      required this.answerStyle,
      required this.selected,
      required this.isLastChoice});

  @override
  _ChoiceButtonState createState() => _ChoiceButtonState();
}

class _ChoiceButtonState extends State<_ChoiceButton> {
  RPChoice? grpChoice;
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    grpChoice = widget.selected ? widget.choice : null;
    RPLocalizations? locale = RPLocalizations.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    final isSmallScreen = screenHeight < 600;
    
    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 8 : 12),
      child: Material(
        elevation: widget.selected ? 2 : 0,
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        child: InkWell(
          onTap: () => widget.selectedCallBack(widget.choice),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(isTablet ? 20 : (isSmallScreen ? 12 : 16)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.selected ? const Color(0xff667eea) : Colors.grey[300]!,
                width: widget.selected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // Indicador de selección responsive
                Container(
                  width: isTablet ? 28 : (isSmallScreen ? 20 : 24),
                  height: isTablet ? 28 : (isSmallScreen ? 20 : 24),
                  decoration: BoxDecoration(
                    shape: widget.answerStyle == RPChoiceAnswerStyle.SingleChoice 
                        ? BoxShape.circle 
                        : BoxShape.rectangle,
                    borderRadius: widget.answerStyle == RPChoiceAnswerStyle.SingleChoice 
                        ? null 
                        : BorderRadius.circular(4),
                    color: widget.selected ? const Color(0xff667eea) : Colors.transparent,
                    border: Border.all(
                      color: widget.selected ? const Color(0xff667eea) : Colors.grey[400]!,
                      width: 2,
                    ),
                  ),
                  child: widget.selected
                      ? Icon(
                          widget.answerStyle == RPChoiceAnswerStyle.SingleChoice 
                              ? Icons.check 
                              : Icons.check,
                          color: Colors.white,
                          size: isTablet ? 18 : (isSmallScreen ? 14 : 16),
                        )
                      : null,
                ),
                SizedBox(width: isTablet ? 20 : (isSmallScreen ? 12 : 16)),
                // Contenido de la opción responsive
                Expanded(
                  child: widget.choice.isFreeText
                      ? TextField(
                          onChanged: (newText) => widget.choice.text = newText,
                          decoration: InputDecoration(
                            hintText: locale?.translate(widget.choice.text) ??
                                widget.choice.text,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            hintStyle: TextStyle(
                              color: Colors.grey[500],
                              fontSize: isTablet ? 18 : (isSmallScreen ? 14 : 16),
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: widget.selected ? FontWeight.w600 : FontWeight.normal,
                            fontSize: isTablet ? 18 : (isSmallScreen ? 14 : 16),
                          ),
                        )
                      : Text(
                          locale?.translate(widget.choice.text) ??
                              widget.choice.text,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: widget.selected ? FontWeight.w600 : FontWeight.normal,
                            fontSize: isTablet ? 18 : (isSmallScreen ? 14 : 16),
                            height: 1.3,
                          ),
                          softWrap: true,
                        ),
                ),
                // Botón de información responsive
                if (widget.choice.detailText != null)
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<dynamic>(
                          builder: (context) => _DetailTextRoute(
                            title: widget.choice.text,
                            content: widget.choice.detailText!,
                          ),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.info_outline,
                      color: Colors.grey[600],
                      size: isTablet ? 24 : (isSmallScreen ? 18 : 20),
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
