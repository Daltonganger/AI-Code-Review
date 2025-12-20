# 🗺️ AI Code Reviewer - Roadmap

Planned features and improvements for future releases.

---

## 📊 Current Language Support Status

### ✅ Full Support (AST + Linters + Type Extraction)
- **TypeScript** - Babel parser, ESLint, type extraction ⭐
- **JavaScript** - Babel parser, ESLint, type extraction ⭐

### ⚠️ Partial Support (Linters Only)
- **C#** - dotnet format + msbuild analyzers
- **Rust** - Clippy (cargo clippy --message-format=json)
- **Python** - Pylint

### 📝 Basic Support (grep-based tools only)
- Go, Ruby, Java, PHP, Scala, Kotlin, Swift, etc.

---

## 🎯 Priority 1: Tree-sitter Integration for Multi-Language AST

### Why Tree-sitter?

Tree-sitter is a parser generator and incremental parsing library that:
- ✅ Supports 50+ languages out of the box
- ✅ Fast and efficient (written in C, used by GitHub, Atom, Neovim)
- ✅ Has Node.js bindings (easy integration)
- ✅ Provides consistent AST structure across languages
- ✅ Actively maintained with large community

### Goal

Add full AST analysis for **Rust** and **C#** (and easily extend to other languages later).

### Current Limitations Without AST

For Rust and C#, we currently can't:
- ❌ Extract function definitions with parameters and types
- ❌ Calculate cyclomatic complexity
- ❌ Build call graphs and dependency trees
- ❌ Show type information in `analyze_function_impact`
- ❌ Provide detailed code structure analysis

We only have:
- ✅ Linters (Clippy, dotnet format)
- ✅ grep-based search (`find_function_callers`, `search_code`)
- ✅ Context display around function calls

### Implementation Plan

#### Phase 1: Add tree-sitter Core (2-3 hours)

**Step 1: Install Dependencies**
```bash
pnpm add tree-sitter tree-sitter-rust tree-sitter-c-sharp
```

**Step 2: Create Parser Registry**
```typescript
// src/analysis/tree-sitter-parser.ts
import Parser from 'tree-sitter';
import Rust from 'tree-sitter-rust';
import CSharp from 'tree-sitter-c-sharp';

const LANGUAGE_PARSERS = new Map([
  ['rust', Rust],
  ['csharp', CSharp],
]);

export function parseWithTreeSitter(code: string, language: string) {
  const parser = new Parser();
  const lang = LANGUAGE_PARSERS.get(language);

  if (!lang) {
    return null;
  }

  parser.setLanguage(lang);
  return parser.parse(code);
}
```

**Step 3: Extract Functions from Tree-sitter AST**

For **Rust**:
```rust
// Query for functions:
fn function_name(param1: Type1, param2: Type2) -> ReturnType {
  // body
}

// Tree-sitter node types:
- function_item
  - name (identifier)
  - parameters (parameter list)
    - parameter (each param)
      - pattern (name)
      - type (type annotation)
  - return_type
  - body
```

For **C#**:
```csharp
// Query for methods:
public void MethodName(Type1 param1, Type2 param2) {
  // body
}

// Tree-sitter node types:
- method_declaration
  - modifier (public/private/etc)
  - type (return type)
  - identifier (name)
  - parameter_list
    - parameter
      - type
      - identifier
  - block (body)
```

**Step 4: Integrate with Existing AST Parser**

Modify `src/analysis/ast-parser.ts`:
```typescript
export async function parseFile(content: string, filename: string) {
  const language = detectLanguage(filename);

  switch (language) {
    case 'typescript':
    case 'tsx':
    case 'javascript':
    case 'jsx':
      return parseBabel(content, language); // Existing

    case 'rust':
      return parseTreeSitter(content, 'rust'); // NEW

    case 'csharp':
      return parseTreeSitter(content, 'csharp'); // NEW

    default:
      return { ast: null, functions: [], ... };
  }
}
```

**Step 5: Extract Function Information**

Create `extractFunctionsFromTreeSitter()` that walks the AST and extracts:
- Function name
- Line number
- Parameters (names + types!)
- Return type
- Async/await status
- Visibility (public/private)
- Complexity estimation

**Step 6: Add Type Extraction for Rust/C#**

Extend `extractTypeInformation()` in `src/ai/tools-registry.ts`:
```typescript
function extractTypeInformation(...) {
  if (file.match(/\.(ts|tsx|js|jsx)$/)) {
    // Existing TypeScript logic
  } else if (file.match(/\.rs$/)) {
    // NEW: Rust type extraction
    // let var_name: i32 = ...
    // fn func(param: String) -> Result<T, E>
  } else if (file.match(/\.cs$/)) {
    // NEW: C# type extraction
    // int varName = ...
    // public string Method(int param)
  }
}
```

#### Phase 2: Add More Languages (1 hour each)

Once tree-sitter is integrated, adding new languages is easy:

**Go:**
```bash
pnpm add tree-sitter-go
```

**Python:**
```bash
pnpm add tree-sitter-python
```

**Java:**
```bash
pnpm add tree-sitter-java
```

