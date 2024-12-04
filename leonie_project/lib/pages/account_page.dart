import 'package:first_app/api_service.dart';
import 'package:first_app/main.dart';
import 'package:first_app/pages/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:first_app/widgets/show_list_selection.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends ConsumerStatefulWidget {
  const AccountPage({super.key});

  @override
  ConsumerState<AccountPage> createState() => AccountPageState();
}

class AccountPageState extends ConsumerState<AccountPage> with RouteAware {
  List<dynamic> availableShows = [];
  List<dynamic> favoriteShows = [];

  @override
  void initState() {
    super.initState();
    _fetchAndSetShows();
  }

  Future<void> _fetchAndSetShows() async {
    List<dynamic>? fetchedShows = await fetchShows();
    if (fetchedShows != null) {
      setState(() {
        availableShows = fetchedShows;
        favoriteShows =
            availableShows.where((show) => show['liked'] == true).toList();
      });
    }
  }

  Future<void> logoutUser() async {
    final url = Uri.parse('https://tta.alwaysdata.net/logout');

    // Envoyer la requête de déconnexion
    final response = await http.post(url);

    if (response.statusCode == 200) {
      // Effacer le cookie de connexion dans SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('almond_cookie');

      // Rediriger vers la page de login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      // Gérer les erreurs si besoin
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de déconnexion')),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ModalRoute? modalRoute = ModalRoute.of(context);
    if (modalRoute is PageRoute) {
      routeObserver.subscribe(this, modalRoute);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _fetchAndSetShows();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50, right: 20, left: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: [
                  const Center(
                    child: Text(
                      'Pseudo',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: logoutUser,
                      tooltip: 'Déconnexion',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ShowListSection(
                title: 'Wishlist',
                shows: favoriteShows,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
