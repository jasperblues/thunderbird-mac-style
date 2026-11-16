#!/usr/bin/env bash
# Install thunderbird-mac-style into a Thunderbird profile.
#
#   ./install.sh                 the default profile
#   ./install.sh <profile-dir>   a specific profile
#
# Thunderbird must be closed: it rewrites xulstore.json when it quits.
# Existing files are backed up with a .bak-<timestamp> suffix.
set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"

find_default_profile() {
    local root
    for root in "$HOME/.thunderbird" \
                "$HOME/.config/thunderbird" \
                "$HOME/.var/app/org.mozilla.Thunderbird/.thunderbird" \
                "$HOME/.var/app/net.thunderbird.Thunderbird/.thunderbird" \
                "$HOME/Library/Thunderbird"; do
        [[ -f "$root/profiles.ini" ]] || continue
        # The profile this installation uses, else the one marked Default=1
        local path
        path=$(awk -F= '/^\[Install/{s=1} s && /^Default=/{print $2; exit}' \
            "$root/installs.ini" 2>/dev/null || true)
        if [[ -z "$path" ]]; then
            path=$(awk -F= '/^\[Profile/{p=""} /^Path=/{p=$2} /^Default=1/{print p; exit}' \
                "$root/profiles.ini")
        fi
        if [[ -n "$path" ]]; then
            [[ "$path" = /* ]] && echo "$path" || echo "$root/$path"
            return
        fi
    done
}

profile="${1:-$(find_default_profile)}"
if [[ -z "$profile" || ! -d "$profile" ]]; then
    echo "No Thunderbird profile found. Pass its folder: $0 <profile-dir>" >&2
    echo "(Thunderbird shows it under Help → Troubleshooting Information.)" >&2
    exit 1
fi
# Thunderbird keeps a lock symlink in a profile while it has it open
if [[ -L "$profile/lock" ]]; then
    echo "Please quit Thunderbird first (this profile is in use)." >&2
    exit 1
fi

echo "Installing into $profile"
stamp=$(date +%Y%m%d-%H%M%S)
backup() { [[ -e "$1" ]] && cp -p "$1" "$1.bak-$stamp" || true; }

mkdir -p "$profile/chrome"
for f in userChrome.css userContent.css; do
    backup "$profile/chrome/$f"
    cp "$here/chrome/$f" "$profile/chrome/$f"
done

# user.js: replace our block, keep anything else that's there
backup "$profile/user.js"
python3 - "$profile/user.js" "$here/user.js" <<'EOF'
import os, re, sys
target, ours = sys.argv[1], open(sys.argv[2]).read().strip()
begin, end = "// >>> thunderbird-mac-style", "// <<< thunderbird-mac-style"
text = open(target).read() if os.path.exists(target) else ""
text = re.sub(re.escape(begin) + r".*?" + re.escape(end) + r"\n?", "", text, flags=re.S)
block = f"{begin}\n{ours}\n{end}\n"
open(target, "w").write((text.rstrip() + "\n\n" if text.strip() else "") + block)
EOF

# xulstore.json: the toolbar buttons and the message header layout
backup "$profile/xulstore.json"
python3 - "$profile/xulstore.json" <<'EOF'
import json, os, sys
path = sys.argv[1]
store = json.load(open(path)) if os.path.exists(path) else {}
doc = store.setdefault("chrome://messenger/content/messenger.xhtml", {})
items = ["write-message", "get-messages", "spacer", "search-bar", "spacer",
         "archive", "delete"]
doc.setdefault("unifiedToolbar", {})["state"] = json.dumps(
    {"mail": items, "default": items})
doc.setdefault("messageHeader", {})["layout"] = json.dumps({
    "showAvatar": True, "showBigAvatar": True, "showFullAddress": False,
    "hideLabels": True, "subjectLarge": True, "buttonStyle": "only-icons"})
json.dump(store, open(path, "w"))
EOF

echo "Done. Start Thunderbird to see it."
