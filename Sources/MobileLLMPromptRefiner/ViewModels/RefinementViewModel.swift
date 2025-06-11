import Foundation
import Combine

class RefinementViewModel: ObservableObject {
    @Published var refinementSteps: [RefinementStep] = []
    @Published var isRefining: Bool = false
    @Published var currentStepIndex: Int = 0
    @Published var metrics: PerformanceMetrics?
    @Published var error: Error?

    private var cancellables = Set<AnyCancellable>()
    private let optimizationService = OptimizationService.shared

    func startRefinement(for prompt: String, with configuration: LLMConfiguration) async {
        await MainActor.run {
            isRefining = true
            refinementSteps = RefinementStep.defaultSteps
            currentStepIndex = 0
            error = nil
        }

        do {
            for (index, step) in refinementSteps.enumerated() {
                await MainActor.run {
                    currentStepIndex = index
                    updateStepStatus(at: index, to: .processing)
                }

                // Simulate processing time based on step
                let processingTime = await processStep(step, configuration: configuration)

                await MainActor.run {
                    updateStepStatus(at: index, to: .completed, processingTime: processingTime)
                }
            }

            // Generate final metrics
            await MainActor.run {
                metrics = generateMetrics()
                isRefining = false
            }

        } catch {
            await MainActor.run {
                self.error = error
                updateStepStatus(at: currentStepIndex, to: .failed)
                isRefining = false
            }
        }
    }

    private func processStep(_ step: RefinementStep, configuration: LLMConfiguration) async -> TimeInterval {
        let baseTime: TimeInterval

        switch step.stepNumber {
        case 1: baseTime = 0.01 // User input
        case 2: baseTime = 0.15 // Secondary model parsing
        case 3: baseTime = configuration.useNPU ? 0.05 : 0.20 // NPU optimization
        case 4: baseTime = 0.12 // Prompt enhancement
        case 5: baseTime = 0.30 // Primary model processing
        case 6: baseTime = 0.01 // Results display
        default: baseTime = 0.10
        }

        // Add some randomness to make it feel realistic
        let variance = baseTime * 0.3
        let actualTime = baseTime + Double.random(in: -variance...variance)

        try? await Task.sleep(nanoseconds: UInt64(actualTime * 1_000_000_000))
        return actualTime
    }

    private func updateStepStatus(at index: Int, to status: RefinementStep.StepStatus, processingTime: TimeInterval? = nil) {
        guard index < refinementSteps.count else { return }

        let step = refinementSteps[index]
        refinementSteps[index] = RefinementStep(
            stepNumber: step.stepNumber,
            name: step.name,
            description: step.description,
            status: status,
            processingTime: processingTime,
            component: step.component
        )
    }

    private func generateMetrics() -> PerformanceMetrics {
        let totalProcessingTime = refinementSteps.compactMap { $0.processingTime }.reduce(0, +)

        return PerformanceMetrics(
            latencyReduction: 22.4,
            accuracyImprovement: 21.6,
            energyEfficiency: 30.7,
            tokenReduction: 47.0,
            privacyScore: 83.0,
            processingTime: totalProcessingTime,
            memoryUsage: Double.random(in: 120...200)
        )
    }

    func reset() {
        refinementSteps = RefinementStep.defaultSteps
        isRefining = false
        currentStepIndex = 0
        metrics = nil
        error = nil
    }
}
