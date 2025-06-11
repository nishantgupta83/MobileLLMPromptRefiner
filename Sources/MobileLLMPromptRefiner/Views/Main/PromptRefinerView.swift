import SwiftUI

struct PromptRefinerView: View {
    @EnvironmentObject var promptViewModel: PromptViewModel
    @EnvironmentObject var refinementViewModel: RefinementViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @State private var copiedPrompt = false
    @State private var copiedOutput = false

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                inputSection

                if promptViewModel.isProcessing || !promptViewModel.processingSteps.allSatisfy({ $0.status == .pending }) {
                    processingSection
                }

                outputSection

                if promptViewModel.currentMetrics != nil {
                    metricsSection
                }
            }
            .padding()
        }
    }

    private var inputSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "smartphone")
                    .foregroundColor(.purple)

                Text("Input Prompt")
                    .font(.headline)
                    .fontWeight(.semibold)

                Spacer()

                Text("\(promptViewModel.inputPrompt.count) chars")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            TextEditor(text: $promptViewModel.inputPrompt)
                .frame(minHeight: 120)
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
                .overlay(
                    Group {
                        if promptViewModel.inputPrompt.isEmpty {
                            VStack {
                                HStack {
                                    Text("Enter your prompt to optimize for mobile LLM deployment...")
                                        .foregroundColor(.secondary)
                                        .padding(.leading, 16)
                                        .padding(.top, 20)
                                    Spacer()
                                }
                                Spacer()
                            }
                        }
                    }
                )

            HStack {
                modelStatusView

                Spacer()

                Button(action: { 
                    Task {
                        await promptViewModel.refinePrompt()
                    }
                }) {
                    HStack(spacing: 8) {
                        if promptViewModel.isProcessing {
                            ProgressView()
                                .scaleEffect(0.8)
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Image(systemName: "bolt.fill")
                        }

                        Text(promptViewModel.isProcessing ? "Refining..." : "Refine Prompt")
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.purple, Color.blue]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(10)
                }
                .disabled(promptViewModel.isProcessing || promptViewModel.inputPrompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }

    private var modelStatusView: some View {
        HStack(spacing: 12) {
            HStack(spacing: 4) {
                Circle()
                    .fill(Color.green)
                    .frame(width: 8, height: 8)
                Text(settingsViewModel.settings.primaryModel.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Text("+")
                .font(.caption)
                .foregroundColor(.secondary)

            HStack(spacing: 4) {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 8, height: 8)
                Text(settingsViewModel.settings.secondaryModel.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }

    private var processingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: promptViewModel.isProcessing ? "gear" : "checkmark.circle.fill")
                    .foregroundColor(promptViewModel.isProcessing ? .purple : .green)
                    .rotationEffect(.degrees(promptViewModel.isProcessing ? 360 : 0))
                    .animation(promptViewModel.isProcessing ? .linear(duration: 2).repeatForever(autoreverses: false) : .default, value: promptViewModel.isProcessing)

                Text("Refinement Pipeline")
                    .font(.headline)
                    .fontWeight(.semibold)
            }

            LazyVStack(spacing: 8) {
                ForEach(Array(promptViewModel.processingSteps.enumerated()), id: \.element.id) { index, step in
                    ProcessingStepView(step: step, isActive: promptViewModel.isProcessing && index == promptViewModel.processingSteps.firstIndex { $0.status == .processing })
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }

    private var outputSection: some View {
        HStack(alignment: .top, spacing: 16) {
            // Enhanced Prompt
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "brain.head.profile")
                        .foregroundColor(.green)

                    Text("Enhanced Prompt")
                        .font(.headline)
                        .fontWeight(.semibold)

                    Spacer()

                    if !promptViewModel.enhancedPrompt.isEmpty {
                        Button(action: { 
                            copyToClipboard(promptViewModel.enhancedPrompt)
                            copiedPrompt = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                copiedPrompt = false
                            }
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: copiedPrompt ? "checkmark" : "doc.on.doc")
                                Text(copiedPrompt ? "Copied!" : "Copy")
                            }
                            .font(.caption)
                            .foregroundColor(.purple)
                        }
                    }
                }

                ScrollView {
                    Text(promptViewModel.enhancedPrompt.isEmpty ? "Enhanced prompt will appear here after refinement..." : promptViewModel.enhancedPrompt)
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(promptViewModel.enhancedPrompt.isEmpty ? .secondary : .green)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                }
                .frame(height: 120)
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            .frame(maxWidth: .infinity)

            // Prompt Output
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "play.fill")
                        .foregroundColor(.blue)

                    Text("Prompt Output")
                        .font(.headline)
                        .fontWeight(.semibold)

                    Spacer()

                    if !promptViewModel.outputResults.isEmpty {
                        Button(action: { 
                            copyToClipboard(promptViewModel.outputResults)
                            copiedOutput = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                copiedOutput = false
                            }
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: copiedOutput ? "checkmark" : "doc.on.doc")
                                Text(copiedOutput ? "Copied!" : "Copy")
                            }
                            .font(.caption)
                            .foregroundColor(.blue)
                        }
                    }
                }

                ScrollView {
                    Text(promptViewModel.outputResults.isEmpty ? "Output from running the refined prompt will appear here..." : promptViewModel.outputResults)
                        .font(.body)
                        .foregroundColor(promptViewModel.outputResults.isEmpty ? .secondary : .primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                }
                .frame(height: 120)
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }

    private var metricsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "bolt.fill")
                    .foregroundColor(.yellow)

                Text("Performance Metrics")
                    .font(.headline)
                    .fontWeight(.semibold)

                Spacer()

                Text("Live Stats")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.yellow.opacity(0.2))
                    .foregroundColor(.yellow)
                    .cornerRadius(8)
            }

            if let metrics = promptViewModel.currentMetrics {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                    MetricCard(title: "Processing Speed", value: "\(metrics.latencyReduction, specifier: "%.1f")x faster", color: .green)
                    MetricCard(title: "Accuracy Improvement", value: "+\(metrics.accuracyImprovement, specifier: "%.1f")%", color: .blue)
                    MetricCard(title: "Energy Efficiency", value: "\(metrics.energyEfficiency, specifier: "%.1f")x better", color: .purple)
                    MetricCard(title: "Token Reduction", value: "\(metrics.tokenReduction, specifier: "%.0f")% saved", color: .orange)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }

    private func copyToClipboard(_ text: String) {
        UIPasteboard.general.string = text
    }
}

struct ProcessingStepView: View {
    let step: RefinementStep
    let isActive: Bool

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(statusColor)
                    .frame(width: 32, height: 32)

                if step.status == .processing && isActive {
                    ProgressView()
                        .scaleEffect(0.6)
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("\(step.stepNumber)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(step.name)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)

                Text(step.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            if step.status == .completed {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isActive ? Color.purple : Color.clear, lineWidth: 2)
        )
    }

    private var statusColor: Color {
        switch step.status {
        case .pending: return .gray
        case .processing: return .purple
        case .completed: return .green
        case .failed: return .red
        }
    }
}

struct MetricCard: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)

            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

#Preview {
    PromptRefinerView()
        .environmentObject(PromptViewModel())
        .environmentObject(RefinementViewModel())
        .environmentObject(SettingsViewModel())
}
