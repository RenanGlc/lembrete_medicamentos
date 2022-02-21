import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController _controllerTempo = TextEditingController();
  TextEditingController _controllerNome = TextEditingController();
  var _idUsuario;
  bool carregando = true;

  _recuperarDadosUsuario(){

    carregando = true;

    OneSignal.shared.getDeviceState().then((deviceState) {
      _idUsuario = deviceState?.userId;
    }).then((value) async {

      var collection = FirebaseFirestore.instance.collection('preferencias');
      var docSnapshot = await collection.doc(_idUsuario).get();
      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data();
        _controllerTempo.text = data?['horas'];
        _controllerNome.text = data?['nomeRemedio'];
      }
    });

    carregando = false;

  }

  _atualizarPreferencias(String nomeRemedio, String horas){

    var db = FirebaseFirestore.instance;

    Map<String, dynamic> dadosAtualizar = {
      "nomeRemedio" : nomeRemedio,
      "horas" : horas
    };

    db.collection("preferencias")
        .doc(_idUsuario).set(
        dadosAtualizar);

  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Container(
            child: const Text("Deu erro"),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {

          _recuperarDadosUsuario();

          return Scaffold(
            body: SafeArea(
              child: carregando
              ? const Center(
                child: CircularProgressIndicator(),
              )
              : SingleChildScrollView(
                child: Column(
                  children: [

                    const Text("Digite a quantidade de tempo em horas para disparo da notificação"),

                    TextField(
                      controller: _controllerTempo,
                    ),

                    TextField(
                      controller: _controllerNome,
                    ),

                    ElevatedButton(
                        onPressed: (){
                          print(_controllerTempo.text);
                          _atualizarPreferencias(_controllerNome.text, _controllerTempo.text);
                        },
                        child: const Text(
                            "Printar tempo"
                        )
                    )

                  ],
                ),
              ),
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const Scaffold(
          body: SafeArea(
              child: Center(
                child: CircularProgressIndicator(),
              )
          ),
        );
      },
    );
  }
}
