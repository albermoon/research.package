part of '../../ui.dart';

/// The UI representation of the [RPQuestionStep].
///
/// This widget is the container, the concrete content depends on the input
/// step's [RPAnswerFormat].
///
/// As soon as the participant has finished with the question the [RPStepResult]
/// is being added to the [RPTaskResult]'s result list.
class RPUIQuestionStep extends StatefulWidget {
  final RPQuestionStep step;

  const RPUIQuestionStep(this.step, {super.key});

  @override
  RPUIQuestionStepState createState() => RPUIQuestionStepState();
}

class RPUIQuestionStepState extends State<RPUIQuestionStep> with CanSaveResult {
  // dynamic because we don't know what value the RPChoice will have
  dynamic _currentQuestionBodyResult;
  RPStepResult? result;
  RPTaskProgress? recentTaskProgress;
  int timeInSeconds = 0;
  Timer? timer;

  set currentQuestionBodyResult(dynamic currentQuestionBodyResult) {
    _currentQuestionBodyResult = currentQuestionBodyResult;
    createAndSendResult();
    if (_currentQuestionBodyResult != null) {
      blocQuestion.sendReadyToProceed(true);
    } else {
      blocQuestion.sendReadyToProceed(false);
    }
  }

  void skipQuestion() {
    timer?.cancel();

    FocusManager.instance.primaryFocus?.unfocus();
    blocTask.sendStatus(RPStepStatus.Skipped);
    currentQuestionBodyResult = null;
  }

  @override
  void initState() {
    super.initState();

    if (timeInSeconds <= 0) {
      timeInSeconds = widget.step.timeout.inSeconds;
      const oneSec = Duration(seconds: 1);
      timer = Timer.periodic(oneSec, (t) {
        if (mounted) {
          setState(() {
            timeInSeconds--;
          });
        }
        if (widget.step.autoSkip) {
          t.cancel();
          skipQuestion();
        }
      });
    }

    // Create the result object here to record the start time
    result = RPStepResult(
        identifier: widget.step.identifier,
        questionTitle: widget.step.title,
        answerFormat: widget.step.answerFormat);
    blocQuestion.sendReadyToProceed(false);
    recentTaskProgress = blocTask.lastProgressValue;
  }

  @override
  void deactivate() {
    timer?.cancel();
    super.deactivate();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  // Returning the according step body widget based on the answerFormat of the step
  Widget stepBody(RPAnswerFormat answerFormat) {
    switch (answerFormat.runtimeType) {
      case const (RPIntegerAnswerFormat):
        return RPUIIntegerQuestionBody((answerFormat as RPIntegerAnswerFormat),
            (result) {
          currentQuestionBodyResult = result;
        });
      case const (RPDoubleAnswerFormat):
        return RPUIDoubleQuestionBody((answerFormat as RPDoubleAnswerFormat),
            (result) {
          currentQuestionBodyResult = result;
        });
      case const (RPChoiceAnswerFormat):
        return RPUIChoiceQuestionBody((answerFormat as RPChoiceAnswerFormat),
            (result) {
          currentQuestionBodyResult = result;
        });
      case const (RPSliderAnswerFormat):
        return RPUISliderQuestionBody((answerFormat as RPSliderAnswerFormat),
            (result) {
          currentQuestionBodyResult = result;
        });
      case const (RPImageChoiceAnswerFormat):
        return RPUIImageChoiceQuestionBody(
            (answerFormat as RPImageChoiceAnswerFormat), (result) {
          currentQuestionBodyResult = result;
        });
      case const (RPDateTimeAnswerFormat):
        return RPUIDateTimeQuestionBody(
            (answerFormat as RPDateTimeAnswerFormat), (result) {
          currentQuestionBodyResult = result;
        });
      case const (RPTextAnswerFormat):
        return RPUITextInputQuestionBody((answerFormat as RPTextAnswerFormat),
            (result) {
          currentQuestionBodyResult = result;
        });
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    RPLocalizations? locale = RPLocalizations.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    final isSmallScreen = screenHeight < 600;
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                isTablet ? 32 : 20,
                isSmallScreen ? 12 : 20,
                isTablet ? 32 : 20,
                isSmallScreen ? 12 : 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locale?.translate(widget.step.title) ?? widget.step.title,
                    style: TextStyle(
                      fontSize: isTablet ? 32 : (isSmallScreen ? 24 : 28),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff2C3E50),
                      height: 1.2,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 32 : 20,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: stepBody(widget.step.answerFormat),
                    ),
                    if (widget.step.optional) ...[
                      SizedBox(height: isSmallScreen ? 2 : 4),
                      TextButton.icon(
                        onPressed: () => skipQuestion(),
                        icon: Icon(Icons.skip_next, size: isTablet ? 20 : 18),
                        label: Text(
                          locale?.translate('skip_this_question') ?? "Skip this question",
                          style: TextStyle(fontSize: isTablet ? 16 : 14),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey[600],
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 20 : 16, 
                            vertical: isSmallScreen ? 6 : 8,
                          ),
                        ),
                      ),
                    ],
                    if (widget.step.footnote != null) ...[
                      SizedBox(height: isSmallScreen ? 4 : 6),
                      Container(
                        padding: EdgeInsets.all(isTablet ? 20 : 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.grey[600],
                              size: isTablet ? 18 : 16,
                            ),
                            SizedBox(width: isTablet ? 12 : 8),
                            Expanded(
                              child: Text(
                                locale?.translate(widget.step.footnote!) ?? widget.step.footnote!,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: isTablet ? 15 : 13,
                                  fontStyle: FontStyle.italic,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    SizedBox(height: isSmallScreen ? 8 : 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void createAndSendResult() {
    timer?.cancel();

    if (result != null) {
      result?.questionTitle = widget.step.title;
      result?.setResult(_currentQuestionBodyResult);
      blocTask.sendStepResult(result!);
    }
  }
}
