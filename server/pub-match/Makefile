OBO = http://purl.obolibrary.org/obo
UPHENO = $(OBO)/upheno
CATALOG = catalog-v001.xml
DATA = ../../data
MIRROR= mirror

MM = $(DATA)/Mus_musculus
##MM_G2P = $(MM)/Mm-gene-to-phenotype-BF.txt
MM_G2P = $(MM)/Mm_gene_phenotype.txt
MM_G2L = $(MM)/Mm_gene_labels.txt

DR = $(DATA)/Danio_rerio
##DR_G2P = $(DR)/Dr-gene-to-phenotype-BF.txt
DR_G2P = $(DR)/Dr_gene_phenotype.txt
DR_G2L = $(DR)/Dr_gene_labels.txt

# TODO: genes
DM = $(DATA)/Drosophila_melanogaster
DM_G2P = $(DM)/Dm_gene_phenotype.txt
DM_G2L = $(DM)/Dm_gene_labels.txt

CE = $(DATA)/Caenorhabditis_elegans
CE_G2P = $(CE)/Ce_gene_phenotype.txt
CE_G2L = $(CE)/Ce_gene_labels.txt

HS = $(DATA)/Homo_sapiens
HS_D2P = $(HS)/Hs_disease_phenotype.txt
HS_D2L = $(HS)/Hs_disease_labels.txt

CASE = $(DATA)/Cases
CASE_C2P = $(CASE)/UDP_case_phenotype.txt
CASE_C2L = $(CASE)/UDP_case_labels.txt

#Experimental
#PUB = $(DATA)/Pubs
#PUB_P2P = $(PUB)/Pub_phenotype.txt
#PUB_P2L = $(PUB)/Pub_labels.txt

#ROOT = $(UPHENO)/metazoa.owl
#ROOT = $(UPHENO)/vertebrate.owl
ROOT = $(UPHENO)/monarch.owl

USECAT = --catalog-xml $(ONT)/catalog-v001.xml

OWLTOOLS_MEMORY ?= 14G

OWLTOOLS = OWLTOOLS_MEMORY=$(OWLTOOLS_MEMORY) owltools

all: caches
caches: owlsim.cache ic-cache.owl

all-%: %-owlsim.cache %-ic-cache.owl

$(CATALOG):
	owltools $(ROOT) --slurp-import-closure -d $(MIRROR) -c $@ --merge-imports-closure -o $(CACHEDIR)/merged.owl


# TODO: trigger rebuild
all.owl:  ../additional-associations.txt ../additional-labels.txt $(DR_G2P) $(MM_G2P) $(HS_D2P) $(DM_D2P) $(CE_G2P) $(PUB_P2P)
	$(OWLTOOLS)  $(ROOT) --merge-imports-closure --load-instances ../additional-associations.txt --load-labels ../additional-labels.txt --load-instances $(MM_G2P) --load-labels $(MM_G2L) --load-instances $(DR_G2P) --load-instances $(CASE_C2P) --load-labels $(CASE_C2L) --load-labels $(DR_G2L) --load-instances $(HS_D2P) --load-labels $(HS_D2L) --load-instances $(DM_G2P) --load-labels $(DM_G2L) --load-instances $(CE_G2P) --load-labels $(CE_G2L) --load-instances $(PUB_P2P) --load-labels $(PUB_P2L) --merge-support-ontologies --remove-axioms -t ObjectPropertyDomain --remove-axioms -t ObjectPropertyRange --remove-axioms -t DisjointClasses -o $@

owlsim.cache: all.owl
	$(OWLTOOLS)  $< --sim-save-lcs-cache --debug-class MP:0000001 -m 3.0 $@ --sim-save-state state1.txt --sim-save-ic-cache ic-cache-redundant.owl --sim-save-state state2.txt

ic-cache.owl: all.owl
	$(OWLTOOLS) $< --no-debug --sim-save-ic-cache $@
