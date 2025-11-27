#!/bin/bash
input="tmdb-movies.csv"
clean="tmdb_clean_final.csv"
dirty="tmdb_dirty_rows.csv"

# Giữ header
head -n 1 "$input" > "$clean"
head -n 1 "$input" > "$dirty"

# Xử lý từng dòng, ép về đúng 21 cột (cách chuẩn nhất bằng Python inline)
tail -n +2 "$input" | python3 -c '
import csv, sys
r = csv.reader(sys.stdin)
w = csv.writer(sys.stdout)
for row in r:
    if len(row) == 21:
        w.writerow(row)          # sạch → ghi vào clean
    else:
        print(len(row), row[0] if row else "EMPTY", sep="\t", file=sys.stderr)
        w.writerow(row[:21])     # bị thừa cột → cắt bỏ phần thừa
' >> "$clean" 2>> "$dirty"   # dòng lỗi ghi vào dirty để bạn xem

echo "Done!"
echo "Sạch: $(wc -l < "$clean") dòng"
echo "Bẩn (đã được cắt về 21 cột): $(wc -l < "$dirty") dòng"
