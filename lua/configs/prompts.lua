local string = require("utils.string")

local system_prompt = string.dedent([[
  Role: Jarvis, Senior Software Engineer & Engineering Lead.
  Mentee: r4ppz (BSIT Student, Arch/Hyprland/Tmux/Neovim power user).

  Engineering Environment & Core Logic:
  - Stack: Full-stack Web, Terminal-centric (CLI/TUI tools).
  - Priority: Total Correctness > Maintainability > Performance. "Making it work" is failure; making it resilient is the goal.
    Provide modular, maintainable, idiomatic code.
  - Methodology: PR Review style. Identify code smells, lack of error handling, and non-idiomatic logic.
  - Verification: Use official RFCs and Documentation as the single source of truth. If no valid link exists, state "Unknown" and do not output any link.
    Only provide links that are verifiable and directly referenced from official sources. Never fabricate or guess URLs.

  Communication Protocol:
  - Gating: If r4ppz lacks fundamentals (e.g., Event Loop, Memory Safety), stop and resolve the concept before providing implementation.
  - Tone: Blunt, objective, and technical. Zero social lubrication.
    Operational Modes:
    Whenever a prompt includes "Mode [Letter]", strictly adhere to the corresponding output protocol:
    - Mode A (Routine): Direct, concise command/syntax output.
    - Mode B (Behind the Scenes): Detailed exploration of underlying mechanisms and internal workings.
    - Mode C (Architecture/Debug): Deep-dive analysis including a Cost-Benefit Matrix for all trade-offs.

  Strict Output Format:

  1. Main Title: Start immediately with `# [Subject]`.
  2. Technical Identifiers: Wrap `file/paths`, `variables()`, `CLI --flags`, `ENV_VARS` and other one liner code in single backticks.
  3. Code Blocks: Use triple backticks with language tags. Precede every block with `File: `path/to/file``.
  4. Links: Always wrap URLs in standard Markdown syntax `[Title](URL)`. Never provide raw, unlinked URLs.
  5. Constraint: NO TABLES. Present comparative data or matrices using structured numbered paragraphs.
  6. Constraint: NO PROSE FILLER. No introductions or conversational bridges.
  7. Constraint: NO GLOBAL WRAPPING. Output raw Markdown only.

  Behavioral Overrides:
  - Identity: If asked "Who are you?", reply: "I am Jarvis, your personal AI engineering assistant."
  - Decision Making: Always justify architectural choices with first-principles reasoning.

  Think step-by-step internally, but output ONLY the final Markdown answer.
]])

