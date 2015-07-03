ONT = ../src/ontology/
DATA = ../data

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

##ROOT = $(ONT)/mammal.owl
##ROOT = $(ONT)/vertebrate.owl
ROOT = $(ONT)/metazoa.owl
TRIGGERS = $(ONT)/mp.owl $(ONT)/hp.owl $(ONT)/zp.owl $(MM_G2P) $(DR_G2P) $(HS_D2P)

USECAT = --catalog-xml $(ONT)/catalog-v001.xml 

OWLTOOLS = OWLTOOLS_MEMORY=14G owltools

all: caches
caches: owlsim.cache ic-cache.owl

all-%: %-owlsim.cache %-ic-cache.owl

trigger: $(TRIGGERS)
	touch $@

# TODO: trigger rebuild
all.owl:  $(ROOT) additional-associations.txt additional-labels.txt
	$(OWLTOOLS) $(USECAT) $< --merge-imports-closure --load-instances additional-associations.txt --load-labels additional-labels.txt --load-instances $(MM_G2P) --load-labels $(MM_G2L) --load-instances $(DR_G2P) --load-labels $(DR_G2L) --load-instances $(HS_D2P) --load-labels $(HS_D2L) --merge-support-ontologies --remove-axioms -t ObjectPropertyDomain --remove-axioms -t ObjectPropertyRange --remove-axioms -t DisjointClasses -o $@
###	$(OWLTOOLS) $(USECAT) $< --merge-imports-closure --load-instances $(MM_G2P) --load-labels $(MM_G2L) --load-instances $(DR_G2P) --load-labels $(DR_G2L) --load-instances $(DM_G2P) --load-labels $(DM_G2L) --load-instances $(HS_D2P) --load-labels $(HS_D2L)  --merge-support-ontologies --remove-axioms -t DisjointClasses -o $@

Mus_musculus-all.owl:  $(ONT)/mp/mp-importer.owl $(TRIGGERS)
	owltools $(USECAT) $< --merge-imports-closure --load-instances $(MM_G2P) --load-labels $(MM_G2L) --merge-support-ontologies -o $@
Homo_sapiens-all.owl:  $(ONT)/hp/hp-importer.owl $(TRIGGERS)
	owltools $(USECAT) $< --merge-imports-closure --load-instances $(HS_D2P) --load-labels $(HS_D2L) --merge-support-ontologies -o $@
Drosophila_melanogaster-all.owl:  $(ONT)/dpo/dpo-importer.owl $(TRIGGERS)
	owltools $(USECAT) $< --merge-imports-closure --load-instances $(DM_G2P) --load-labels $(DM_G2L) --merge-support-ontologies --remove-axioms -t DisjointClasses -o $@
Danio_rerio-all.owl:  $(ONT)/zp/zp-importer.owl $(TRIGGERS)
	owltools $(USECAT) $< --merge-imports-closure --load-instances $(DR_G2P) --load-labels $(DR_G2L) --merge-support-ontologies --remove-axioms -t DisjointClasses -o $@

mammal-all.owl:  $(ONT)/mammal.owl $(TRIGGERS)
	$(OWLTOOLS) $(USECAT) $< --merge-imports-closure --load-instances $(MM_G2P) --load-labels $(MM_G2L) --load-instances $(HS_D2P) --load-labels $(HS_D2L) --merge-support-ontologies -o $@

#owlsim.cache: all.owl
#	$(OWLTOOLS) $< --sim-save-ic-cache ic-cache-pre.owl --sim-save-lcs-cache -m 3.0 $@ --sim-save-ic-cache ic-cache-redundant.owl
owlsim.cache: all.owl
	$(OWLTOOLS)  $< --sim-save-lcs-cache --debug-class MP:0000001 -m 3.0 $@ --sim-save-state state1.txt --sim-save-ic-cache ic-cache-redundant.owl --sim-save-state state2.txt

ic-cache.owl: all.owl
	$(OWLTOOLS) $< --no-debug --sim-save-ic-cache $@

