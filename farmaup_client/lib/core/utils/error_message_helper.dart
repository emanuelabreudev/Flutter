import '../exceptions/api_exceptions.dart';

class ErrorMessageHelper {
  /// Converte exceções em mensagens amigáveis para o usuário
  static String getErrorMessage(dynamic error) {
    if (error is NetworkException) {
      return '❌ Sem conexão com a internet.\nVerifique sua conexão e tente novamente.';
    }

    if (error is NotFoundException) {
      return '🔍 Cliente não encontrado.\nEle pode ter sido excluído por outro usuário.';
    }

    if (error is ConflictException) {
      return '⚠️ ${error.message}\nEste e-mail já está cadastrado no sistema.';
    }

    if (error is ValidationException) {
      if (error.details != null) {
        return '📝 Erro de validação:\n${_formatValidationErrors(error.details)}';
      }
      return '📝 ${error.message}\nVerifique os dados e tente novamente.';
    }

    if (error is ServerException) {
      if (error.statusCode == 500) {
        return '🔧 Erro no servidor.\nTente novamente em alguns instantes.';
      }
      return '❌ ${error.message}\n(Código: ${error.statusCode})';
    }

    if (error is ApiException) {
      return '❌ ${error.message}';
    }

    return '❌ Erro inesperado.\nTente novamente mais tarde.';
  }

  /// Formata erros de validação detalhados
  static String _formatValidationErrors(dynamic details) {
    if (details is List) {
      return details
          .map((e) {
            if (e is Map &&
                e.containsKey('campo') &&
                e.containsKey('mensagem')) {
              return '• ${e['campo']}: ${e['mensagem']}';
            }
            return '• $e';
          })
          .join('\n');
    }

    if (details is Map) {
      return details.entries.map((e) => '• ${e.key}: ${e.value}').join('\n');
    }

    return details.toString();
  }

  /// Mensagem curta para SnackBar
  static String getShortMessage(dynamic error) {
    if (error is NetworkException) {
      return 'Sem conexão com a internet';
    }

    if (error is NotFoundException) {
      return 'Cliente não encontrado';
    }

    if (error is ConflictException) {
      return 'E-mail já cadastrado';
    }

    if (error is ValidationException) {
      return 'Erro de validação';
    }

    if (error is ServerException) {
      return 'Erro no servidor';
    }

    if (error is ApiException) {
      return error.message;
    }

    return 'Erro inesperado';
  }

  /// Retorna ícone apropriado para o tipo de erro
  static String getErrorIcon(dynamic error) {
    if (error is NetworkException) return '📡';
    if (error is NotFoundException) return '🔍';
    if (error is ConflictException) return '⚠️';
    if (error is ValidationException) return '📝';
    if (error is ServerException) return '🔧';
    return '❌';
  }
}
