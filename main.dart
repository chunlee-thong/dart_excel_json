import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:excel/excel.dart';

String one_language_name;

//Required
final String saved_json_path = "generated_file";

//Required
final String saved_locale_key_class_path = "generated_file";

//Required
final String excel_file_path = "translation_example.xlsx";

void main(List<String> args) async {
  final bytes = File(excel_file_path).readAsBytesSync();
  final excel = Excel.decodeBytes(bytes);
  final sheetName = "Translation";
  final sheet = excel.tables[sheetName];

  //method
  await generateJSONFile(sheet);
  generateDartClass();
}

Future<void> generateJSONFile(Sheet sheet) async {
  //get language count by column count minus 1 (minus 1 becuase first column is a key column)
  int langage_count = sheet.maxCols - 1;

  //get key count by row count minus 1 (minus 1 because first row is a title row)
  int key_count = sheet.maxRows - 1;

  //getenrate language list
  List<int> language_list = List<int>.generate(langage_count, (i) => i + 1);
  for (var lang in language_list) {
    //SplayTreeMap auto sort it's key
    SplayTreeMap<String, dynamic> data = SplayTreeMap<String, dynamic>();

    var key_list = List<int>.generate(key_count, (i) => i + 1);
    for (var key_index in key_list) {
      String key = sheet
          .cell(CellIndex.indexByColumnRow(
            columnIndex: 0,
            rowIndex: key_index,
          ))
          .value
          .toString();
      String value = sheet
          .cell(CellIndex.indexByColumnRow(
            columnIndex: lang,
            rowIndex: key_index,
          ))
          .value
          .toString();
      key = key.replaceAll(" ", "-");
      data[key] = value;
    }
    //get language name
    String language_name = sheet
        .cell(CellIndex.indexByColumnRow(
          columnIndex: lang,
          rowIndex: 0,
        ))
        .value
        .toString();

    //Save file language name to access json file and read key for LocaleKeys class
    one_language_name = language_name;

    //
    data.keys.toList()..sort();
    String json_data = json.encode(data);
    final language_file = File("$saved_json_path/${language_name}.json");
    await language_file.writeAsString(json_data);
  }
}

void generateDartClass() async {
  File json_file = File("$saved_json_path/${one_language_name}.json");
  String json_data = await json_file.readAsString();
  Map<String, dynamic> map_data = json.decode(json_data);
  String dartClass = "class LocaleKeys {\n";

  for (var key in map_data.keys.toList()) {
    String key_data_type = key.runtimeType.toString();
    String key_value = checkKeyConflict(key);
    String key_field_name = key_value.replaceAll("-", "_");
    dartClass += "    static const ${key_data_type} ${key_field_name} = " +
        '"${key}";\n';
  }

  dartClass += "}";

  File dartClassFile = File("$saved_locale_key_class_path/locale_keys.dart");
  dartClassFile.writeAsString(dartClass);
}

String checkKeyConflict(String key) {
  if (dart_key_word.contains(key)) {
    return "${key}_";
  }
  return key;
}

List<String> dart_key_word = [
  "abstract ",
  "else",
  "import",
  "super",
  "as",
  "enum",
  "in",
  "switch",
  "assert",
  "export",
  "interface",
  "sync",
  "async",
  "extends",
  "is",
  "this",
  "await",
  "extension",
  "library",
  "throw",
  "break",
  "external",
  "mixin",
  "true",
  "case",
  "factory",
  "new",
  "try",
  "catch",
  "false",
  "null",
  "typedef",
  "class",
  "final",
  "on",
  "var",
  "const",
  "finally",
  "operator",
  "void",
  "continue",
  "for",
  "part",
  "while",
  "covariant",
  "Function",
  "rethrow",
  "with",
  "default",
  "get",
  "return",
  "yield",
  "deferred",
  "hide",
  "set",
  "do",
  "if",
  "show",
  "dynamic",
  "implements",
  "static"
];
