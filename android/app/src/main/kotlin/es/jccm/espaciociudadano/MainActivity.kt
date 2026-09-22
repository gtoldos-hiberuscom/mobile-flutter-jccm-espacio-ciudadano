package es.jccm.espaciociudadano

import android.content.ActivityNotFoundException
import android.content.Intent
import androidx.core.content.FileProvider
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            PKPASS_CHANNEL,
        ).setMethodCallHandler(::handlePkPassMethod)
    }

    private fun handlePkPassMethod(call: MethodCall, result: MethodChannel.Result) {
        if (call.method != "openPkPass") {
            result.notImplemented()
            return
        }

        val fileName = call.argument<String>("fileName")
        val bytes = call.argument<ByteArray>("bytes")
        if (fileName.isNullOrBlank() || bytes == null) {
            result.error("invalid_arguments", "Faltan el nombre o los bytes del archivo PKPASS.", null)
            return
        }

        try {
            val passDirectory = File(cacheDir, PKPASS_CACHE_DIRECTORY).apply { mkdirs() }
            val safeFileName = File(fileName).name.let {
                if (it.endsWith(PKPASS_EXTENSION, ignoreCase = true)) it else "$it$PKPASS_EXTENSION"
            }
            val passFile = File(passDirectory, safeFileName).apply { writeBytes(bytes) }
            val passUri = FileProvider.getUriForFile(
                this,
                "$packageName.fileprovider",
                passFile,
            )
            val intent = Intent(Intent.ACTION_VIEW).apply {
                setDataAndType(passUri, PKPASS_MIME_TYPE)
                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                clipData = android.content.ClipData.newRawUri(fileName, passUri)
            }
            startActivity(intent)
            result.success(true)
        } catch (_: ActivityNotFoundException) {
            result.success(false)
        } catch (error: Exception) {
            result.error("open_failed", error.message, null)
        }
    }

    companion object {
        private const val PKPASS_CHANNEL = "es.jccm.espaciociudadano/pkpass"
        private const val PKPASS_MIME_TYPE = "application/vnd.apple.pkpass"
        private const val PKPASS_CACHE_DIRECTORY = "wallet_passes"
        private const val PKPASS_EXTENSION = ".pkpass"
    }
}
