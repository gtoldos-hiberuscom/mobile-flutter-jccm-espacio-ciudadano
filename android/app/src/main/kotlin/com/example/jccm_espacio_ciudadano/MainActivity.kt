package com.example.jccm_espacio_ciudadano

import android.app.Activity
import android.content.Intent
import android.net.Uri
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    private var pendingPkPassResult: MethodChannel.Result? = null
    private var pendingPkPassBytes: ByteArray? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            PKPASS_CHANNEL,
        ).setMethodCallHandler(::handlePkPassMethod)
    }

    private fun handlePkPassMethod(call: MethodCall, result: MethodChannel.Result) {
        if (call.method != "savePkPass") {
            result.notImplemented()
            return
        }
        if (pendingPkPassResult != null) {
            result.error("save_in_progress", "Ya hay un archivo PKPASS pendiente de guardar.", null)
            return
        }

        val fileName = call.argument<String>("fileName")
        val bytes = call.argument<ByteArray>("bytes")
        if (fileName.isNullOrBlank() || bytes == null) {
            result.error("invalid_arguments", "Faltan el nombre o los bytes del archivo PKPASS.", null)
            return
        }

        pendingPkPassResult = result
        pendingPkPassBytes = bytes
        val intent = Intent(Intent.ACTION_CREATE_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = PKPASS_MIME_TYPE
            putExtra(Intent.EXTRA_TITLE, fileName)
        }
        startActivityForResult(intent, SAVE_PKPASS_REQUEST_CODE)
    }

    @Deprecated("Deprecated in Android")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode != SAVE_PKPASS_REQUEST_CODE) {
            return
        }

        val result = pendingPkPassResult
        val bytes = pendingPkPassBytes
        pendingPkPassResult = null
        pendingPkPassBytes = null

        if (resultCode != Activity.RESULT_OK || data?.data == null) {
            result?.success(false)
            return
        }

        try {
            writePkPass(data.data!!, bytes!!)
            result?.success(true)
        } catch (error: Exception) {
            result?.error("save_failed", error.message, null)
        }
    }

    private fun writePkPass(uri: Uri, bytes: ByteArray) {
        contentResolver.openOutputStream(uri, "w").use { stream ->
            requireNotNull(stream) { "No se ha podido abrir el destino seleccionado." }
            stream.write(bytes)
            stream.flush()
        }
    }

    companion object {
        private const val PKPASS_CHANNEL = "es.jccm.espaciociudadano/pkpass"
        private const val PKPASS_MIME_TYPE = "application/vnd.apple.pkpass"
        private const val SAVE_PKPASS_REQUEST_CODE = 42137
    }
}
