import pysam
import argparse

parser = argparse.ArgumentParser(description='drop pairs that have anomalous insert sizes')
parser.add_argument('--bam_out', type=argparse.FileType('w'), required=True)
parser.add_argument('--bam_in', type=argparse.FileType('rb'), required=True)

parser.add_argument('--mean', type=int, required=True)
parser.add_argument('--s', type=int, required=True)

args = parser.parse_args()




input_bam_path = args.bam_in.name
infile  = pysam.Samfile(input_bam_path, 'rb')

output_bam_path = args.bam_out.name
outfile = pysam.Samfile(output_bam_path, "wh", header = infile.header )




for read in infile:
    if read.is_proper_pair:
        if (abs(read.isize) <= args.mean + args.s) and (abs(read.isize) >= args.mean - args.s):
            outfile.write(read)
outfile.close()
