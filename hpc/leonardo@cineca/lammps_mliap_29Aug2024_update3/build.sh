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
module load python/3.11.6--gcc--8.5.0
module load gcc/12.2.0
module load gsl/2.7.1--gcc--12.2.0
module load openmpi/4.1.6--gcc--12.2.0
module load fftw/3.3.10--openmpi--4.1.6--gcc--12.2.0
module load openblas/0.3.24--gcc--12.2.0
module load cuda/12.1
module load intel-oneapi-mkl/2023.2.0
module load plumed/2.8.1--openmpi--4.1.6--gcc--12.2.0

source $PUBLIC/programs/lammps/lammps_stable_29Aug2024_update3/build/.lammps-mliap/bin/activate

cmake -C confing.make \
  -D CMAKE_BUILD_TYPE=Release \
  -D CMAKE_INSTALL_PREFIX=$(pwd) \
  ../cmake

make -j32