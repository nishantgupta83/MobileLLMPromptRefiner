import Foundation

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
