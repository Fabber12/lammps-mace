# INSTALL LAMMPS-MLIAP (stable 29 Aug 2024)
<div align="right">
  by PDA
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
> This guide is based on the **Leonardo @ CINECA** HPC cluster.


## 1  Clone the LAMMPS repository

```bash
cd $PUBLIC
mkdir -p programs/lammps
cd programs/lammps
````

```bash
git clone https://github.com/lammps/lammps.git lammps_stable_29Aug2024_update3
cd lammps_stable_29Aug2024_update3
git checkout stable_29Aug2024_update3
```

> \[!WARNING]
> The `git checkout` step is crucial to select the correct development point.
> Verify with:
>
> ```bash
> git log -1
> # commit 81980666de9ec2b1694e82a9b55d28ec29e8db07 (HEAD, > # tag: stable_29Aug2024_update3, origin/stable)
> # Merge: 0435e156ba 7d4757e745
> # Author: Axel Kohlmeyer <akohlmey@gmail.com>
> # Date:   Thu Jun 12 23:06:51 2025 -0400
> #
> #    Merge pull request #4531 from lammps/maintenance
> #
> #    Third Set of Collected Bug Fixes and Maintenance Updates for 29 August 2024 Stable Release
> ```


## 2  Create a virtual environment

```bash
mkdir build
cd build
module load python/3.11.6--gcc--8.5.0
python -m venv .lammps-mliap
```

Activate and install Python dependencies:

```bash
source .lammps-mliap/bin/activate
pip install torch==2.5.0 torchvision==0.20.0 torchaudio==2.5.0 \
            --index-url https://download.pytorch.org/whl/cu121
pip install cuequivariance-ops-cu12==0.4.0   # resolves dependency issues with torch 2.5.0
pip install cuequivariance-ops-torch-cu12==0.4.0 # resolves dependency issues with torch 2.5.0
pip install numpy==2.1
pip install cupy-cuda12x
pip install -U cython==3.0.11                # fixes LAMMPS MLIAP issue #1014 https://github.com/ACEsuit/mace/discussions/1014
```


## 3  Build LAMMPS

Load the required modules:

```bash
module purge
module load profile/chem-phys
module load python/3.11.6--gcc--8.5.0
module load gcc/12.2.0
module load gsl/2.7.1--gcc--12.2.0
module load openmpi/4.1.6--gcc--12.2.0
module load fftw/3.3.10--openmpi--4.1.6--gcc--12.2.0
module load openblas/0.3.24--gcc--12.2.0
module load cuda/12.1
module load intel-oneapi-mkl/2023.2.0
module load plumed/2.8.1--openmpi--4.1.6--gcc--12.2.0
```

Fetch the CMake configuration and Slurm build script:

```bash
# CMake config file
wget https://raw.githubusercontent.com/paolodeangelis/lammps-mace/refs/heads/main/hpc/leonardo@cineca/lammps_mliap_29Aug2024_update3/config.make
# Slurm build script
wget https://raw.githubusercontent.com/paolodeangelis/lammps-mace/refs/heads/main/hpc/leonardo@cineca/lammps_mliap_29Aug2024_update3/build.sh
```

Submit the build job:

```bash
sbatch build.sh
tail -f slurm*.out
```


## 4  Create a module file

```bash
cd $PUBLIC
mkdir -p modules/lammps
cd modules/lammps
```

Download the module file and replace the `<PATH_TO_LAMMPS_REPO>` placeholder with the actual path:

```bash
wget https://raw.githubusercontent.com/paolodeangelis/lammps-mace/refs/heads/main/hpc/leonardo@cineca/lammps_mliap_29Aug2024_update3/module/stable_29Aug2024_update3
```

> [!TIP]
> **Using the new module:**
>
> ```bash
> module purge
> module use -a $PUBLIC/modules
> module load profile/chem-phys
> module load lammps/stable_29Aug2024_update3
> ```

