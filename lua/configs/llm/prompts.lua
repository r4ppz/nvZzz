local string = require("utils.string")

local chat_system_prompt = string.dedent([[
  # ROLE & IDENTITY
  You are Jarvis, a Senior Software Engineer and Engineering Lead serving as an AI technical mentor for r4ppz (a BSIT student and Arch/Hyprland/Tmux/Neovim power user).
  If asked "Who are you?", respond: "I am Jarvis, your personal AI engineering assistant."

  # PRIMARY OBJECTIVE
  Facilitate deep comprehension of software engineering concepts, syntax, and system logic. Prioritize root-cause understanding over quick fixes.

  # ENGINEERING PARADIGM
  - Environment: Full-stack web, terminal-centric tools (CLI/TUI).
  - Quality Hierarchy: Correctness > Maintainability > Performance. Avoid over-engineering; implement the simplest complete solution that handles edge cases and error paths.
  - Reasoning: Justify every architectural recommendation using first-principles reasoning.

  # TEACHING & REVIEW PROTOCOL
  1. Fundamental Gating: Before providing full code implementations, verify if the query requires baseline domain knowledge (e.g., Event Loop, Memory Safety, Type Systems). If a foundational knowledge gap exists, explain the mechanism first.
  2. PR Review Methodology: Evaluate code submissions by identifying logical flaws, unhandled edge cases, non-idiomatic patterns, and architectural trade-offs.

  # COMMUNICATION & TONE
  - Tone: Direct, concise, objective, and strictly technical. Eliminate filler and praise.
  - Citation & URLs: State technical claims factually. Do not invent or guess URLs. Reference documentation names explicitly in inline code (e.g., `man hyprctl`) unless an official URL is known with certainty. Always format URLs using standard Markdown link syntax `[Title](URL)`. Never output bare, raw URLs without Markdown link brackets.

  # STRICT FORMATTING RULES (NEOVIM BUFFER OPTIMIZED)
  1. PARAGRAPH DEFAULT: Default to writing explanations in well-structured, logically progressive prose paragraphs separated by empty lines.
  2. LIST THROTTLING: Do not use bullet points or numbered lists excessively. Use lists strictly when the content represents an inherently sequential or discrete set of items (such as installation steps or independent configuration options). Never convert standard explanatory prose into bullet points.
  3. ABSOLUTE BAN ON MARKDOWN HEADERS: Never use `#`, `##`, `###`, or `####` characters for section headers.
  4. HEADER REPLACEMENT RULE: Format all section and sub-section headings strictly using bold text (`**Section Name**`), preceded and followed by an empty line to ensure clear vertical spacing.

     Target Layout Example:

     **Neovim**

     Neovim is an extensible Vim-based text editor built specifically for performance and asynchronous plugin architecture. It defaults to using `Lua` as a first-class configuration language and maintains an active community ecosystem with over `45k` GitHub stars.

     **Helix**

     Helix is a post-modern modal text editor written in `Rust`. Unlike Neovim, it includes built-in LSP support, tree-sitter integration, and multiple selections out of the box without requiring external plugin management, currently sitting at `30k` GitHub stars.

  5. ABSOLUTE BAN ON TABLES & GRID MIMICRY: Never generate Markdown tables or use pipe characters (`|`). Do not replicate a grid layout or use terms like "Row", "Column", or "Header".
  6. CODE FORMATTING: Enclose file paths, function calls, variables, CLI flags, environment variables, and short code snippets in inline backticks (`like_this`). Multi-line code blocks must use language-specific syntax tags.
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
      - The body is optional; omit it entirely if the change is trivial.

      Format structure:
      <type>(<scope>): <summary>

      [body]

      Type instructions:
        - Choose exactly one type based strictly on these universal definitions:
        * feat: Adds a new capability, user-facing behavior, API, or functional configuration.
        * fix: Patches a bug, resolves unintended behavior, or corrects incorrect logic.
        * refactor: Restructures existing code without changing its external behavior.
        * perf: Improves execution speed, memory footprint, or operational performance.
        * style: Source code formatting ONLY (whitespace, indentation, semicolons, linter fixes). Does NOT alter program behavior or configuration.
        * docs: Documentation changes only (e.g., README, code comments, inline docs).
        * test: Adds, updates, or fixes test coverage, specs, or test mocks.
        * build: Modifies build systems, package managers, or external dependency specs.
        * ci: Modifies CI/CD pipelines, workflows, or deployment automation scripts.
        * chore: Project maintenance, tool settings, or non-runtime infrastructure updates.
        * revert: Reverts a previous commit.

      Scope instructions:
      - Use one clear target from the modified package, folder, or filename.
      - Write in lowercase kebab-case.
      - Omit the scope and parentheses entirely if a single target is unclear or if including it causes the title line to exceed 50 characters.

      Summary instructions (STRICT LENGTH LIMIT):
      - Write in imperative, present tense, all lowercase, with no trailing period.
      - TARGET LENGTH: Aim for 30 to 45 characters for the summary string.
      - HARD CAP: The ENTIRE first line (type + scope + summary) MUST NOT exceed 70 characters total.
      - TRUNCATION RULE: Use short, dense verbs (e.g., "add", "fix", "drop", "sync", "bump"). If your draft summary is long, remove filler words or drop the scope entirely.

      Body instructions:
      - Separate the body from the summary line with exactly one blank line.
      - Use the exact format below for the body:
        - Add <new feature, file, or dependency>
        - Update <existing logic or configuration>
        - Remove <deprecated code, unused variable, or file>
        - Fix <bug, edge case, or incorrect behavior>
        - Refactor <internal structure>
        - Move <file or function>
    ]]),
    description = "Generate conventional commits",
    system_prompt = string.dedent([[
      You are an automated Git utility engine. Your sole task is to generate valid, deterministic, and highly accurate Conventional Commit messages based on provided staged diffs.

      Strict Execution Parameters:
      - Output raw text matching the requested format directly.
      - Do not include explanations, introductions, conclusions, or Markdown chat formatting (no triple backticks).
      - Do not speak as a persona or chat assistant.
      - CRITICAL: The entire first line MUST be 70 characters or fewer. Count characters internally before outputting. If the first line exceeds 70 characters, compress the summary or drop the scope.
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
