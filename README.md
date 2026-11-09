# Flutter + WebScoket, GraphQL y SSE

Cliente Flutter desarrollado con Dart para practicar autenticación, formularios y comunicación con servidores mediante REST, GraphQL, Server-Sent Events (SSE) y WebSocket. Utiliza Material 3, recursos SVG y fuentes personalizadas.

Este repositorio contiene el cliente. Los servicios de backend se proporcionan por separado.

## Funcionalidades

- Inicio de sesión con correo y contraseña mediante una API REST, manejo de errores y almacenamiento local de tokens.
- Formularios de registro por secciones: datos personales, cuenta y domicilio, con validaciones e indicadores de avance.
- Instrucciones y confirmación de requisitos de fotografía.
- Consulta del perfil y actualización del teléfono mediante GraphQL.
- Recepción de notificaciones SSE y solicitud de avisos de prueba al servidor.
- Envío y recepción de mensajes de chat mediante WebSocket.
- Aviso de privacidad académico y cierre de sesión con limpieza de tokens y datos temporales.

Los formularios de registro guardan datos temporalmente en `UserData`; actualmente no los envían a un endpoint de registro. La sección de fotografía confirma instrucciones, pero no captura ni sube imágenes.

## Requisitos

- Flutter con Dart compatible con `^3.5.4` (`>=3.5.4 <4.0.0`), según `pubspec.yaml`, y con las dependencias del proyecto.
- Git para clonar el repositorio.
- Chrome para la versión web o un dispositivo/emulador configurado para Flutter.
- Acceso a los servidores de autenticación, GraphQL, SSE y WebSocket para utilizar las funciones remotas.

Se incluyen carpetas para Android, iOS, web, Windows, Linux y macOS. Cada destino requiere sus herramientas de compilación; su presencia no implica que todas las plataformas hayan sido verificadas.

## Instalación y ejecución

Clona el repositorio con su URL de Git y abre una terminal en la carpeta que contiene `pubspec.yaml`. Ejecuta:

```sh
flutter doctor
flutter pub get
flutter devices
```

Para iniciar en Chrome:

```sh
flutter run -d chrome
```

Para otro destino, utiliza el identificador mostrado por `flutter devices`:

```sh
flutter run -d <id-del-dispositivo>
```

También puedes servir la aplicación web en un puerto fijo:

```sh
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 3000
```

Abre `http://localhost:3000` en el equipo que ejecuta Flutter.

## Configuración del backend

Las direcciones están definidas directamente en el código. Actualmente no se cargan desde `.env` ni mediante `--dart-define`. Ajusta estas ubicaciones según tu entorno:

| Servicio | Dirección configurada | Archivo |
| --- | --- | --- |
| Login REST | `http://developer.jquiroz.net:3005/api/users/login` | [auth_service.dart](lib/services/auth_service.dart) |
| Perfil GraphQL | `http://localhost:8000/graphql` | [graphql_service.dart](lib/services/graphql_service.dart) |
| Eventos SSE | `http://localhost:8000/notificaciones/eventos` | [notifications_page.dart](lib/screens/notifications_page.dart) |
| Generación de avisos | `http://localhost:8000/notificaciones/generar` | [notifications_page.dart](lib/screens/notifications_page.dart) |
| Chat WebSocket | `ws://localhost:8000/ws/chat` | [websocket_test_page.dart](lib/screens/websocket_test_page.dart) |

La pantalla independiente [sse_test_page.dart](lib/screens/sse_test_page.dart) también contiene las direcciones SSE. El servicio alternativo [api_service.dart](lib/services/api_service.dart) utiliza `http://localhost:3000`, distinto del servicio GraphQL utilizado por Mi cuenta.

### Contratos esperados

