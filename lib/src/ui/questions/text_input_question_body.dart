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

    super.build(context);
    return TextField(
        maxLines: 6,
        minLines: 3,
        onChanged: checkInput,
        decoration: InputDecoration(
          hintText: (widget.answerFormat.hintText != null)
              ? (locale?.translate(widget.answerFormat.hintText!) ??
                  widget.answerFormat.hintText)
              : "Escribe tu respuesta aquí...",
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: 16,
            height: 1.4,
          ),
        ),
        controller: _controller,
        autofocus: widget.answerFormat.autoFocus,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        autocorrect: widget.answerFormat.disableHelpers ? false : true,
        enableSuggestions: widget.answerFormat.disableHelpers ? false : true,
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xff2C3E50),
          height: 1.4,
        ),
      );
  }

  @override
  bool get wantKeepAlive => true;
}
