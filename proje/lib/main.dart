import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Cafe {
  final String name;
  final int rating; // Kafe puanı

  Cafe({required this.name, required this.rating});
}

class MyApp extends StatelessWidget {
  final List<Cafe> cafes = [
    Cafe(name: 'Cafe 1', rating: 4),
    Cafe(name: 'Cafe 2', rating: 5),
    Cafe(name: 'Cafe 3', rating: 3),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(cafes: cafes),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final List<Cafe> cafes;

  HomeScreen({required this.cafes});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> favorites = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ana Sayfa'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: CafeSearchDelegate(widget.cafes));
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('Profil'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Hakkımızda'),
              onTap: () {
                // Buraya hakkımızda sayfasına yönlendirme işlemleri eklenebilir.
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoriler',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FavoritesScreen(favorites: favorites),
              ),
            );
          }
        },
      ),
      body: ListView.builder(
        itemCount: widget.cafes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(widget.cafes[index].name),
            subtitle: Text('Puan: ${widget.cafes[index].rating}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CafeDetailScreen(cafe: widget.cafes[index]),
                ),
              );
            },
            trailing: IconButton(
              icon: favorites.contains(widget.cafes[index].name)
                  ? Icon(Icons.favorite, color: Colors.red)
                  : Icon(Icons.favorite_border, color: Colors.grey),
              onPressed: () {
                setState(() {
                  if (favorites.contains(widget.cafes[index].name)) {
                    favorites.remove(widget.cafes[index].name);
                  } else {
                    favorites.add(widget.cafes[index].name);
                  }
                });
              },
            ),
          );
        },
      ),
    );
  }
}

class ProfilScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile_image.jpg'),
            ),
            SizedBox(height: 20),
            Text(
              'Kullanıcı Adı',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('E-posta: kullanici@mail.com'),
            Text('Telefon: 123-456-7890'),
          ],
        ),
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  final List<String> favorites;

  FavoritesScreen({required this.favorites});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favoriler'),
      ),
      body: ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(favorites[index]),
          );
        },
      ),
    );
  }
}

class CafeDetailScreen extends StatelessWidget {
  final Cafe cafe;

  CafeDetailScreen({required this.cafe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cafe.name),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Puan: ${cafe.rating}'),
            // Diğer kafe detayları buraya eklenebilir
          ],
        ),
      ),
    );
  }
}

class CafeSearchDelegate extends SearchDelegate<String> {
  final List<Cafe> cafes;

  CafeSearchDelegate(this.cafes);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Implement search results here
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? cafes
        : cafes.where((cafe) => cafe.name.toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionList[index].name),
          subtitle: Text('Puan: ${suggestionList[index].rating}'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CafeDetailScreen(cafe: suggestionList[index]),
              ),
            );
          },
        );
      },
    );
  }
}