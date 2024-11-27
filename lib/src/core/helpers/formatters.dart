class Formatters {
  String formatPhoneNumber(String number) {
  // Remove todos os caracteres que não são dígitos
  number = number.replaceAll(RegExp(r'\D'), '');

  // Verifica se o número tem 13 dígitos (incluindo o DDD)
  if (number.length == 13) {
    return '(${number.substring(0, 2)}) ${number.substring(2, 4)} ${number.substring(4, 9)}-${number.substring(9)}';
  }
  return number; // Retorna o número sem formatação se não tiver o tamanho esperado
}
}