# 🤖 AI Code Review - GitHub Action with Deep Static Analysis

<div align="center">

[![GitHub stars](https://img.shields.io/github/stars/loli669/AI-Code-Review?style=social)](https://github.com/loli669/AI-Code-Review/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/loli669/AI-Code-Review?style=social)](https://github.com/loli669/AI-Code-Review/network/members)
[![GitHub issues](https://img.shields.io/github/issues/loli669/AI-Code-Review)](https://github.com/loli669/AI-Code-Review/issues)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub Action](https://img.shields.io/badge/GitHub-Action-blue?logo=github-actions)](https://github.com/marketplace/actions)

**Automated AI-powered code review for GitHub Pull Requests**  
*GPT-5 • Claude Opus 4 • Gemini 2.5 Pro • O3 • Custom AI Models*

[🚀 Quick Start](#-quick-start) • [✨ Features](#-key-features) • [📖 Documentation](#-configuration-options) • [💡 Examples](#-example-reviews) • [🤝 Contributing](#-contributing)

</div>

---

## 🎯 What is AI Code Review?

**AI Code Review** is a next-generation GitHub Action that automates pull request reviews using advanced artificial intelligence and deep static code analysis. Get **Principal/Staff engineer-level** feedback on every PR with AST parsing, linter integration, dependency tracking, and beautiful visual statistics.

### 🏆 Why Choose AI Code Review?

✅ **Save 2-4 hours per day** on code reviews  
✅ **Catch bugs before production** with deep analysis  
✅ **Consistent quality standards** across your team  
✅ **Support for 10+ programming languages**  
✅ **Works with GPT-5, Claude 4, Gemini, O3, and custom AI models**  
✅ **AST parsing + Linter integration + Dependency analysis**

---

## ✨ Key Features

### 🧠 **Senior-Level AI Reviews**
- AI analyzes code like a Principal engineer with 15+ years of experience
- Deep understanding of architecture, performance, and security
- Provides detailed "why" explanations, not just "what"
- Recognizes good code and best practices

### 🔍 **Deep Static Code Analysis**
- **AST Parsing**: Extract functions, classes, and dependencies from any language
- **Linter Integration**: Auto-runs ESLint, Pylint, Rust Clippy, C# Analyzers
- **Dependency Tracking**: Maps function calls and dependencies across codebase
- **Complexity Metrics**: Cyclomatic complexity and maintainability index
- **Call Graph Analysis**: Understand function relationships and breaking changes

### 🎨 **Beautiful Visual Reports**
```
┌─────────────────────────────────────────────────────────────┐
│ Files Reviewed    │ 15                                      │
│ Quality Score     │ ████████████████░░░░ 85/100             │
│ Issues Found      │ Critical: 0 | Warnings: 2 | Info: 1     │
└─────────────────────────────────────────────────────────────┘
```
- ASCII charts and sparklines
- Quality scores and visual statistics
- Trend analysis over time

### 🤖 **Multi-Model Support**
- **OpenAI**: GPT-5, GPT-5-High, O3, O3-Mini
- **Anthropic**: Claude Opus 4, Claude Sonnet 4
- **Google**: Gemini 2.5 Pro, Gemini 2.5 Flash
- **Custom Endpoints**: Azure OpenAI, AWS Bedrock, local models, or any OpenAI-compatible API

### 🛠️ **AI Tool System (14 Tools)**
AI actively investigates your code using specialized tools:
- `read_file`, `get_file_diff`, `analyze_file_ast` - Deep file analysis
- `analyze_function_impact` - 🎯 **Breaking change detector!** Shows full context around ALL function call sites
- `find_function_callers`, `find_function_dependencies` - Code navigation
- `analyze_function_complexity` - Complexity metrics
- `run_linter` - Execute language-specific linters
- `get_commits_list`, `get_commit_diff`, `get_file_history` - Git context
- ...and more!

### 🌍 **Multi-Language Support**
- **Review Language**: Comments in any language (English, Russian, Spanish, French, German, Chinese, etc.)
- **Code Languages**: TypeScript, JavaScript, Python, Rust, C#, Go, Java, PHP, Ruby, and more

### 📦 **Smart PR Handling**
- **Intelligent Chunking**: Splits large PRs optimally by module boundaries
- **Handles massive PRs** without hitting token limits
- **Silent Mode**: Reduce notification spam for your team
- **Auto Labeling**: Manages PR labels based on review results

---

## 🚀 Quick Start

### Step 1: Create Workflow File

Create `.github/workflows/ai-code-review.yml`:

```yaml
name: AI Code Review

on:
  pull_request:
    types: [opened, synchronize, reopened]

jobs:
  ai-review:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      pull-requests: write
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0  # Important for commit history analysis

      - name: Run AI Code Review
        uses: loli669/AI-Code-Review@v1
        with:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}
```

### Step 2: Add OpenAI API Key

1. Get your API key from [OpenAI Platform](https://platform.openai.com/api-keys)
2. Go to your repository **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Name: `OPENAI_API_KEY`, Value: `your-api-key-here`

### Step 3: Create a Pull Request

That's it! 🎉 AI Code Review will automatically analyze every new PR.

---

## 📖 Configuration Options

### Required Inputs

| Input | Description | Default |
|-------|-------------|---------|
| `GITHUB_TOKEN` | GitHub token (auto-provided by Actions) | - |
| `OPENAI_API_KEY` | OpenAI API key or compatible provider | - |

### Optional Inputs

| Input | Description | Default |
|-------|-------------|---------|
| `OPENAI_API_MODEL` | AI model (`gpt-5`, `claude-opus-4`, `o3`, etc.) | `gpt-5` |
| `OPENAI_API_BASE_URL` | Custom endpoint (Azure, Bedrock, local) | `https://api.openai.com/v1` |
| `REVIEW_LANGUAGE` | Review language (`en`, `ru`, `es`, `fr`, `de`, `zh`, etc.) | `en` |
| `SILENT_MODE` | Minimize email notifications (`true`/`false`) | `false` |
| `MAX_CHUNK_SIZE` | Max tokens per chunk (adjust for your model) | `6000` |
| `ENABLE_LINTERS` | Run language-specific linters | `true` |
| `ENABLE_AST` | AST analysis for deep code understanding | `true` |
| `ENABLE_DEPENDENCY_ANALYSIS` | Dependency tracking and call graphs | `true` |
| `SEVERITY_THRESHOLD` | Min severity to report (`info`, `warning`, `error`) | `warning` |

---

## 💡 Example Reviews

<details>
<summary>🔍 Click to see example review output</summary>

```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃                                                                   ┃
┃      🤖 𝗔𝗜 𝗖𝗢𝗗𝗘 𝗥𝗘𝗩𝗜𝗘𝗪 - 𝗔𝗡𝗔𝗟𝗬𝗦𝗜𝗦 𝗖𝗢𝗠𝗣𝗟𝗘𝗧𝗘 🤖              ┃
┃                                                                   ┃
┃         ⚡ Powered by Advanced AI & Deep Code Analysis ⚡           ┃
┃                                                                   ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

## 📋 Executive Summary

This PR implements a new caching layer to reduce database load and improve 
response times. The implementation is solid with good error handling and test 
coverage. Found 2 performance optimizations and 1 documentation suggestion.

**Verdict**: ✅ APPROVED with minor suggestions

## 📊 Review Overview

┌─────────────────────────────────────────────────────────────┐
│ Files Reviewed        │ 15                                  │
│ Total Lines Changed   │ 450 (+320/-130)                     │
│ Commits Analyzed      │ 8                                   │
│ Tools Used            │ 12                                  │
│ Review Time           │ 45s                                 │
│ Quality Score         │ ████████████████░░░░ 85/100         │
└─────────────────────────────────────────────────────────────┘

## 🎯 Issues Summary

Critical  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  0
Warnings  ████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░  2
Info      ████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  1

## 🏆 Highlights

✅ Well-structured code with clear separation of concerns
✅ Comprehensive error handling in API endpoints
✅ Good use of TypeScript types for type safety

## ⚠️ Issues Found

### src/api/handler.ts:45
**Severity:** Warning | **Category:** Performance

The database query inside the loop creates N+1 queries. Consider using 
a single query with JOIN or batch loading.

**Current:**
\`\`\`typescript
for (const user of users) {
  const posts = await db.query('SELECT * FROM posts WHERE user_id = ?', [user.id]);
}
\`\`\`

**Suggested:**
\`\`\`typescript
const posts = await db.query(`
  SELECT p.*, u.id as user_id
  FROM posts p
  JOIN users u ON p.user_id = u.id
  WHERE u.id IN (?)
`, [users.map(u => u.id)]);
\`\`\`
```

</details>

---

## 🎯 Advanced Use Cases

### Manual Trigger with `/review` Command

Add the ability to trigger reviews on-demand:

```yaml
on:
  pull_request:
    types: [opened, synchronize, reopened]
  issue_comment:
    types: [created]

jobs:
  ai-review:
    if: |
      (github.event_name == 'pull_request') ||
      (github.event_name == 'issue_comment' &&
       github.event.issue.pull_request &&
       contains(github.event.comment.body, '/review'))
    # ... rest of the workflow
```

Now comment `/review` on any PR to trigger a review!

### Use Claude Opus 4

```yaml
- uses: loli669/AI-Code-Review@v1
  with:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
    OPENAI_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
    OPENAI_API_BASE_URL: 'https://api.anthropic.com/v1'
    OPENAI_API_MODEL: 'claude-opus-4'
```

### Use Google Gemini 2.5 Pro

```yaml
- uses: loli669/AI-Code-Review@v1
  with:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
    OPENAI_API_KEY: ${{ secrets.GOOGLE_API_KEY }}
    OPENAI_API_BASE_URL: 'https://generativelanguage.googleapis.com/v1'
    OPENAI_API_MODEL: 'gemini-2.5-pro'
    MAX_CHUNK_SIZE: '12000'  # Gemini supports larger context
```

### Use OpenAI O3 Reasoning Model

```yaml
- uses: loli669/AI-Code-Review@v1
  with:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
    OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}
    OPENAI_API_MODEL: 'o3-mini'
    MAX_CHUNK_SIZE: '10000'
```

### Reviews in Russian

```yaml
- uses: loli669/AI-Code-Review@v1
  with:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
    OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}
    REVIEW_LANGUAGE: 'ru'  # Reviews in Russian
```

### Silent Mode (Reduce Notifications)

```yaml
- uses: loli669/AI-Code-Review@v1
  with:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
    OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}
    SILENT_MODE: 'true'  # Minimize email spam
```

---

## 🛠️ How It Works

### 1️⃣ Data Collection
- Retrieves PR details, branch info, and linked issues
- Analyzes file types and programming languages
- Builds commit history timeline

### 2️⃣ Smart Chunking
- Splits large PRs intelligently by module boundaries
- Groups related files together
- Optimizes token usage for your chosen AI model

### 3️⃣ Deep Analysis
AI actively investigates code using 14 specialized tools:

**File Analysis:**
- `read_file` - Read complete file content
- `get_file_diff` - View specific changes with context
- `analyze_file_ast` - Deep AST (Abstract Syntax Tree) parsing

**Code Understanding:**
- `analyze_function_impact` - 🎯 **Breaking Change Detector!** Shows full context around ALL function call sites
- `find_function_callers` - List all places where a function is called
- `find_function_dependencies` - Find what a function depends on
- `analyze_function_complexity` - Cyclomatic complexity metrics

**Quality Tools:**
- `run_linter` - Execute language-specific linters (ESLint, Pylint, Clippy, etc.)

**Git & History:**
- `get_commits_list`, `get_commit_diff`, `get_file_history` - Analyze code evolution

### 4️⃣ AI Review Process
- Uses mandatory workflow requiring 4-6 tools minimum per review
- Analyzes from multiple dimensions: Security, Performance, Architecture, Maintainability
- Provides senior-level feedback with detailed explanations
- Categorizes issues by severity (critical, warning, info)

### 5️⃣ Executive Summary Generation
- Sends full review to AI for concise summary
- Creates brief but comprehensive executive summary (under 300 words)
- Includes: main changes, critical findings, key recommendations, verdict

### 6️⃣ Publishing Results
- Posts comprehensive review comment
- Adds inline comments on specific lines
- Manages labels automatically
- Supports silent mode to reduce notification spam

---

## 🔥 Breaking Change Detection Example

When refactoring a function used across multiple files, AI uses `analyze_function_impact` to show **full context** around ALL call sites.

**Example:** Changing `calculatePrice(quantity, price)` to `calculatePrice(options)`

```typescript
// Before:
function calculatePrice(quantity: number, price: number): number {
  return quantity * price;
}

// After:
function calculatePrice(options: { quantity: number; price: number; discount?: number }): number {
  const { quantity, price, discount = 0 } = options;
  return quantity * price * (1 - discount);
}
```

**What AI sees:**

```
## Function Impact Analysis: calculatePrice

**Definition**: `src/utils/pricing.ts:42`
**Parameters**: quantity, price
**Exported**: Yes

### Call Sites

Found **8** call site(s) across **3** file(s)

---

#### `src/components/Cart.tsx` (3 calls)

**Call at line 67**:
→ 67 | const total = calculatePrice(item.quantity, item.price);
  68 | setCartTotal(total);

**Call at line 89**:
  88 | items.forEach(item => {
→ 89 |   subtotal += calculatePrice(item.qty, item.unitPrice);
  90 | });

---

Total Impact: 8 call site(s) would be affected

Recommendations:
⚠️ Medium impact: 8 call sites - thorough testing recommended
- All callers pass 2 parameters - breaking change confirmed
- Consider backward compatibility or deprecation period
```

The AI can now **intelligently warn** that all 8 call sites need updating! 🎯

---

## 🌐 Supported Languages

### Review Languages (Comments)
English, Russian, Spanish, French, German, Chinese, Japanese, Korean, Portuguese, Italian, Dutch, Polish, Turkish, Arabic, Hindi, and more...

### Code Analysis Languages
- **JavaScript/TypeScript** - ESLint, AST parsing
- **Python** - Pylint, AST parsing
- **Rust** - Clippy, AST parsing
- **C#** - dotnet format analyzers
- **Go** - golangci-lint (custom integration)
- **Java, PHP, Ruby, C++** - Basic analysis
- **And more...**

---

## 🏗️ Development

### Prerequisites
- Node.js 20+
- pnpm 9+

### Setup

```bash
git clone https://github.com/loli669/AI-Code-Review.git
cd AI-Code-Review
pnpm install
pnpm build
```

### Project Structure

```
src/
├── index.ts              # Entry point
├── types/                # TypeScript types
├── ai/                   # AI client & prompts
│   ├── client.ts         # OpenAI/compatible client
│   ├── prompts.ts        # System & user prompts
│   └── tools-registry.ts # 14 AI tools registry
├── analysis/             # Code analysis engines
│   ├── ast-parser.ts     # AST parsing (Babel, TS, Acorn)
│   ├── linter-runner.ts  # Multi-language linter runner
│   └── call-graph.ts     # Dependency & call graph analysis
├── chunking/             # Smart chunking strategies
├── github/               # GitHub API integration
├── stats/                # Visualization & statistics
└── utils/                # Utilities
```

### Testing

```bash
pnpm run build
pnpm run type-check
```

Create a test repository, set up the workflow, and verify the output.

---

## 🤝 Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

1. Fork the repository
2. Create feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'feat: add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open Pull Request

---

## 📝 License

MIT License - see [LICENSE](LICENSE) for details.

---

## 🙏 Acknowledgments

- [OpenAI](https://openai.com) - GPT-5, O3 models
- [Anthropic](https://anthropic.com) - Claude Opus 4
- [Google](https://deepmind.google/technologies/gemini/) - Gemini 2.5 Pro
- [GitHub Actions](https://github.com/features/actions)
- [@babel/parser](https://babeljs.io/docs/en/babel-parser) - JavaScript/TypeScript AST
- [@typescript-eslint/parser](https://typescript-eslint.io) - TypeScript analysis
- [Rust Clippy](https://github.com/rust-lang/rust-clippy) - Rust linting
- [.NET Roslyn Analyzers](https://github.com/dotnet/roslyn-analyzers) - C# analysis

---

## ⭐ Support This Project

If you find AI Code Review useful, please:
- ⭐ **Star this repository**
- 🐛 [Report bugs or request features](https://github.com/loli669/AI-Code-Review/issues)
- 🔀 Share with your team
- 💬 [Join discussions](https://github.com/loli669/AI-Code-Review/discussions)

---

<div align="center">

**Made with ❤️ by [loli669](https://github.com/loli669)**

[⬆ Back to top](#-ai-code-review---github-action-with-deep-static-analysis)

---

<img src="https://count.getloli.com/get/@AI-Code-Review">

 <a href="https://github.com/loli669/AI-Code-Review">
  <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=loli669/AI-Code-Review&type=date&theme=dark" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=loli669/AI-Code-Review&type=date" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=loli669/AI-Code-Review&type=date" />
  </picture>
 </a>
</div>