- **Login:** `POST /api/users/login` con JSON `{"email":"...","password":"..."}`. Una respuesta exitosa usa HTTP 200 e incluye `accessToken` y `refreshToken`; los errores pueden incluir `message`.
- **GraphQL:** consulta `perfil { id nombre email telefono }` y mutación `actualizarTelefono(telefono: String!) { id nombre email telefono }`.
- **SSE:** `GET /notificaciones/eventos`, con respuesta `text/event-stream`. Los eventos pueden contener JSON en `data` con `id`, `mensaje` y `hora`, o mensajes de texto.
- **Generación de avisos:** `POST /notificaciones/generar` con JSON que incluya `mensaje`. El aviso aparece al recibirse por el flujo SSE.
- **WebSocket:** `/ws/chat` intercambia mensajes de texto. La difusión entre clientes depende del servidor.

### Conexión desde otros dispositivos

`localhost` se refiere al dispositivo donde se ejecuta la aplicación. Para acceder al servidor de tu computadora desde el emulador estándar de Android, utiliza `10.0.2.2`; en un teléfono físico, utiliza una IP de la computadora accesible desde su red.

En web, el backend debe permitir el origen del cliente mediante CORS. Si sirves el cliente mediante HTTPS, configura HTTPS y WSS en los servicios para evitar bloqueos por contenido mixto.

## Uso

1. Inicia los servidores necesarios y revisa sus direcciones en el cliente.
2. Accede con credenciales válidas del backend de autenticación.
3. Desde la bienvenida, abre Registro para completar sus secciones.
4. Abre Mi cuenta en el menú para consultar el perfil y guardar un teléfono.
5. Abre Notificaciones para recibir eventos y generar un aviso de prueba.
6. Abre Chat en dos clientes para comprobar el intercambio de mensajes si el servidor permite su difusión.
7. Utiliza Cerrar sesión para eliminar los tokens locales y limpiar los datos temporales.

La aplicación carga `assets/es.json` y fija el idioma español en `lib/app.dart`. Incluye también `assets/en.json`, pero no dispone de un selector de idioma en la interfaz.

## Estructura

```text
lib/
  main.dart       # Punto de entrada
  app.dart        # Tema, idioma e inicialización
  models/         # Datos temporales y modelos de respuesta
  screens/        # Login, registro, perfil, notificaciones y chat
  services/       # REST, GraphQL y almacenamiento de tokens
  widgets/        # Componentes compartidos
assets/           # SVG, imágenes, fuentes y textos JSON
test/             # Pruebas de lógica y widgets
docs/             # Documentación técnica y guías
```

## Verificación y compilación

Desde la raíz del proyecto:

```sh
flutter analyze
flutter test
flutter build web
```

La compilación web se genera en `build/web/`. Para generar un APK con las herramientas de Android instaladas:

```sh
flutter build apk --release
```

Las pruebas incluyen validaciones, formularios, navegación, localización y almacenamiento de tokens. Algunas pruebas con nombres de integración o E2E utilizan datos simulados; no sustituyen una comprobación con los servidores reales.

## Docker para desarrollo web

Se incluyen `Dockerfile.dev` y `docker-compose.yml`. Antes de usarlos, alinea los puertos: el comando del Dockerfile inicia Flutter en **3000**, mientras que Compose publica `8081:8080` y el Dockerfile declara `EXPOSE 8080`.

Si mantienes Flutter en el puerto 3000, cambia el mapeo de Compose a `8081:3000` y la declaración del Dockerfile a `EXPOSE 3000`. Después ejecuta:

```sh
docker compose up --build
```

Abre `http://localhost:8081`. El contenedor ejecuta únicamente el cliente Flutter y no inicia los servicios de backend. El comentario de versión del Dockerfile difiere de su etiqueta `FROM`; verifica la imagen disponible antes de construir.

## Consideraciones de uso

Es un proyecto académico: utiliza datos ficticios y credenciales exclusivas de prueba. Las direcciones actuales usan HTTP/WS y los tokens se guardan mediante `shared_preferences`, que no proporciona almacenamiento cifrado de secretos.

## Documentación adicional

- [Comunicación con el backend y guion de demostración](docs/comunicacion.md).
- [Guía de desarrollo completa (LaTeX)](docs/guia_desarrollo_completa.tex).
- [Continuación de la guía de desarrollo (LaTeX)](docs/guia_desarrollo_continuacion.tex).
