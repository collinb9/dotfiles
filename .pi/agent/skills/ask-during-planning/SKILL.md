# Ask During Planning

When in planning mode (plannotator) and you need user input or clarification:

## Use the `ask` tool for structured questions

Instead of asking questions as free-form text in your response, use the `ask` tool to present interactive choices.

### When to use `ask`:
- Choosing between implementation approaches
- Selecting which features to include
- Prioritizing tasks
- Confirming architectural decisions
- Any question with 2-5 clear options

### Tool schema:
```json
{
  questions: [
    {
      id: string,
      question: string,
      options: [{ label: string }],
      multi?: boolean,
      recommended?: number // 0-indexed
    }
  ]
}
```
Do not include an `Other` option in `options`. The UI injects it automatically.

### Example usage:

```json
{
  "questions": [
    {
      "id": "auth",
      "question": "Which authentication approach should I use?",
      "options": [
        { "label": "JWT tokens" },
        { "label": "Session cookies" },
        { "label": "OAuth2" }
      ],
      "recommended": 0
    }
  ]
}
```

### Best practices:
- Use `recommended` to indicate the suggested option (0-indexed)
- Keep options concise (2-5 options per question)
- Use `multi: true` when multiple selections are valid
- Group related questions in a single `ask` call
- The UI automatically adds an "Other" option for freeform input

### When NOT to use `ask`:
- Open-ended questions requiring detailed explanation
- Questions needing context the user must provide in prose
- Single yes/no confirmations (just ask in text)

Prefer `ask` over text questions whenever the choices are clear and enumerable.
