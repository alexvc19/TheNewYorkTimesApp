# The Most Popular Articles de The New York Times
## TheNewYorkTimesApp

Esta es una aplicación iOS que consume la API de los artículos más enviados por correo electrónico del New York Times.

## Objetivo
Se consume una API para obtener los articulos, mostrar los artículos mas populares en una lista, Permitir que los usuarios vean los detalles completos de los artículos.

## Descripción 
La aplicación permite a los usuarios visualizar los artículos más populares, ver sus detalles y guardar los artículos localmente en core data para su acceso sin conexión.

## Requisitos
Para ejecutar este proyecto, necesitarás lo siguiente:
- Xcode 12.0 o superior
- Swift 5.0 o superior
- CocoaPods

### Dependencias
- [RxSwift](https://github.com/ReactiveX/RxSwift) 
#### Instalacion de dependencias
- cd <Ruta_del_Proyecto>
- pod install

## Arquitectura
Se optó por utilizar **MVVM** como patrón de arquitectura ya que ayuda a organizar de mejor manera el código pues separa la capa de datos, logica de negoció y la vista, a difetencia de otros patrones MVVM distribuye mejor las responsabilidades de cada capa lo que evita el uso de patrones complejos.