#!/usr/bin/env python3
"""
Download GENCODE genome.
"""

from argparse import ArgumentParser
from os.path import join, realpath

from koopa.arg import dir_path
from koopa.files import download
from koopa.genome import tx2gene_from_fasta
from koopa.genome.gencode import (
    download_gencode_genome,
    download_gencode_gff,
    download_gencode_gtf,
    download_gencode_transcriptome,
    gencode_version,
)
from koopa.print import stop
from koopa.strings import paste_url
from koopa.syntactic import kebab_case
from koopa.system import koopa_help

koopa_help()


parser = ArgumentParser()
parser.add_argument("--organism", required=True, type=str)
parser.add_argument("--build", type=str)
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
    annotation, build, decompress, genome_type, organism, output_dir, release,
):
    """
    Download GENCODE genome.
    """
    if genome_type == "none" and annotation == "none":
        stop("'type' or 'annotation' are required.")
    if organism == "Homo sapiens":
        organism_short = "human"
        if build is None:
            build = "GRCh38"
    elif organism == "Mus musculus":
        organism_short = "mouse"
        if build is not None:
            stop("'build' is only supported for Homo sapiens.")
        build = "GRCm38"
    if release is None:
        release = gencode_version(organism=organism)
    base_url = paste_url(
        "ftp://ftp.ebi.ac.uk",
        "pub",
        "databases",
        "gencode/",
        "Gencode_" + organism_short,
        "release_" + release,
    )
    output_basename = kebab_case(
        organism + " " + build + " " + "gencode" + " " + release
    )
    output_dir = join(realpath(output_dir), output_basename)
    if build == "GRCh37":
        base_url = paste_url(base_url, "GRCh37_mapping")
        transcriptome_fasta_url = paste_url(
            base_url, "gencode.v" + release + "lift37.transcripts.fa.gz"
        )
        gtf_url = paste_url(
            base_url, "gencode.v" + release + "lift37.annotation.gtf.gz"
        )
        gff_url = paste_url(
            base_url, "gencode.v" + release + "lift37.annotation.gff3.gz"
        )
        readme_url = paste_url(base_url, "_README_GRCh37_mapping.txt")
    else:
        transcriptome_fasta_url = paste_url(
            base_url, "gencode.v" + release + ".transcripts.fa.gz"
        )
        gtf_url = paste_url(
            base_url, "gencode.v" + release + ".annotation.gtf.gz"
        )
        gff_url = paste_url(
            base_url, "gencode.v" + release + ".annotation.gff3.gz"
        )
        readme_url = paste_url(base_url, "_README.TXT")
    genome_fasta_url = paste_url(
        base_url, build + ".primary_assembly.genome.fa.gz"
    )
    md5sums_url = paste_url(base_url, "MD5SUMS")
    download(url=readme_url, output_dir=output_dir)
    download(url=md5sums_url, output_dir=output_dir)
    if genome_type == "genome":
        download_gencode_genome(
            genome_fasta_url=genome_fasta_url,
            output_dir=output_dir,
            decompress=decompress,
        )
    elif genome_type == "transcriptome":
        download_gencode_transcriptome(
            transcriptome_fasta_url=transcriptome_fasta_url,
            output_dir=output_dir,
            decompress=decompress,
        )
    elif genome_type == "all":
        download_gencode_genome(
            genome_fasta_url=genome_fasta_url,
            output_dir=output_dir,
            decompress=decompress,
        )
        download_gencode_transcriptome(
            transcriptome_fasta_url=transcriptome_fasta_url,
            output_dir=output_dir,
            decompress=decompress,
        )
    if annotation == "gtf":
        download_gencode_gtf(
            gtf_url=gtf_url, output_dir=output_dir, decompress=decompress
        )
    elif annotation == "gff":
        download_gencode_gff(
            gff_url=gff_url, output_dir=output_dir, decompress=decompress
        )
    elif annotation == "all":
        download_gencode_gtf(
            gtf_url=gtf_url, output_dir=output_dir, decompress=decompress
        )
        download_gencode_gff(
            gff_url=gff_url, output_dir=output_dir, decompress=decompress
        )
    if genome_type != "genome":
        tx2gene_from_fasta(source_name="gencode", output_dir=output_dir)
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