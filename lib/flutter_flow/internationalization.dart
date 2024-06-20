import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleStorageKey = '__locale_key__';

class FFLocalizations {
  FFLocalizations(this.locale);

  final Locale locale;

  static FFLocalizations of(BuildContext context) =>
      Localizations.of<FFLocalizations>(context, FFLocalizations)!;

  static List<String> languages() => ['en', 'de', 'ar'];

  static late SharedPreferences _prefs;
  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance();
  static Future storeLocale(String locale) =>
      _prefs.setString(_kLocaleStorageKey, locale);
  static Locale? getStoredLocale() {
    final locale = _prefs.getString(_kLocaleStorageKey);
    return locale != null && locale.isNotEmpty ? createLocale(locale) : null;
  }

  String get languageCode => locale.toString();
  String? get languageShortCode =>
      _languagesWithShortCode.contains(locale.toString())
          ? '${locale.toString()}_short'
          : null;
  int get languageIndex => languages().contains(languageCode)
      ? languages().indexOf(languageCode)
      : 0;

  String getText(String key) =>
      (kTranslationsMap[key] ?? {})[locale.toString()] ?? '';

  String getVariableText({
    String? enText = '',
    String? deText = '',
    String? arText = '',
  }) =>
      [enText, deText, arText][languageIndex] ?? '';

  static const Set<String> _languagesWithShortCode = {
    'ar',
    'az',
    'ca',
    'cs',
    'da',
    'de',
    'dv',
    'en',
    'es',
    'et',
    'fi',
    'fr',
    'gr',
    'he',
    'hi',
    'hu',
    'it',
    'km',
    'ku',
    'mn',
    'ms',
    'no',
    'pt',
    'ro',
    'ru',
    'rw',
    'sv',
    'th',
    'uk',
    'vi',
  };
}

class FFLocalizationsDelegate extends LocalizationsDelegate<FFLocalizations> {
  const FFLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    final language = locale.toString();
    return FFLocalizations.languages().contains(
      language.endsWith('_')
          ? language.substring(0, language.length - 1)
          : language,
    );
  }

  @override
  Future<FFLocalizations> load(Locale locale) =>
      SynchronousFuture<FFLocalizations>(FFLocalizations(locale));

  @override
  bool shouldReload(FFLocalizationsDelegate old) => false;
}

Locale createLocale(String language) => language.contains('_')
    ? Locale.fromSubtags(
        languageCode: language.split('_').first,
        scriptCode: language.split('_').last,
      )
    : Locale(language);

