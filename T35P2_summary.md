# T35-P2 - split commutator/pressure refinement implementation and rerun charter

## Purpose
Implement the next non-circular refinement after T35-P1. The remaining obstruction is limited to pressure and commutator families, so carrier and shell stay frozen while only those two lanes are refined.

## Why this pass exists
T35-P1 showed the 11-cell obstruction is structured:
- 6 commutator-only cells: 15, 24, 25, 44, 45, 58
- 3 pressure-only cells: 30, 31, 42
- 2 dual pressure+commutator cells: 26, 47

The obstruction is mirror-paired and localized, which means a split refinement is justified. More threshold tuning would be circular.

## Locked split refinements
### Pressure lane
Replace the repaired pressure share export with a direct pressure face-variation quantity:
- pressure_face_variation = average over faces of |p(face midpoint) - p(cell midpoint)|
- err_pressure = h_cell * pressure_face_variation

Rationale: the remaining pressure-only blockers are all boundary-touching cells, so a direct local pressure reconstruction/variation quantity is a cleaner target than another residual-budget share.

### Commutator lane
Keep the repaired residual-share idea, but localize it by the ratio of shell variation to local transport scale:
- total_activity_proxy = time_derivative_proxy + convective_proxy + pressure_gradient_proxy + viscous_surrogate + 1e-12
- commutator_share = convective_proxy / total_activity_proxy
- commutator_localization_factor = shell_face_variation / (shell_face_variation + kinematic_midpoint + 1e-12)
- err_commutator = h_cell * residual_balance_gap * commutator_share * commutator_localization_factor

Rationale: T35-P1 identified a commutator-only mirror family. This refinement ties commutator burden to actual interface/localization activity instead of leaving it as a broad raw transport share.

### Frozen lanes
- err_carrier stays on the T35-A1R repair
- err_shell stays unchanged

## What this pass does
- prepares a new implementation bundle for rerun
- exports pressure_face_variation and commutator_localization_factor for audit
- preserves the Path A close route

## What this pass does not do
- does not claim theorem close
- does not claim 136/136
- does not ingest a rerun yet

## Exact next pass
T35-P3 - split-refined rerun intake and obstruction-collapse audit
