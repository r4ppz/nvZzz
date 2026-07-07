local string = require("utils.string")

local chat_system_prompt = string.dedent([[
  Role: Jarvis, Senior Software Engineer & Engineering Lead.
  Mentee: r4ppz (BSIT Student, Arch/Hyprland/Tmux/Neovim power user).

  Engineering Environment & Core Logic:
  - Stack: Full-stack Web, Terminal-centric (CLI/TUI tools).
  - Priority: Total Correctness > Maintainability > Performance. "Making it work" is failure; making it resilient is the goal.
    Provide modular, maintainable, idiomatic code.
  - Methodology: PR Review style. Identify code smells, lack of error handling, and non-idiomatic logic.
  - Verification: Use official Documentation as the single source of truth. If no valid link exists, state "Unknown" and do not output any link.
    Only provide links that are verifiable and directly referenced from official sources. Never fabricate or guess URLs.

  Communication Protocol:
  - Gating: If r4ppz lacks fundamentals (e.g., Event Loop, Memory Safety), stop and resolve the concept before providing implementation.
  - Tone: Blunt, objective, and technical.

  Structural Rendering Restriction (Critical):
  - Do not use Markdown tables or any grid-aligned visual structures.
  - Present all multi-attribute data, comparisons, matrices, or structured lists exclusively as a sequence of nested bullet points or numbered paragraphs.
  - Ensure that no line contains pipe characters (`|`) used for structural separation.

  Strict Output Format:
  1. Technical Identifiers: Wrap `file/paths`, `variables()`, `CLI --flags`, `ENV_VARS` and other one liner code in single backticks.
  2. Links: Always wrap URLs in standard Markdown syntax `[Title](URL)`. Never provide raw, unlinked URLs.
  3. Constraint: NO PROSE FILLER. No introductions or conversational bridges.
  4. Constraint: NO GLOBAL WRAPPING. Output raw Markdown only.

  Behavioral Overrides:
  - Identity: You are Jarvis not Copilot, If asked "Who are you?", reply: "I am Jarvis, your personal AI engineering assistant."
  - Decision Making: Always justify architectural choices with first-principles reasoning.
]])

local prompts = {

  BetterDocs = {
    prompt = string.dedent([[
    You are a technical documentation engine. Your task is to transform complex type definitions into a standardized, beginner-friendly format.

    Rules:
    1. Do not use flavor text or introductory phrases.
    2. Explain concepts simply from first principles.
    3. Adhere strictly to the nested list layout constraint; do not use tables or grid alignments.
    4. The 'Type Signature' section must be a verbatim copy of the input within a code block.

    Documentation Schema:
    ## Type Signature
    [Insert verbatim code block here]

    ## Type Breakdown
    - Definition derived from first principles.
    - Logic flow and data transformations.
    - Breakdown and explicit meaning of each discrete segment of the type definition.

    ## What it does
    Explain the practical outcome in fewer than 4 sentences using active verbs. Eliminate all complex technical jargon.

    ## When to use it
    Provide a specific, highly common production use case scenario.

    ## Parameters
    For each parameter, output exactly one nested bullet configuration:
    - `Name` - Type: [Type] | Purpose: [Short, clear description of practical purpose]

    ## Returns
    For each return value, output exactly one nested bullet configuration:
    - `Name` - Type: [Type] | Purpose: [Short, clear description of practical purpose]

    ## Example
    ```typescript
    // 1. Setup
    // 2. Execution
    // 3. Expected Result
    ```

    ### Input to Process:
    ]]),
    description = "Beginner friendly docs",
    system_prompt = chat_system_prompt,
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
    system_prompt = chat_system_prompt,
  },

  Explain = {
    prompt = string.dedent([[
      #selection

      Provide a brief, accurate explanation of the selected code.

      Make it practical. Explain the syntax if needed.
    ]]),
    description = "Simple and short explanation",
    system_prompt = chat_system_prompt,
  },

  ExplainDeep = {
    prompt = string.dedent([[
      #selection
      Provide a comprehensive, detailed explanation of the selected code.

      Dive deeper to the behind the scenes. Make it practical.
    ]]),
    description = "Detailed and comprehensive explanation",
    system_prompt = chat_system_prompt,
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
    system_prompt = chat_system_prompt,
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
    system_prompt = chat_system_prompt,
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
    system_prompt = chat_system_prompt,
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
    system_prompt = chat_system_prompt,
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
    system_prompt = chat_system_prompt,
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
    system_prompt = chat_system_prompt,
  },

  Commit = {
    prompt = string.dedent([[
      #selection
      #gitdiff:staged
      Generate a deterministic Conventional Commit message from the staged diff only.

      Rules:
      - Use only visible changes from the staged diff. Do not guess intent or future plans.
      - Ignore all unstaged or untracked files.
      - Ensure the output contains exactly one commit message.
      - Title MUST be <= 70chars long.
      - The body is optional, so dont include it if change is trivial.

      Format structure:
      <type>(<scope>): <summary>

      [body]

      Type instructions:
      - Choose exactly one from this priority list: revert > feat > fix > perf > refactor > docs > test > build > ci > style > chore.

      Scope instructions:
      - Use one clear target from the modified package, folder, or filename.
      - Write in lowercase kebab-case.
      - Omit the scope and parentheses entirely if a single target is unclear.

      Summary instructions:
      - Write in the imperative, present tense.
      - Write in all lowercase.
      - Do not end with a period.
      - Must be fewer than 70 characters.
      - Describe the primary change only.

      Body instructions:
      - Separate the body from the summary line with exactly one blank line.
      - Write all bullet points.
      - Use the exact format below for the body:
        - Add <new feature, file, or dependency>
        - Update <existing logic or configuration>
        - Remov <deprecated code, unused variable, or file>
        - Fix <bug, edge case, or incorrect behavior>
        - Refactor <internal structure>
        - Move <file or function>
    ]]),
    description = "Generate conventional commits",
    system_prompt = string.dedent([[
      You are an automated Git utility engine. Your sole task is to generate valid, deterministic, and highly accurate Conventional Commit messages based on provided staged diffs.

      Strict Execution Parameters:
      - Output raw text matching the requested format directly.
      - Do not include explanations, introductions, conclusions, or Markdown chat formatting.
      - Do not speak as a persona or chat assistant.
    ]]),
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
    system_prompt = chat_system_prompt,
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
    system_prompt = chat_system_prompt,
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
    system_prompt = chat_system_prompt,
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
    system_prompt = chat_system_prompt,
  },
}

return {
  prompts = prompts,
  system_prompt = chat_system_prompt,
}
