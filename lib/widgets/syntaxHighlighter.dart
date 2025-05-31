import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:highlight/highlight.dart';
import 'package:highlight/languages/all.dart';

class MySyntaxHighlighter extends SyntaxHighlighter {
  MySyntaxHighlighter() {
    highlight.registerLanguages(allLanguages);
  }

  @override
  TextSpan format(String source, {String? language}) {
    final result = highlight.parse(source, autoDetection: true);
    return _convert(result.nodes ?? []);
  }

  TextSpan _convert(List<Node> nodes, [String? parentClass]) {
    List<TextSpan> spans = [];
    for (var node in nodes) {
      final effectiveClass = node.className ?? parentClass;
      if (node.value != null) {
        spans.add(
          TextSpan(
            text: node.value,
            style: TextStyle(
              color: _getColor(effectiveClass),
              fontFamily: 'monospace',
            ),
          ),
        );
      } else if (node.children != null) {
        spans.add(_convert(node.children!, effectiveClass));
      }
    }
    return TextSpan(children: spans);
  }

  static const Map<String, Color> _defaultColorMap = {
    'keyword': Color(0xFFC678DD),
    'meta-keyword': Color(0xFFC678DD),
    'string': Color(0xFF98C379),
    'meta-string': Color(0xFF98C379),
    'number': Color(0xFFD19A66),
    'function': Color(0xFF61AFEF),
    'comment': Color(0xFF5C6370),
    'title': Color(0xFFE5C07B),
    'params': Color(0xFFD19A66),
    'type': Color(0xFFE5C07B),
    'built_in': Color(0xFF56B6C2),
    'literal': Color(0xFF56B6C2),
    'attr': Color(0xFFD19A66),
    'variable': Color(0xFFE06C75),
  };

  Color _getColor(String? className) {
    if (className == null) return Color(0xFFABB2BF);
    return _defaultColorMap[className] ?? Color(0xFFABB2BF);
  }
}
