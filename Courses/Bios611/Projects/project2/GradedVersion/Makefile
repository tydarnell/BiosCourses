data:
	curl -o stats.txt 'https://raw.githubusercontent.com/tydarnell/Bios611/master/project2/stats.csv'
	curl -o  ratings.txt 'https://raw.githubusercontent.com/tydarnell/Bios611/master/project2/ratings.csv'
	
render:
	R -e "rmarkdown::render('project2.Rmd',output_file='project2.html')"

out.png: data render 
	make out.png -Bnd | ./makefile2graph/make2graph | dot -Tpng -o out.png