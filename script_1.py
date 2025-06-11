# Create the main SwiftUI app file
app_file = '''import SwiftUI
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
'''

content_view = '''import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .refiner
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var promptViewModel: PromptViewModel
    @EnvironmentObject var refinementViewModel: RefinementViewModel
    
    enum Tab: String, CaseIterable {
        case refiner = "Prompt Refiner"
        case techniques = "Techniques"
        case settings = "Settings"
        
        var icon: String {
            switch self {
            case .refiner: return "bolt.fill"
            case .techniques: return "brain.head.profile"
            case .settings: return "gearshape.fill"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                headerView
                
                tabView
                
                contentView
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(.systemBackground), Color.purple.opacity(0.1)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
            .ignoresSafeArea(.container, edges: .top)
        }
    }
    
    private var headerView: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.purple.opacity(0.8), Color.blue.opacity(0.6)]),
                startPoint: .leading,
                endPoint: .trailing
            )
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: "brain.head.profile")
                            .font(.title2)
                            .foregroundColor(.white)
                        
                        Text("Mobile LLM Refiner")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    
                    Text("Advanced Prompt Optimization")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                HStack(spacing: 12) {
                    performanceChip("22.4x Faster", color: .green)
                    performanceChip("21.6% Accurate", color: .blue)
                }
            }
            .padding()
        }
        .frame(height: 100)
    }
    
    private func performanceChip(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.caption2)
            .fontWeight(.medium)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.3))
            .clipShape(Capsule())
    }
    
    private var tabView: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \\.self) { tab in
                Button(action: { selectedTab = tab }) {
                    HStack(spacing: 8) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 14, weight: .medium))
                        
                        Text(tab.rawValue)
                            .font(.system(size: 14, weight: .medium))
                    }
                    .foregroundColor(selectedTab == tab ? .white : .secondary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        selectedTab == tab 
                            ? LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .leading, endPoint: .trailing)
                            : LinearGradient(gradient: Gradient(colors: [Color.clear]), startPoint: .leading, endPoint: .trailing)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch selectedTab {
        case .refiner:
            PromptRefinerView()
        case .techniques:
            TechniquesView()
        case .settings:
            SettingsView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(SettingsViewModel())
        .environmentObject(PromptViewModel())
        .environmentObject(RefinementViewModel())
}
'''

# Write the main app files
with open('MobileLLMPromptRefinerApp.swift', 'w') as f:
    f.write(app_file)

with open('ContentView.swift', 'w') as f:
    f.write(content_view)

print("Created main app files:")
print("- MobileLLMPromptRefinerApp.swift")
print("- ContentView.swift")