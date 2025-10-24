class Validators {
  /// Valida e-mail
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'E-mail é obrigatório';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'E-mail inválido';
    }

    return null;
  }

  /// Valida nome (mínimo 3 caracteres)
  static String? nome(String? value, {int minLength = 3}) {
    if (value == null || value.trim().isEmpty) {
      return 'Nome é obrigatório';
    }

    if (value.trim().length < minLength) {
      return 'Nome deve ter pelo menos $minLength caracteres';
    }

    return null;
  }

  /// Valida telefone brasileiro (10 ou 11 dígitos)
  static String? telefone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Telefone é obrigatório';
    }

    final numbers = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (numbers.length < 10 || numbers.length > 11) {
      return 'Telefone deve ter 10 ou 11 dígitos';
    }

    // Valida DDD (11 a 99)
    final ddd = int.tryParse(numbers.substring(0, 2));
    if (ddd == null || ddd < 11 || ddd > 99) {
      return 'DDD inválido';
    }

    return null;
  }

  /// Valida cidade
  static String? cidade(String? value, {int minLength = 2}) {
    if (value == null || value.trim().isEmpty) {
      return 'Cidade é obrigatória';
    }

    if (value.trim().length < minLength) {
      return 'Cidade deve ter pelo menos $minLength caracteres';
    }

    return null;
  }

  /// Valida campo obrigatório genérico
  static String? required(String? value, {String fieldName = 'Campo'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName é obrigatório';
    }
    return null;
  }

  /// Combina múltiplos validadores
  static String? Function(String?) combine(
    List<String? Function(String?)> validators,
  ) {
    return (String? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }
}
