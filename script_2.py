# Create the data models
prompt_model = '''import Foundation
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
'''

llm_configuration = '''import Foundation

struct LLMConfiguration: Codable {
    var primaryModel: LLMModel
    var secondaryModel: LLMModel
    var optimizationLevel: OptimizationLevel
    var chunkSize: Int
    var useNPU: Bool
    var privacyMode: Bool
    var quantization: QuantizationLevel
    
    enum LLMModel: String, CaseIterable, Codable {
        case gpt4 = "GPT-4"
        case claude3 = "Claude-3"
        case geminiPro = "Gemini-Pro"
        case gemma2B = "Gemma-2B"
        case phi3 = "Phi-3"
        case llama7B = "LLaMA-7B"
        
        var isSecondary: Bool {
            switch self {
            case .gemma2B, .phi3, .llama7B:
                return true
            default:
                return false
            }
        }
        
        var description: String {
            switch self {
            case .gpt4: return "OpenAI's most capable model"
            case .claude3: return "Anthropic's advanced reasoning model"
            case .geminiPro: return "Google's multimodal model"
            case .gemma2B: return "Efficient 2B parameter model"
            case .phi3: return "Microsoft's small language model"
            case .llama7B: return "Meta's 7B parameter model"
            }
        }
    }
    
    enum OptimizationLevel: String, CaseIterable, Codable {
        case performance = "Performance"
        case balanced = "Balanced"
        case efficiency = "Efficiency"
        
        var description: String {
            switch self {
            case .performance: return "Maximum speed and accuracy"
            case .balanced: return "Optimized balance of speed and quality"
            case .efficiency: return "Minimum resource usage"
            }
        }
    }
    
    enum QuantizationLevel: String, CaseIterable, Codable {
        case fourBit = "4-bit"
        case eightBit = "8-bit"
        case sixteenBit = "16-bit"
        
        var description: String {
            switch self {
            case .fourBit: return "Maximum compression, good performance"
            case .eightBit: return "Balanced compression and quality"
            case .sixteenBit: return "Minimal compression, best quality"
            }
        }
    }
    
    static let `default` = LLMConfiguration(
        primaryModel: .gpt4,
        secondaryModel: .gemma2B,
        optimizationLevel: .balanced,
        chunkSize: 128,
        useNPU: true,
        privacyMode: false,
        quantization: .fourBit
    )
}
'''

refinement_step = '''import Foundation

struct RefinementStep: Identifiable, Codable {
    let id = UUID()
    let stepNumber: Int
    let name: String
    let description: String
    let status: StepStatus
    let processingTime: TimeInterval?
    let component: String
    
    enum StepStatus: String, Codable {
        case pending = "pending"
        case processing = "processing"
        case completed = "completed"
        case failed = "failed"
        
        var color: String {
            switch self {
            case .pending: return "gray"
            case .processing: return "blue"
            case .completed: return "green"
            case .failed: return "red"
            }
        }
    }
    
    static let defaultSteps: [RefinementStep] = [
        RefinementStep(stepNumber: 1, name: "User Input", description: "Processing initial prompt from user", status: .pending, processingTime: nil, component: "PromptView"),
        RefinementStep(stepNumber: 2, name: "Secondary Model Parsing", description: "Gemma-2B analyzing prompt structure", status: .pending, processingTime: nil, component: "SecondaryModel"),
        RefinementStep(stepNumber: 3, name: "NPU Optimization", description: "Hardware-accelerated chunk processing", status: .pending, processingTime: nil, component: "NPUService"),
        RefinementStep(stepNumber: 4, name: "Prompt Enhancement", description: "Generating refined prompt structure", status: .pending, processingTime: nil, component: "PromptService"),
        RefinementStep(stepNumber: 5, name: "Primary Model Processing", description: "GPT-4 processing enhanced prompt", status: .pending, processingTime: nil, component: "PrimaryModel"),
        RefinementStep(stepNumber: 6, name: "Results Display", description: "Presenting optimized results to user", status: .pending, processingTime: nil, component: "OutputView")
    ]
}
'''

# Write the model files
with open('PromptModel.swift', 'w') as f:
    f.write(prompt_model)

with open('LLMConfiguration.swift', 'w') as f:
    f.write(llm_configuration)

with open('RefinementStep.swift', 'w') as f:
    f.write(refinement_step)

print("Created model files:")
print("- PromptModel.swift")
print("- LLMConfiguration.swift") 
print("- RefinementStep.swift")