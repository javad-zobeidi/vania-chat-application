import 'dart:core';
import 'dart:io';

import 'package:vania/vania.dart';

// Helper function to evaluate expressions
bool evaluateExpression(String expression, Map<String, dynamic> context) {
  final comparisonPattern = RegExp(r'(\w+)\s*(==|!=|>|<|>=|<=)\s*(\w+)');
  final match = comparisonPattern.firstMatch(expression);

  if (match != null) {
    final leftOperand = match.group(1)?.trim() ?? '';
    final operator = match.group(2)?.trim() ?? '';
    final rightOperand = match.group(3)?.trim() ?? '';

    final leftValue = context[leftOperand];
    final rightValue = context.containsKey(rightOperand)
        ? context[rightOperand]
        : rightOperand;

    switch (operator) {
      case '==':
        return leftValue.toString() == rightValue.toString();
      case '!=':
        return leftValue.toString() != rightValue.toString();
      case '>':
        return num.tryParse(leftValue.toString())! >
            num.tryParse(rightValue.toString())!;
      case '<':
        return num.tryParse(leftValue.toString())! <
            num.tryParse(rightValue.toString())!;
      case '>=':
        return num.tryParse(leftValue.toString())! >=
            num.tryParse(rightValue.toString())!;
      case '<=':
        return num.tryParse(leftValue.toString())! <=
            num.tryParse(rightValue.toString())!;
      default:
        return false;
    }
  } else {
    return context[expression] == true;
  }
}

// Helper function to process conditionals
String processConditionals(String template, Map<String, dynamic> context) {
  final conditionalPattern = RegExp(
      r'\{@\s*if\s+(.*?)\s*@\}(.*?)(\{@\s*elseif\s+(.*?)\s*@\}(.*?))*(\{@\s*else\s*@\}(.*?))?\{@\s*endif\s*@\}',
      dotAll: true);

  return template.replaceAllMapped(conditionalPattern, (match) {
    final ifCondition = match.group(1)?.trim() ?? '';
    final ifContent = match.group(2) ?? '';
    final elseIfBlocks = match.group(3) ?? '';
    final elseContent = match.group(7) ?? '';

    if (evaluateExpression(ifCondition, context)) {
      return ifContent;
    }

    final elseIfPattern =
        RegExp(r'\{@\s*elseif\s+(.*?)\s*@\}(.*?)', dotAll: true);
    for (var elseIfMatch in elseIfPattern.allMatches(elseIfBlocks)) {
      final elseIfCondition = elseIfMatch.group(1)?.trim() ?? '';
      final elseIfContent = elseIfMatch.group(2) ?? '';
      if (evaluateExpression(elseIfCondition, context)) {
        return elseIfContent;
      }
    }

    return elseContent;
  });
}

// Helper function to replace variables with their values
String replaceVariables(String template, Map<String, dynamic> context) {
  final variablePattern = RegExp(r'\{\{(.*?)\}\}');
  return template.replaceAllMapped(variablePattern, (match) {
    final expression = match.group(1)?.trim() ?? '';
    final parts = expression.split('|').map((e) => e.trim()).toList();
    final variableName = parts[0];

    dynamic value = context;
    for (var key in variableName.split('.')) {
      if (value is Map<String, dynamic> && value.containsKey(key)) {
        value = value[key];
      } else {
        value = null;
        break;
      }
    }

    // Handle default value if provided
    if (value == null && parts.length > 1) {
      final defaultPattern = RegExp(r'default:\s*(.*)');
      for (var part in parts.sublist(1)) {
        final match = defaultPattern.firstMatch(part);
        if (match != null) {
          value = match.group(1);
          break;
        }
      }
    }

    // Handle joining lists if specified
    if (value is List && parts.any((part) => part.startsWith('join:'))) {
      final joinPattern = RegExp(r'join:\s*(.*)');
      final joinMatch = parts.firstWhere((part) => joinPattern.hasMatch(part));
      final delimiter = joinPattern.firstMatch(joinMatch)?.group(1) ?? ', ';
      value = (value as List).join(delimiter);
    }

    return value?.toString() ?? '';
  });
}

