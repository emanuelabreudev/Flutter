class DateFormatter {
  static const List<String> _months = [
    'janeiro',
    'fevereiro',
    'março',
    'abril',
    'maio',
    'junho',
    'julho',
    'agosto',
    'setembro',
    'outubro',
    'novembro',
    'dezembro',
  ];

  static String formatBrazilianDate(DateTime date) {
    return '${date.day} de ${_months[date.month - 1]} de ${date.year}';
  }
}
