# Browse and restore archived Claude Code sessions.
# Archives live at ~/.claude/archived-sessions/<escaped-cwd>/<session-id>.jsonl
# Each archive has a sidecar <session-id>.meta.json with title + origin cwd.
# Written by the SessionEnd hook in ~/.claude/settings.json.

claude-archive() {
  local archive_root="$HOME/.claude/archived-sessions"
  local projects_root="$HOME/.claude/projects"
  local archive_bin="$HOME/.claude/bin/archive-session.py"
  local cmd="${1:-help}"
  [ $# -gt 0 ] && shift

  case "$cmd" in
    list|ls)
      if [ ! -d "$archive_root" ]; then
        echo "No archives yet at $archive_root"
        return 0
      fi
      "$archive_bin" list
      ;;

    search|grep)
      local term="$1"
      if [ -z "$term" ]; then echo "Usage: claude-archive search <term>"; return 1; fi
      "$archive_bin" search "$term"
      ;;

    view|show|cat)
      local id="$1"
      if [ -z "$id" ]; then echo "Usage: claude-archive view <session-id-or-prefix>"; return 1; fi
      local afile
      afile=$(find "$archive_root" -type f -name "${id}*.jsonl" | head -1)
      if [ -z "$afile" ]; then echo "Not found: $id"; return 1; fi
      /usr/bin/python3 - "$afile" <<'PY' | ${PAGER:-less -R}
import json, sys
for line in open(sys.argv[1]):
    try: d = json.loads(line)
    except Exception: continue
    t = d.get("type")
    if t not in ("user", "assistant"): continue
    msg = d.get("message", {})
    role = msg.get("role", t)
    content = msg.get("content", "")
    if isinstance(content, list):
        parts = []
        for c in content:
            if not isinstance(c, dict): continue
            if c.get("type") == "text":
                parts.append(c.get("text", ""))
            elif c.get("type") == "tool_use":
                parts.append(f"[tool_use: {c.get('name','?')}]")
            elif c.get("type") == "tool_result":
                parts.append("[tool_result]")
        content = "\n".join(p for p in parts if p)
    print(f"\n===== {role.upper()} =====\n{content}")
PY
      ;;

    info)
      local id="$1"
      if [ -z "$id" ]; then echo "Usage: claude-archive info <session-id-or-prefix>"; return 1; fi
      local afile
      afile=$(find "$archive_root" -type f -name "${id}*.jsonl" | head -1)
      if [ -z "$afile" ]; then echo "Not found: $id"; return 1; fi
      local sid meta_path
      sid=$(basename "$afile" .jsonl)
      meta_path="$(dirname "$afile")/${sid}.meta.json"
      [ -f "$meta_path" ] && cat "$meta_path" || echo "No meta for $sid"
      ;;

    path)
      local id="$1"
      if [ -z "$id" ]; then echo "Usage: claude-archive path <session-id-or-prefix>"; return 1; fi
      find "$archive_root" -type f -name "${id}*.jsonl" | head -1
      ;;

    restore)
      local id="$1"
      if [ -z "$id" ]; then echo "Usage: claude-archive restore <session-id-or-prefix>"; return 1; fi
      local src
      src=$(find "$archive_root" -type f -name "${id}*.jsonl" | head -1)
      if [ -z "$src" ]; then echo "Not found: $id"; return 1; fi
      local full_sid
      full_sid=$(basename "$src" .jsonl)
      # Claude escapes cwd by replacing '/' and '.' with '-'.
      local cwd_escaped
      cwd_escaped=$(pwd | sed 's|[/.]|-|g')
      local dest="$projects_root/$cwd_escaped"
      mkdir -p "$dest"
      cp -p "$src" "$dest/${full_sid}.jsonl"
      echo "Restored: $dest/${full_sid}.jsonl"
      echo "Run 'claude --resume' here to pick it up."
      ;;

    reindex)
      # Regenerate meta sidecars for all archived transcripts.
      local count=0
      local jsonl
      while IFS= read -r jsonl; do
        "$archive_bin" --reindex "$jsonl"
        count=$((count+1))
      done < <(find "$archive_root" -type f -name '*.jsonl')
      echo "Reindexed $count archives."
      ;;

    help|-h|--help|'')
      cat <<'EOF'
Usage: claude-archive <command> [args]

  list              List archived sessions, newest first
  search <term>     Find archives whose transcript contains <term>
  view <id>         Pretty-print a session (user/assistant turns only)
  info <id>         Show the full meta sidecar for a session
  path <id>         Print the archive file path for a session id
  restore <id>      Copy archive into current dir's project folder so
                    `claude --resume` in this directory can resume it
  reindex           Regenerate title/meta sidecars for all archives

IDs can be full UUIDs or unique prefixes.
EOF
      ;;

    *)
      echo "Unknown command: $cmd (try 'claude-archive help')" >&2
      return 1
      ;;
  esac
}
