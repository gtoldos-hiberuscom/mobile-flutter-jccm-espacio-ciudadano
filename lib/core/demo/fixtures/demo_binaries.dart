import 'dart:convert';
import 'dart:typed_data';

/// Ficheros binarios del modo demostración, en base64 para poder vivir en el
/// código sin assets ni E/S.
///
/// Generados una vez con un script (PDF con tabla `xref` bien calculada, PNG
/// con un patrón tipo QR, zip mínimo de pkpass) y pegados aquí: un PDF escrito
/// a mano con offsets incorrectos lo rechazan algunos visores. El pkpass es un
/// zip válido pero **Wallet lo rechazará** (sin firma): es una limitación
/// documentada del modo demo.
abstract final class DemoBinaries {
  const DemoBinaries._();

  /// PDF de una página («Documento de demostración»). Sirve de documento de
  /// notificación, justificante, recibo de registro y carné en PDF.
  static const String pdfBase64 = 'JVBERi0xLjQKJeLjz9MKMSAwIG9iago8PCAvVHlwZSAvQ2F0YWxvZyAvUGFnZXMgMiAwIFIgPj4KZW5kb2JqCjIgMCBvYmoKPDwgL1R5cGUgL1BhZ2VzIC9LaWRzIFszIDAgUl0gL0NvdW50IDEgPj4KZW5kb2JqCjMgMCBvYmoKPDwgL1R5cGUgL1BhZ2UgL1BhcmVudCAyIDAgUiAvTWVkaWFCb3ggWzAgMCA1OTUgODQyXSAvQ29udGVudHMgNCAwIFIgL1Jlc291cmNlcyA8PCAvRm9udCA8PCAvRjEgNSAwIFIgPj4gPj4gPj4KZW5kb2JqCjQgMCBvYmoKPDwgL0xlbmd0aCAxMjAgPj4Kc3RyZWFtCkJUIC9GMSAyMCBUZiA2MCA3NDAgVGQgKERvY3VtZW50byBkZSBkZW1vc3RyYWNpb24pIFRqIDAgLTMwIFRkIC9GMSAxMiBUZiAoQ2FycGV0YSBDaXVkYWRhbmEgQ0xNIC0gZGF0b3MgZmljdGljaW9zKSBUaiBFVAplbmRzdHJlYW0KZW5kb2JqCjUgMCBvYmoKPDwgL1R5cGUgL0ZvbnQgL1N1YnR5cGUgL1R5cGUxIC9CYXNlRm9udCAvSGVsdmV0aWNhID4+CmVuZG9iagp4cmVmCjAgNgowMDAwMDAwMDAwIDY1NTM1IGYgCjAwMDAwMDAwMTUgMDAwMDAgbiAKMDAwMDAwMDA2NCAwMDAwMCBuIAowMDAwMDAwMTIxIDAwMDAwIG4gCjAwMDAwMDAyNDcgMDAwMDAgbiAKMDAwMDAwMDQxOCAwMDAwMCBuIAp0cmFpbGVyCjw8IC9TaXplIDYgL1Jvb3QgMSAwIFIgPj4Kc3RhcnR4cmVmCjQ4OAolJUVPRgo=';

  /// PNG 116×116 con un patrón tipo QR (no es un QR legible, a propósito).
  static const String qrPngBase64 = 'iVBORw0KGgoAAAANSUhEUgAAAHQAAAB0CAAAAABx8Un7AAABXUlEQVR42u3a266DIBAFUP7/p+1TE2tkX4BBm2xeehI9LE3GYbi0BtoB2vf69fd8fagFXYKqnV7vRw+G+g26B712ygKJAajfoO9BnQcK+h/o+T52LejzKPrgew+ExuWpUSboNIpqJzZo04AZqQaDTqGH0Xqo3U/QUhQl+bsgQnHBYqY70gRdio4ERi/xowf96T/oFlSZ/Kr5Gw0eQfehSnGmTJ6UFwm6F3U67378oIALugdVFx97C8tOQR60HnUT9kwCCboXZUWWGkxqAAatRVnidjaBrOIuaBmqbLqyhUn0f7cvEbQMZZBTkCkT5qa8XdAplE1uRwJF3RwKWoO6m+q9+6RFKzYpDlqCqoMy+vDRanbQelTZh5MWL8D91m5j0CWocuBFSSJsEwIm/aDL0ZUb8GzhI+izqIuzv4O+A1UPPQ0tSAYtQ1lCV4LDSfxBa1GnMHMPlNun64LOoh/sEFREFFPLRwAAAABJRU5ErkJggg==';

  /// Zip con un `pass.json` mínimo.
  static const String pkpassBase64 = 'UEsDBBQAAAAIAC1aUF2x6sNZ1QAAAEYBAAAJAAAAcGFzcy5qc29ubY67TgMxEEV/xXJNIkepoIUgIUHSRDRAMWvPRgN+aWwjLav9dzybCon2nvua9Zg4QH1FLpSivlO7G6UzlHKeMj45jJVGQu5gVbcOQ9piyWApbSw1Bw5i0j1UkAn8sYXhan84vJw2xpidwIoQ/rYJFpL4ApF+oPb5IwRcWR8plfvGezNm3EcxOiyWKdfrTX0PHIXirXKo3H+JC8b+yXb3rDNTAJ4eCb0rXXmb9RdOUhRTGBjF72FAL9KZavPAon2Db+un52bXOQfq8Ikh+6Tkpl4+luUXUEsDBBQAAAAIAC1aUF1Dv6ajBAAAAAIAAAANAAAAbWFuaWZlc3QuanNvbquuBQBQSwECFAMUAAAACAAtWlBdserDWdUAAABGAQAACQAAAAAAAAAAAAAAgAEAAAAAcGFzcy5qc29uUEsBAhQDFAAAAAgALVpQXUO/pqMEAAAAAgAAAA0AAAAAAAAAAAAAAIAB/AAAAG1hbmlmZXN0Lmpzb25QSwUGAAAAAAIAAgByAAAAKwEAAAAA';

  static Uint8List get pdf => base64Decode(pdfBase64);
  static Uint8List get qrPng => base64Decode(qrPngBase64);
  static Uint8List get pkpass => base64Decode(pkpassBase64);
}