local prompts = {
  BetterDocs = {
    prompt = string.dedent([[
      Rewrite this hover documentation in a clearer and more readable way,
      but DO NOT remove or hide the original type signature.

      Use this exact structure:

      ## Type Signature
      (paste the full original type exactly as-is use (md code block))

      ## Type Breakdown
      Explain what each part of the type means.
      Explain generics, constraints, unions, overloads, etc (if available).

      ## What it does
      Plain English explanation of the behavior.

      ## When to use it
      Real-world usage scenarios.

      ## Parameters
      - `name` (type): practical explanation (if available)

      ## Returns
      - `name` (type): practical explanation (if available)

      ## Example
      A realistic/practical example showing input, output and a short explanation.

      Docs to improve:

    ]]),
    description = "Beginner friendly docs",
    system_prompt = system_prompt,
  },

  Concepts = {
    prompt = string.dedent([[
      #selection
      Identify **all foundational concepts** required to understand this code snippet.

      Requirements:
      • List only concepts explicitly demonstrated or strictly required by the syntax and structure present.
      • For each concept, provide a concise, technically accurate explanation focused on its role in this snippet.
      • At the end, recommend one authoritative resource (official docs, specification, or canonical reference) for learning these concepts.

      Output structure:
      • `Concept name`: Explanation tied directly to its usage in this snippet
      <space>
      • `Concept name`: Explanation tied directly to its usage in this snippet
      ...
    ]]),
    description = "List foundational concepts",
    system_prompt = system_prompt,
  },

  Explain = {
    prompt = string.dedent([[
      #selection

      Provide a brief, accurate explanation of the selected code.

      Make it practical. Explain the syntax if needed.
    ]]),
    description = "Simple and short explanation",
    system_prompt = system_prompt,
  },

  ExplainDeep = {
    prompt = string.dedent([[
      #selection
      Mode B

      Provide a comprehensive, detailed explanation of the selected code.

      Dive deeper to the behind the scenes. Make it practical.
    ]]),
    description = "Detailed and comprehensive explanation",
    system_prompt = system_prompt,
  },

  Log = {
    prompt = string.dedent([[
      #selection
      Add logging statements to the selected code to aid in debugging and monitoring.

      Requirements:
      • Insert log statements at key points such as function entry, exit, and critical decision points.
      • Use appropriate log levels (e.g., debug, info, warn, error).
      • Ensure logs provide meaningful context without exposing sensitive information.
    ]]),
    description = "Add logging",
    system_prompt = system_prompt,
  },

  Review = {
    prompt = string.dedent([[
      #selection (preferred)
      #buffer:active (additional context)
      Perform a **comprehensive code review**.

      Requirements:
      • Identify issues and reference specific lines.
      • Categorize findings by severity: Critical / Warning / Suggestion.
      • Evaluate correctness, safety, readability, maintainability, and style.
      • Provide concrete fixes or improvements with concise technical explanations.
    ]]),
    description = "Perform a detailed review",
    system_prompt = system_prompt,
  },

  Fix = {
    prompt = string.dedent([[
      #buffer:active
      Identify and fix all issues in the given code.

      Requirements:
      • List each issue and explain why it’s a problem.
      • Provide corrected code, using modern and idiomatic conventions.
      • Justify each fix with precise technical reasoning.
      • Prefer solutions that prioritize correctness, maintainability, and clarity.

      Constraints:
      • Do not add features beyond what the original code intends.
    ]]),
    description = "Find, explain, and fix code issues",
    system_prompt = system_prompt,
  },

  Optimize = {
    prompt = string.dedent([[
      #selection
      Optimize the given code for performance and clarity.

      Requirements:
      • Identify inefficiencies or redundant operations.
      • Suggest algorithmic or structural improvements.
      • Provide before/after examples and explain trade-offs.
      • Ensure optimizations do not harm readability or maintainability.
    ]]),
    description = "Optimize code",
    system_prompt = system_prompt,
  },

  Docs = {
    prompt = string.dedent([[
      #selection
      Generate concise, accurate documentation comments for the selected code.

      Requirements:
      - Use the standard documentation format for the detected language or framework.
        - Java → JavaDoc
        - JavaScript / TypeScript → JSDoc
        - Python → docstrings (PEP 257)
        - C/C++ → Doxygen-style comments
        - Other languages → their most widely accepted documentation convention
      - Output only the documentation comments, formatted exactly as they would appear in source code.
    ]]),
    description = "Generate documentation comments",
    system_prompt = system_prompt,
  },

  Tests = {
    prompt = string.dedent([[
      #selection
      Generate tests for the given code using the standard testing framework for [language/framework].

      Requirements:
      • Cover normal, edge, and error cases.
      • Ensure test structure is clear, maintainable, and logically organized.
      • Include setup/teardown only when necessary.
    ]]),
    description = "Generate tests",
    system_prompt = system_prompt,
  },

  Commit = {
    prompt = string.dedent([[
      #gitdiff:staged
      Task: Generate a deterministic commit message based on the provided diff.
      Convention: Conventional Commits (Project Agnostic).

      Format:
      <type>(<scope>): <summary>
      <BLANK LINE>
      <body>
      <BLANK LINE>
      <footer>

      Constraints:
      1. Header:
         - Types: feat|fix|perf|refactor|docs|style|test|build|ci|chore|revert
         - Scope: Optional. Use the specific module/package/filename name affected.
         - Summary: Mandatory. Use imperative, present tense. Lowercase. No trailing period. Must be below 70 characters.
      2. Body:
         - Mandatory unless type is "docs". Must be > 20 characters.
         - Content: Focus on the "why" of the change. Compare previous vs. new behavior.
         - Style: Imperative, present tense.
      3. Footer (Optional):
         - Breaking Changes: Start with "BREAKING CHANGE:" followed by summary, blank line, and migration steps.
         - Issues: Use "Fixes #<id>" or "Closes #<id>".
      4. Reverts:
         - Header: "revert: <original header>"
         - Body: Must include "This reverts commit <SHA>." and the specific reason for revert.

      Requirement: Output ONLY the commit message. No preamble, no post-explanation, and no markdown code blocks unless the diff dictates it.
    ]]),
    description = "Generate conventional commits",
    system_prompt = system_prompt,
  },

  Idiomatic = {
    prompt = string.dedent([[
      #selection (preferred)
      #buffer:active (additional context)
      Review the code for idiomatic style and conventions.

      Requirements:
      • Assess adherence to community standards.
      • Identify non-idiomatic patterns and suggest more conventional alternatives.
      • Briefly explain why each alternative is preferred.

      Constraints:
      • Base suggestions only on widely accepted conventions.
    ]]),
    description = "Suggest idiomatic improvements",
    system_prompt = system_prompt,
  },

  Suggest = {
    prompt = string.dedent([[
      #selection (preferred)
      #buffer:active (additional context)
      Propose alternative implementations or designs for the given code.

      Requirements:
      • Consider readability, safety, maintainability, and performance.
      • Provide concrete alternative examples with short reasoning.
      • Discuss trade-offs and migration complexity when relevant.

      Constraints:
      • Do not add features not present in the original intent.
    ]]),
    description = "Suggest alternative implementations",
    system_prompt = system_prompt,
  },

  Diagnostic = {
    prompt = string.dedent([[
      #buffer:active
      Analyze diagnostics and source code.

      Requirements:
      • List issues by severity.
      • Explain root causes and contributing factors.
      • Provide fixes and corrected code.
      • Suggest practices to prevent similar issues.
    ]]),
    description = "Analyze diagnostic data",
    system_prompt = system_prompt,
  },

  Refactor = {
    prompt = string.dedent([[
      #selection
      Refactor the given code for better structure and maintainability.

      Requirements:
      • Improve naming, modularity, and organization.
      • Remove redundancy or unnecessary complexity.
      • Preserve behavior and functionality.
      • Apply clean code principles and idiomatic patterns.

      Constraints:
      • Do not change semantics or add new features.
    ]]),
    description = "Refactor code",
    system_prompt = system_prompt,
  },
}

return {
  prompts = prompts,
  system_prompt = system_prompt,
}
