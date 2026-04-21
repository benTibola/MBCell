T35-P2 bundle contents
- time_dependent_navier_stokes.cc : split refinement implementation
- run_b2_codespace.sh : rerun script with updated metadata
- T35_P2_split_refinement.diff : unified diff from T35-A1R source
- T35P2_summary.md : rationale and locked formulas
- T35P1_obstruction_anatomy.csv : prior obstruction anatomy input
- T35P1_family_summary.csv : prior obstruction family summary
- manifest.txt : file list

How to use
1. Replace the repo-root time_dependent_navier_stokes.cc and run_b2_codespace.sh with the versions in this bundle.
2. Run: bash run_b2_codespace.sh
3. Upload build/B2_public_run_01_min.zip here.

Success condition for next pass
The rerun zip should include:
- C1_CERTIFIED_ERROR_COMPONENTS_step*.csv
- KELLY_PRESSURESHELLKINRESREF2_LOCAL_ENVELOPE_PROXY_step*.csv
- KELLY_INDICATOR_step*.csv
- TIME_STEP_TABLE.csv
- INCREMENT_NORMS.csv
- RHS_NORMS.csv
