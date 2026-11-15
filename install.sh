#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC_DIR="${SCRIPT_DIR}/skills"

MODE="install"
DRY_RUN=0

usage() {
  cat <<'EOF'
Usage: ./install.sh [--install | --check | --uninstall] [--dry-run]

Symlink bstack skills into user-level agent skill directories:
  - ~/.claude/skills/<skill>          (Claude Code, when ~/.claude exists)
  - ~/.agents/skills/<skill>          (Codex and pi; always linked as cross-agent default)
  - ~/.gemini/config/skills/<skill>   (Antigravity / agy, when ~/.gemini exists)

Note: pi scans ~/.agents/skills/ automatically, so ~/.pi/agent/skills/ is intentionally
not linked in parallel to prevent duplicate skill entries in pi.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --install)
      MODE="install"
      shift
      ;;
    --check)
      MODE="check"
      shift
      ;;
    --uninstall)
      MODE="uninstall"
      shift
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [[ ! -d "${SKILLS_SRC_DIR}" ]]; then
  echo "Error: skills directory not found at ${SKILLS_SRC_DIR}" >&2
  exit 1
fi

TARGET_ROOTS=()
if [[ -d "${HOME}/.claude" ]]; then
  TARGET_ROOTS+=("${HOME}/.claude/skills")
fi
TARGET_ROOTS+=("${HOME}/.agents/skills")
if [[ -d "${HOME}/.gemini" ]]; then
  TARGET_ROOTS+=("${HOME}/.gemini/config/skills")
fi

run_cmd() {
  if [[ "${DRY_RUN}" -eq 1 ]]; then
    echo "[dry-run] $*"
  else
    "$@"
  fi
}

STATUS_ERRORS=0

for skill_path in "${SKILLS_SRC_DIR}"/*; do
  [[ -d "${skill_path}" ]] || continue
  skill_name="$(basename "${skill_path}")"

  if [[ "${MODE}" == "install" || "${MODE}" == "check" ]]; then
    if [[ -e "${HOME}/.pi/agent/skills/${skill_name}" || -L "${HOME}/.pi/agent/skills/${skill_name}" ]]; then
      echo "[warn] ${HOME}/.pi/agent/skills/${skill_name} also exists; pi scans ~/.agents/skills/ too, which may list ${skill_name} twice."
    fi
  fi

  for target_root in "${TARGET_ROOTS[@]}"; do
    dest="${target_root}/${skill_name}"

    case "${MODE}" in
      install)
        if [[ -L "${dest}" ]]; then
          current_target="$(readlink "${dest}")"
          if [[ "${current_target}" == "${skill_path}" ]]; then
            echo "[ok] ${dest} -> ${skill_path}"
          else
            echo "[error] ${dest} points to ${current_target} (expected ${skill_path}); refusing to overwrite." >&2
            STATUS_ERRORS=$((STATUS_ERRORS + 1))
          fi
        elif [[ -e "${dest}" ]]; then
          echo "[error] ${dest} exists and is not a symlink; refusing to overwrite." >&2
          STATUS_ERRORS=$((STATUS_ERRORS + 1))
        else
          run_cmd mkdir -p "${target_root}"
          run_cmd ln -s "${skill_path}" "${dest}"
          echo "[linked] ${dest} -> ${skill_path}"
        fi
        ;;
      check)
        if [[ -L "${dest}" ]]; then
          current_target="$(readlink "${dest}")"
          if [[ "${current_target}" == "${skill_path}" ]]; then
            echo "[ok] ${dest} -> ${skill_path}"
          else
            echo "[mismatch] ${dest} -> ${current_target} (expected ${skill_path})" >&2
            STATUS_ERRORS=$((STATUS_ERRORS + 1))
          fi
        elif [[ -e "${dest}" ]]; then
          echo "[conflict] ${dest} exists and is not a symlink" >&2
          STATUS_ERRORS=$((STATUS_ERRORS + 1))
        else
          echo "[missing] ${dest}" >&2
          STATUS_ERRORS=$((STATUS_ERRORS + 1))
        fi
        ;;
      uninstall)
        if [[ -L "${dest}" ]]; then
          current_target="$(readlink "${dest}")"
          if [[ "${current_target}" == "${skill_path}" ]]; then
            run_cmd rm "${dest}"
            echo "[removed] ${dest}"
          else
            echo "[skip] ${dest} points to ${current_target}, not managed by ${SCRIPT_DIR}"
          fi
        elif [[ -e "${dest}" ]]; then
          echo "[skip] ${dest} is not a symlink; leaving untouched"
        else
          echo "[ok] ${dest} already absent"
        fi
        ;;
    esac
  done
done

if [[ "${STATUS_ERRORS}" -gt 0 ]]; then
  exit 1
fi
