import plotly.express as px
import plotly.graph_objects as go
import pandas as pd

# Data from the provided JSON - correcting the misrepresented values
data = {
    "techniques": [
        {"name": "NPU Acceleration", "improvement": 22.4, "unit": "x faster", "description": "Hardware-optimized inference"},
        {"name": "Energy Efficiency", "improvement": 30.7, "unit": "x improvement", "description": "Power consumption reduction"},
        {"name": "Privacy Enhancement", "improvement": 83, "unit": "% reduction", "description": "Data exposure protection"},
        {"name": "Quantized Inference", "improvement": 67.8, "unit": "% UX improvement", "description": "4-bit precision optimization"},
        {"name": "Token Reduction", "improvement": 47, "unit": "% saved", "description": "Efficient prompt processing"},
        {"name": "Dual-Model Refinement", "improvement": 21.6, "unit": "% accuracy", "description": "Multi-model collaboration"}
    ]
}

# Create DataFrame
df = pd.DataFrame(data["techniques"])

# Sort by improvement value for better visualization
df = df.sort_values('improvement', ascending=True)

# Truncate technique names to 15 characters
df['short_name'] = df['name'].apply(lambda x: x[:15] if len(x) > 15 else x)

# Create formatted labels for data display based on unit type
def format_label(row):
    if 'x' in row['unit']:
        return f"{row['improvement']:.1f}x"
    else:
        return f"{row['improvement']:.1f}%"

df['label'] = df.apply(format_label, axis=1)

# Create horizontal bar chart
fig = go.Figure()

# Purple to blue gradient colors
colors = ['#8A2BE2', '#7B68EE', '#6495ED', '#1FB8CD', '#5D878F', '#4682B4']

fig.add_trace(go.Bar(
    y=df['short_name'],
    x=df['improvement'],
    orientation='h',
    marker=dict(
        color=colors,
        line=dict(color='rgba(0,0,0,0.1)', width=1)
    ),
    text=df['label'],
    textposition='outside',
    textfont=dict(size=10)
))

# Update layout
fig.update_layout(
    title="iOS LLM Optimizer Performance Gains",
    xaxis_title="Improvement",
    yaxis_title="Technique",
    showlegend=False,
    xaxis=dict(
        title_standoff=20
    ),
    yaxis=dict(
        title_standoff=20
    )
)

# Save the chart
fig.write_image("ios_llm_performance_chart.png")