import Flutter
import PassKit
import SafariServices
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    guard
      let registrar = engineBridge.pluginRegistry.registrar(
        forPlugin: "DigitalCardPkPassPlugin")
    else { return }

    let channel = FlutterMethodChannel(
      name: "es.jccm.espaciociudadano/pkpass",
      binaryMessenger: registrar.messenger())
    channel.setMethodCallHandler { [weak self] call, result in
      self?.handlePkPassMethod(call, result: result)
    }

    let browserChannel = FlutterMethodChannel(
      name: "es.jccm.espaciociudadano/browser_session",
      binaryMessenger: registrar.messenger())
    browserChannel.setMethodCallHandler { call, result in
      AppDelegate.handleBrowserSessionMethod(call, result: result)
    }
  }

  /// Vacía el almacén de datos de `SFSafariViewController`, que es el contenedor
  /// propio de la app donde viven la sesión de Cl@ve y la de los portales.
  ///
  /// POC de JCCMEC-224/228 (§10.6 de `documentation/sso_portales_externos.md`).
  /// Lo que se quiere medir: si este borrado se lleva también el **estado del
  /// IdP de certificado** —la asociación del certificado con el host, que es lo
  /// que hoy permite entrar como el ciudadano anterior sin pedir nada— o sólo
  /// las cookies. Apple documenta «local storage, cached resources and cookies»
  /// y no dice nada del certificado, así que no se puede saber sin probarlo.
  ///
  /// Devuelve `false` en iOS 15, donde la API no existe (el mínimo de la app).
  private static func handleBrowserSessionMethod(
    _ call: FlutterMethodCall, result: @escaping FlutterResult
  ) {
    guard call.method == "clearWebsiteData" else {
      result(FlutterMethodNotImplemented)
      return
    }
    if #available(iOS 16.0, *) {
      SFSafariViewController.DataStore.default.clearWebsiteData {
        result(true)
      }
    } else {
      result(false)
    }
  }

  private func handlePkPassMethod(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard call.method == "openPkPass" else {
      result(FlutterMethodNotImplemented)
      return
    }
    guard
      let arguments = call.arguments as? [String: Any],
      let typedData = arguments["bytes"] as? FlutterStandardTypedData
    else {
      result(FlutterError(
        code: "invalid_arguments",
        message: "Faltan los bytes del archivo PKPASS.",
        details: nil))
      return
    }

    guard PKAddPassesViewController.canAddPasses() else {
      result(false)
      return
    }

    do {
      let pass = try PKPass(data: typedData.data)
      guard
        let passController = PKAddPassesViewController(pass: pass),
        let presentingController = topViewController()
      else {
        result(false)
        return
      }
      presentingController.present(passController, animated: true)
      result(true)
    } catch {
      result(FlutterError(
        code: "invalid_pkpass",
        message: "El archivo PKPASS recibido no es válido.",
        details: error.localizedDescription))
    }
  }

  private func topViewController() -> UIViewController? {
    let rootController = UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap(\.windows)
      .first(where: \.isKeyWindow)?
      .rootViewController
    return presentedViewController(from: rootController)
  }

  private func presentedViewController(from controller: UIViewController?) -> UIViewController? {
    if let presented = controller?.presentedViewController {
      return presentedViewController(from: presented)
    }
    if let navigation = controller as? UINavigationController {
      return presentedViewController(from: navigation.visibleViewController)
    }
    if let tabs = controller as? UITabBarController {
      return presentedViewController(from: tabs.selectedViewController)
    }
    return controller
  }
}
