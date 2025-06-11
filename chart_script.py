import plotly.graph_objects as go
import plotly.express as px
import pandas as pd
import numpy as np

# Parse the data
nodes_data = [
    {"id": "ui", "name": "UI Layer", "type": "layer", "description": "SwiftUI Views"},
    {"id": "viewmodels", "name": "ViewModel Layer", "type": "layer", "description": "MVVM Coordination"},
    {"id": "services", "name": "Service Layer", "type": "layer", "description": "Business Logic"},
    {"id": "models", "name": "Model Layer", "type": "layer", "description": "Data Models"},
    
    {"id": "prompt_view", "name": "PromptView", "type": "component", "parent": "ui"},
    {"id": "refine_view", "name": "RefinementView", "type": "component", "parent": "ui"},
    {"id": "settings_view", "name": "SettingsView", "type": "component", "parent": "ui"},
    {"id": "techniques_view", "name": "TechniquesView", "type": "component", "parent": "ui"},
    
    {"id": "prompt_vm", "name": "PromptViewModel", "type": "component", "parent": "viewmodels"},
    {"id": "refine_vm", "name": "RefinementViewModel", "type": "component", "parent": "viewmodels"},
    {"id": "settings_vm", "name": "SettingsViewModel", "type": "component", "parent": "viewmodels"},
    
    {"id": "llm_service", "name": "LLMService", "type": "component", "parent": "services"},
    {"id": "prompt_service", "name": "PromptService", "type": "component", "parent": "services"},
    {"id": "optimization_service", "name": "OptimizationService", "type": "component", "parent": "services"},
    
    {"id": "primary_model", "name": "Primary Model", "type": "component", "parent": "models"},
    {"id": "secondary_model", "name": "Secondary Model", "type": "component", "parent": "models"},
    {"id": "prompt_model", "name": "Prompt Model", "type": "component", "parent": "models"},
    {"id": "settings_model", "name": "Settings Model", "type": "component", "parent": "models"}
]

edges_data = [
    {"source": "prompt_view", "target": "prompt_vm", "type": "uses"},
    {"source": "refine_view", "target": "refine_vm", "type": "uses"},
    {"source": "settings_view", "target": "settings_vm", "type": "uses"},
    
    {"source": "prompt_vm", "target": "prompt_service", "type": "uses"},
    {"source": "refine_vm", "target": "llm_service", "type": "uses"},
    {"source": "refine_vm", "target": "optimization_service", "type": "uses"},
    {"source": "settings_vm", "target": "llm_service", "type": "uses"},
    
    {"source": "llm_service", "target": "primary_model", "type": "uses"},
    {"source": "llm_service", "target": "secondary_model", "type": "uses"},
    {"source": "prompt_service", "target": "prompt_model", "type": "uses"},
    {"source": "optimization_service", "target": "primary_model", "type": "uses"},
    {"source": "optimization_service", "target": "secondary_model", "type": "uses"}
]

# Create position mapping for components
layer_positions = {
    "ui": 4,
    "viewmodels": 3,
    "services": 2,
    "models": 1
}

# Group components by layer
ui_components = [n for n in nodes_data if n.get("parent") == "ui"]
vm_components = [n for n in nodes_data if n.get("parent") == "viewmodels"]
service_components = [n for n in nodes_data if n.get("parent") == "services"]
model_components = [n for n in nodes_data if n.get("parent") == "models"]

# Create positions for each component
positions = {}

# Position UI components
for i, comp in enumerate(ui_components):
    positions[comp["id"]] = (i * 2, 4)

# Position ViewModel components
for i, comp in enumerate(vm_components):
    positions[comp["id"]] = (i * 2.5, 3)

# Position Service components
for i, comp in enumerate(service_components):
    positions[comp["id"]] = (i * 2.5, 2)

# Position Model components
for i, comp in enumerate(model_components):
    positions[comp["id"]] = (i * 2, 1)

# Create the figure
fig = go.Figure()

# Define colors for each layer
layer_colors = {
    "ui": "#1FB8CD",
    "viewmodels": "#FFC185", 
    "services": "#ECEBD5",
    "models": "#5D878F"
}

# Add edges first (so they appear behind nodes)
for edge in edges_data:
    if edge["source"] in positions and edge["target"] in positions:
        x0, y0 = positions[edge["source"]]
        x1, y1 = positions[edge["target"]]
        
        fig.add_trace(go.Scatter(
            x=[x0, x1],
            y=[y0, y1],
            mode='lines',
            line=dict(color='rgba(150,150,150,0.5)', width=1),
            showlegend=False,
            hoverinfo='skip'
        ))

# Add nodes for each layer
for layer, components in [("ui", ui_components), ("viewmodels", vm_components), 
                         ("services", service_components), ("models", model_components)]:
    x_coords = []
    y_coords = []
    hover_texts = []
    names = []
    
    for comp in components:
        if comp["id"] in positions:
            x, y = positions[comp["id"]]
            x_coords.append(x)
            y_coords.append(y)
            # Abbreviate names to fit 15 char limit
            short_name = comp["name"][:15]
            hover_texts.append(f"{comp['name']}")
            names.append(short_name)
    
    if x_coords:  # Only add if there are components
        fig.add_trace(go.Scatter(
            x=x_coords,
            y=y_coords,
            mode='markers+text',
            marker=dict(
                size=30,
                color=layer_colors[layer],
                line=dict(width=2, color='white')
            ),
            text=names,
            textposition="middle center",
            textfont=dict(size=8, color='black'),
            name=layer.replace("_", " ").title(),
            hovertext=hover_texts,
            hoverinfo='text',
            cliponaxis=False
        ))

# Update layout
fig.update_layout(
    title="iOS LLM App Architecture",
    showlegend=True,
    legend=dict(orientation='h', yanchor='bottom', y=1.05, xanchor='center', x=0.5),
    plot_bgcolor='white',
    xaxis=dict(
        showgrid=False,
        showticklabels=False,
        zeroline=False,
        title=""
    ),
    yaxis=dict(
        showgrid=False,
        showticklabels=True,
        zeroline=False,
        title="Architecture",
        tickmode='array',
        tickvals=[1, 2, 3, 4],
        ticktext=['Model Layer', 'Service Layer', 'ViewModel', 'UI Layer']
    )
)

# Save the chart
fig.write_image("ios_architecture_diagram.png")