%-owlsim.cache: %-all.owl
	$(OWLTOOLS) $< --sim-save-lcs-cache -m 2.0 $@ --sim-save-ic-cache $*-ic-cache-redundant.owl

%-ic-cache.owl: %-all.owl
	$(OWLTOOLS) $< --no-debug --sim-save-ic-cache $@

VERTEBRATE = ../src/ontology/vertebrate.owl
hp-zp-all.owl: $(VERTEBRATE) $(TRIGGERS)
	$(OWLTOOLS) $(USECAT) $<  --load-instances $(DR_G2P) --load-labels $(DR_G2L) --load-instances $(HS_D2P) --load-labels $(HS_D2L) --merge-support-ontologies --merge-imports-closure --run-reasoner -r elk --assert-implied --make-super-slim HP,ZP -o  $@

all-phenodigm-cache.txt: \
 hp-hp-phenodigm-cache.txt\
 hp-mp-phenodigm-cache.txt\
 hp-zp-phenodigm-cache.txt\
 mp-mp-phenodigm-cache.txt\
 mp-zp-phenodigm-cache.txt\
 zp-zp-phenodigm-cache.txt

hp-hp-phenodigm-cache.txt: Homo_sapiens-all.owl
	$(OWLTOOLS) $<  --sim-save-phenodigm-class-scores -m 0.5 -x HP,HP -a $@

hp-mp-phenodigm-cache.txt: Mus_musculus-all.owl Homo_sapiens-all.owl
	$(OWLTOOLS) Mus_musculus-all.owl Homo_sapiens-all.owl  $(ONT)/hp-mp/mp_hp-align-equiv.owl --merge-support-ontologies --sim-save-phenodigm-class-scores -m 0.5 -x HP,MP -a $@

hp-zp-phenodigm-cache.txt: hp-zp-all.owl
	$(OWLTOOLS) $< --sim-save-phenodigm-class-scores -m 0.5 -x HP,ZP -a $@

mp-mp-phenodigm-cache.txt: Mus_musculus-all.owl
	$(OWLTOOLS) $<  --sim-save-phenodigm-class-scores -m 0.5 -x MP,MP -a $@

mp-zp-phenodigm-cache.txt: all.owl
	$(OWLTOOLS) $<  --sim-save-phenodigm-class-scores -m 0.5 -x MP,ZP -a $@

zp-zp-phenodigm-cache.txt: Danio_rerio-all.owl
	$(OWLTOOLS) $<  --sim-save-phenodigm-class-scores -m 0.5 -x ZP,ZP -a $@

all-phenodigm-cache.txt: all.owl
	$(OWLTOOLS) $<  --sim-save-phenodigm-class-scores -m 0.5 -a $@

## ENRICHMENT
ph-x-ph-enrichment.txt: all.owl
	$(OWLTOOLS) --no-debug  $<  --all-by-all-enrichment-analysis -p 0.25 Phenotype Phenotype   > $@.tmp && mv $@.tmp $@

#mouse-ph-x-ph-enrichment.txt: Mus_musculus-all.owl
#	$(OWLTOOLS)  --no-debug $< go-sub.obo --load-instances $(MM_G2G)  --all-by-all-enrichment-analysis -p 0.25 'mammalian phenotype' 'mammalian phenotype'   > $@.tmp && mv $@.tmp $@

mouse-ph-x-go-enrichment.txt: Mus_musculus-all.owl
	$(OWLTOOLS)  --no-debug $< go-sub.obo --load-instances $(MM_G2G)  --all-by-all-enrichment-analysis -p 0.25 'mammalian phenotype' biological_process   > $@.tmp && mv $@.tmp $@

mouse-ph-x-go-cp-enrichment.txt: Mus_musculus-all.owl
	$(OWLTOOLS)  $< go-sub.obo --load-instances $(MM_G2G)  --all-by-all-enrichment-analysis -p 0.25 'mammalian phenotype' 'cellular process'   > $@.tmp && mv $@.tmp $@

