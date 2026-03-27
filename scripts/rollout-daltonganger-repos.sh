#!/usr/bin/env bash

set -euo pipefail

OWNER="Daltonganger"
WORKFLOW_PATH=".github/workflows/ai-code-review.yml"
TEMPLATE_PATH="templates/ai-code-review.codex.yml"
BRANCH_NAME="chore/add-ai-code-review"
COMMIT_MESSAGE="chore: add AI code review workflow"
PR_TITLE="chore: add AI code review workflow"
ACTION_VERSION="v1.4.2"
PR_BODY=$(cat <<EOF
## Summary
- add the shared AI Code Review workflow
- configure the workflow to use the Codex provider in English
- point workflow usage at \`Daltonganger/AI-Code-Review@${ACTION_VERSION}\`
EOF
)

APPLY=false
CREATE_PRS=false
SET_SECRET=false
PROMPT_SECRET=false
INCLUDE_FORKS=false
REPOS=()

usage() {
  cat <<'EOF'
Usage: scripts/rollout-daltonganger-repos.sh [options]

Dry-run by default. Use --apply to make changes.

Options:
  --apply                 Write changes, commit, push, and optionally open PRs
  --create-prs            Create a PR for each changed repository
  --set-secret            Set CODEX_API_KEY in each target repo from local env
  --prompt-secret         Prompt once for CODEX_API_KEY and set it in each target repo
  --include-forks         Include forked repositories in the target list
  --repo NAME             Target a specific repo (repeatable)
  --owner NAME            Override owner/user (default: Daltonganger)
  --help                  Show this help

Environment:
  CODEX_API_KEY           Required only when --set-secret is used

Examples:
  scripts/rollout-daltonganger-repos.sh
  scripts/rollout-daltonganger-repos.sh --apply --create-prs
  CODEX_API_KEY=... scripts/rollout-daltonganger-repos.sh --apply --set-secret --create-prs
  scripts/rollout-daltonganger-repos.sh --apply --prompt-secret --set-secret --create-prs
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --apply)
      APPLY=true
      ;;
    --create-prs)
      CREATE_PRS=true
      ;;
    --set-secret)
      SET_SECRET=true
      ;;
    --prompt-secret)
      PROMPT_SECRET=true
      ;;
    --include-forks)
      INCLUDE_FORKS=true
      ;;
    --repo)
      shift
      REPOS+=("$1")
      ;;
    --owner)
      shift
      OWNER="$1"
      ;;
    --help)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown option: %s\n\n' "$1" >&2
      usage >&2
      exit 1
      ;;
  esac
  shift
done

if ! command -v gh >/dev/null 2>&1; then
  printf 'gh CLI is required\n' >&2
  exit 1
fi

if ! command -v git >/dev/null 2>&1; then
  printf 'git is required\n' >&2
  exit 1
fi

if [[ ! -f "$TEMPLATE_PATH" ]]; then
  printf 'Template not found: %s\n' "$TEMPLATE_PATH" >&2
  exit 1
fi

if [[ "$PROMPT_SECRET" == true ]]; then
  if [[ ! -t 0 ]]; then
    printf '%s\n' '--prompt-secret requires an interactive terminal' >&2
    exit 1
  fi
  printf 'Enter CODEX_API_KEY: ' >&2
  read -r -s CODEX_API_KEY
  printf '\n' >&2
fi

if [[ "$SET_SECRET" == true && -z "${CODEX_API_KEY:-}" ]]; then
  printf 'CODEX_API_KEY must be set when using --set-secret\n' >&2
  exit 1
fi

if [[ ${#REPOS[@]} -eq 0 ]]; then
  repo_json=$(gh repo list "$OWNER" --limit 200 --json name,isArchived,isFork)
else
  repo_json='[]'
fi

TARGET_REPOS=()

if [[ ${#REPOS[@]} -gt 0 ]]; then
  TARGET_REPOS=("${REPOS[@]}")
else
  while IFS= read -r repo_name; do
    TARGET_REPOS+=("$repo_name")
  done < <(
    printf '%s' "$repo_json" | node -e '
      const repos = JSON.parse(require("node:fs").readFileSync(0, "utf8"));
      for (const repo of repos) {
        if (repo.isArchived) continue;
        if (repo.isFork && process.argv[1] !== "true") continue;
        process.stdout.write(`${repo.name}\n`);
      }
    ' "$INCLUDE_FORKS"
  )
fi

if [[ ${#TARGET_REPOS[@]} -eq 0 ]]; then
  printf 'No target repositories found for %s\n' "$OWNER"
  exit 0
fi

printf 'Owner: %s\n' "$OWNER"
printf 'Mode: %s\n' "$([[ "$APPLY" == true ]] && printf 'apply' || printf 'dry-run')"
printf 'Create PRs: %s\n' "$CREATE_PRS"
printf 'Set CODEX_API_KEY secret: %s\n\n' "$SET_SECRET"

tmp_dir=$(mktemp -d)
cleanup() {
  rm -rf "$tmp_dir"
}
trap cleanup EXIT

for repo in "${TARGET_REPOS[@]}"; do
  full_repo="${OWNER}/${repo}"
  repo_dir="$tmp_dir/$repo"

  printf '=== %s ===\n' "$full_repo"

  default_branch=$(gh repo view "$full_repo" --json defaultBranchRef --jq '.defaultBranchRef.name')
  printf 'Default branch: %s\n' "$default_branch"

  if [[ -z "$default_branch" || "$default_branch" == "null" ]]; then
    printf 'Skipping empty repository with no default branch\n\n'
    continue
  fi

  if [[ "$APPLY" == false ]]; then
    printf '[dry-run] would clone, add %s, and %s\n\n' \
      "$WORKFLOW_PATH" \
      "$([[ "$CREATE_PRS" == true ]] && printf 'open a PR' || printf 'push branch only')"
    continue
  fi

  git clone --quiet "https://github.com/${full_repo}.git" "$repo_dir"
  mkdir -p "$repo_dir/.github/workflows"
  cp "$TEMPLATE_PATH" "$repo_dir/$WORKFLOW_PATH"

  if [[ "$SET_SECRET" == true ]]; then
    printf '%s' "$CODEX_API_KEY" | gh secret set CODEX_API_KEY --repo "$full_repo" --body -
    printf 'Secret CODEX_API_KEY updated\n'
  fi

  if [[ -z "$(git -C "$repo_dir" status --short -- "$WORKFLOW_PATH")" ]]; then
    printf 'Workflow already up to date\n\n'
    continue
  fi

  git -C "$repo_dir" checkout -B "$BRANCH_NAME" "origin/$default_branch"
  git -C "$repo_dir" config user.name "github-actions[bot]"
  git -C "$repo_dir" config user.email "github-actions[bot]@users.noreply.github.com"
  git -C "$repo_dir" add "$WORKFLOW_PATH"
  git -C "$repo_dir" commit -m "$COMMIT_MESSAGE"
  git -C "$repo_dir" push --force-with-lease origin "$BRANCH_NAME"

  if [[ "$CREATE_PRS" == true ]]; then
    if gh pr view "$BRANCH_NAME" --repo "$full_repo" >/dev/null 2>&1; then
      printf 'PR already exists for branch %s\n' "$BRANCH_NAME"
    else
      gh pr create \
        --repo "$full_repo" \
        --base "$default_branch" \
        --head "$BRANCH_NAME" \
        --title "$PR_TITLE" \
        --body "$PR_BODY"
    fi
  fi

  printf '\n'
done
