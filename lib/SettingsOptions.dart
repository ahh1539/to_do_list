class SettingsOptions{

  static const String Theme = 'Theme';
  static const String Info = 'Info';

  static const List<String> choices = <String>[
    Theme,
    Info
  ];

  int itemCount(){
    return choices.length;
  }

  List<String> sendInfo() => choices;
}