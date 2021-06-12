# Flutter TFLite

Esta es una aplicación en Flutter ideada para hacer uso de un modelo de TensorFlow Lite. 

## Entrenamiento del Modelo

El modelo se entrenó en **Lobe**, con 2 datasets distintos:

- [60,000+ Images of Cars, The Car Connection Picture Dataset](https://www.kaggle.com/prondeau/the-car-connection-picture-dataset)

- [Cat and Dog, Cats and Dogs dataset to train a DL model](https://www.kaggle.com/tongpython/cat-and-dog)

Se entrenaron 3 categorías (Cats, Dogs, Cars), cada una de ellas con un rango de imágenes de entre 4000 y 5000 imágenes, logrando un total de 12834. El proceso de entrenamiento en Lobe, determino que la predicción fue de 99% correcto, dejando un error del 1%. El modelo posteriormente fue exportado como un TensorFlow Lite para uso en dispositivos móviles. 

## Previas configuraciones

Dentro del archivo `android/app/build.gradle`, se debe cambiar la versión mínima del SDK a 19, además de que se debe añadir la herramienta `aaptOptions`, para lo cual, en la se muestra cómo debe quedar:

```gradle
android {
    ...
    defaultConfig {
        ...
        minSdkVersion 19
        ...
    }
    ...
    aaptOptions {
        noCompress "tflite"
        noCompress "lite"
    }
}
```

## Instalación de dependencias en Flutter

Dentro del archivo `pubspec.yaml`, se proceden a instalar los paquetes necesarios para la aplicación y la integración con TensorFlow.

Para TensorFlow usamos la siguiente dependencia:

```yaml
dependencies:
    ...
    tflite: ^1.1.2
```

Y para el selector de imágenes, instalamos el siguiente paquete:

```yaml
dependencies:
    ...
    image_picker: ^0.8.0+1
```

## Ubicación del modelo

A nivel de raíz dentro del directorio de la aplicación, se crea una carpeta llamada `assets` y dentro del archivo `pubspec.yaml` editamos lo siguiente para tener un acceso total al modelo:

```yaml
assets:
    - assets/
```

## Icono de la aplicación

Para hacer uso de un icono que represente a la aplicación, se debe hacer la instalación de algunos paquetes dentro del archivo `pubspec.yaml`. 

```yaml
dev_dependencies:
  ...
  flutter_launcher_icons: ^0.9.0

flutter_icons:
  android: true
  ios: true
  image_path: "assets/images/icon/icon.png"
```

Para permitir que el icono se instancie en la aplicación, ingresamos el siguiente comando en la terminal:

```
flutter pub run flutter_launcher_icons:main
```

## Exportar apk en release

Para exportar la aplicación en modo release, ingresamos el siguiente comando en la terminal:

```
flutter build apk
```

Cuando se termine la ejecución de dicho comando, podemos acceder a la apk en la carpeta `build/app/outputs/flutter-apk/app-release.apk`
