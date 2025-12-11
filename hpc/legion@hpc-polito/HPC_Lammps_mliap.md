# INSTALL LAMMPS-MLIAP (stable 22 Jul 2025)
<div align="right">
  by FT
</div>

> [!NOTE]  
> This will install **LAMMPS** with the following settings  
>
> **ACCELERATORS:**  
> &nbsp;&nbsp;&nbsp;&nbsp;OPT, OpenMP, Kokkos, GPU  
>
> **PACKAGES:**  
> &nbsp;&nbsp;&nbsp;&nbsp;ATC OPENMP KSPACE MANYBODY MOLECULE RIGID PLUMED DIELECTRIC DIPOLE ELECTRODE  
> &nbsp;&nbsp;&nbsp;&nbsp;MC MEAM MOLFILE OPT QEQ REACTION REAXFF REPLICA PYTHON ML-IAP ML-MACE ML-SNAP  
> &nbsp;&nbsp;&nbsp;&nbsp;EXTRA-COMPUTE EXTRA-DUMP EXTRA-FIX EXTRA-MOLECULE EXTRA-PAIR

> [!IMPORTANT]  
> This guide is based on the **Legion @ POLITO** HPC cluster.


## 1  Clone the LAMMPS repository

```bash
mkdir -p $HOME/programs
cd $HOME/programs
````

```bash
git clone https://github.com/lammps/lammps.git lammps_mliap_22Jul2025
cd lammps_mliap_22Jul2025
git checkout stable_22Jul2025_update2
```


## 2  Create a virtual environment

```bash
cd $HOME/venv
module load miniforge/24.3.0-0
python -m venv .lammpsmace-mliap
```

Activate and install Python dependencies:

```bash
source .lammpsmace-mliap/bin/activate
pip install --upgrade pip
pip install torch==2.5.0 torchvision==0.20.0 torchaudio==2.5.0 \
            --index-url https://download.pytorch.org/whl/cu121
pip install cuequivariance-ops-cu12==0.4.0   # resolves dependency issues with torch 2.5.0  # resolves dependency issues with torch 2.5.0
pip install cuequivariance-ops-torch-cu12==0.4.0 # resolves dependency issues with torch 2.5.0
pip install numpy==2.1
pip install cupy-cuda12x
pip install mace-torch
pip install -U cython==3.0.11                # fixes LAMMPS MLIAP issue #1014 https://github.com/ACEsuit/mace/discussions/1014
```


## 3  Build LAMMPS

Load the required modules:

```bash
module purge
module use $HOME/modules
module load miniforge/24.3.0-0
module load cmake/4.1.1
module load gcc/12.4.0
module load openmpi/5.0.7_gcc12
module load openblas/0.3.30
module load cuda/12.1
```

If present: edit `cmake/presets/kokkos-cuda.cmake` and replace `PASCAL60` with `AMPERE86` (for gpu_a40)

If not present: add `set(Kokkos_ARCH_AMPERE86 ON CACHE BOOL "" FORCE)` 


Submit the build job:

```bash
sbatch build.sh
tail -f slurm*.out
```

Otherwise, log into a node 

```bash
srun --partition=gpu_a40 --gres=gpu:1 --pty /bin/bash
```
and follow the instruction of `build.sh`

## 4  Module file

Move the modulefile `mliap_22Jul2025` into `$HOME/modules/lammps`

> [!TIP]
> **Using the new module:**
>
> ```bash
> module purge
> module use -a $HOME/modules
> module load lammps/mliap_22Jul2025
> ```

