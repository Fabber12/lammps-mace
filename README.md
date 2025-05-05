# lammps-mace
GPU installation of LAMMPS-MACE using module environement in HPC.
This guide is based on CINECA cluster architectures.

Create an installation folder and enter it `mkdir -p $HOME/programs/LAMMPS-MACE && cd $HOME/programs/LAMMPS-MACE`.

Clone the repository for LAMMPS MACE `git clone --branch=mace --depth=1 https://github.com/ACEsuit/lammps`.

Download LibTorch compatible with cuda 12.1 `wget https://download.pytorch.org/libtorch/cu121/libtorch-shared-with-deps-2.2.0%2Bcu121.zip`.

Extract all and remove the source .zip file `unzip libtorch-shared-with-deps-2.2.0+cu121.zip`; `rm libtorch-shared-with-deps-2.2.0+cu121.zip`; `mv libtorch libtorch-gpu`.

Submit a batch script for automatise the installation `sbatch build-mace.sh`
