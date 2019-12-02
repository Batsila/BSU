mkdir .\docking_results
for /r ligands %%i in (*.pdbqt) do (
mkdir .\docking_results\"%%~ni"
start .\vina.exe
.\vina.exe --config gp120_docking.config --ligand %%i --out .\docking_results\%%~ni\%%~ni.pdbqt
)
pause