# INSTALL LAMMPS-MLIAP (11 Feb 2026) (guide to complete)
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
git clone https://github.com/lammps/lammps.git lammps_mliap_11Feb2026
cd lammps_mliap_11Feb2026
git checkout patch_11Feb2026
```


## 2  Create a virtual environment

```bash
cd $SCRATCH_FLASH/venv
module load miniforge/24.3.0-0    #Python 3.10.14
python -m venv .lammpsmace-mliap
```

Activate and install Python dependencies:

```bash
source .lammpsmace-mliap/bin/activate
pip install --upgrade pip
pip install torch==2.9.0 torchvision==0.24.0 torchaudio==2.9.0 --index-url https://download.pytorch.org/whl/cu126
pip install cuequivariance-ops-torch-cu12==0.9.1 
pip install cuequivariance-ops-cu12==0.9.1 
pip install cuequivariance==0.9.1
pip install numpy==2.1
pip install cupy-cuda12x
pip install mace-torch==0.3.15
pip install -U cython==3.2
```


## 3  Build LAMMPS

Required modules:

```bash
module purge
module use $SCRATCH_FLASH/modules
module load miniforge/24.3.0-0
module load cmake/4.1.1
module load gcc/12.4.0
module load openmpi/5.0.7_gcc12
module load openblas/0.3.30
module load cuda/12.6
```

If present: edit `cmake/presets/kokkos-cuda.cmake` and replace `PASCAL60` with `AMPERE86` (for gpu_a40) or `HOPPER90` (for gpu_h200)

If not present: add `set(Kokkos_ARCH_HOPPER90 ON CACHE BOOL "" FORCE)` 


Submit the build job:

```bash
sbatch build.sh
tail -f slurm*.out
```

Otherwise, log into a node 

```bash
srun --partition=gpu_h200 --gres=gpu:1 --pty /bin/bash
```
and follow the instruction of `build.sh`

## 4  Module file

Move the modulefile `mliap_11Feb2026` into `$SCRATCH_FLASH/modules/lammps`

> [!TIP]
> **Using the new module:**
>
> ```bash
> module purge
> module use -a $SCRATCH_FLASH/modules
> module load lammps/mliap_11Feb2026
> ```

