# shellcheck shell=bash
# shellcheck disable=SC2154
IFS=' ' read -ra wrappers <<<"$WRAPPER_NAMES"
for wrapper in "${wrappers[@]}"; do
  path="$(command -v "$wrapper")"
  if [ ! -x "$path" ]; then
    echo "FAIL: $wrapper is not executable" >&2
    exit 1
  fi
  bash -n "$path"
  echo "OK: $wrapper"
done
mkdir -p "$out"
touch "$out/success"
