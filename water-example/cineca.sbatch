#!/bin/bash
#SBATCH --job-name=MACE-4GPU
#SBATCH --account=IscrB_NEXT-LIB
#SBATCH --partition=boost_usr_prod
#SBATCH --qos=boost_qos_dbg
#SBATCH --time=00:30:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --gres=gpu:4
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=12G

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

module use /leonardo/home/userexternal/ftarulli/modules
module load lammps-mace-mliap

source $HOME/venvs/.lammps-mliap/bin/activate

export OMP_NUM_THREADS=1

#lmp -k on g 1 -sf kk -pk kokkos newton on neigh half -in lammps.in
mpirun -np 4 lmp -k on g 4 -sf kk -pk kokkos newton on neigh half -in lammps.in
