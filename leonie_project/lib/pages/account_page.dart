import 'package:first_app/api_service.dart';
import 'package:first_app/main.dart';
import 'package:first_app/pages/login/login_page.dart';
import 'package:first_app/widgets/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:first_app/widgets/list_selection.dart';
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
  List<dynamic> availableProductions = [];
  List<dynamic> favoriteProductions = [];
  List<dynamic> seenProductions = [];
  Map profile = {};

  @override
  void initState() {
    super.initState();
    getProfile();
    loadShows();
    loadProductions();
  }

  Future<void> loadShows() async {
    final response = await callApiGet("shows");
    if (response != null) {
      setState(() {
        availableShows = response;
        favoriteShows =
            availableShows.where((show) => show['liked'] == true).toList();
      });
    }
  }

  Future<void> loadProductions() async {
    final response = await callApiGet("productions");
    if (response != null) {
      setState(() {
        availableProductions = response;
        favoriteProductions = availableProductions
            .where((prod) => prod['liked'] == true)
            .fold<Map<int, Map<String, dynamic>>>({}, (map, prod) {
              map[prod['id_production']] = prod;
              return map;
            })
            .values
            .toList();
        seenProductions = availableProductions
            .where((prod) => prod['seen'] == true)
            .fold<Map<int, Map<String, dynamic>>>({}, (map, prod) {
              map[prod['id_production']] = prod;
              return map;
            })
            .values
            .toList();
      });
    }
  }

  Future<void> getProfile() async {
    final response = await callApiGet("profile");
    if (response != null) {
      setState(() {
        profile = response[0];
      });
    }
  }

  Future<void> logoutUser() async {
    final url = Uri.parse('https://tta.alwaysdata.net/logout');

    // Sends the logout request.
    final response = await http.post(url);

    if (response.statusCode == 200) {
      // Delete connection cookie in SharedPreferences.
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('almond_cookie');

      _navigateToLogin();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur de déconnexion')),
        );
      }
    }
  }

  void refresh() {
    // synchronize data on refresh page
    loadShows();
    loadProductions();
  }

  void _navigateToLogin() {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
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
    loadShows();
    loadProductions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50, right: 20, left: 20),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: [
                  Center(
                    child: Column(
                      children: [
                        // Profile picture
                        ProfilePicture(imageUrl: profile['url_avatar']),
                        const SizedBox(height: 10),
                        // Pseudo.
                        Text(
                          profile.isEmpty ? 'Pseudo' : profile['pseudo'],
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Disconnect button.
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: logoutUser,
                      tooltip: 'Déconnexion',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Wishlist field.
              ListSection(
                title: 'Shows Wishlist',
                elements: favoriteShows,
                type: 'show',
              ),
              ListSection(
                title: 'Productions Wishlist',
                elements: favoriteProductions,
                type: 'favorite production',
              ),
              ListSection(
                title: 'Productions Seen',
                elements: seenProductions,
                type: 'seen production',
              )
            ],
          ),
        ),
      ),
    );
  }
}
