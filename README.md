# LAMMPS-MACE
### GPU installation of LAMMPS-MACE using Environment Modules in HPC.
###### This guide is based on CINECA cluster architectures.

Create an installation folder and enter it `mkdir -p $HOME/programs/LAMMPS-MACE && cd $HOME/programs/LAMMPS-MACE`.

Clone the repository for LAMMPS MACE `git clone --branch=mace --depth=1 https://github.com/ACEsuit/lammps`.

Download LibTorch compatible with cuda 12.1 `wget https://download.pytorch.org/libtorch/cu121/libtorch-shared-with-deps-2.2.0%2Bcu121.zip`.

Extract all and remove the source .zip file `unzip libtorch-shared-with-deps-2.2.0+cu121.zip`; `rm libtorch-shared-with-deps-2.2.0+cu121.zip`; `mv libtorch libtorch-gpu`.

Submit a batch script for automatise the installation `sbatch build-mace.sh`


## LAMMPS-MACE with ML-IAP interface

### Prerequisites
```bash
module load python/3.11.6--gcc--8.5.0 cuda/12.1
```

### Virtual Environment
```bash
mkdir -p $HOME/venvs
cd $HOME/venvs
python -m venv .lammps-mliap
source $HOME/venvs/.lammps-mliap/bin/activate
pip install --upgrade pip
```

### Dependencies
```bash
pip install torch==2.5.0 torchvision==0.20.0 torchaudio==2.5.0 --index-url https://download.pytorch.org/whl/cu121
pip install cuequivariance-ops-torch-cu12
pip install cuequivariance-torch
pip install numpy==2.1
pip install cupy-cuda12x
pip install -U cython
pip install mace-torch
```

### Clone and Configure LAMMPS
```bash
cd $HOME/programs
git clone https://github.com/lammps/lammps.git
mv lammps LAMMPS-MACE_MLIAP
cd LAMMPS-MACE_MLIAP
```
Edit `cmake/presets/kokkos-cuda.cmake` and replace `PASCAL60` with `AMPERE80`.

### Run `build-mace_mliap.sh` script to compile
```bash
sbatch build-mace_mliap.sh
```

### Build and Install Python Interface
```bash
cd $HOME/programs/LAMMPS-MACE_MLIAP/build-mliap
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

source $HOME/venvs/.lammps-mliap/bin/activate
make install-python
```

### Create a modulefile
Move `lammps-mliap_modulefile` in the modulefile folder (I created this directory in `$HOME/modules`)
```bash
mv lammps-mliap_modulefile $HOME/modules/.
```

### If you want to use your module, remember to import it before using it
```bash
module use $HOME/modules
```

# PyTorch-MACE
### Installation of the machine learning software 

Choose a MACE installation path `MACEpath=/up/to/you`.

Change directory `cd $(MACEpath)`.

Create a virtual environment `python3 -m venv .mace_env`.

Load Cuda 12.6 `module load cuda/12.6`.

Clone MACE repository `git clone https://github.com/ACEsuit/mace.git`.

Install MACE via pip `pip install ./mace`.


### Conversion of MACE models to be compatible with lammps

Activate the virtual environment `source MACEpath/.mace_env/bin/activate`

Load Cuda 12.6 `module load cuda/12.6`.

Convert the model `python3 MACEpath/mace/cli/create_lammps_model.py /path/to/model/X.model`, you will obtain a Y.pt file to use with LAMMPS-MACE. See `example.in` for a simple LAMMPS-MACE input file.
