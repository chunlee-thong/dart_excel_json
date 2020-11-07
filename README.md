# dart_excel_json

Generate json localization file from excel sheet

## How to use

- create an excel sheet and rename sheet's name to **Translation**

- Create a data structure like below or you can check file **translation_example.xlsx** in this repo

| Key         | en-US       | km-KH   | es-ES          | th-TH | vi-VN  |
| ----------- | ----------- | ------- | -------------- | ----- | ------ |
| title       | Title       | ចំណងជើង | titulo         | dgh   | dfghjk |
| buy_account | Buy Account | ទិញគណនី | comprar cuenta | sfgg  | evsd   |
| attraction  | Attraction  | កន្លែង  | asdfaf         | add   | dfrw   |

- You can change field **saved_json_path**, **saved_locale_key_class_path** or **excel_file_path** in main.dart to your flutter project path

- run **dart main.dart**
