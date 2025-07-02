#!/bin/bash
#SBATCH --account=IscrB_NEXT-LIB
#SBATCH --partition=boost_usr_prod # partition to be used
#SBATCH --qos boost_qos_dbg
#SBATCH --time 00:30:00 # format: HH:MM:SS
#SBATCH --nodes=1 # node
#SBATCH --ntasks-per-node=1 # tasks out of 32
#SBATCH --gres=gpu:1 # gpus per node out of 4
#SBATCH --cpus-per-task=32
source env
echo "sourcing environments"

cd $HOME/programs/LAMMPS-MACE/lammps/build

module purge
module load profile/chem-phys
module load gcc/12.2.0
module load gsl/2.7.1--gcc--12.2.0
module load openmpi/4.1.6--gcc--12.2.0
module load fftw/3.3.10--openmpi--4.1.6--gcc--12.2.0
module load openblas/0.3.24--gcc--12.2.0
module load cuda/12.1
module load intel-oneapi-mkl/2023.2.0

cmake \
  -D CMAKE_BUILD_TYPE=Release \
  -D CMAKE_INSTALL_PREFIX=$(pwd) \
  -D CMAKE_CXX_STANDARD=17 \
  -D CMAKE_CXX_STANDARD_REQUIRED=ON \
  -D BUILD_MPI=ON \
  -D BUILD_SHARED_LIBS=ON \
  -D PKG_KOKKOS=ON \
  -D Kokkos_ENABLE_CUDA=ON \
  -D CMAKE_CXX_COMPILER=$(pwd)/../lib/kokkos/bin/nvcc_wrapper \
  -D Kokkos_ARCH_AMDAVX=ON \
  -D Kokkos_ARCH_AMPERE100=ON \
  -D CMAKE_PREFIX_PATH=$(pwd)/../../libtorch-gpu \
  -D PKG_ML-MACE=ON \
  ../cmake

make -j32 install
