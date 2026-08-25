import UIKit
import Flutter
import FirebaseCore
import HealthKit

/// Notifies Flutter when HealthKit step data changes (HKObserverQuery).
final class HealthStepObserver: NSObject, FlutterStreamHandler {
  private let healthStore = HKHealthStore()
  private var observerQuery: HKObserverQuery?
  private var eventSink: FlutterEventSink?

  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    eventSink = events
    startObserving()
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    stopObserving()
    eventSink = nil
    return nil
  }

  private func startObserving() {
    guard HKHealthStore.isHealthDataAvailable(),
          let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
      return
    }

    stopObserving()

    healthStore.enableBackgroundDelivery(for: stepType, frequency: .immediate) { _, _ in }

    let query = HKObserverQuery(sampleType: stepType, predicate: nil) { [weak self] _, completionHandler, _ in
      DispatchQueue.main.async {
        self?.eventSink?(Int(Date().timeIntervalSince1970 * 1000))
      }
      completionHandler()
    }
    observerQuery = query
    healthStore.execute(query)
  }

  private func stopObserving() {
    if let query = observerQuery {
      healthStore.stop(query)
      observerQuery = nil
    }
  }
}

@main
@objc class AppDelegate: FlutterAppDelegate {
  private let healthStepObserver = HealthStepObserver()

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)

    if let controller = window?.rootViewController as? FlutterViewController {
      FlutterEventChannel(
        name: "eat_wise/health_steps_events",
        binaryMessenger: controller.binaryMessenger
      ).setStreamHandler(healthStepObserver)
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
