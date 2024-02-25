import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uhholivia_live2d_app/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

bool isInDebugMode = false;
final FirebaseFirestore db = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  auth.setPersistence(Persistence.LOCAL);

  assert(isInDebugMode = true);
  if (isInDebugMode) {
    db.useFirestoreEmulator('localhost', 6968);
    auth.useAuthEmulator('localhost', 9099);
  }
  runApp(const MaterialApp(
    title: 'Uhh Olivia Live2d',
    home: MainWindow(),
  ));
}

class MainWindow extends StatelessWidget {
  const MainWindow({super.key});

  Future<UserCredential> signInWithGoogle() async {
    // Create a new provider
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    googleProvider
        .addScope('https://www.googleapis.com/auth/contacts.readonly');
    googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithPopup(googleProvider);

    // Or use signInWithRedirect
    // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 255, 66, 139),
              title: const Text('UhhOlivia')),
          body: Stack(children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color:
                  Colors.primaries[Random().nextInt(Colors.primaries.length)],
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const AboutScreen()));
                },
                child: const Text('text')),
            Center(
              child: ElevatedButton(
                  onPressed: signInWithGoogle,
                  child: const Icon(Icons.login_outlined)),
            ),
          ])),
    );
  }
}

class Movie {
  Movie({required this.title, required this.genre});

  Movie.fromJson(Map<String, Object?> json)
      : this(
          title: json['title']! as String,
          genre: json['genre']! as String,
        );

  final String title;
  final String genre;

  Map<String, Object?> toJson() {
    return {
      'title': title,
      'genre': genre,
    };
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: TextButton(
          onPressed: () {
            final user = <String, dynamic>{
              "first": "Ada",
              "last": "Lovelace",
              "born": 1815
            };

            db.collection("users").add(user).then((DocumentReference doc) =>
                // ignore: avoid_print
                print('DocumentSnapshot added with ID: ${doc.id}'));
          },
          child: const Text("Create user")),
    );
  }
}
