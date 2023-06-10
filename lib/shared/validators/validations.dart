class Validations {
  static bool isValidName(String name) {
    return name != null && name.length > 2;
  }

  static bool isValidPass(String pass) {
    return pass != null && pass.length >= 6;
  }

  static bool isValidPhone(String phone) {
    return phone != null && phone.length >= 10;
  }

  static bool isValidEmail(String email) {
    return email != null && email.length > 10 && email.contains("@gmail.com");
  }
}

