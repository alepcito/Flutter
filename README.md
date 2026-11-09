# Cliente Flutter: autenticación, GraphQL, SSE y WebSocket

Cliente Flutter que integra autenticación REST, consultas y mutaciones
GraphQL, notificaciones en tiempo real por Server-Sent Events (SSE) y chat
por WebSocket, usando Material 3, recursos SVG y fuentes personalizadas.

Este repositorio contiene únicamente el cliente. Los servicios de backend
se proporcionan por separado.

## Capturas y demo

> _Pendiente: agregar 2–3 capturas del login, la pantalla de perfil y el
> chat, e idealmente un GIF corto del flujo de notificaciones SSE._

## Stack y protocolos

- **Framework:** Flutter / Dart (`^3.5.4`)
- **UI:** Material 3, SVG, fuentes personalizadas
- **Comunicación:**
  - REST para autenticación (login y manejo de tokens)
  - GraphQL para consulta y actualización de perfil
  - SSE para notificaciones en tiempo real
  - WebSocket para chat
- **Almacenamiento local:** `shared_preferences` para tokens y datos temporales

## Funcionalidades

- Inicio de sesión con correo y contraseña mediante API REST, manejo de
  errores y almacenamiento local de tokens.
- Formularios de registro por secciones (datos personales, cuenta y
  domicilio) con validaciones e indicadores de avance.
- Instrucciones y confirmación de requisitos de fotografía.
- Consulta del perfil y actualización del teléfono mediante GraphQL.
- Recepción de notificaciones SSE y solicitud de avisos de prueba al servidor.
- Envío y recepción de mensajes de chat mediante WebSocket.
- Aviso de privacidad académico y cierre de sesión con limpieza de tokens
  y datos temporales.

## Requisitos

- Flutter con Dart compatible con `^3.5.4` (`>=3.5.4 <4.0.0`), según
  `pubspec.yaml`, y con las dependencias del proyecto.
- Git para clonar el repositorio.
- Chrome para la versión web o un dispositivo/emulador configurado para Flutter.
- Acceso a los servidores de autenticación, GraphQL, SSE y WebSocket para
  utilizar las funciones remotas.

Se incluyen carpetas para Android, iOS, web, Windows, Linux y macOS. Cada
destino requiere sus herramientas de compilación; su presencia no implica
que todas las plataformas hayan sido verificadas.

## Instalación y ejecución

Clona el repositorio con su URL de Git y abre una terminal en la carpeta
que contiene `pubspec.yaml`. Ejecuta:

```sh
flutter doctor
flutter pub get
flutter devices