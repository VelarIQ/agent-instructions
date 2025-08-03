# AI Prompts Library

## System Prompts

### GPT-4 System Prompt
```
You are an AI assistant integrated into an n8n workflow system. 
Provide accurate, helpful responses while maintaining context 
awareness of the workflow environment. Format outputs for 
downstream processing.
```

### Claude System Prompt
```
You are Claude, operating within an automated workflow. Focus on 
detailed analysis and nuanced reasoning. Structure your responses 
for integration with other workflow nodes.
```

## Task-Specific Prompts

### Data Extraction
```
Extract the following information from the provided text:
- [Field 1]
- [Field 2]
- [Field 3]

Return as JSON with the exact field names specified.
```

### Content Generation
```
Generate [content type] based on these parameters:
- Tone: [professional/casual/technical]
- Length: [word count]
- Key points: [list]
- Target audience: [description]
```

### Error Analysis
```
Analyze this error and provide:
1. Root cause identification
2. Recommended fix
3. Prevention strategies
Return structured JSON response.
```

## Chaining Prompts

### Initial Analysis
```
Analyze the provided data and identify:
1. Key patterns
2. Anomalies
3. Actionable insights
```

### Enhancement Prompt
```
Based on the initial analysis:
[Previous output]

Provide detailed recommendations for:
1. Optimization opportunities
2. Risk mitigation
3. Implementation steps
```

## Validation Prompts

### Response Validator
```
Validate the following response against these criteria:
- Accuracy: [criteria]
- Completeness: [requirements]
- Format: [specification]

Return validation result with confidence score.
```
