# INSTALL LAMMPS-MLIAP (stable 29Aug2024)
<div align="right">
  by PDA
</div>

> [!IMPORTANT]  
> This guide is base on Leonardo@CINECA HPC

## Clone Lammps repo

Setup working directory

```bash
cd $PUBLIC
mkdir programs
cd programs
mkdir lammps
cd lammps
```

clone from repo

```bash
git clone https://github.com/lammps/lammps.git lammps_stable_29Aug2024_update3
cd lammps_stable_29Aug2024_update3
git checkout stable_29Aug2024_update3
```

> [!WARNING]  
> the `checout` step is crucial to select the righ development point of the lammps project
> you can check if is allright with `git log`
> ```bash
> $ git log
> commit 81980666de9ec2b1694e82a9b55d28ec29e8db07 (HEAD, > tag: stable_29Aug2024_update3, origin/stable)
> Merge: 0435e156ba 7d4757e745
>Author: Axel Kohlmeyer <akohlmey@gmail.com>
> Date:   Thu Jun 12 23:06:51 2025 -0400
>
>     Merge pull request #4531 from lammps/maintenance
> 
>     Third Set of Collected Bug Fixes and Maintenance Updates for 29 August 2024 Stable Release
> ```
> 