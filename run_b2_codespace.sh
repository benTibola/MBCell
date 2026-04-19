#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"
echo "Patching run length to first slab only [0.00,0.01]..."
python3 - <<'PY'
from pathlib import Path
p = Path('time_dependent_navier_stokes.cc')
text = p.read_text()
old = 'time(1e0, 1e-3, 1e-2, 1e-2)'
new = 'time(1e-2, 1e-3, 1e-2, 1e0)'
if old in text:
    text = text.replace(old, new)
    p.write_text(text)
PY
mkdir -p build
cd build
cmake ..
make -j2
./fluid | tee SOLVER_LOG.txt
mkdir -p B2_public_run_01_min
cp SOLVER_LOG.txt B2_public_run_01_min/
cp navierstokes.pvd B2_public_run_01_min/
cp navierstokes000000-*.vtu B2_public_run_01_min/ 2>/dev/null || true
cp navierstokes000010-*.vtu B2_public_run_01_min/ 2>/dev/null || true
printf 'Built public deal.II cylinder run for first slab [0.00,0.01].\n' > B2_public_run_01_min/RUN_METADATA.txt
cd B2_public_run_01_min
zip -r ../B2_public_run_01_min.zip .
echo
echo "DONE"
echo "Your file is: build/B2_public_run_01_min.zip"
