part of '../../../ui.dart';

class RPUITextInputQuestionBody extends StatefulWidget {
  final RPTextAnswerFormat answerFormat;
  final void Function(dynamic) onResultChange;

  const RPUITextInputQuestionBody(
    this.answerFormat,
    this.onResultChange, {
    super.key,
  });

  @override
  RPUITextInputQuestionBodyState createState() =>
      RPUITextInputQuestionBodyState();
}

class RPUITextInputQuestionBodyState extends State<RPUITextInputQuestionBody>
    with AutomaticKeepAliveClientMixin<RPUITextInputQuestionBody> {
  final TextEditingController _controller = TextEditingController();

  void checkInput(String input) {
    if (input.isNotEmpty) {
      widget.onResultChange(input);
    } else {
      widget.onResultChange(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    RPLocalizations? locale = RPLocalizations.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    final isSmallScreen = screenHeight < 600;

    super.build(context);
    return Container(
      padding: EdgeInsets.all(isTablet ? 24 : (isSmallScreen ? 12 : 16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: TextField(
        maxLines: isSmallScreen ? 4 : (isTablet ? 8 : 6),
        minLines: isSmallScreen ? 2 : (isTablet ? 4 : 3),
        onChanged: checkInput,
        decoration: InputDecoration(
          hintText: (widget.answerFormat.hintText != null)
              ? (locale?.translate(widget.answerFormat.hintText!) ??
                  widget.answerFormat.hintText)
              : "Escribe tu respuesta aquí...",
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: isTablet ? 18 : (isSmallScreen ? 14 : 16),
            height: 1.4,
          ),
        ),
        controller: _controller,
        autofocus: widget.answerFormat.autoFocus,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        autocorrect: widget.answerFormat.disableHelpers ? false : true,
        enableSuggestions: widget.answerFormat.disableHelpers ? false : true,
        style: TextStyle(
          fontSize: isTablet ? 18 : (isSmallScreen ? 14 : 16),
          color: const Color(0xff2C3E50),
          height: 1.4,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