final kTranslationsMap = <Map<String, Map<String, String>>>[
  // MY_profilePage
  {
    'i61y9ibx': {
      'en': 'Edit Profile',
      'ar': 'تعديل الملف الشخصي',
      'de': 'Profil bearbeiten',
    },
    '03k0vw86': {
      'en': 'Cambiar Password',
      'ar': 'تغيير كلمة المرور',
      'de': 'Kennwort ändern',
    },
    '6w6wv95p': {
      'en': 'Notification Settings',
      'ar': 'إعدادات الإشعار',
      'de': 'Benachrichtigungseinstellungen',
    },
    'eojlfs66': {
      'en': 'Privacy Policy',
      'ar': 'سياسة الخصوصية',
      'de': 'Datenschutz-Bestimmungen',
    },
    '2ll42t1u': {
      'en': 'Dark Mode',
      'ar': '',
      'de': '',
    },
    '8d386226': {
      'en': 'Light Mode',
      'ar': '',
      'de': '',
    },
    '8srr2k0j': {
      'en': '',
      'ar': '•',
      'de': '•',
    },
  },
  // notificationsSettings
  {
    'sc4ff4ce': {
      'en': 'Notifications',
      'ar': 'إشعارات',
      'de': 'Benachrichtigungen',
    },
    'r72zvrv5': {
      'en':
          'Choose what notifcations you want to recieve below and we will update the settings.',
      'ar': 'اختر الإشعارات التي تريد تلقيها أدناه وسنقوم بتحديث الإعدادات.',
      'de':
          'Wählen Sie unten aus, welche Benachrichtigungen Sie erhalten möchten, und wir aktualisieren die Einstellungen.',
    },
    'gjygkr0n': {
      'en': 'Push Notifications',
      'ar': 'دفع الإخطارات',
      'de': 'Mitteilungen',
    },
    '3y3yhxbk': {
      'en':
          'Receive Push notifications from our application on a semi regular basis.',
      'ar': 'تلقي إشعارات من تطبيقنا على أساس شبه منتظم.',
      'de':
          'Erhalten Sie regelmäßig Push-Benachrichtigungen von unserer Anwendung.',
    },
    '1ytebj35': {
      'en': 'Email Notifications',
      'ar': 'اشعارات البريد الالكتروني',
      'de': 'E-Mail Benachrichtigungen',
    },
    '9lvh5nst': {
      'en':
          'Receive email notifications from our marketing team about new features.',
      'ar':
          'تلقي إشعارات البريد الإلكتروني من فريق التسويق لدينا حول الميزات الجديدة.',
      'de':
          'Erhalten Sie E-Mail-Benachrichtigungen von unserem Marketingteam über neue Funktionen.',
    },
    '69d2j74u': {
      'en': 'Location Services',
      'ar': 'خدمات الموقع',
      'de': 'Standortdienste',
    },
    '3k8cuv0d': {
      'en':
          'Allow us to track your location, this helps keep track of spending and keeps you safe.',
      'ar':
          'اسمح لنا بتتبع موقعك ، فهذا يساعد على تتبع الإنفاق ويحافظ على سلامتك.',
      'de':
          'Erlauben Sie uns, Ihren Standort zu verfolgen, dies hilft, die Ausgaben im Auge zu behalten und schützt Sie.',
    },
    'isgrgbfs': {
      'en': 'Save Changes',
      'ar': 'حفظ التغييرات',
      'de': 'Änderungen speichern',
    },
    'a96mlyeh': {
      'en': 'Home',
      'ar': 'مسكن',
      'de': 'Heim',
    },
  },
  // privacyPolicy
  {
    'alczfiiy': {
      'en': 'Privacy Policy',
      'ar': 'سياسة الخصوصية',
      'de': 'Datenschutz-Bestimmungen',
    },
    'fvsfg5on': {
      'en': 'How we use your data',
      'ar': 'كيف نستخدم بياناتك',
      'de': 'Wie wir Ihre Daten verwenden',
    },
    'nbiyrnzl': {
      'en':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Accumsan sit amet nulla facilisi morbi tempus. Non consectetur a erat nam. Donec ultrices tincidunt arcu non sodales. Velit sed ullamcorper morbi tincidunt. Molestie a iaculis at erat pellentesque adipiscing. Mauris nunc congue nisi vitae. Nisl tincidunt eget nullam non nisi. Faucibus nisl tincidunt eget nullam non nisi est. Leo duis ut diam quam nulla.\n\nEuismod lacinia at quis risus sed vulputate odio. Velit dignissim sodales ut eu sem integer vitae justo eget. Risus feugiat in ante metus. Leo vel orci porta non pulvinar neque laoreet suspendisse interdum. Suscipit tellus mauris a diam maecenas sed enim ut sem. Sem integer vitae justo eget magna fermentum iaculis eu. Lacinia at quis risus sed. Faucibus purus in massa tempor. Leo a diam sollicitudin tempor id eu. Nisi scelerisque eu ultrices vitae auctor. Vulputate dignissim suspendisse in est ante in. Enim neque volutpat ac tincidunt vitae semper quis. Ipsum dolor sit amet consectetur adipiscing elit.\n\nEt malesuada fames ac turpis egestas maecenas pharetra convallis. Sed sed risus pretium quam vulputate. Elit pellentesque habitant morbi tristique senectus et. Viverra maecenas accumsan lacus vel facilisis volutpat est. Sit amet mattis vulputate enim nulla. Nisi lacus sed viverra tellus in hac habitasse. Sit amet risus nullam eget felis eget nunc lobortis. Pretium lectus quam id leo in vitae. Adipiscing diam donec adipiscing tristique. Commodo sed egestas egestas fringilla. Ipsum dolor sit amet consectetur adipiscing. Ipsum dolor sit amet consectetur adipiscing elit pellentesque habitant morbi. Montes nascetur ridiculus mus mauris. Ut etiam sit amet nisl purus in. Arcu ac tortor dignissim convallis aenean et tortor at. Ornare suspendisse sed nisi lacus sed viverra.',
      'ar':
          'Lorem ipsum dolor sit amet، consectetur adipiscing elit، sed do eiusmod tempor incidunt ut labore et dolore magna aliqua. Accumsan sit amet nulla facilisi morbi tempus. غير consectetur a erat nam. دونك ألتريسيس تينسيدونت قوس غير مخادع. Velit sed ullamcorper morbi tincidunt. Molestie a iaculis في erat pellentesque adipiscing. موريس نونك كونيج سيرة ذاتية. Nisl tincidunt eget nullam non nisi. Faucibus nisl tincidunt eget nullam non nisi est. Leo duis ut diam quam nulla. Euismod lacinia في quis risus sed vulputate odio. فيليت كريمينسيم sodales ut eu sem سيرة ذاتية صحيحة justo eget. Risus feugiat في ما قبل ميتوس. Leo vel orci porta non pulvinar neque laoreet suspension interdum. Suscipit Tellus mauris a Diam Maecenas Sed enim ut sem. SEM السيرة الذاتية الصحيحة justo eget magna fermentum iaculis eu. لاسينيا في quis risus sed. Faucibus purus في ماسا مؤقت. ليو بقطر سوليتودين معرف مؤقت الاتحاد الأوروبي. Nisi scelerisque eu ultrices السيرة الذاتية موصل. Vulputate كريم معلق في وقت مبكر. Enim neque volutpat ac tincidunt vitae semper quis. Ipsum dolor sit amet consectetur adipiscing elit. Et malesuada fames ac turpis egestas maecenas pharetra convallis. Sed sed risus Préium quam vulputate. Elit pellentesque موطن morbi tristique senectus et. Viverra maecenas accumsan lacus vel facilisis volutpat est. sit amet mattis vulputate enim nulla. Nisi lacus sed viverra Tellus في العادة السيئة. اجلس أميت ريسوس نولام إيجيت فيليس إيجيت نونك لوبورتيز. Pretium lectus quam id leo in vitae. Adipiscing Diam donec adipiscing tristique. كومودو سيد egestas egestas fringilla. Ipsum dolor sit amet consectetur adipiscing. Ipsum dolor sit amet consectetur adipiscing النخبة pellentesque المعيشية morbi. مونتيس ناسيتور ريديكولوس موس موريس. Ut etiam sit amet nisl purus in. Arcu ac Ornare suspendisse sed nisi lacus sed viverra.',
      'de':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Accumsan sit amet nulla facilisi morbi tempus. Non consectetur a erat nam. Donec ultrices tincidunt arcu non sodales. Velit sed ullamcorper morbi tincidunt. Molestie a iaculis bei erat pellentesque adipiscing. Mauris nunc congue nisi vitae. Nisl tincidunt eget nullam non nisi. Faucibus nisl tincidunt eget nullam non nisi est. Leo duis ut diam quam nulla. Euismod lacinia at quis risus sed vulputate odio. Velit dignissim sodales ut eu sem integer vitae justo eget. Risus feugiat in ante metus. Leo vel orci porta non pulvinar neque laoreet suspendisse interdum. Suscipit tellus mauris a diam maecenas sed enim ut sem. Sem integer vitae justo eget magna fermentum iaculis eu. Lacinia bei quis risus sed. Faucibus purus in massa tempor. Leo a diam sollicitudin tempor id eu. Nisi scelerisque eu ultrices vitae auctor. Vulputate dignissim suspendisse in est ante in. Enim neque volutpat ac tincidunt vitae semper quis. Ipsum dolor sit amet consectetur adipiscing elit. Et malesuada fames ac turpis egestas maecenas pharetra convallis. Sed sed risus pretium quam vulputate. Elit pellentesque habitant morbi tristique senectus et. Viverra maecenas accumsan lacus vel facilisis volutpat est. Sit amet mattis vulputate enim nulla. Nisi lacus sed viverra tellus in hac habitasse. Sit amet risus nullam eget felis eget nunc lobortis. Pretium lectus quam id leo in vitae. Adipiscing diam donec adipiscing tristique. Commodo sed egestas egestas fringilla. Ipsum dolor sit amet consectetur adipiscing. Ipsum dolor sit amet consectetur adipiscing elit pellentesque habitant morbi. Montes nascetur ridiculus mus mauris. Ut etiam sit amet nisl purus in. Arcu ac tortor dignissim convallis aenean et tortor at. Ornare suspendisse sed nisi lacus sed viverra.',
    },
    'oks4x95o': {
      'en': 'Home',
      'ar': 'مسكن',
      'de': 'Heim',
    },
  },
  // homePage
  {
    'ysokumwl': {
      'en': 'Bienvenido',
      'ar': '',
      'de': '',
    },
    'kwfkdw55': {
      'en': 'Hijuelas, donde siempre',
      'ar': '',
      'de': '',
    },
    'metxy87w': {
      'en': '18 Agosto',
      'ar': '',
      'de': '',
    },
    '6f14vk8c': {
      'en': '20:00 hrs',
      'ar': '',
      'de': '',
    },
    '1fw8r7yu': {
      'en': '60',
      'ar': '',
      'de': '',
    },
    'zteq2wgi': {
      'en': 'Dias',
      'ar': '',
      'de': '',
    },
    '1wjai0f5': {
      'en': '60',
      'ar': '',
      'de': '',
    },
    '8bfig4sn': {
      'en': 'Dias',
      'ar': '',
      'de': '',
    },
    'iml3l5bq': {
      'en': '60',
      'ar': '',
      'de': '',
    },
    'mnztvdbu': {
      'en': 'Dias',
      'ar': '',
      'de': '',
    },
    'k290xjtj': {
      'en': '60',
      'ar': '',
      'de': '',
    },
    'kzit6c8y': {
      'en': 'Dias',
      'ar': '',
      'de': '',
    },
    'vo8tcdeu': {
      'en': '¡Deja volar tu imaginación y deslumbra con tu mejor disfraz!',
      'ar': '',
      'de': '',
    },
    'tfqsdxdb': {
      'en': '¡Toma el micrófono y deslumbra con tu talento en nuestro karaoke!',
      'ar': '',
      'de': '',
    },
    'gwa3xpxv': {
      'en': '¡Levanta tu copa y celebra con nuestras deliciosas bebidas!',
      'ar': '',
      'de': '',
    },
    '93gjluga': {
      'en': '',
      'ar': '',
      'de': '',
    },
  },
  // init
  {
    '3hn16327': {
      'en': '¡Estás Invitado!\n¡No te lo puedes perder!',
      'ar': '',
      'de': '',
    },
    'fcivjcip': {
      'en':
          'Estamos emocionados de tú asistencia. \n\nVen y disfruta de una noche llena de diversión, risas y recuerdos inolvidables. ',
      'ar': '',
      'de': '',
    },
    'rlrleueu': {
      'en': 'Ingreso',
      'ar': '',
      'de': '',
    },
    '4hbjt4rn': {
      'en': 'correo',
      'ar': '',
      'de': '',
    },
    '9fwymond': {
      'en': 'contraseña',
      'ar': '',
      'de': '',
    },
    '5d1jjuy6': {
      'en': 'Ingresar',
      'ar': '',
      'de': '',
    },
    'niqwd8sb': {
      'en': '',
      'ar': '',
      'de': '',
    },
    '6959blpi': {
      'en': 'Registro',
      'ar': '',
      'de': '',
    },
    'zipz2xek': {
      'en': 'correo',
      'ar': '',
      'de': '',
    },
    '5yltsksb': {
      'en': 'contraseña',
      'ar': '',
      'de': '',
    },
    '4z0grc1e': {
      'en': 'confirma contraseña',
      'ar': '',
      'de': '',
    },
    'yjkwfbi7': {
      'en': 'registrar',
      'ar': '',
      'de': '',
    },
    'taill4c8': {
      'en': '',
      'ar': '',
      'de': '',
    },
    'oxfwbcqv': {
      'en': 'Home',
      'ar': '',
      'de': '',
    },
  },
  // createGuest
  {
    'tiwknjce': {
      'en': 'Mi Personaje',
      'ar': '',
      'de': '',
    },
    'a3crinsw': {
      'en': 'mi disfraz',
      'ar': '',
      'de': '',
    },
    'l0fxj9hk': {
      'en': 'Invitado',
      'ar': '',
      'de': '',
    },
    '20t2fcpt': {
      'en': 'Ingresa el nombre del asistente',
      'ar': '',
      'de': '',
    },
    'opksl55s': {
      'en': 'Personaje',
      'ar': '',
      'de': '',
    },
    '84rf25eg': {
      'en': 'Cual será tu personaje ',
      'ar': '',
      'de': '',
    },
    '4662shix': {
      'en': 'Crear',
      'ar': '',
      'de': '',
    },
  },
  // profile
  {
    'k2qj5vo9': {
      'en': 'Mi Perfil',
      'ar': '',
      'de': '',
    },
    'qwml9bxs': {
      'en': 'Seleccionar ',
      'ar': '',
      'de': '',
    },
    'x3xwo1wz': {
      'en': 'Invitado',
      'ar': '',
      'de': '',
    },
    'x4g2ggb2': {
      'en': 'Email',
      'ar': '',
      'de': '',
    },
    '25w03a2n': {
      'en': 'Actualizar',
      'ar': '',
      'de': '',
    },
  },
  // editGuest
  {
    'jayykgk9': {
      'en': 'Mi Personaje',
      'ar': '',
      'de': '',
    },
    'ajr3jgq1': {
      'en': 'mi disfraz',
      'ar': '',
      'de': '',
    },
    't5c3ulwr': {
      'en': 'Invitado',
      'ar': '',
      'de': '',
    },
    'y2i5f8wo': {
      'en': 'Personaje',
      'ar': '',
      'de': '',
    },
    'cb7m5xi6': {
      'en': 'Actualizar',
      'ar': '',
      'de': '',
    },
    'kmfdjlim': {
      'en': 'Eliminar',
      'ar': '',
      'de': '',
    },
  },
  // changePass
  {
    'elmh6tns': {
      'en': 'Cambiar mi contraseña',
      'ar': '',
      'de': '',
    },
    'mrpi36yh': {
      'en': 'Email',
      'ar': '',
      'de': '',
    },
    '2w88daof': {
      'en': 'confirma el correo registrado y revia tu bandeja de entrada...',
      'ar': '',
      'de': '',
    },
    'ga06q8f6': {
      'en': 'Enviar Link',
      'ar': '',
      'de': '',
    },
  },
  // listinvitation
  {
    '1lb1v5z2': {
      'en': 'Personajes NO dsponibles',
      'ar': '',
      'de': '',
    },
  },
  // modalCustom
  {
    'nretwfml': {
      'en': 'Okis',
      'ar': '',
      'de': '',
    },
  },
  // Miscellaneous
  {
    'lzyb73wy': {
      'en': '',
      'ar': '',
      'de': '',
    },
    'kx9cdks4': {
      'en': '',
      'ar': '',
      'de': '',
    },
    'efvtwj7k': {
      'en': '',
      'ar': '',
      'de': '',
    },
    'ec5hfa1e': {
      'en': '',
      'ar': '',
      'de': '',
    },
    'q5ljwvfo': {
      'en': '',
      'ar': '',
      'de': '',
    },
    'j4rmwb3h': {
      'en': '',
      'ar': '',
      'de': '',
    },
    '6ah1b18f': {
      'en': '',
      'ar': '',
      'de': '',
    },
    '2kos1hen': {
      'en': '',
      'ar': '',
      'de': '',
    },
    'xvhmvwu4': {
      'en': '',
      'ar': '',
      'de': '',
    },
    'q0eb41y6': {
      'en': '',
      'ar': '',
      'de': '',
    },
    'pa7fojva': {
      'en': '',
      'ar': '',
      'de': '',
    },
    'ksw47jjm': {
      'en': '',
      'ar': '',
      'de': '',
    },
    'ozf72f5r': {
      'en': '',
      'ar': '',
      'de': '',
    },
    'aox3s4fb': {
      'en': '',
      'ar': '',
      'de': '',
    },
    'l8hv5a7z': {
      'en': '',
      'ar': '',
      'de': '',
    },
    '4pjwb70a': {
      'en': '',
      'ar': '',
      'de': '',
    },
    '0xlokf4y': {
      'en': '',
      'ar': '',
      'de': '',
    },
    '8twlwiwt': {
      'en': '',
      'ar': '',
      'de': '',
    },
    '8wcvsavt': {
      'en': '',
      'ar': '',
      'de': '',
    },
    '341adwsn': {
      'en': '',
      'ar': '',
      'de': '',
    },
    'adum5tv5': {
      'en': '',
      'ar': '',
      'de': '',
    },
    'jgtgdp2d': {
      'en': '',
      'ar': '',
      'de': '',
    },
    'ajhc3oj6': {
      'en': '',
      'ar': '',
      'de': '',
    },
    'twyxju5d': {
      'en': '',
      'ar': '',
      'de': '',
    },
    't4xzlq9q': {
      'en': '',
      'ar': '',
      'de': '',
    },
    '513nj4m0': {
      'en': '',
      'ar': '',
      'de': '',
    },
    'a1jxfgju': {
      'en': '',
      'ar': '',
      'de': '',
    },
  },
].reduce((a, b) => a..addAll(b));
