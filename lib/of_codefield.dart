import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:of_codefield/code_block.dart';

typedef FinishedCallback = void Function(String code);

class CodeField extends StatefulWidget {
  final int codeLength;

  final double blockHeight;
  final double blockWidth;
  final double blockSpace;

  final FinishedCallback succeed;

  final ContentWidgetBuilder contentBuilder;
  final BoxDecoration filledDecoration;
  final BoxDecoration focusedDecoration;
  final BoxDecoration emptyDecoration;

  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;

  CodeField({
    this.succeed,
    this.codeLength = 4,
    this.blockHeight = 60,
    this.blockWidth = 60,
    this.blockSpace = 14,
    this.contentBuilder,
    this.filledDecoration,
    this.focusedDecoration,
    this.emptyDecoration,
    this.keyboardType,
    this.inputFormatters,
  });

  @override
  _CodeFieldState createState() =>
      _CodeFieldState(codeLength, blockHeight, blockWidth, blockSpace);
}

class _CodeFieldState extends State<CodeField> {
  final int codeLength;

  final double blockHeight;
  final double blockWidth;
  final double blockSpace;

  bool hasCallback = false;

  _CodeFieldState(
      this.codeLength, this.blockHeight, this.blockWidth, this.blockSpace);

  final TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();
  List<CodeBlock> captchaBlocks = [];

  int keyboardListenerId;

  @override
  void initState() {
    super.initState();
    keyboardListenerId = KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        if (!visible) {
          _focusNode.unfocus();
        }
      },
    );
    _controller.addListener(_handleInput);

    captchaBlocks = _createBlocks(codeLength);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleInput);
    KeyboardVisibilityNotification().removeListener(keyboardListenerId);
    super.dispose();
  }

  _handleInput() {
    // print('[ Info] captcha:${_controller.text}');
    String code = _controller.text;
    for (int i = 0; i < captchaBlocks.length; i++) {
      CodeBlock block = captchaBlocks[i];
      String text = i < code.length ? code[i] : '';
      CodeBlockState state = i < code.length
          ? CodeBlockState.filled
          : i == code.length ? CodeBlockState.focused : CodeBlockState.empty;
      if (block.text == text && block.state == state) continue;

      captchaBlocks[i] = _createBlock(text, state);
    }

    if (code.length >= codeLength) {
      if (widget.succeed != null && !hasCallback) widget.succeed(code);
      hasCallback = true;
    } else {
      hasCallback = false;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(_focusNode);
        print("${_focusNode.hasFocus}");
      },
      child: Container(
        height: 150,
        width: 4 * 60 + 3 * 20.0,
        color: Colors.transparent,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: captchaBlocks,
              ),
            ),
            Offstage(
              // offstage: false,
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                maxLength: codeLength,
                autofocus: true,
                keyboardType: widget.keyboardType ?? TextInputType.number,
                inputFormatters: widget.inputFormatters ??
                    [WhitelistingTextInputFormatter.digitsOnly],
              ),
            )
          ],
        ),
      ),
    );
  }

  List<CodeBlock> _createBlocks(int len) {
    List<CodeBlock> blocks = [];
    for (int i = 0; i < len; i++) {
      CodeBlock cb;
      if (i == 0) {
        cb = _createBlock('', CodeBlockState.focused);
      } else {
        cb = _createBlock('', CodeBlockState.empty);
      }
      blocks.add(cb);
    }
    return blocks;
  }

  CodeBlock _createBlock(String t, CodeBlockState state) {
    return CodeBlock(
      text: t,
      state: state,
      width: blockWidth,
      height: blockHeight,
      contentBuilder: widget.contentBuilder,
      filledDecoration: widget.filledDecoration,
      focusDecoration: widget.focusedDecoration,
      emptyDecoration: widget.emptyDecoration,
    );
  }
}