// Helper function to process loops
String processLoops(String template, Map<String, dynamic> context) {
  final loopPattern = RegExp(
      r'\{@\s*for\s+(.*?)\s+in\s+(.*?)\s*@\}(.*?)\{@\s*endfor\s*@\}',
      dotAll: true);
  return template.replaceAllMapped(loopPattern, (match) {
    final itemName = match.group(1)?.trim() ?? '';
    final listName = match.group(2)?.trim() ?? '';
    final loopContent = match.group(3) ?? '';
    final list = context[listName] as List<dynamic>? ?? [];

    final buffer = StringBuffer();
    for (var item in list) {
      final itemContext = {...context, itemName: item};
      buffer.write(viewTemplate(loopContent, itemContext));
    }

    return buffer.toString();
  });
}

// Helper function to process switch-case
String processSwitchCases(String template, Map<String, dynamic> context) {
  final switchPattern = RegExp(
      r'\{@\s*switch\s+(.*?)\s*@\}(.*?)\{@\s*endswitch\s*@\}',
      dotAll: true);
  return template.replaceAllMapped(switchPattern, (match) {
    final switchVariable = match.group(1)?.trim() ?? '';
    final switchContent = match.group(2) ?? '';

    dynamic switchValue = context[switchVariable];

    final casePattern = RegExp(
        r'\{@\s*case\s+(.*?)\s*@\}(.*?)\{@\s*endcase\s*@\}',
        dotAll: true);

    for (var caseMatch in casePattern.allMatches(switchContent)) {
      final caseValue = caseMatch.group(1)?.trim() ?? '';
      final caseContent = caseMatch.group(2) ?? '';

      // Check if caseValue matches switchValue
      if (switchValue != null && switchValue.toString() == caseValue) {
        return caseContent;
      }
    }

    return '';
  });
}

// Helper function to process while loops
String processWhileLoops(String template, Map<String, dynamic> context) {
  final whilePattern = RegExp(
      r'\{@\s*while\s+(.*?)\s*@\}(.*?)\{@\s*endwhile\s*@\}',
      dotAll: true);
  return template.replaceAllMapped(whilePattern, (match) {
    final condition = match.group(1)?.trim() ?? '';
    final loopContent = match.group(2) ?? '';

    final buffer = StringBuffer();
    while (evaluateExpression(condition, context)) {
      buffer.write(viewTemplate(loopContent, context));
      // Execute Dart code blocks within the loop to potentially update the context
      buffer.write(processDartBlocks(loopContent, context));
    }

    return buffer.toString();
  });
}

// Helper function to process dart code blocks
String processDartBlocks(String template, Map<String, dynamic> context) {
  final dartPattern =
      RegExp(r'\{@\s*dart\s*@\}(.*?)\{@\s*enddart\s*@\}', dotAll: true);
  return template.replaceAllMapped(dartPattern, (match) {
    final dartCode = match.group(1)?.trim() ?? '';

    // Here we simulate the Dart code execution and update the context manually
    if (dartCode.contains('keepLooping = false;')) {
      context['keepLooping'] = false;
    }

    return '';
  });
}

// Helper function to read file content
String readFileContent(String filePath) {
  return File('${Directory.current.path}/resources/views/$filePath.dart.html')
      .readAsStringSync();
}

// Helper function to process includes
String processIncludes(String template) {
  final includePattern = RegExp(r"\@include\('(.+?)'\)");
  return template.replaceAllMapped(includePattern, (match) {
    final filePath = match.group(1) ?? '';
    return readFileContent(filePath);
  });
}

// Main template processing function
String viewTemplate(String template, Map<String, dynamic> context) {
  template = processIncludes(template);
  template = processConditionals(template, context);
  template = processLoops(template, context);
  template = processSwitchCases(template, context);
  template = processWhileLoops(template, context);
  template = replaceVariables(template, context);
  template = processDartBlocks(template, context);
  return template;
}

Response view(String template, context) {
  File file =
      File('${Directory.current.path}/resources/views/$template.dart.html');
  return Response.html(viewTemplate(file.readAsStringSync(), context));
}
