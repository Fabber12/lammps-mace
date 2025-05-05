# LAMMPS-MACE
### GPU installation of LAMMPS-MACE using Environment Modules in HPC.
###### This guide is based on CINECA cluster architectures.

Create an installation folder and enter it `mkdir -p $HOME/programs/LAMMPS-MACE && cd $HOME/programs/LAMMPS-MACE`.

Clone the repository for LAMMPS MACE `git clone --branch=mace --depth=1 https://github.com/ACEsuit/lammps`.

Download LibTorch compatible with cuda 12.1 `wget https://download.pytorch.org/libtorch/cu121/libtorch-shared-with-deps-2.2.0%2Bcu121.zip`.

Extract all and remove the source .zip file `unzip libtorch-shared-with-deps-2.2.0+cu121.zip`; `rm libtorch-shared-with-deps-2.2.0+cu121.zip`; `mv libtorch libtorch-gpu`.

Submit a batch script for automatise the installation `sbatch build-mace.sh`


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

Convert the model `python3 MACEpath/mace/cli/create_lammps_model.py /path/to/model/X.model`, you will obtain a Y.pt file to use with LAMMPS-MACE
