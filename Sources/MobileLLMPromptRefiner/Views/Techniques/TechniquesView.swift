import SwiftUI

struct TechniquesView: View {
    let optimizationTechniques = PromptModel.OptimizationType.allCases

    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 1), spacing: 16) {
                ForEach(optimizationTechniques, id: \.self) { technique in
                    TechniqueCard(technique: technique)
                }
            }
            .padding()
        }
    }
}

struct TechniqueCard: View {
    let technique: PromptModel.OptimizationType
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(technique.rawValue)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)

                    Text(technique.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(isExpanded ? nil : 2)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 8) {
                    Text(technique.performance)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(performanceColor)
                        .cornerRadius(8)

                    Button(action: { 
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isExpanded.toggle()
                        }
                    }) {
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .foregroundColor(.secondary)
                    }
                }
            }

            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    Divider()

                    // Detailed information based on technique
                    switch technique {
                    case .npuAcceleration:
                        TechniqueDetailView(
                            title: "Hardware Optimization",
                            details: [
                                "22.4x latency reduction",
                                "Hardware-accelerated inference",
                                "Optimized for Apple Silicon",
                                "Real-time processing capabilities"
                            ],
                            icon: "cpu",
                            color: .blue
                        )

                    case .dualModelRefinement:
                        TechniqueDetailView(
                            title: "Multi-Model Collaboration",
                            details: [
                                "21.6% accuracy improvement",
                                "Gemma-2B for initial parsing",
                                "GPT-4 for final processing",
                                "Synergistic model interaction"
                            ],
                            icon: "brain.head.profile",
                            color: .green
                        )

                    case .quantizedInference:
                        TechniqueDetailView(
                            title: "Precision Optimization",
                            details: [
                                "67.8% UX improvement",
                                "4-bit precision processing",
                                "Reduced memory footprint",
                                "Maintained accuracy"
                            ],
                            icon: "memorychip",
                            color: .purple
                        )

                    case .tokenOptimization:
                        TechniqueDetailView(
                            title: "Efficiency Enhancement",
                            details: [
                                "47% token reduction",
                                "Smart compression algorithms",
                                "Semantic preservation",
                                "Bandwidth optimization"
                            ],
                            icon: "speedometer",
                            color: .orange
                        )

                    case .privacyPreserving:
                        TechniqueDetailView(
                            title: "Privacy Protection",
                            details: [
                                "83% data exposure reduction",
                                "Federated learning approach",
                                "Differential privacy (ε=0.3)",
                                "On-device processing"
                            ],
                            icon: "lock.shield",
                            color: .red
                        )

                    case .chunkedProcessing:
                        TechniqueDetailView(
                            title: "Processing Optimization",
                            details: [
                                "30.7x energy savings",
                                "128-token segments",
                                "Overlap maintenance",
                                "Parallel processing"
                            ],
                            icon: "square.grid.3x3",
                            color: .cyan
                        )
                    }

                    HStack(spacing: 4) {
                        Circle()
                            .fill(Color.purple)
                            .frame(width: 6, height: 6)

                        Text("Research-backed optimization")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }

    private var performanceColor: Color {
        switch technique {
        case .npuAcceleration, .dualModelRefinement: return .green
        case .quantizedInference: return .purple
        case .tokenOptimization: return .orange
        case .privacyPreserving: return .red
        case .chunkedProcessing: return .blue
        }
    }
}

struct TechniqueDetailView: View {
    let title: String
    let details: [String]
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)

                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                ForEach(details, id: \.self) { detail in
                    HStack(spacing: 6) {
                        Circle()
                            .fill(color)
                            .frame(width: 4, height: 4)

                        Text(detail)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
        .padding(12)
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}

#Preview {
    TechniquesView()
}
