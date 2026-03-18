# GitHub Copilot Coding Agent Permissions

This document describes the permissions available to the GitHub Copilot coding agent when working in this repository.

## Read Permissions

The agent can read the following GitHub resources:

| Resource | Details |
| --- | --- |
| Repository contents | Files, directories, and commit history in the current repository |
| Issues | Issue titles, descriptions, comments, labels, and sub-issues |
| Pull requests | PR details, diffs, file changes, reviews, review comments, and check run statuses |
| Workflows & CI | Workflow definitions, run history, job logs, and artifacts |
| Code scanning alerts | CodeQL and other code scanning tool results |
| Secret scanning alerts | Secret scanning alert details and resolutions |
| Commits, branches & tags | Full commit metadata, branch listings, tag listings, and releases |
| Labels | Label names, colors, and descriptions |
| Repository metadata | Description, topics, language, stars, and other public repository info |

## Write Permissions

The agent can make the following changes:

| Resource | Details |
| --- | --- |
| Repository files | Commit and push file changes to the current working branch via the `report_progress` tool |
| Pull request description | Update the description of the open PR it is working on |

## Limitations

The agent operates under the following restrictions:

- **Cannot open new pull requests** — the agent may only update the PR it was assigned to.
- **Cannot push directly via `git`** — all code pushes go through the `report_progress` tool, which stages, commits, and pushes changes.
- **Cannot access other repositories** — the agent only has access to the single repository that was cloned for its current task.
- **Cannot access secrets or credentials** — API tokens, passwords, and other secrets are not directly accessible.
- **Cannot access `.github/agents/`** — agent instruction files in this directory are off-limits.
- **Cannot push to other branches** — the agent works exclusively on the branch associated with its PR.
- **Cannot generate harmful or copyrighted content** — content policies apply regardless of task instructions.
