//Daniel Baez 2021-1697

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Couteau App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PaginaDeNavegacion(),
      //icon: AssetImage('assets/icon.png'),
    );
  }
}

class PaginaDeNavegacion extends StatefulWidget {
  @override
  _EstadoPaginaDeNavegacion createState() => _EstadoPaginaDeNavegacion();
}

class _EstadoPaginaDeNavegacion extends State<PaginaDeNavegacion> {
  int _indiceSeleccionado = 0;

  static List<Widget> _opcionesDeWidget = <Widget>[
    PaginaDeCajaDeHerramientas(),
    PaginaDePredictorDeGenero(),
    PaginaDeDeterminadorDeEdad(),
    PaginaDeUniversidades(),
    PaginaDeClima(),
    PaginaDeNoticiasWordPress(),
    PaginaDeAcercaDe(),
  ];

  static List<BottomNavigationBarItem> _itemsDeBarraDeNavegacionInferior =
      <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.build),
      label: 'Caja de Herramientas',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Predictor de Género',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.cake),
      label: 'Determinador de Edad',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.school),
      label: 'Universidades',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.wb_sunny),
      label: 'Clima',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.library_books),
      label: 'Noticias WordPress',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.info),
      label: 'Acerca de',
    ),
  ];

  void _alTocarItem(int index) {
    setState(() {
      _indiceSeleccionado = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Couteau App'),
      ),
      body: Center(
        child: _opcionesDeWidget.elementAt(_indiceSeleccionado),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _itemsDeBarraDeNavegacionInferior,
        currentIndex: _indiceSeleccionado,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        onTap: _alTocarItem,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
    );
  }
}

class PaginaDeCajaDeHerramientas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Caja de Herramientas'),
      ),
      body: Center(
        child: Image.asset(
          'assets/toolbox_image.jpg',
          width: 300,
          height: 300,
        ),
      ),
    );
  }
}

class PaginaDePredictorDeGenero extends StatefulWidget {
  @override
  _EstadoPaginaDePredictorDeGenero createState() =>
      _EstadoPaginaDePredictorDeGenero();
}

