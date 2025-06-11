import plotly.graph_objects as go
import plotly.io as pio

# Create figure
fig = go.Figure()

# Layer data
layers = [
    {
        "name": "UI Layer (SwiftUI)",
        "level": 1,
        "components": ["PromptInputView", "RefinementView", "SettingsView", "TechniquesView", "MetricsView"],
        "color": "#6366f1"
    },
    {
        "name": "ViewModel Layer (MVVM)",
        "level": 2,
        "components": ["PromptViewModel", "RefinementViewModel", "SettingsViewModel", "TechniquesViewModel"],
        "color": "#8b5cf6"
    },
    {
        "name": "Service Layer (Business Logic)",
        "level": 3,
        "components": ["LLMService", "PromptService", "OptimizationService", "NetworkService", "CoreMLService"],
        "color": "#a855f7"
    },
    {
        "name": "Data Layer (Models & Storage)",
        "level": 4,
        "components": ["PromptModel", "SettingsModel", "MetricsModel", "LLMConfiguration", "UserDefaults"],
        "color": "#c084fc"
    }
]

# Refinement process
process_steps = [
    {"step": 1, "name": "User Input", "description": "Enter basic prompt in SwiftUI"},
    {"step": 2, "name": "2nd Model Parse", "description": "Gemma-2B processes initial input"},
    {"step": 3, "name": "NPU Optimize", "description": "Hardware-accelerated chunk processing"},
    {"step": 4, "name": "Prompt Enhance", "description": "Generate refined prompt structure"},
    {"step": 5, "name": "Primary Model", "description": "GPT-4/Primary model execution"},
    {"step": 6, "name": "Display Results", "description": "Show enhanced output in UI"}
]

# Architecture layers positioning
layer_height = 1.5
layer_width = 6
layer_x_start = 0.5
layer_y_start = 8

# Add architecture layers
for i, layer in enumerate(layers):
    y_pos = layer_y_start - (i * (layer_height + 0.5))
    
    # Add layer rectangle
    fig.add_shape(
        type="rect",
        x0=layer_x_start, x1=layer_x_start + layer_width,
        y0=y_pos - layer_height/2, y1=y_pos + layer_height/2,
        fillcolor=layer["color"],
        opacity=0.8,
        line=dict(color="white", width=2)
    )
    
    # Add layer title
    fig.add_annotation(
        x=layer_x_start + 0.2,
        y=y_pos + layer_height/3,
        text=f"<b>{layer['name']}</b>",
        showarrow=False,
        font=dict(size=14, color="white"),
        xanchor="left"
    )
    
    # Add components
    comp_per_row = 3
    for j, component in enumerate(layer["components"]):
        row = j // comp_per_row
        col = j % comp_per_row
        comp_x = layer_x_start + 0.3 + col * 1.8
        comp_y = y_pos - 0.1 - row * 0.4
        
        # Truncate component names to 15 chars
        comp_name = component[:15] if len(component) > 15 else component
        
        fig.add_shape(
            type="rect",
            x0=comp_x, x1=comp_x + 1.6,
            y0=comp_y - 0.15, y1=comp_y + 0.15,
            fillcolor="white",
            opacity=0.9,
            line=dict(color=layer["color"], width=1)
        )
        
        fig.add_annotation(
            x=comp_x + 0.8,
            y=comp_y,
            text=comp_name,
            showarrow=False,
            font=dict(size=10, color=layer["color"]),
            xanchor="center"
        )

# Add dependency arrows between layers
for i in range(len(layers) - 1):
    y_start = layer_y_start - (i * (layer_height + 0.5)) - layer_height/2
    y_end = layer_y_start - ((i+1) * (layer_height + 0.5)) + layer_height/2
    
    fig.add_annotation(
        x=layer_x_start + layer_width/2,
        y=(y_start + y_end)/2,
        ax=layer_x_start + layer_width/2,
        ay=y_start,
        axref="x", ayref="y",
        arrowhead=2,
        arrowsize=1,
        arrowwidth=2,
        arrowcolor="#374151"
    )

# Add refinement process flowchart on the right
process_x_start = 8
process_width = 2.5
step_height = 0.8

for i, step in enumerate(process_steps):
    y_pos = layer_y_start - (i * (step_height + 0.3))
    
    # Add step rectangle
    fig.add_shape(
        type="rect",
        x0=process_x_start, x1=process_x_start + process_width,
        y0=y_pos - step_height/2, y1=y_pos + step_height/2,
        fillcolor="#1FB8CD",
        opacity=0.8,
        line=dict(color="white", width=2)
    )
    
    # Add step number and name
    fig.add_annotation(
        x=process_x_start + process_width/2,
        y=y_pos + 0.1,
        text=f"<b>{step['step']}. {step['name']}</b>",
        showarrow=False,
        font=dict(size=12, color="white"),
        xanchor="center"
    )
    
    # Add description (truncated to 15 chars)
    desc = step['description'][:15] + "..." if len(step['description']) > 15 else step['description']
    fig.add_annotation(
        x=process_x_start + process_width/2,
        y=y_pos - 0.2,
        text=desc,
        showarrow=False,
        font=dict(size=9, color="white"),
        xanchor="center"
    )
    
    # Add arrows between process steps
    if i < len(process_steps) - 1:
        arrow_y_start = y_pos - step_height/2
        arrow_y_end = y_pos - step_height/2 - 0.3 + step_height/2
        
        fig.add_annotation(
            x=process_x_start + process_width/2,
            y=arrow_y_end,
            ax=process_x_start + process_width/2,
            ay=arrow_y_start,
            axref="x", ayref="y",
            arrowhead=2,
            arrowsize=1,
            arrowwidth=2,
            arrowcolor="#1FB8CD"
        )

# Update layout
fig.update_layout(
    title="iOS LLM Prompt Refiner Architecture",
    showlegend=False,
    xaxis=dict(visible=False, range=[0, 12]),
    yaxis=dict(visible=False, range=[1, 9]),
    plot_bgcolor="white",
    paper_bgcolor="white"
)

# Save the chart
fig.write_image("ios_llm_architecture.png")