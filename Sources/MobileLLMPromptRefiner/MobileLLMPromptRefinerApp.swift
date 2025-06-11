import SwiftUI
import Foundation
import Combine
import CoreML

@main
struct MobileLLMPromptRefinerApp: App {
    @StateObject private var settingsViewModel = SettingsViewModel()
    @StateObject private var promptViewModel = PromptViewModel()
    @StateObject private var refinementViewModel = RefinementViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settingsViewModel)
                .environmentObject(promptViewModel)
                .environmentObject(refinementViewModel)
                .onAppear {
                    setupServices()
                }
        }
    }

    private func setupServices() {
        // Initialize Core ML models and services
        LLMService.shared.initialize()
        OptimizationService.shared.configure(settings: settingsViewModel.settings)
    }
}
