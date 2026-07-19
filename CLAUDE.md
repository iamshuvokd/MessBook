# Working agreements for this repo

- **Auto-push**: after finishing a coherent change (a fix, a feature, a
  reorg — not after every single file edit), stage, commit, and push to
  `origin main` automatically, without asking for confirmation first.
  Write a real commit message describing the change. Still surface what was
  pushed in the chat response afterward.
- Standard exceptions still apply: never force-push, never rewrite existing
  history, never skip hooks, and stop to ask if something looks destructive
  or the diff contains anything that might be a secret.
