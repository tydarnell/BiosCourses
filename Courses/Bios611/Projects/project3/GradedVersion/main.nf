#! /usr/bin/env nextflow

params.abstracts= 'data/abstracts/*txt'

institutions=file('data/institutions.csv')


in_abstracts = Channel.fromPath(params.abstracts)

process create_data {
    container 'rocker/tidyverse:3.5'
    
	input:
	file i from in_abstracts
	file institutions

	output:
	file '*.csv' into csv_out

	script:
	"""
	Rscript $baseDir/bin/createdata.R $i $insitutions
	"""
}

process top {
    container 'rocker/tidyverse:3.5'
    publishDir '.', mode: 'copy'
    input:
    file i from csv_out.collectFile(name: 'collab.csv', newLine: true)

    output:
    file 'top10.csv' into csv_out2

    script:
    """
    Rscript $baseDir/bin/top.R $i
    """

}