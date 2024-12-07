// import 'package:flutter/material.dart';
// import 'package:habbit_app/profileScreens/settings/theme/theme_provider.dart';
// import 'package:provider/provider.dart';
// // import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class SettingsView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         // title: Text(AppLocalizations.of(context)!.settings),
//         title: const Text("Settings"),
//       ),
//       body: ListView(
//         children: [
//           SwitchListTile(
//             // title: Text(AppLocalizations.of(context)!.darkMode),
//             title: const Text("Dark Mode"),
//             value: themeProvider.themeMode == ThemeMode.dark,
//             onChanged: (value) {
//               themeProvider.toggleTheme();
//             },
//           ),
//           ListTile(
//             // title: Text(AppLocalizations.of(context)!.language),
//             // subtitle: Text(AppLocalizations.of(context)!.currentLanguage),
//             title: const Text("Language"),
//             subtitle: const Text("Current Language"),
//             onTap: () {
//               showLanguageDialog(context);
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   void showLanguageDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           // title: Text(AppLocalizations.of(context)!.chooseLanguage),
//           title: const Text("Choose Language"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               ListTile(
//                 title: Text('English'),
//                 onTap: () {
//                   updateLocale(context, Locale('en'));
//                 },
//               ),
//               ListTile(
//                 title: Text('Русский'),
//                 onTap: () {
//                   updateLocale(context, Locale('ru'));
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void updateLocale(BuildContext context, Locale locale) {
//     Provider.of<ThemeProvider>(context, listen: false).setLocale(locale);
//     Navigator.of(context).pop();
//   }
// }
