import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  void addFavorite(dynamic mekan) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriMekanlar = prefs.getStringList('favoriMekanlar') ?? [];
    favoriMekanlar.add(mekan['name']);
    prefs.setStringList('favoriMekanlar', favoriMekanlar);
  }

  void removeFavorite(dynamic mekan) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriMekanlar = prefs.getStringList('favoriMekanlar') ?? [];
    favoriMekanlar.remove(mekan['name']); // Favorilerden gym ismini kaldırıyoruz
    prefs.setStringList('favoriMekanlar', favoriMekanlar);
  }

  Future<List<String>> getfavoriMekanlar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('favoriMekanlar') ?? [];
  }
}