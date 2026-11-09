/// Clase en memoria para almacenar los datos del usuario durante la sesión.
class UserData {
  /// Datos personales
  static String name = '';
  static String lastName = ''; // Primer Apellido (Paterno)
  static String secondLastName = ''; // Segundo Apellido (Materno)
  static String birthDate = ''; // Formato esperado: YYYY-MM-DD
  static String gender = '';
  static String nationality = '';

  /// Datos de cuenta
  static String phone = '';
  static String email = '';
  static String username = '';
  static String password = '';
  static String occupation = '';
  static String role = 'user'; // Valor por defecto común

  /// Dirección
  static String zipCode = '';
  static String state = '';
  static String city = '';
  static String neighborhood = '';
  static String street = '';
  static String extNumber = '';
  static String intNumber = ''; // Opcional
  static String reference = ''; // Opcional

  static bool photoConfirmed = false;

  /// Limpia todos los campos al terminar el registro o cerrar sesión
  static void clear() {
    name = '';
    lastName = '';
    secondLastName = '';
    birthDate = '';
    gender = '';
    nationality = '';

    phone = '';
    email = '';
    username = '';
    password = '';
    occupation = '';

    role = 'user';

    zipCode = '';
    state = '';
    city = '';
    neighborhood = '';
    street = '';
    extNumber = '';
    intNumber = '';
    reference = '';

    photoConfirmed = false;
  }

  static Map<String, dynamic> toJson() {
    // Función para asegurar que la fecha sea YYYY-MM-DD
    String formatForBackend(String date) {
      if (date.contains('/')) {
        // Si viene como 31/03/2026 -> lo voltea a 2026-03-31
        var parts = date.split('/');

        if (parts.length == 3) {
          return "${parts[2]}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}";
        }
      }

      return date; // Si ya tiene el formato correcto, lo deja igual
    }

    return {
      "username": username,
      "password": password,
      "email": email,
      "first_name": name,
      "last_name": "$lastName $secondLastName".trim(),
      "profile_picture": "https://api.tuferreteria.com/default.png",
      "nationality": nationality,
      "occupation": occupation,
      "date_of_birth": formatForBackend(birthDate),
      "contact_phone_number": phone,
      "gender": gender,
      "address": street,
      "address_number": extNumber,
      "address_interior_number": intNumber,
      "address_complement": reference,
      "address_neighborhood": neighborhood,
      "address_zip_code": zipCode,
      "address_city": city,
      "address_state": state,
      "role": role.toLowerCase(),
      "is_superuser": false,
      "is_active": true,
    };
  }

  /// Verifica si los campos OBLIGATORIOS están llenos.
  ///
  /// Se quitaron intNumber y reference por ser comúnmente opcionales.
  static bool isComplete() {
    return name.isNotEmpty &&
        lastName.isNotEmpty &&
        birthDate.isNotEmpty &&
        phone.isNotEmpty &&
        email.isNotEmpty &&
        username.isNotEmpty &&
        password.isNotEmpty &&
        street.isNotEmpty &&
        extNumber.isNotEmpty &&
        zipCode.isNotEmpty &&
        city.isNotEmpty &&
        state.isNotEmpty &&
        photoConfirmed;
  }
}