organism="$1"
ensembl="$ENSEMBL_RELEASE_PATH/gtf"

if [[ $organism == "hsapiens" ]]; then
    echo "Homo sapiens"
    echo "Ensembl GRCh38"
    request="$ensembl/homo_sapiens/Homo_sapiens.GRCh38.${ENSEMBL_RELEASE}.chr_patch_hapl_scaff.gtf.gz"
elif [[ $organism == "mmusculus" ]]; then
    echo "Mus musculus"
    echo "Ensembl GRCm38"
    request="$ensembl/mus_musculus/Mus_musculus.GRCm38.${ENSEMBL_RELEASE}.chr_patch_hapl_scaff.gtf.gz"
elif [[ $organism == "celegans" ]]; then
    # Use WormBase annotations instead of Ensembl?
    echo "Caenorhabditis elegans"
    echo "Ensembl WBcel235"
    request="$ensembl/caenorhabditis_elegans/Caenorhabditis_elegans.WBcel235.${ENSEMBL_RELEASE}.gtf.gz"
elif [[ $organism == "dmelanogaster" ]]; then
    # D. melanogaster Ensembl annotations are out of date.
    # Use the FlyBase annotations instead.
    echo "Drosophila melanogaster"
    echo "FlyBase r${FLYBASE_RELEASE}"
    request="$FLYBASE_RELEASE_PATH/gtf/dmel-all-r${FLYBASE_RELEASE}.gtf.gz"
fi

wget "$request"
gtf=$(basename "$request")
# Extract but keep original compressed file
gunzip -c "$gtf" > "${gtf%.*}"

unset organism
unset ensembl
unset request
