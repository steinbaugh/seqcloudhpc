#!/usr/bin/env python3
"""
Download Ensembl genome.
"""

from argparse import ArgumentParser
from os.path import join, realpath

from koopa.arg import dir_path
from koopa.genome import tx2gene_from_fasta
from koopa.genome.ensembl import (
    download_ensembl_genome,
    download_ensembl_gff,
    download_ensembl_gtf,
    download_ensembl_transcriptome,
    ensembl_version,
)
from koopa.goalie import stop
from koopa.strings import paste_url
from koopa.syntactic import kebab_case
from koopa.system import koopa_help

koopa_help()


parser = ArgumentParser()
parser.add_argument("--organism", required=True, type=str)
parser.add_argument("--build", required=True, type=str)
parser.add_argument("--release", type=str)
parser.add_argument(
    "--type",
    default="all",
    const="all",
    nargs="?",
    choices=["all", "genome", "transcriptome", "none"],
)
parser.add_argument(
    "--annotation",
    default="all",
    const="all",
    nargs="?",
    choices=["all", "gtf", "gff", "none"],
)
parser.add_argument("--output-dir", type=dir_path, default=".")
parser.add_argument("--decompress", action="store_true")
args = parser.parse_args()


def main(
    annotation, build, decompress, genome_type, organism, output_dir, release
):
    """
    Download Ensembl genome.
    """
    if genome_type == "none" and annotation == "none":
        stop("'genome_type' or 'annotation' are required.")
    organism = organism.replace(" ", "_")
    base_url = "ftp://ftp.ensembl.org/pub"
    grch37_base_url = paste_url(base_url, "grch37")
    grch37_release = "87"
    if build == "GRCh37":
        base_url = grch37_base_url
        release = grch37_release
    if release is None:
        release = ensembl_version()
    release_url = paste_url(base_url, "release-" + release)
    output_basename = kebab_case(
        organism + " " + build + " " + "ensembl" + " " + release
    )
    output_dir = join(realpath(output_dir), output_basename)
    if genome_type == "genome":
        download_ensembl_genome(
            organism=organism,
            build=build,
            release_url=release_url,
            output_dir=output_dir,
            decompress=decompress,
        )
    elif genome_type == "transcriptome":
        download_ensembl_transcriptome(
            organism=organism,
            build=build,
            release_url=release_url,
            output_dir=output_dir,
            decompress=decompress,
        )
    elif genome_type == "all":
        download_ensembl_genome(
            organism=organism,
            build=build,
            release_url=release_url,
            output_dir=output_dir,
            decompress=decompress,
        )
        download_ensembl_transcriptome(
            organism=organism,
            build=build,
            release_url=release_url,
            output_dir=output_dir,
            decompress=decompress,
        )
    if annotation == "gtf":
        download_ensembl_gtf(
            organism=organism,
            build=build,
            release=release,
            release_url=release_url,
            output_dir=output_dir,
            decompress=decompress,
        )
    elif annotation == "gff":
        download_ensembl_gff(
            organism=organism,
            build=build,
            release=release,
            release_url=release_url,
            output_dir=output_dir,
            decompress=decompress,
        )
    elif annotation == "all":
        download_ensembl_gtf(
            organism=organism,
            build=build,
            release=release,
            release_url=release_url,
            output_dir=output_dir,
            decompress=decompress,
        )
        download_ensembl_gff(
            organism=organism,
            build=build,
            release=release,
            release_url=release_url,
            output_dir=output_dir,
            decompress=decompress,
        )
    if type != "genome":
        tx2gene_from_fasta(source_name="ensembl", output_dir=output_dir)
    print("Genome downloaded successfully to '" + output_dir + "'.")


main(
    annotation=args.annotation,
    build=args.build,
    decompress=args.decompress,
    genome_type=args.type,
    organism=args.organism,
    output_dir=args.output_dir,
    release=args.release,
)