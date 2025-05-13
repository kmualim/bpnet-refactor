CUDA_VISIBLE_DEVICES=3

BASE_DIR=/oak/stanford/groups/akundaje/kmualim/dapseq/20250312_data
DATA_DIR=$BASE_DIR/data
MODEL_DIR=/srv/scratch/kmualim/dapseq/multi_species/
CV_SPLITS=splits_multispecies.json
INPUT_DATA=multi_species.json
MODEL_PARAMS=multispecies.bpnet_params.json

python bpnet/cli/bpnettrainer.py \
	--input-data $INPUT_DATA \
	--output-dir $MODEL_DIR \
	--splits $CV_SPLITS \
	--model-arch-name BPNet \
	--model-arch-params-json $MODEL_PARAMS \
	--sequence-generator-name BPNet \
	--model-output-filename model \
	--input-seq-len 2114 \
	--output-len 1000 \
	--shuffle \
	--threads 10 \
	--epochs 100 \
	--batch-size 32 \
	--reverse-complement-augmentation \
	--early-stopping-patience 10 \
	--reduce-lr-on-plateau-patience 5 \
	--learning-rate 0.001

