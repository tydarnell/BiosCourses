#! /usr/bin/env nextflow

params.abstracts= 'data/abstracts/*txt'

institutions=file('data/institutions.csv')


in_abstracts = Channel.fromPath(params.abstracts)

process listinst {
  container 'rocker/tidyverse:3.5'
  publishDir '.', mode: 'copy'
  
  input:
  file institutions
  
  output:
  file 'institutions2.csv' into csv_out1
  
  script:
	"""
	Rscript $baseDir/bin/listinst.R $institutions
	"""
}

in_combine = in_abstracts.combine(csv_out1)

process create_data {
  container 'rocker/tidyverse:3.5'
    
	input:
	file k from in_combine

	output:
	file '*.csv' into csv_out2

	script:
	"""
	Rscript $baseDir/bin/createdata.R $k
	"""
}


process top {
    container 'rocker/tidyverse:3.5'
    publishDir '.', mode: 'copy'
    
    input:
    file i from csv_out2.collectFile(name: 'collab_match.csv', newLine: true)

    output:
    file 'top10.csv' into csv_out3

    script:
    """
    Rscript $baseDir/bin/top.R $i
    """
}