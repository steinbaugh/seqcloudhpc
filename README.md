# koopa 🐢

[![Build Status](https://travis-ci.org/steinbaugh/koopa.svg?branch=master)](https://travis-ci.org/steinbaugh/koopa)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)

Shell bootloader for bioinformatics.

## Installation

Bash shell running on either Linux or macOS is currently supported.

First, clone the repository:

```bash
git clone https://github.com/steinbaugh/koopa.git ~/koopa
```

Add these lines to your `.bash_profile` file:

```bash
# koopa shell
# https://github.com/steinbaugh/koopa
source ~/koopa/bin/koopa activate
```

## HPC interactive session

To launch an interactive session on a high-performance computing (HPC) cluster, simply run the `interactive` script. All arguments are optional, but generally we recommend setting the number of cores, memory, and time.

```bash
interactive --cores=[N] --mem=[GB] --time=[D-HH::MM]
```

For example, here's how to start an interactive session on an HPC using the [slurm][] scheduler, which will run for 6 hours using 2 cores and 16 GB of RAM total (i.e. 8 GB per core).

```bash
interactive --cores=2 --mem=16 --time=0-06:00
```

For more information on configuration, consult `interactive --help`.

[slurm]: https://slurm.schedmd.com
