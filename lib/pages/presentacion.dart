import 'package:flutter/material.dart';

class Presentacion extends StatelessWidget {
  const Presentacion({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            new Expanded(
              flex: 1,
              child: new SingleChildScrollView(
                scrollDirection: Axis.vertical, //.horizontal
                child: new Column(children: [
                  SizedBox(height: 50),
                  Text(
                    'Aplicando un Modelo TensorFlow Lite en Flutter',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(height: 50),
                  Text(
                      'Esta es una aplicación para poder ejemplificar el uso de un modelo de Machine Learning. En este caso directo, '
                      ''
                      'contamos con 2 ventanas, en ambas se hace uso de un modelo de reconocimiento de imágenes, en la primera ventana se '
                      ''
                      'encarga de clasificar en perros, gatos, o carros, y se muestra la clase y el porcentaje de acierto. En la segunda '
                      ''
                      'ventana se muestra directamente de la imagen las clases que un nuevo modelo reconoce.'
                      ''
                      'Para hacer la prueba de los modelos, desliza a la derecha y presiona en el botón flotante para cargar la imagen que deseas analizar.',
                      style: TextStyle(fontSize: 17.5),
                      textAlign: TextAlign.justify),
                  SizedBox(height: 50),
                  Text(
                      'Importante tener en cuenta que la aplicación no guarda nada en memoria, motivo por el cual solo es de '
                      ''
                      'validación en el instante, cada vez que cierres la aplicación, o salgas de la ventana de validación, la imagen que hayas analizado, '
                      ''
                      'sera limpiada.',
                      style: TextStyle(fontSize: 17.5),
                      textAlign: TextAlign.justify),
                  SizedBox(height: 100),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: RichText(
                      textAlign: TextAlign.right,
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: 'Esta aplicación ha sido diseñada por: \n'),
                          TextSpan(text: 'Carlos David Páez Ferreira \n'),
                          TextSpan(text: 'Universidad Santo Tomás \n'),
                          TextSpan(text: 'Seccional Tunja, 2021 \n'),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