Each language just needs:
1. Import parser
2. Add to `LANGUAGE_PARSERS` map
3. Create extraction function (15-30 min)

### Benefits

After implementation:

✅ **Rust** gets:
- Full function analysis with types (`fn calculate(price: f64) -> Result<f64, Error>`)
- Complexity metrics
- Type information in impact analysis
- Better code understanding for AI

✅ **C#** gets:
- Method analysis with types (`public async Task<User> GetUser(int id)`)
- Property and field detection
- Type information in impact analysis
- Better refactoring support

✅ **Easy expansion** to 50+ languages

### Estimated Impact

- Bundle size: +150-200kb (tree-sitter + 2 language parsers)
- Performance: Tree-sitter is very fast (<10ms for most files)
- Code quality: ~200 lines of new code
- Maintenance: Tree-sitter is stable and well-maintained

### Priority

**Priority: High** 🔴

**Reason**: Rust and C# are your important languages. Currently they get only basic analysis (linters + grep). With tree-sitter they'll get same level of support as TypeScript.

**When**: Next major feature after current release stabilizes

---

## 🚀 Priority 2: Other Improvements

### 🔄 Call Graph Integration

**Status**: TODO comment in code (low priority)

**Current**: `find_function_callers` uses git grep
**Planned**: Build project-wide call graph using AST

**Benefits**:
- See full function call chains
- Detect circular dependencies
- Find unused functions
- Impact analysis across modules

**Implementation**: Use existing `src/analysis/call-graph.ts` (already written, just needs integration)

**Priority**: Medium 🟡

---

### 📦 Dependency Graph Visualization

**Idea**: Generate visual dependency graphs

**Example**:
```
src/index.ts
  ├─ src/ai/client.ts
  │   ├─ src/ai/prompts.ts
  │   └─ src/ai/tools-registry.ts
  └─ src/github/client.ts
```

**Output**: Mermaid diagrams in review comments

**Priority**: Low 🟢

---

### 🧪 Test Coverage Analysis

**Idea**: Detect if changes have tests

**How**:
1. Analyze changed functions
2. Search for test files (`*.test.ts`, `*_test.go`, etc.)
3. Check if changed functions are tested
4. Warn if critical code has no tests

**Priority**: Medium 🟡

---

### 🎨 Custom Review Templates

**Idea**: Let users customize review format

**Example**:
```yaml
# .github/ai-review-config.yml
review_template: |
  ## Changes Summary
  {summary}

  ## Issues Found
  {issues}

  ## Custom Section
  - My custom checks...
```

**Priority**: Low 🟢

---

### 🌐 Multi-LLM Support

**Status**: Partially done (already supports OpenAI-compatible APIs)

**Planned improvements**:
- Native Anthropic Claude API support
- Native Google Gemini API support
- Native Azure OpenAI support
- LLM response caching for faster reviews

**Priority**: Medium 🟡

---

### 📊 Review History & Trends

**Idea**: Track review metrics over time

**Metrics**:
- Code quality trend (improving/declining)
- Most common issue types
- Files with most issues
- Review time trends

**Storage**: GitHub repo annotations or separate DB

**Priority**: Low 🟢

---

## 🎯 Completed Features ✅

- ✅ TypeScript/JavaScript full AST support
- ✅ Multi-language linter integration (ESLint, Pylint, Clippy, dotnet format)
- ✅ Breaking change detection (`analyze_function_impact`)
- ✅ Type extraction for TypeScript
- ✅ CLI-table3 for perfect ASCII formatting
- ✅ JSON5 syntax support
- ✅ `/review` command support
- ✅ Chunk-based review for large PRs
- ✅ Smart file grouping by module
- ✅ Beautiful statistics with quality scores
- ✅ Multi-language support (en, ru, es, fr, de, etc.)
- ✅ Silent mode to reduce notifications
- ✅ 14 analysis tools for deep code investigation

---

## 💡 Community Ideas

Have an idea? Open an issue with the `enhancement` label!

**Wanted features**:
- 🎤 Voice your opinion on what should be prioritized
- 🔧 Suggest new tools for AI to use
- 🌍 Request support for your favorite language
- 📝 Share your custom prompts and workflows

---

## 📅 Release Schedule

### v1.1 (Next)
- 🔴 Tree-sitter integration for Rust
- 🔴 Tree-sitter integration for C#
- 🟡 Call graph integration
- 🟡 Test coverage warnings

### v1.2 (Future)
- 🟡 More languages (Go, Python, Java via tree-sitter)
- 🟡 Multi-LLM native support
- 🟢 Custom review templates

### v2.0 (Long-term)
- 🟢 Review history & trends
- 🟢 Dependency graph visualization
- 🟢 Advanced caching and performance optimizations

---

## 🤝 Contributing

Want to help implement these features? Check [CONTRIBUTING.md](CONTRIBUTING.md)!

**Good first issues**:
- Add tree-sitter support for Go/Python/Java (after Rust/C# are done)
- Improve type extraction patterns for edge cases
- Add more linter integrations
- Write tests for new features

---

**Last updated**: 2025-11-06
**Maintainer**: @loli669
