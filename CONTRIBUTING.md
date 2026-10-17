# Contributing

Thanks for helping improve AI-DLC.

## Principles for changes
1. **One agent, one stage.** An agent has a single clear responsibility, defined inputs, written outputs under
   `aidlc-docs/`, and a short return summary.
2. **Evidence over opinion.** Gates and reviews cite command output or `file:line`. Nothing passes without evidence.
3. **Never weaken quality to go faster.** Thresholds change only through an ADR and a user approval.
4. **Token-lean.** Agents read `context.min.md` first and pass file paths, not pasted documents.
5. **Standards-backed.** When you add a check, cite the standard or practice it comes from.

## How to contribute
- **New stack tooling**: add a row to the tooling table in `skills/aidlc/references/quality-gates.md`.
- **New pattern**: add it to `patterns.md` with *use when | avoid when*, under the right usage section.
- **New agent**: add `agents/aidlc-<name>.md` with frontmatter (`name`, `description`, `tools`), wire it into the
  lifecycle table in `SKILL.md` and the routing table in `aidlc-orchestrator.md`, and list it in the README.
- Update `CHANGELOG.md` and bump the version in `.claude-plugin/plugin.json` and `marketplace.json`.

## Testing a change
Install locally (`./install.sh` or `install.ps1`), restart Claude Code, and run `/aidlc` on a small sample
project at `spike` depth. Describe in your PR what you ran and what changed.
