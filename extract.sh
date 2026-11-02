#!/usr/bin/env bash
# Extract readable V8 assets without installing or changing the running factory.
set -Eeuo pipefail
umask 027
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
command -v python3 >/dev/null || { echo "Python 3 is required" >&2; exit 1; }
python3 - "$ROOT/bootstrap.sh" "$ROOT/web" <<'PY'
import base64
import gzip
import hashlib
from pathlib import Path
import sys

source = Path(sys.argv[1]).read_text(encoding="utf-8").splitlines()
destination = Path(sys.argv[2])
destination.mkdir(parents=True, exist_ok=True)

assets = (
    ("TITAN_INDEX_HTML", "index.html", "7c0df55a1910635c54c9e048371351287e125378c391c567d5404e5171928536"),
    ("TITAN_STYLES_CSS", "styles.css", "6cc27b16565ff11fb3a6f71b29ffe96a4e3cd37b44369e8fcf74bbd6c20f4677"),
    ("TITAN_APP_JS", "app.js", "e30af930bc4018c2952ac9de99af92a6c0a0b5b279ed873569ab652c15714344"),
)
for marker, filename, expected in assets:
    header = f"""base64 -d <<'{marker}' | gzip -d > "$STAGE/{filename}" """
    header = header.rstrip()
    try:
        start = source.index(header) + 1
        end = source.index(marker, start)
        payload = "".join(source[start:end])
        data = gzip.decompress(base64.b64decode(payload, validate=True))
    except (ValueError, OSError, EOFError) as exc:
        raise SystemExit(f"Failed to extract {filename}: {exc}")
    digest = hashlib.sha256(data).hexdigest()
    if digest != expected:
        raise SystemExit(f"SHA-256 mismatch for {filename}: {digest}")
    target = destination / filename
    temp = destination / f".{filename}.extracting"
    temp.write_bytes(data)
    temp.replace(target)
    print(f"PASS {filename} sha256={digest}")
PY
