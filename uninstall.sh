#!/usr/bin/env bash
# Remove thunderbird-mac-style from a Thunderbird profile.
#
#   ./uninstall.sh                 the default profile
#   ./uninstall.sh <profile-dir>   a specific profile
#
# Deletes the two stylesheets and the user.js block this project added.
# The toolbar and header layout stay; change them in Thunderbird
# (right-click the toolbar → Customize; message header → More → Customize).
set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
# Reuse the profile lookup from install.sh
eval "$(sed -n '/^find_default_profile()/,/^}/p' "$here/install.sh")"

profile="${1:-$(find_default_profile)}"
if [[ -z "$profile" || ! -d "$profile" ]]; then
    echo "No Thunderbird profile found. Pass its folder: $0 <profile-dir>" >&2
    exit 1
fi
# Thunderbird keeps a lock symlink in a profile while it has it open
if [[ -L "$profile/lock" ]]; then
    echo "Please quit Thunderbird first (this profile is in use)." >&2
    exit 1
fi

rm -f "$profile/chrome/userChrome.css" "$profile/chrome/userContent.css"
if [[ -f "$profile/user.js" ]]; then
    python3 - "$profile/user.js" <<'EOF'
import re, sys
path = sys.argv[1]
begin, end = "// >>> thunderbird-mac-style", "// <<< thunderbird-mac-style"
text = open(path).read()
text = re.sub(re.escape(begin) + r".*?" + re.escape(end) + r"\n?", "", text, flags=re.S)
open(path, "w").write(text)
EOF
fi
echo "Removed from $profile. Prefs that user.js set stay as they are in"
echo "Thunderbird's settings until you change them."