class _EstadoPaginaDePredictorDeGenero
    extends State<PaginaDePredictorDeGenero> {
  TextEditingController _controladorNombre = TextEditingController();
  String _genero = '';
  Color _colorTexto = Colors.black;
  String _imagenGenero = '';

  void _predecirGenero() async {
    final response = await http.get(
        Uri.parse('https://api.genderize.io/?name=${_controladorNombre.text}'));
    final responseData = json.decode(response.body);
    setState(() {
      _genero = responseData['gender'];
      _colorTexto = _genero == 'male'
          ? Colors.blue
          : _genero == 'female'
              ? Colors.pink
              : Colors.black;
      _imagenGenero = _genero == 'male'
          ? 'assets/male_icon.png'
          : _genero == 'female'
              ? 'assets/female_icon.png'
              : '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Predictor de Género'),
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _controladorNombre,
            decoration: InputDecoration(
              labelText: 'Ingrese su nombre',
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _predecirGenero,
            child: Text('Predecir'),
          ),
          SizedBox(height: 20),
          _genero.isNotEmpty
              ? Column(
                  children: [
                    Text(
                      _genero == 'male'
                          ? 'Masculino'
                          : _genero == 'female'
                              ? 'Femenino'
                              : 'Desconocido',
                      style: TextStyle(color: _colorTexto, fontSize: 24),
                    ),
                    SizedBox(height: 10),
                    _imagenGenero.isNotEmpty
                        ? Image.asset(
                            _imagenGenero,
                            width: 100,
                            height: 100,
                          )
                        : Container(),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}

class PaginaDeDeterminadorDeEdad extends StatefulWidget {
  @override
  _EstadoPaginaDeDeterminadorDeEdad createState() =>
      _EstadoPaginaDeDeterminadorDeEdad();
}

class _EstadoPaginaDeDeterminadorDeEdad
    extends State<PaginaDeDeterminadorDeEdad> {
  TextEditingController _controladorNombre = TextEditingController();
  int _edad = 0;
  String _categoriaEdad = '';

  void _determinarEdad() async {
    final response = await http
        .get(Uri.parse('https://api.agify.io/?name=${_controladorNombre.text}'));
    final responseData = json.decode(response.body);
    setState(() {
      _edad = responseData['age'];
      if (_edad < 18) {
        _categoriaEdad = 'Joven';
      } else if (_edad >= 18 && _edad <= 65) {
        _categoriaEdad = 'Adulto';
      } else {
        _categoriaEdad = 'Anciano';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Determinador de Edad'),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _controladorNombre,
                decoration: InputDecoration(
                  labelText: 'Ingrese su nombre',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _determinarEdad,
                child: Text('Determinar'),
              ),
              SizedBox(height: 20),
              _edad != 0
                  ? Column(
                      children: [
                        Text(
                          'Edad: $_edad',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Categoría de Edad: $_categoriaEdad',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        _categoriaEdad == 'Joven'
                            ? Image.asset('assets/young_image.jpg')
                            : _categoriaEdad == 'Adulto'
                                ? Image.asset('assets/adult_image.jpg')
                                : Image.asset('assets/elderly_image.jpg'),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

class PaginaDeUniversidades extends StatefulWidget {
  @override
  _EstadoPaginaDeUniversidades createState() =>
      _EstadoPaginaDeUniversidades();
}

class _EstadoPaginaDeUniversidades extends State<PaginaDeUniversidades> {
  TextEditingController _controladorPais = TextEditingController();
  List<dynamic> _universidades = [];

  void _buscarUniversidades() async {
    final response = await http.get(Uri.parse(
        'http://universities.hipolabs.com/search?country=${_controladorPais.text}'));
    final responseData = json.decode(response.body);
    setState(() {
      _universidades = responseData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Universidades'),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          TextField(
            controller: _controladorPais,
            decoration: InputDecoration(
              labelText: 'Ingrese el nombre del país (en inglés)',
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _buscarUniversidades,
            child: Text('Buscar'),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _universidades.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_universidades[index]['name']),
                  subtitle: Text('Dominio: ${_universidades[index]['domains'].join(", ")}'),
                  onTap: () {
                    if (_universidades[index]['web_pages'] != null &&
                        _universidades[index]['web_pages'].isNotEmpty) {
                      _lanzarURL(_universidades[index]['web_pages'][0]);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _lanzarURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir $url';
    }
  }
}

class PaginaDeClima extends StatefulWidget {
  @override
  _EstadoPaginaDeClima createState() => _EstadoPaginaDeClima();
}

class _EstadoPaginaDeClima extends State<PaginaDeClima> {
  String _nombreCiudad = 'Santo Domingo';
  double _temperatura = 0.0;
  String _condicionClimatica = '';
  String _urlIcono = '';

  void _obtenerDatosClima() async {
    final String apiKey = 'a36b03d5548e01d9dc46508e1728e1ed';
    final String apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=$_nombreCiudad&appid=$apiKey&units=metric';

    final response = await http.get(Uri.parse(apiUrl));
    final responseData = json.decode(response.body);

    setState(() {
      _temperatura = responseData['main']['temp'];
      _condicionClimatica = responseData['weather'][0]['main'];
      _urlIcono =
          'http://openweathermap.org/img/wn/${responseData['weather'][0]['icon']}.png';
    });
  }

  @override
  void initState() {
    super.initState();
    _obtenerDatosClima();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clima en $_nombreCiudad'),
      ),
      body: Center(
        child: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.lightBlueAccent,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Temperatura: $_temperatura°C',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              Text(
                'Condición: $_condicionClimatica',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              _urlIcono.isNotEmpty
                  ? Image.network(
                      _urlIcono,
                      width: 100,
                      height: 100,
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

class PaginaDeNoticiasWordPress extends StatefulWidget {
  @override
  _EstadoPaginaDeNoticiasWordPress createState() =>
      _EstadoPaginaDeNoticiasWordPress();
}

class _EstadoPaginaDeNoticiasWordPress extends State<PaginaDeNoticiasWordPress> {
  List<dynamic> _noticias = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _obtenerNoticias();
  }

  void _obtenerNoticias() async {
    try {
      final response =
          await http.get(Uri.parse('https://itla.edu.do/wp-json/wp/v2/posts'));
      final responseData = json.decode(response.body);
      final List<String> urlsMedios =
          await _obtenerUrlsMedios(responseData);
      setState(() {
        _noticias = responseData.take(3).toList();
        for (int i = 0; i < _noticias.length; i++) {
          _noticias[i]['mediaUrl'] = urlsMedios[i];
        }
        _cargando = false;
      });
    } catch (e) {
      print("Error fetching news: $e");
      setState(() {
        _cargando = false;
      });
    }
  }

  Future<List<String>> _obtenerUrlsMedios(List<dynamic> datosNoticias) async {
    List<String> urlsMedios = [];
    for (var noticia in datosNoticias) {
      var urlImagen = '';
      if (noticia['_links'] != null &&
          noticia['_links']['wp:featuredmedia'] != null &&
          noticia['_links']['wp:featuredmedia'].isNotEmpty) {
        final enlaceMedioDestacado =
            noticia['_links']['wp:featuredmedia'][0]['href'];
        final urlMedio = await _obtenerUrlMedio(enlaceMedioDestacado);
        urlImagen = urlMedio.isNotEmpty ? urlMedio : '';
      }
      urlsMedios.add(urlImagen);
    }
    return urlsMedios;
  }

  Future<String> _obtenerUrlMedio(String enlaceMedio) async {
    try {
      final respuestaMedio = await http.get(Uri.parse(enlaceMedio));
      final datosMedio = json.decode(respuestaMedio.body);
      if (datosMedio['source_url'] != null) {
        return datosMedio['source_url'];
      }
    } catch (e) {
      print("Error fetching media URL: $e");
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Noticias de ITLA'),
      ),
      body: _cargando
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Image.network(
                  'https://itla.edu.do/wp-content/uploads/2022/04/cropped-logo-full-3.png',
                  width: 150,
                  height: 150,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _noticias.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: _noticias[index]['mediaUrl'].isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: _noticias[index]['mediaUrl'],
                                width: 50,
                                height: 50,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              )
                            : Container(),
                        title: Text(
                          _noticias[index]['title']['rendered'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          _noticias[index]['excerpt']['rendered']
                              .replaceAll(RegExp(r'<[^>]*>'), '')
                              .replaceAll(RegExp(r'&#[0-9]+;'), ''),
                        ),
                        onTap: () {
                          if (_noticias[index]['link'] != null) {
                            _lanzarURL(_noticias[index]['link']);
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  void _lanzarURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir $url';
    }
  }
}

class PaginaDeAcercaDe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acerca de'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage('assets/daniel.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Daniel Baez',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 10),
          Text(
            'Si requieres una app como esta no dudes en contactarme a los siguientes contactos:',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 10),
          Text(
            'Teléfono: +1234567890',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            'Email: 20211697@itla.edu.do',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
