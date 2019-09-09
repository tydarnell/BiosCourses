
shakespeare.txt:
	curl -o shakespeare.txt http://www.gutenberg.org/files/100/100-0.txt
	
thee_count_grep.txt: shakespeare.txt count_thee.sh
	./count_thee.sh > thee_count_grep.txt

top_ten_grep.txt: shakespeare.txt count_b4_thee.sh
	./count_b4_thee.sh shakespeare.txt > top_ten_grep.txt

.PHONY: print_results
