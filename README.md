## LAMMPS-MACE
### GPU Installation with Environment Modules
###### Based on CINECA cluster architectures

### Setup Directory
```bash
mkdir -p $HOME/programs/LAMMPS-MACE && cd $HOME/programs/LAMMPS-MACE
```

### Clone Repository
```bash
git clone --branch=mace --depth=1 https://github.com/ACEsuit/lammps
```

### Download LibTorch
```bash
wget https://download.pytorch.org/libtorch/cu121/libtorch-shared-with-deps-2.2.0%2Bcu121.zip
```

### Extract and Rename
```bash
unzip libtorch-shared-with-deps-2.2.0+cu121.zip
rm libtorch-shared-with-deps-2.2.0+cu121.zip
mv libtorch libtorch-gpu
```

### Build
```bash
sbatch build-mace.sh
```

##

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
An example of how to submit a job to run a simple simulation is provided in ML-IAP_water_benchmark
##

## PyTorch-MACE
### Installation of the machine learning software

### Set installation path
```bash
MACEpath=/up/to/you
```

### Virtual environment
```bash
cd $MACEpath
python3 -m venv .mace_env
source $MACEpath/.mace_env/bin/activate
```

### Load CUDA
```bash
module load cuda/12.6
```

### Clone repository
```bash
git clone https://github.com/ACEsuit/mace.git
```

### Install via pip
```bash
pip install ./mace
```

### Conversion of MACE models to be compatible with lammps
```bash
source $MACEpath/.mace_env/bin/activate
module load cuda/12.6
python3 $MACEpath/mace/cli/create_lammps_model.py /path/to/model/X.model
```
You will obtain `.pt` (potential) file to use with LAMMPS-MACE. See `example.in` for a simple simulation input file.
