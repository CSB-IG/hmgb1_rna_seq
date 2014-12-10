
paste Ctl-1_counts.strict.txt Ctl-4_counts.strict.txt Ctl-5_counts.strict.txt HMGB1-1_counts.strict.txt HMGB1-4_counts.strict.txt HMGB1-5_counts.strict.txt > strict.txt
# ine paste Ctl-1_counts.strict.txt Ctl-4_counts.strict.txt Ctl-5_counts.strict.txt HMGB1-1_counts.strict.txt HMGB1-4_counts.strict.txt HMGB1-5_counts.strict.txt > strict.txt
# union paste Ctl-1_counts.strict.txt Ctl-4_counts.strict.txt Ctl-5_counts.strict.txt HMGB1-1_counts.strict.txt HMGB1-4_counts.strict.txt HMGB1-5_counts.strict.txt > strict.txt


# awk '{print $1,$2,$4,$6,$8,$10,$12}' strict.txt > s.txt

grep -v "0 0 0 0 0 0" ine.txt > ine_no0.txt
grep -v "0 0 0 0 0 0" union.txt > union_no0.txt
grep -v "0 0 0 0 0 0" strict.txt > strict_no0.txt
