/// SESCAM no puede consultar las citas porque no existe ningún CIP vinculado
/// a la identidad del ciudadano (código funcional 3031).
final class MyDataHealthCipMissing implements Exception {
  const MyDataHealthCipMissing();
}
