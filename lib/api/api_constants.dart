class ApiConstants {
  static const String baseUrl =
      'http://172.20.10.3/tkpm-contact-app-backend/api';

  // Auth
  static const String register = '$baseUrl/auth/register.php';
  static const String login = '$baseUrl/auth/login.php';
  static const String user = '$baseUrl/auth/user.php';
  static const String updateUser = '$baseUrl/auth/update.php';
  static const String deleteUser = '$baseUrl/auth/delete.php';

  // Contact
  static const String createContact = '$baseUrl/contact/create.php';
  static const String readContact = '$baseUrl/contact/read.php';
  static const String detailContact = '$baseUrl/contact/detail.php';
  static const String updateContact = '$baseUrl/contact/update.php';
  static const String deleteContact = '$baseUrl/contact/delete.php';
}
