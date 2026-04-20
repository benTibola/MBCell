#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"

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

rm -rf build
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
cp TIME_STEP_TABLE.csv B2_public_run_01_min/ 2>/dev/null || true
cp INCREMENT_NORMS.csv B2_public_run_01_min/ 2>/dev/null || true
cp RHS_NORMS.csv B2_public_run_01_min/ 2>/dev/null || true
cp KELLY_INDICATOR_step*.csv B2_public_run_01_min/ 2>/dev/null || true
cp PROVISIONAL_ERROR_ENVELOPE_step*.csv B2_public_run_01_min/ 2>/dev/null || true
printf 'Built public deal.II cylinder run for first slab [0.00,0.01].\n' > B2_public_run_01_min/RUN_METADATA.txt

python3 - <<'PY'
from pathlib import Path
import zipfile
root = Path('B2_public_run_01_min')
out = Path('B2_public_run_01_min.zip')
with zipfile.ZipFile(out, 'w', zipfile.ZIP_DEFLATED) as zf:
    for p in root.rglob('*'):
        if p.is_file():
            zf.write(p, p.relative_to(root))
print(f'Created {out}')
PY

echo
echo "DONE"
echo "Your file is: build/B2_public_run_01_min.zip"
