#!/usr/bin/env bash
# Point Pixel Launcher's repository links at your own GitHub account.
#
# Usage: scripts/set-repo.sh <github-user> [repo-name]
#   e.g. scripts/set-repo.sh miusuario PixelLauncher
#
# Run it from the repository root (Git Bash on Windows works fine).
set -euo pipefail

user="${1:?usage: scripts/set-repo.sh <github-user> [repo-name]}"
repo="${2:-PixelLauncher}"

# Repo / updater / bug tracker links
sed -i "s#FreesmTeam/FreesmLauncher#${user}/${repo}#g" \
    CMakeLists.txt \
    program_info/CMakeLists.txt \
    program_info/org.pixellauncher.PixelLauncher.metainfo.xml.in

# Placeholders in CI and Nix docs
sed -i "s#YOUR_GITHUB_USER/PixelLauncher#${user}/${repo}#g" \
    .github/workflows/update-flake.yml \
    nix/README.md

echo "Done. Repository links now point to https://github.com/${user}/${repo}"
