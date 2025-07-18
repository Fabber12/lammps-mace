#!/bin/bash
#SBATCH --account=IscrB_NEXT-LIB
#SBATCH --partition=boost_usr_prod # partition to be used
#SBATCH --qos=boost_qos_dbg
#SBATCH --time 00:30:00 # format: HH:MM:SS
#SBATCH --nodes=1 # node
#SBATCH --ntasks-per-node=1 # tasks out of 32
#SBATCH --gres=gpu:1 # gpus per node out of 4
#SBATCH --cpus-per-task=32

echo "sourcing environments"

module purge
module load profile/chem-phys
module load python/3.11.7
module load gcc/12.2.0
module load openblas/0.3.26--gcc--12.2.0
module load gsl/2.7.1--gcc--12.2.0-spack0.22
module load openmpi/4.1.6--gcc--12.2.0-cuda-12.2
module load fftw/3.3.10--openmpi--4.1.6--gcc--12.2.0-spack0.22
module load cuda/12.1
module load intel-oneapi-mkl/2024.0.0
module load plumed/2.9.2--openmpi--4.1.6--gcc--12.2.0

source $PUBLIC/programs/lammps/lammps_stable_29Aug2024_update3/build/.lammps-mliap/bin/activate

cmake -C config.make \
  -D CMAKE_BUILD_TYPE=Release \
  -D CMAKE_INSTALL_PREFIX=$(pwd) \
  ../cmake

make -j32
