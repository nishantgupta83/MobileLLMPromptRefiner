import plotly.graph_objects as go
import pandas as pd
import json

# Load the data
data = {
  "optimization_techniques": [
    {"technique": "NPU Acceleration", "percentage": 2200, "description": "Hardware-optimized inference pipeline", "category": "Performance"},
    {"technique": "Energy Efficiency", "percentage": 3000, "description": "Power consumption optimization", "category": "Efficiency"},
    {"technique": "Privacy Enhancement", "percentage": 83, "description": "Data exposure reduction", "category": "Privacy"},
    {"technique": "Quantized Inference", "percentage": 68, "description": "4-bit precision processing", "category": "Performance"},
    {"technique": "Token Reduction", "percentage": 47, "description": "Efficient prompt compression", "category": "Efficiency"},
    {"technique": "Dual-Model Refinement", "percentage": 22, "description": "Multi-model collaboration", "category": "Accuracy"}
  ]
}

# Convert to DataFrame
df = pd.DataFrame(data["optimization_techniques"])

# Sort by percentage descending for better visualization
df = df.sort_values('percentage', ascending=True)

# Brand colors in order
colors = ['#1FB8CD', '#FFC185', '#ECEBD5', '#5D878F', '#D2BA4C', '#B4413C']

# Create horizontal bar chart
fig = go.Figure()

# Add bars with brand colors
for i, (idx, row) in enumerate(df.iterrows()):
    # Truncate technique names to fit 15 character limit
    technique_short = row['technique'][:15]
    if len(row['technique']) > 15:
        technique_short = row['technique'][:12] + "..."
    
    # Truncate description to fit 15 character limit
    desc_short = row['description'][:15]
    if len(row['description']) > 15:
        desc_short = row['description'][:12] + "..."
    
    # Format percentage with k suffix if over 1000
    perc_text = f"{row['percentage']/1000:.1f}k%" if row['percentage'] >= 1000 else f"{row['percentage']}%"
    
    fig.add_trace(go.Bar(
        x=[row['percentage']],
        y=[f"{technique_short}<br>{desc_short}"],
        orientation='h',
        marker_color=colors[i % len(colors)],
        text=[perc_text],
        textposition='outside',
        textfont=dict(size=12),
        showlegend=False,
        cliponaxis=False
    ))

# Update layout
fig.update_layout(
    title="iOS Mobile LLM Optimization Techniques",
    xaxis_title="Performance %",
    yaxis_title="Technique",
    xaxis=dict(range=[0, 3500]),
    bargap=0.3
)

# Save the chart as PNG
fig.write_image("ios_llm_optimization_chart.png")