import pandas as pd
import pysam
import argparse
from tqdm import tqdm


def parse_args():
    parser = argparse.ArgumentParser(description="get gc content after binning the entire genome into bins")
    parser.add_argument("-g", "--ref_fasta", help="reference genome file")
    parser.add_argument("-c", "--chrom_sizes",
                        help="chromosome sizes file for reference genome (contains chr and chrom size seperated by tab)")
    parser.add_argument("-o", "--out_prefix", help="output prefix path to store the gc content of binned genome")
    parser.add_argument("-f", "--inputlen", type=int, default=2114, help="inputlen to use to find gc content")
    parser.add_argument("-s", "--stride", type=int, default=50, help="stride to use for shifting the bins")
    return parser.parse_args()


def get_genomewide_gc_bins_main(ref_fasta: str,
                                chrom_sizes: str,
                                stride: int,
                                inputlen: int,
                                out_prefix: str,
                                ) -> None:
    """
    Calculate GC content of genome-wide bins, offset from each other by # of bases specified in `stride`
    Args:
        ref_fasta: reference genome file
        chrom_sizes: path to tab-separated file with chrom and size for genome corresponding to ref_fasta
        stride: number of bases to shift bin start positions between bins
        inputlen: bin size
        out_prefix: where to save output
    """
    ref = pysam.FastaFile(ref_fasta)
    chrom_sizes = pd.read_csv(chrom_sizes, header=None, sep='\t')
    region_dict = dict()
    for index, row in chrom_sizes.iterrows():
        chrom = row[0]
        print(chrom)
        chrom_size = row[1]
        for bin_start in tqdm(range(0, chrom_size, stride)):
            bin_end = bin_start + inputlen
            seq = ref.fetch(chrom, bin_start, bin_end).upper()
            g = seq.count('G')
            c = seq.count('C')
            gc = g + c
            fract = round(gc / (inputlen), 2)
            region_dict[tuple([chrom, bin_start, bin_end])] = fract

    # generate pandas df from dict
    print("making df")
    df = pd.DataFrame.from_dict(region_dict, orient='index')
    print("made df")
    new_index = pd.MultiIndex.from_tuples(df.index, names=('CHR', 'START', 'END'))
    df = pd.DataFrame(df[0], new_index)
    df.to_csv(out_prefix + ".bed", sep='\t', header=False, index=True)


if __name__ == "__main__":
    args = parse_args()
    get_genomewide_gc_bins_main(ref_fasta=args.ref_fasta, chrom_sizes=args.chrom_sizes, stride=args.stride,
                                inputlen=args.inputlen,
                                out_prefix=args.out_prefix)
