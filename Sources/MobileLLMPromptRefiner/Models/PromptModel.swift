import Foundation
import CoreML

struct PromptModel: Codable, Identifiable {
    let id = UUID()
    var originalText: String
    var enhancedText: String?
    var timestamp: Date
    var processingTime: TimeInterval?
    var tokens: Int?
    var optimizations: [OptimizationType]
    var metrics: PerformanceMetrics?

    enum OptimizationType: String, CaseIterable, Codable {
        case npuAcceleration = "NPU Acceleration"
        case dualModelRefinement = "Dual-Model Refinement"
        case quantizedInference = "Quantized Inference"
        case tokenOptimization = "Token Optimization"
        case privacyPreserving = "Privacy Preserving"
        case chunkedProcessing = "Chunked Processing"

        var description: String {
            switch self {
            case .npuAcceleration: return "Hardware-optimized inference pipeline"
            case .dualModelRefinement: return "Multi-model collaboration for enhanced accuracy"
            case .quantizedInference: return "4-bit precision for efficient processing"
            case .tokenOptimization: return "Smart token reduction and compression"
            case .privacyPreserving: return "Federated learning with differential privacy"
            case .chunkedProcessing: return "128-token segments with overlap maintenance"
            }
        }

        var performance: String {
            switch self {
            case .npuAcceleration: return "22.4x faster"
            case .dualModelRefinement: return "+21.6% accuracy"
            case .quantizedInference: return "67.8% UX improvement"
            case .tokenOptimization: return "47% token reduction"
            case .privacyPreserving: return "83% privacy boost"
            case .chunkedProcessing: return "30.7x energy savings"
            }
        }
    }
}

struct PerformanceMetrics: Codable {
    var latencyReduction: Double // Multiplier (e.g., 22.4 for 22.4x faster)
    var accuracyImprovement: Double // Percentage (e.g., 21.6 for 21.6%)
    var energyEfficiency: Double // Multiplier (e.g., 30.7 for 30.7x better)
    var tokenReduction: Double // Percentage (e.g., 47 for 47%)
    var privacyScore: Double // Percentage (e.g., 83 for 83% protection)
    var processingTime: TimeInterval
    var memoryUsage: Double // MB

    static let mock = PerformanceMetrics(
        latencyReduction: 22.4,
        accuracyImprovement: 21.6,
        energyEfficiency: 30.7,
        tokenReduction: 47.0,
        privacyScore: 83.0,
        processingTime: 0.34,
        memoryUsage: 156.7
    )
}
