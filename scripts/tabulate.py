import sys
import pandas as pd
import os

def map_card_data(tab_file, outpath, org_file,aro_index,aro_categories,aro_categories_index,aro_ontology,aro_prevalence, aro_index_model):
	
	''' This function parses the BLAST output tab file and maps the query accessions and reference accessions to the 
		data files from CARD database. 
		Inputs: BLAST output in tsv format, path to output directory to write mapped tsv files 
		Outputs: 5 mapped files - Final tsv file used for visualizaion is mapped_aro_prevalence.tsv

	'''
	
	card_output = pd.read_csv(tab_file,sep="\t",header=2)
	

	organisms = pd.read_csv(org_file,sep="|",header=None)
	organisms.columns = ['gb','genbank','strand','number','ARO accession','Gene[Organism]']
	organisms['reference acc.'] = organisms['gb'].str.extract('(\d+)',expand=False).apply(pd.to_numeric)

	mapped = pd.merge(card_output, organisms, how='inner', on=['reference acc.'])
	
	
 	mapped_subset = mapped[['# Fields: query acc.','reference acc.','% identity','query start', 'query end','reference start','reference end', 'query strand','reference strand','query length','composite score','ARO accession','Gene[Organism]', 'left overhang','right overhang']]
 	mapped_subset.columns = ['query acc.','reference acc.','% identity','query start', 'query end','reference start','reference end', 'query strand','reference strand','query length','composite score','ARO Accession','Gene[Organism]', 'left overhang','right overhang']
 	mapped_subset.to_csv(os.path.join(outpath,"mapped_card_accession.tsv"),index=False,sep="\t")

 	_aro_index_ = pd.read_csv(aro_index, sep="\t",header=0)
 	mapped_aro_index = pd.merge(mapped_subset,_aro_index_, how='inner',on=['ARO Accession'])
 	mapped_aro_index.to_csv(os.path.join(outpath,"mapped_card_aro_index.tsv"),index=False,sep="\t")


 	#_aro_categories_  = pd.read_csv(aro_categories,sep="\t",header=0)
 	#mapped_aro_categories = pd.merge(mapped_aro_index,_aro_categories_, how='inner',on=['ARO Accession'])

 	_aro_category_index = pd.read_csv(aro_categories_index,sep="\t",header=0)
 	mapped_aro_category_index = pd.merge(mapped_aro_index,_aro_category_index,how='inner',on=['Protein Accession'])

 	mapped_aro_category_index.to_csv(os.path.join(outpath,"mapped_aro_categories_index.tsv"),sep="\t",index=False)

 	_aro_ontology_ = pd.read_csv(aro_ontology,sep="\t",header=0)
 	_aro_ontology_.columns = ['ARO Accession','Name','Description']
 	mapped_aro_ontology = pd.merge(mapped_aro_category_index,_aro_ontology_,how='inner',on=['ARO Accession'])
 	mapped_aro_ontology.to_csv(os.path.join(outpath,"mapped_aro_ontology.tsv"),sep="\t",index=False)


 	_aro_prevalence_ = pd.read_csv(aro_prevalence,sep="\t",header=0)
 	mapped_aro_prevalence = pd.merge(mapped_aro_ontology,_aro_prevalence_,how='inner',on=['ARO Accession'])
 	
 	mapped_aro_prevalence = mapped_aro_prevalence[['query acc.', 'DNA Accession_x',  '% identity', 'query start','query end', 'reference start', 'reference end', 'query strand','reference strand', 'query length', 'composite score','ARO Accession', 'Gene[Organism]', 'left overhang','right overhang', 'Model Sequence ID', 'Model ID_x','Model Name', 'ARO Name', 'Protein Accession','AMR Gene Family', 'Drug Class','Resistance Mechanism', 'Name_x', 'Description', 'Model Type', 'Pathogen', 'Criteria', 'ARO Categories']]
 	mapped_aro_prevalence.columns = ['query acc.', 'DNA Accession', '% identity', 'query start','query end', 'reference start', 'reference end', 'query strand','reference strand', 'query length', 'composite score','ARO Accession', 'Gene[Organism]', 'left overhang','right overhang', 'Model Sequence ID', 'Model ID','Model Name', 'ARO Name', 'Protein Accession', 'AMR Gene Family', 'Drug Class','Resistance Mechanism', 'Name', 'Description', 'Model Type', 'Pathogen', 'Criteria', 'ARO Categories']
 	mapped_aro_prevalence.to_csv(os.path.join(outpath,"mapped_aro_prevalence.tsv"),sep="\t",index=False)

 	#_aro_index_model_ = pd.read_csv(aro_index_model,sep="\t",header=0)
 	#_aro_index_model_.columns = ['prevalence_sequence_id','model_id','aro_term','ARO Accession', 'detection_model','species_name','ncbi_accession','data_type','rgi_criteria','percent_identity','bitscore','amr_gene_family','resistance_mechanism','drug_class']
 	#print(_aro_index_model_.shape)
 	#_aro_index_model_dedup = _aro_index_model_.drop_duplicates()
 	#print(_aro_index_model_dedup.shape)
 	#mapped_aro_index_model = pd.merge(mapped_aro_prevalence,_aro_index_model_,how='inner',on=['ARO Accession'])
 	#mapped_aro_index_model.to_csv("test/mapped_aro_index_model.tsv",sep="\t",index=False)	

map_card_data(sys.argv[1],sys.argv[2],'lib/ref_acc.tsv','lib/card-data/aro_index.csv','lib/card-data/aro_categories.csv','lib/card-data/aro_categories_index.csv','lib/card-ontology/aro.csv','lib/card-prevalence/card_prevalence.txt','lib/card-prevalence/index-for-model-sequences.txt')










