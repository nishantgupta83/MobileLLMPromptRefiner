import Foundation

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
