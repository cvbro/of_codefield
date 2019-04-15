import 'package:flutter/material.dart';

enum CodeBlockState {
  filled, // 已填充
  focused, // 高亮，下一个填充
  empty, // 未填充
}

// 如果使用 Widget 将会覆盖 text 相关功能
typedef ContentWidgetBuilder = Widget Function(String text);

class CodeBlock extends StatelessWidget {
  final String text;
  final CodeBlockState state;

  final ContentWidgetBuilder contentBuilder;
  final BoxDecoration filledDecoration;
  final BoxDecoration focusDecoration;
  final BoxDecoration emptyDecoration;

  final double width;
  final double height;

  CodeBlock({
    this.text,
    this.state,
    this.width,
    this.height,
    this.contentBuilder,
    this.filledDecoration,
    this.focusDecoration,
    this.emptyDecoration,
  });
  //增加 captcha block decoration

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: _boxDecoration(state),
      child: Center(child: _contentWidget(text)),
    );
  }

  BoxDecoration _boxDecoration(CodeBlockState state) {
    if (state == CodeBlockState.filled && filledDecoration != null) {
      return filledDecoration;
    }

    if (state == CodeBlockState.focused && focusDecoration != null) {
      return focusDecoration;
    }

    if (state == CodeBlockState.empty && emptyDecoration != null) {
      return emptyDecoration;
    }

    return _defaultDecoration(state);
  }

  BoxDecoration _defaultDecoration(CodeBlockState state) {
    BoxDecoration bd;

    if (state == CodeBlockState.focused) {
      bd = BoxDecoration(
        borderRadius: BorderRadius.circular((6.0)),
        color: Color(0xFF1D1D2B),
        boxShadow: [
          BoxShadow(
              color: Color(0xFFFF315E), blurRadius: 10.0, spreadRadius: 2.0),
        ],
      );
    } else {
      bd = BoxDecoration(
        borderRadius: BorderRadius.circular((6.0)),
        color: Color(0xFF1D1D2B),
      );
    }
    return bd;
  }

  Widget _contentWidget(String t) {
    if (contentBuilder != null) {
      if (t.length == 0) return null;
      return contentBuilder(t);
    }
    return _defaultText(t);
  }

  Text _defaultText(String t) {
    return Text(
      t ?? '',
      style: TextStyle(fontSize: 20, color: Color(0xFFFFFFFF)),
    );
  }
}
