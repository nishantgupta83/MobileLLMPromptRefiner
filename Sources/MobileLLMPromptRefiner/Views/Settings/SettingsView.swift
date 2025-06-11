import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsViewModel: SettingsViewModel

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                modelConfigurationSection
                optimizationSection
                hardwareSection
                privacySection
                readmeSection
            }
            .padding()
        }
    }

    private var modelConfigurationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Model Configuration", icon: "cpu")

            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Primary Model")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Picker("Primary Model", selection: $settingsViewModel.settings.primaryModel) {
                        ForEach(LLMConfiguration.LLMModel.allCases.filter { !$0.isSecondary }, id: \.self) { model in
                            Text(model.rawValue).tag(model)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Secondary Model")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Picker("Secondary Model", selection: $settingsViewModel.settings.secondaryModel) {
                        ForEach(LLMConfiguration.LLMModel.allCases.filter { $0.isSecondary }, id: \.self) { model in
                            Text(model.rawValue).tag(model)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }

    private var optimizationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Optimization Settings", icon: "bolt.fill")

            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Optimization Level")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Picker("Optimization Level", selection: $settingsViewModel.settings.optimizationLevel) {
                        ForEach(LLMConfiguration.OptimizationLevel.allCases, id: \.self) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.vertical, 8)
                }

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Chunk Size")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Spacer()

                        Text("\(settingsViewModel.settings.chunkSize) tokens")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Slider(value: Binding(
                        get: { Double(settingsViewModel.settings.chunkSize) },
                        set: { settingsViewModel.settings.chunkSize = Int($0) }
                    ), in: 64...512, step: 64)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }

    private var hardwareSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Hardware Options", icon: "cpu")

            VStack(alignment: .leading, spacing: 16) {
                toggleSetting(
                    title: "NPU Acceleration",
                    description: "22.4x latency reduction",
                    isOn: $settingsViewModel.settings.useNPU,
                    action: { settingsViewModel.toggleNPUAcceleration() }
                )

                VStack(alignment: .leading, spacing: 8) {
                    Text("Quantization")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Picker("Quantization", selection: $settingsViewModel.settings.quantization) {
                        ForEach(LLMConfiguration.QuantizationLevel.allCases, id: \.self) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }

    private var privacySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Privacy & Security", icon: "lock.shield")

            VStack(alignment: .leading, spacing: 16) {
                toggleSetting(
                    title: "Privacy Mode",
                    description: "Federated learning with differential privacy",
                    isOn: $settingsViewModel.settings.privacyMode,
                    action: { settingsViewModel.togglePrivacyMode() }
                )

                Button(action: { settingsViewModel.exportConfiguration() }) {
                    HStack {
                        if settingsViewModel.isExporting {
                            ProgressView()
                                .scaleEffect(0.8)
                                .progressViewStyle(CircularProgressViewStyle(tint: .purple))
                        } else {
                            Image(systemName: "square.and.arrow.down")
                        }

                        Text(settingsViewModel.isExporting ? "Exporting..." : "Export Configuration")
                            .fontWeight(.medium)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple.opacity(0.2))
                    .foregroundColor(.purple)
                    .cornerRadius(8)
                }
                .disabled(settingsViewModel.isExporting)

                Button(action: { settingsViewModel.resetToDefaults() }) {
                    HStack {
                        Image(systemName: "arrow.counterclockwise")
                        Text("Reset to Defaults")
                            .fontWeight(.medium)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .foregroundColor(.red)
                    .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }

    private var readmeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "book")
                    .foregroundColor(.purple)

                Text("Documentation")
                    .font(.headline)
                    .fontWeight(.semibold)

                Spacer()

                Button(action: { withAnimation { settingsViewModel.showReadme.toggle() } }) {
                    HStack(spacing: 4) {
                        Text(settingsViewModel.showReadme ? "Hide README" : "Show README")
                            .font(.caption)
                            .foregroundColor(.purple)

                        Image(systemName: settingsViewModel.showReadme ? "chevron.up" : "chevron.down")
                            .font(.caption)
                            .foregroundColor(.purple)
                    }
                }
            }

            if settingsViewModel.showReadme {
                ScrollView {
                    Text(settingsViewModel.readme)
                        .font(.system(.caption, design: .monospaced))
                        .padding()
                }
                .frame(height: 300)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }

    private func sectionHeader(_ title: String, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.purple)

            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
        }
    }

    private func toggleSetting(title: String, description: String, isOn: Binding<Bool>, action: @escaping () -> Void) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .foregroundColor(.primary)

                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Toggle("", isOn: isOn)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: .purple))
                .onChange(of: isOn.wrappedValue) { _ in action() }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(SettingsViewModel())
}
