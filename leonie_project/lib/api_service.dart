import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<dynamic>?> fetchShows() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Récupérer la valeur du cookie stocké
  String? cookie = prefs.getString('almond_cookie');
  if (cookie == null) {
    return null;
  }

  final url = Uri.parse('https://tta.alwaysdata.net/shows');

  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Cookie': cookie, // Utilisation du cookie récupéré
    },
  );

  if (response.statusCode == 200) {
    // Décoder la réponse JSON et renvoyer la liste des shows
    List<dynamic> shows = json.decode(response.body);
    return shows;
  } else {
    return null;
  }
}

Future<Map?> getInfoShow(idShow) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Récupérer la valeur du cookie stocké
  String? cookie = prefs.getString('almond_cookie');

  if (cookie == null) {
    return null;
  }

  final url = Uri.parse('https://tta.alwaysdata.net/shows/$idShow/details');

  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Cookie': cookie, // Utilisation du cookie récupéré
    },
  );

  if (response.statusCode == 200) {
    // Décoder la réponse JSON et renvoyer la liste des shows
    Map show = json.decode(response.body);
    return show;
  } else {
    return null;
  }
}

Future<List?> getInfoProductions(idShow) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Récupérer la valeur du cookie stocké
  String? cookie = prefs.getString('almond_cookie');

  if (cookie == null) {
    return null;
  }

  final url = Uri.parse('https://tta.alwaysdata.net/shows/$idShow/productions');

  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Cookie': cookie, // Utilisation du cookie récupéré
    },
  );

  if (response.statusCode == 200) {
    // Décoder la réponse JSON et renvoyer la liste des shows
    List productions = json.decode(response.body);
    return productions;
  } else {
    return null;
  }
}

Future<void> likeShow(int idShow) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Récupérer la valeur du cookie stocké
  String? cookie = prefs.getString('almond_cookie');
  if (cookie == null) {
    return;
  }

  final url = Uri.parse('https://tta.alwaysdata.net/shows/$idShow/like');

  await http.put(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Cookie': cookie, // Utilisation du cookie récupéré
    },
    body: json.encode({
      'action': 'yes',
    }),
  );
}

Future<void> unlikeShow(int idShow) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Récupérer la valeur du cookie stocké
  String? cookie = prefs.getString('almond_cookie');
  if (cookie == null) {
    return;
  }

  final url = Uri.parse('https://tta.alwaysdata.net/shows/$idShow/like');

  await http.put(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Cookie': cookie, // Utilisation du cookie récupéré
    },
    body: json.encode({
      'action': 'no',
    }),
  );
}
