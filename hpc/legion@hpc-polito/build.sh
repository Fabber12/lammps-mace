#!/bin/bash
#SBATCH --job-name=mliap
#SBATCH --mail-type=None
#SBATCH --partition=gpu_a40
#SBATCH --time=02:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --gres=gpu:1
#SBATCH --output=slurm-%j.out
#SBATCH --mem=32G

cd $HOME/programs/lammps_mliap_22Jul2025
mkdir -p build_mliap && cd build_mliap
cp $HOME/programs/lammps_mliap_22Jul2025/cmake/presets/kokkos-cuda.cmake . 

module purge
module use $HOME/modules
module load miniforge/24.3.0-0
module load cmake/4.1.1
module load gcc/12.4.0
module load openmpi/5.0.7_gcc12
module load openblas/0.3.30
module load cuda/12.1

export CC=$(which gcc)
export CXX=$(which g++)

source $HOME/venv/.lammpsmace-mliap/bin/activate

cmake -C kokkos-cuda.cmake \
  -D CMAKE_BUILD_TYPE=Release \
  -D CMAKE_INSTALL_PREFIX=$(pwd) \
  -D BUILD_MPI=ON \
  -D PKG_ML-IAP=ON \
  -D PKG_ML-SNAP=ON \
  -D MLIAP_ENABLE_PYTHON=ON \
  -D PKG_PYTHON=ON \
  -D PKG_ML-MACE=ON \
  -DKokkos_ENABLE_OPENMP=on \
  -DKokkos_ENABLE_SERIAL=on \
  -D WITH_JPEG=OFF \
  -D PKG_MOLECULE=ON \
  -D PKG_EXTRA-COMPUTE=ON \
  -D PKG_EXTRA-FIX=ON \
  -D PKG_MC=ON \
  -D PKG_MISC=ON \
  -D PKG_RIGID=ON \
  -D BUILD_SHARED_LIBS=ON \
  ../cmake

make -j16
make install-python
