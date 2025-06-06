import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future callApiGet(String request) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Retrieves the value of the stored cookie.
  String? cookie = prefs.getString('almond_cookie');

  if (cookie == null) {
    return null;
  }

  final url = Uri.parse('https://tta.alwaysdata.net/$request');

  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Cookie': cookie,
    },
  );
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    return null;
  }
}

Future<void> likeShow(int idShow) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Retrieves the value of the stored cookie.
  String? cookie = prefs.getString('almond_cookie');
  if (cookie == null) {
    return;
  }

  final url = Uri.parse('https://tta.alwaysdata.net/shows/$idShow/like');

  await http.put(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Cookie': cookie,
    },
    body: json.encode({
      'action': 'yes',
    }),
  );
}

Future<void> unlikeShow(int idShow) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Retrieves the value of the stored cookie.
  String? cookie = prefs.getString('almond_cookie');
  if (cookie == null) {
    return;
  }

  final url = Uri.parse('https://tta.alwaysdata.net/shows/$idShow/like');

  await http.put(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Cookie': cookie,
    },
    body: json.encode({
      'action': 'no',
    }),
  );
}

Future<void> likeProduction(int idProduction) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Retrieves the value of the stored cookie.
  String? cookie = prefs.getString('almond_cookie');
  if (cookie == null) {
    return;
  }

  final url =
      Uri.parse('https://tta.alwaysdata.net/productions/$idProduction/like');

  await http.put(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Cookie': cookie,
    },
    body: json.encode({
      'action': 'yes',
    }),
  );
}

Future<void> unlikeProduction(int idProduction) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Retrieves the value of the stored cookie.
  String? cookie = prefs.getString('almond_cookie');
  if (cookie == null) {
    return;
  }

  final url =
      Uri.parse('https://tta.alwaysdata.net/productions/$idProduction/like');

  await http.put(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Cookie': cookie,
    },
    body: json.encode({
      'action': 'no',
    }),
  );
}

Future<void> seeProduction(int idProduction, int idProgramming) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Retrieves the value of the stored cookie.
  String? cookie = prefs.getString('almond_cookie');
  if (cookie == null) {
    return;
  }

  final url = Uri.parse('https://tta.alwaysdata.net/seen/create');

  await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Cookie': cookie,
    },
    body: json.encode({
      'id_production': idProduction,
      'id_programming': idProgramming,
    }),
  );
}

Future<void> unseeProduction(int idSeen) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Retrieves the value of the stored cookie.
  String? cookie = prefs.getString('almond_cookie');
  if (cookie == null) {
    return;
  }

  final url = Uri.parse('https://tta.alwaysdata.net/seen/$idSeen');

  await http.delete(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Cookie': cookie,
    },
  );
}

// Future<void> uploadProfilePicture(File image) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();

//   // Retrieves the value of the stored cookie.
//   String? cookie = prefs.getString('almond_cookie');
//   if (cookie == null) {
//     return;
//   }

//   final url =
//       Uri.parse('https://tta.alwaysdata.net/profile/url_avatar');

//   await http.put(
//     url,
//     headers: {
//       'Content-Type': 'application/json',
//       'Cookie': cookie,
//     },
//     body: json.encode({
//       'action': 'yes',
//     }),
//   );
// }
