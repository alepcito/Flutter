import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLService {
  static final HttpLink _httpLink = HttpLink(
    'http://localhost:8000/graphql',
  );

  static final GraphQLClient _client = GraphQLClient(
    link: _httpLink,
    cache: GraphQLCache(store: InMemoryStore()),
  );

  /// Consulta los datos del perfil en el backend.
  static Future<Map<String, dynamic>> obtenerPerfil() async {
    const String query = r'''
      query ObtenerPerfil {
        perfil {
          id
          nombre
          email
          telefono
        }
      }
    ''';

    final resultado = await _client.query(
      QueryOptions(
        document: gql(query),
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (resultado.hasException) {
      throw Exception(
        'Error al consultar el perfil: ${resultado.exception}',
      );
    }

    final perfil = resultado.data?['perfil'];

    if (perfil == null) {
      throw Exception('El backend no devolvió los datos del perfil.');
    }

    return Map<String, dynamic>.from(perfil);
  }

  /// Actualiza el teléfono del perfil.
  static Future<Map<String, dynamic>> actualizarTelefono(
    String telefono,
  ) async {
    const String mutation = r'''
      mutation ActualizarTelefono($telefono: String!) {
        actualizarTelefono(telefono: $telefono) {
          id
          nombre
          email
          telefono
        }
      }
    ''';

    final resultado = await _client.mutate(
      MutationOptions(
        document: gql(mutation),
        variables: {'telefono': telefono},
      ),
    );

    if (resultado.hasException) {
      throw Exception(
        'Error al actualizar el teléfono: ${resultado.exception}',
      );
    }

    final perfil = resultado.data?['actualizarTelefono'];

    if (perfil == null) {
      throw Exception('El backend no devolvió el perfil actualizado.');
    }

    return Map<String, dynamic>.from(perfil);
  }
}