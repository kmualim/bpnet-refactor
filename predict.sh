CUDA_VISIBLE_DEVICES=3
FASTA_CHROM="Ath"

BASE_DIR=/oak/stanford/groups/akundaje/kmualim/dapseq/20250312_data
DATA_DIR=$BASE_DIR/data
MODEL_DIR=/srv/scratch/kmualim/dapseq/multi_species/
CV_SPLITS=splits_multispecies.json
INPUT_DATA=multi_species.json
MODEL_PARAMS=multispecies.bpnet_params.json
REFERENCE_DIR=/oak/stanford/groups/akundaje/kmualim/dapseq/reference
CHROM_SIZES=$BASE_DIR/chrom_sizes/$FASTA_CHROM.fa.chrom.sizes
CHROMS=$BASE_DIR/chrom_sizes/${FASTA_CHROM}_test_chroms.txt
REFERENCE_GENOME=$BASE_DIR/genomes/$FASTA_CHROM.fa


PREDICTIONS_DIR=$MODEL_DIR/predictions_and_metrics_split000/

#mkdir -p $PREDICTIONS_DIR
python bpnet/cli/predict.py \
	--model $MODEL_DIR/model_split000 \
	--chroms $(paste -s -d ' ' ${CHROMS}) \
	--test-indices-file None \
	--output-dir $PREDICTIONS_DIR \
	--input-data $INPUT_DATA \
	--sequence-generator-name BPNet \
	--input-seq-len 2114 \
	--output-len 1000 \
	--output-window-size 1000 \
	--batch-size 64 \
	--reverse-complement-average \
	--threads 2 \
	--generate-predicted-profile-bigWigs 
