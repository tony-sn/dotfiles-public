# Contribution Flow

How this fork stays in sync with [craftzdog/dotfiles-public](https://github.com/craftzdog/dotfiles-public) while keeping local customizations out of PRs.

## Remotes

- `origin` → my fork (`tony-sn/dotfiles-public`)
- `upstream` → Takuya's repo (`craftzdog/dotfiles-public`)

## Sync with Takuya

```bash
git fetch upstream
git rebase upstream/master
git push
```

Local customizations live in `mine(*)` commits on top of `upstream/master`.
Rebase keeps history clean — conflicts only happen when Takuya touches the
same lines I changed.

## Clean PR to craftzdog

Branch from **his** master, not mine:

```bash
git checkout -b fix/something upstream/master
# ...make the change, commit...
git push origin fix/something
gh pr create --repo craftzdog/dotfiles-public
```

Because PR branches start from `upstream/master`, they contain only the fix —
never my `mine:*` commits or local configs.

## What stays local (never committed, never in PRs)

| What | Where | Mechanism |
|------|-------|-----------|
| Identity, credentials, ghq root, URL rewrites | `~/.gitconfig.private` | included by tracked `.gitconfig`, untracked itself |
| Delta theme tweaks | `~/.config/git/delta.gitconfig` | symlink to tracked file |
| Secrets (API keys, tokens) | `.config/fish/config-local.fish` | gitignored by Takuya's design, `chmod 600` |
| Fish completions/conf.d/functions, `fish_variables` | `.config/fish/...` | gitignored by Takuya's `.gitignore` |
| Machine-local files (e.g. `fish_plugins`) | repo paths | `.git/info/exclude` — local-only ignore, never pushed |

Rule of thumb: use these extension points **before** editing any tracked file.

## Side note: stash audit (2026-03)

Before adopting this flow, local changes lived in a `git stash` for months.
When it was applied and reconciled, only 3 files differed from the stash — all
intentional:

| File | Why it differs | Safe? |
|------|---------------|-------|
| `.gitconfig` | Resolved to Takuya's version; identity/credentials moved to `~/.gitconfig.private` | ✅ by design |
| `config-linux.fish` | Secrets block moved to `config-local.fish` (verified still loading) | ✅ by design |
| `completions/openclaw.fish` | Stash held an old 1-line symlink stub; disk has the full generated completion (3,813 lines) — disk is newer, and it's an auto-generated ignored file anyway | ✅ disk wins |

The other 63 stash files were byte-identical to disk (committed as `mine(*)`
commits or kept as ignored local files), so the stash was dropped. Lesson:
**prefer `mine(*)` commits over stashes** — commits survive rebases and syncs;
stashes are easy to forget.
