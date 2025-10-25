class PhoneFormatter {
  /// Remove todos os caracteres não numéricos
  static String removeFormatting(String phone) {
    return phone.replaceAll(RegExp(r'[^0-9]'), '');
  }

  /// Formata telefone brasileiro: (11) 98765-4321 ou (11) 3456-7890
  static String format(String phone) {
    final numbers = removeFormatting(phone);

    if (numbers.length == 11) {
      // Celular: (11) 98765-4321
      return '(${numbers.substring(0, 2)}) ${numbers.substring(2, 7)}-${numbers.substring(7)}';
    } else if (numbers.length == 10) {
      // Fixo: (11) 3456-7890
      return '(${numbers.substring(0, 2)}) ${numbers.substring(2, 6)}-${numbers.substring(6)}';
    }

    return phone; // Retorna original se não for 10 ou 11 dígitos
  }

  /// Valida se o telefone tem formato válido (10 ou 11 dígitos)
  static bool isValid(String phone) {
    final numbers = removeFormatting(phone);
    return numbers.length == 10 || numbers.length == 11;
  }

  /// Formata enquanto digita (para TextField)
  static String formatWhileTyping(String text) {
    final numbers = removeFormatting(text);

    if (numbers.isEmpty) return '';

    final buffer = StringBuffer();

    // Adiciona DDD
    if (numbers.isNotEmpty) {
      buffer.write('(');
      buffer.write(
        numbers.substring(0, numbers.length >= 2 ? 2 : numbers.length),
      );
      if (numbers.length >= 2) buffer.write(') ');
    }

    // Adiciona primeira parte
    if (numbers.length >= 3) {
      final endIndex = numbers.length >= 7 ? 7 : numbers.length;
      buffer.write(numbers.substring(2, endIndex));
      if (numbers.length >= 7) buffer.write('-');
    }

    // Adiciona segunda parte
    if (numbers.length >= 8) {
      buffer.write(numbers.substring(7));
    }

    return buffer.toString();
  }
}
