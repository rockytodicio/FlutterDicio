import UIKit
import Flutter
import ConsentimientoExpreso

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    var controller : FlutterViewController?
    let viewToPush = CEWebView()
    var fResult : FlutterResult?
    var uuidTrx = ""
    var uuidClient = ""
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
        ) -> Bool {
        
        guard let flutterViewController  = window?.rootViewController as? FlutterViewController else {
            return super.application(application, didFinishLaunchingWithOptions: launchOptions)
        }
        
        let flutterChannel = FlutterMethodChannel.init(name: "test_activity", binaryMessenger: flutterViewController as! FlutterBinaryMessenger);
        flutterChannel.setMethodCallHandler { (flutterMethodCall, flutterResult) in
            self.fResult = flutterResult
            
            if flutterMethodCall.method == "startNewActivity" {
                if let arguments = flutterMethodCall.arguments as? [String: Any],
                  let selectedEnvironmentString = arguments["selectedEnvironment"] as? String,
                   
                   let APIKey = arguments["APIKey"] as? String,
                   let url = arguments["url"] as? String{
                    
                    print("Selected Environment: \(selectedEnvironmentString)")
                    print("API Key: \(APIKey)")
                    print("URL: \(url)")
                    
                    
                    UIView.animate(withDuration: 0.5, animations: {
                        self.window?.rootViewController = nil
                        self.uuidTrx = UUID().uuidString
                        self.uuidClient = UUID().uuidString
                        self.viewToPush.uuidTrx = self.uuidTrx
                        self.viewToPush.uuidClient = self.uuidClient
                        
//                        self.viewToPush.idLender = "CNVFKn77DYyZS5Du6LebjNA8IQNs2DHY"
                        self.viewToPush.idLender = APIKey
                        self.viewToPush.delegate = self
                        
                        
//                        self.viewToPush.url = "https://app.proddicio.net/"
                        self.viewToPush.url = url
                        
                        
                        switch selectedEnvironmentString {
                        case "Enviroment.Prod":
                            self.viewToPush.environment = .prod
                            break
                        case "Enviroment.QA":
                            self.viewToPush.environment = .qa
                            break
                        case "Enviroment.Dev":
                            self.viewToPush.environment = .dev
                            break
                        default:
                            break
                        }
                        
                        self.viewToPush.isWebViewLaunched = true
                        
                        
                        let navigationController = UINavigationController(rootViewController: flutterViewController)
                        self.window = UIWindow(frame: UIScreen.main.bounds)
                        self.window?.makeKeyAndVisible()
                        self.window.rootViewController = navigationController
                        navigationController.isNavigationBarHidden = true
                        
                        navigationController.pushViewController(self.viewToPush, animated: true)
                        
                    })
                    
                }
                
                

            }
            if flutterMethodCall.method == "getInfoDocs" {
                if self.uuidTrx == "" || self.uuidClient == "" {
                    self.fResult!("¡Se requiere iniciar el webview antes de consultar los datos!")
                } else {
                    self.viewToPush.uuidTrx = self.uuidTrx
                    self.viewToPush.uuidClient = self.uuidClient
                    self.viewToPush.idLender = "CNVFKn77DYyZS5Du6LebjNA8IQNs2DHY"
                    self.viewToPush.delegate = self
                    
                    self.viewToPush.getDocuments()
                }
                
            }
            if flutterMethodCall.method == "getInfoData" {
                if self.uuidTrx == "" || self.uuidClient == "" {
                    self.fResult!("¡Se requiere iniciar el webview antes de consultar los datos!")
                } else {
                    self.viewToPush.uuidTrx = self.uuidTrx
                    self.viewToPush.uuidClient = self.uuidClient
                    self.viewToPush.idLender = "CNVFKn77DYyZS5Du6LebjNA8IQNs2DHY"
                    self.viewToPush.delegate = self
                    
                    self.viewToPush.getData()
                }
            }
        }
        
        let _ = GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    @objc func removeWebViewController() {
        self.viewToPush.removeFromParentViewController()
        self.viewToPush.isFlutter = true
    }
    
    
}

extension AppDelegate: CEDelegate {
    
    func ceStatus(isFinished: Bool, step: String) {
        self.fResult!(step)
        if isFinished {
            self.performSelector(onMainThread: #selector(self.removeWebViewController), with: nil, waitUntilDone: false)
            print("Se llama a cerrar el webview")
        }
    }
    
    
    func ceGetData(data: String) {
//        print(data)
//        self.performSelector(onMainThread: #selector(self.updateData(mensaje:)), with: data, waitUntilDone: false)
        self.fResult!(data)
    }
    
    func ceFiles(data: String) {
//        self.performSelector(onMainThread: #selector(self.updateData(mensaje:)), with: data, waitUntilDone: false)
//        print(data)
        self.fResult!(data)
    }
}

