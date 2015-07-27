OBO = http://purl.obolibrary.org/obo
UPHENO = $(OBO)/upheno
CATALOG = catalog-v001.xml
DATA = ../data
MIRROR= mirror

MM = $(DATA)/Mus_musculus
MM_G2P = $(MM)/Mm-gene-to-phenotype-BF.txt
MM_G2L = $(MM)/Mm-gene-labels.txt

MM_G2G = $(MM)/Mm-gene-to-go.txt

DR = $(DATA)/Danio_rerio
DR_G2P = $(DR)/Dr-gene-to-phenotype-BF.txt
DR_G2L = $(DR)/Dr-gene-labels.txt

# TODO: genes
DM = $(DATA)/Drosophila_melanogaster
DM_G2P = $(DM)/Dm-genotype-phenotype-NOFILTER.txt
DM_G2L = $(DM)/Dm-genotype-labels.txt

HS = $(DATA)/Homo_sapiens
HS_D2P = $(HS)/Hs-disease-to-phenotype-O.txt
HS_D2L = $(HS)/Hs-disease-labels.txt

ROOT = $(UPHENO)/metazoa.owl

USECAT = --catalog-xml $(ONT)/catalog-v001.xml 

OWLTOOLS = OWLTOOLS_MEMORY=14G owltools

all: caches
caches: owlsim.cache ic-cache.owl

all-%: %-owlsim.cache %-ic-cache.owl

$(CATALOG): 
	owltools $(ROOT) --slurp-import-closure -d $(MIRROR) -c $@ --merge-imports-closure -o $(CACHEDIR)/merged.owl


# TODO: trigger rebuild
all.owl: $(CATALOG) additional-associations.txt additional-labels.txt
	$(OWLTOOLS) --use-catalog $(CATALOG) $(ROOT) --merge-imports-closure --load-instances additional-associations.txt --load-labels additional-labels.txt --load-instances $(MM_G2P) --load-labels $(MM_G2L) --load-instances $(DR_G2P) --load-labels $(DR_G2L) --load-instances $(HS_D2P) --load-labels $(HS_D2L) --merge-support-ontologies --remove-axioms -t ObjectPropertyDomain --remove-axioms -t ObjectPropertyRange --remove-axioms -t DisjointClasses -o $@


owlsim.cache: all.owl
	$(OWLTOOLS)  $< --sim-save-lcs-cache --debug-class MP:0000001 -m 3.0 $@ --sim-save-state state1.txt --sim-save-ic-cache ic-cache-redundant.owl --sim-save-state state2.txt

ic-cache.owl: all.owl
	$(OWLTOOLS) $< --no-debug --sim-save-ic-cache $@


