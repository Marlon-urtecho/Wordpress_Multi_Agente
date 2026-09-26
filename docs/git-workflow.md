# Git Workflow

Before Git actions, confirm the repository root with `git rev-parse --show-toplevel`, current branch with `git branch --show-current`, and configured remote names with `git remote`. Do not use URL-printing remote commands or expose credential-bearing remote details. Stop if repository or target identity is ambiguous.

Inspect `git status --short --branch`, `git diff --name-only`, `git diff`, and `git diff --check`; inspect the staged diff separately before a commit. Stage explicit approved paths only, never broad adds. Exclude secrets, credentials, unrelated changes, and user-owned artifacts; report sensitive findings by path and severity only.

Commit only as an explicitly approved, reviewable work unit after staged-diff review. Push requires separate explicit approval and a confirmed destination; never print credential-bearing remote values. PR creation and deployment also require explicit approval and intended-branch diff review. This readiness task creates no commit, push, PR, or deployment.