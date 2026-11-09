# Comunicación en el proyecto académico

El menú integra las tres tecnologías con los servicios ya existentes:

| Acceso | Tecnología | Función |
| --- | --- | --- |
| Mi cuenta | GraphQL | Consulta automática del perfil y edición del teléfono |
| Notificaciones | SSE | Recepción automática de eventos del servidor |
| Chat | WebSocket | Envío y recepción de mensajes |

El formulario Cuenta dentro de Registro sigue guardando datos temporales en
`UserData`; Mi cuenta muestra el perfil remoto y no modifica ese formulario.
Los botones de prueba independientes permanecen comentados en la bienvenida.

## Contrato del backend existente

Este repositorio contiene el cliente Flutter. Para una demostración real se
necesita un servidor accesible que implemente los siguientes endpoints:

- `POST http://localhost:8000/graphql`: query `perfil { id nombre email telefono }`
  y mutation `actualizarTelefono(telefono: String!) { id nombre email telefono }`.
- `GET http://localhost:8000/notificaciones/eventos`: respuesta
  `Content-Type: text/event-stream`; cada evento contiene JSON en `data`, con
  `id`, `mensaje` y `hora`. Los eventos de texto también se muestran.
- `POST http://localhost:8000/notificaciones/generar`: recibe
  `{"mensaje":"Notificación de prueba desde Flutter"}` y debe publicar el aviso
  en el flujo SSE. El botón no agrega avisos directamente a la lista: estos
  aparecen al recibir el evento del servidor.
- `ws://localhost:8000/ws/chat`: recibe y envía mensajes de texto. La difusión
  entre clientes depende de la implementación del servidor.

Las direcciones están en `graphql_service.dart`, `notifications_page.dart` y
`websocket_test_page.dart`. `localhost` se refiere al dispositivo que ejecuta
la aplicación. En un emulador o teléfono se debe usar una dirección alcanzable
del equipo que aloja el backend. Para Flutter Web, el backend debe permitir
el origen de la aplicación mediante CORS en sus endpoints HTTP.

## Guion de demostración

1. Iniciar el backend y acceder a la aplicación.
2. Abrir Mi cuenta: observar el perfil consultado, editar el teléfono y guardar.
   Volver a consultar para comprobar el dato persistido por el servidor.
3. Abrir Notificaciones: observar el estado de suscripción y generar un aviso.
   Comprobar que aparece sin recargar. También se pueden emitir avisos desde
   otro cliente. Pausar la recepción y reactivarla con los botones de la pantalla.
4. Abrir Chat en dos clientes conectados al mismo servidor y enviar mensajes.
5. Detener el servidor para documentar los estados de error y desconexión.

El aviso de privacidad es contenido estático adaptado al uso académico.
