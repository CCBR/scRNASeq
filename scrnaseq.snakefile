from snakemake.utils import R
from os.path import join
from os import listdir
import os

configfile: "run.json"

samples=config['project']['groups']['rsamps']

workpath = config['project']['workpath']

pid=config['project']['id']
if config['project']['DOCYCLEREGRESS'] == "TRUE" :
  subdir="with_cell_cycle_regression/"
elif config['project']['DOCYCLEREGRESS'] == "FALSE" :
  subdir="no_cell_cycle_regression/"
print(expand(join(workpath,subdir,"{pid}.{name}"),pid=pid,name=samples))


if config['project']['pipeline'] == "cellranger":
  rule all:
     params: batch='--time=168:00:00',crid=config['project']['CRID']
     input: join(workpath,"{pid}/outs/web_summary.html".format(pid=pid))

        
elif config['project']['pipeline'] == "scrnaseqinit":
  if len(samples) > 1:
    rule all:
      params: batch='--time=168:00:00'
      input:
       expand(join(workpath,subdir,"{name}/","{pid}.{name}_scrna_initial.html"),pid=pid,name=samples),
       expand(join(workpath,subdir,"{name}/","{pid}.{name}_scrna_jackstraw.html"),pid=pid,name=samples),
       join(workpath,subdir,"combined_cca/","{pid}_scrna_cca.html".format(pid=pid))
  else:
    rule all:
       params: batch='--time=168:00:00'
       input: 
        expand(join(workpath,subdir,"{name}/","{pid}.{name}_scrna_initial.html"),pid=pid,name=samples),
        expand(join(workpath,subdir,"{name}/","{pid}.{name}_scrna_jackstraw.html"),pid=pid,name=samples)

elif config['project']['pipeline'] == "scrnaseqcluster":
  rule all:
     params: batch='--time=168:00:00'
     input: expand(join(workpath,subdir,"{name}/","{pid}.{name}_scrna_cluster_{pcs}_{resolution}.html"),pcs=config['project']['PCS'],resolution=config['project']['RESOLUTION'],pid=pid,name=samples)

elif config['project']['pipeline'] == "scrnaseqmulticluster":
  rule all:
     params: batch='--time=168:00:00'
     input: expand(join(workpath,subdir,"combined_cca/","{pid}_scrna_multicluster_{pcs}_{resolution}.html".format(pcs=config['project']['PCS'],resolution=config['project']['RESOLUTION'],pid=pid)))


rule cellranger: 
   params: rname='pl:cellranger',batch='--partition=ccr,norm --cpus-per-task=40 --mem=110g --time=48:00:00',crid=config['project']['CRID'],refer=config['project']['annotation'],datapath=config['project']['datapath'],dir=config['project']['workpath'],expected=config['project']['EXPECTED'],projectId=config['project']['id']
   output: "{projectId}/outs/web_summary.html".format(projectId=config['project']['id'])
   shell: """
          module load cellranger;
          cellranger count --id={params.projectId} \
                   --transcriptome=$CELLRANGER_REF/{params.refer} \
                   --fastqs={params.datapath} \
                   --sample={params.crid} \
                   --localcores=32 \
                   --localmem=100 \
                   --jobmode=slurm --maxjobs=30 > cellranger_{params.projectId}.log
          """

if config['project']['MATTYPE'] == "cellranger" :
  rule scrna_initial: 
     params: rname='pl:scrnainit',batch='--partition=ccr,norm --cpus-per-task=4 --mem=100g --time=48:00:00',countspath=config['project']['COUNTSPATH'],refer=config['project']['annotation'],dir=config['project']['workpath'],projDesc=config['project']['description'],projectId=config['project']['id'],mattype=config['project']['MATTYPE'],docycleregress=config['project']['DOCYCLEREGRESS'],sd=subdir
     output: 
      out1=join(workpath,subdir,"{name}/","{pid}.{name}_scrna_initial.html"),
      out2=join(workpath,subdir,"{name}/","{pid}.{name}_initial_seurat_object.rds")
     shell: "mkdir -p {params.dir}/{params.sd}/{wildcards.name}; cp Scripts/scrna_initial.Rmd {params.dir}/{params.sd}/{wildcards.name}/; module load R/3.5; Rscript Scripts/scrna_initial_call.R '{params.dir}/{params.sd}/{wildcards.name}' '{params.countspath}/{wildcards.name}/outs/filtered_gene_bc_matrices/{params.refer}' '{params.refer}' '{params.projectId}.{wildcards.name}' '{params.projDesc}' '{params.mattype}' '{params.docycleregress}'"
elif config['project']['MATTYPE'] == "cellranger_raw" :
  rule scrna_initial: 
     params: rname='pl:scrnainit',batch='--partition=ccr,norm --cpus-per-task=4 --mem=100g --time=48:00:00',countspath=config['project']['COUNTSPATH'],refer=config['project']['annotation'],dir=config['project']['workpath'],projDesc=config['project']['description'],projectId=config['project']['id'],mattype=config['project']['MATTYPE'],docycleregress=config['project']['DOCYCLEREGRESS'],sd=subdir
     output: 
      out1=join(workpath,subdir,"{name}/","{pid}.{name}_scrna_initial.html"),
      out2=join(workpath,subdir,"{name}/","{pid}.{name}_initial_seurat_object.rds")
     shell: "mkdir -p {params.dir}/{params.sd}/{wildcards.name}; cp Scripts/scrna_initial.Rmd {params.dir}/{params.sd}/{wildcards.name}/; module load R/3.5; Rscript Scripts/scrna_initial_call.R '{params.dir}/{params.sd}/{wildcards.name}' '{params.countspath}/{wildcards.name}/outs/raw_gene_bc_matrices/{params.refer}' '{params.refer}' '{params.projectId}.{wildcards.name}' '{params.projDesc}' '{params.mattype}' '{params.docycleregress}'"

elif config['project']['MATTYPE'] == "biorad" :
  rule scrna_initial: 
     params: rname='pl:scrnainit',batch='--partition=ccr,norm --cpus-per-task=4 --mem=100g --time=48:00:00',countspath=config['project']['COUNTSPATH'],refer=config['project']['annotation'],dir=config['project']['workpath'],projDesc=config['project']['description'],projectId=config['project']['id'],mattype=config['project']['MATTYPE'],docycleregress=config['project']['DOCYCLEREGRESS'],sd=subdir
     output: 
      out1=join(workpath,subdir,"{name}/","{pid}.{name}_scrna_initial.html"),
      out2=join(workpath,subdir,"{name}/","{pid}.{name}_initial_seurat_object.rds")
     shell: "mkdir -p {params.dir}/{params.sd}/{wildcards.name}; cp Scripts/scrna_initial.Rmd {params.dir}/{params.sd}/{wildcards.name}/; module load R/3.5; Rscript Scripts/scrna_initial_call.R '{params.dir}/{params.sd}/{wildcards.name}' '{params.countspath}/{wildcards.name}.txt' '{params.refer}' '{params.projectId}.{wildcards.name}' '{params.projDesc}' '{params.mattype}' '{params.docycleregress}'"

elif config['project']['MATTYPE'] == "zumi" :
  rule scrna_initial: 
     params: rname='pl:scrnainit',batch='--partition=ccr,norm --cpus-per-task=4 --mem=100g --time=48:00:00',countspath=config['project']['COUNTSPATH'],refer=config['project']['annotation'],dir=config['project']['workpath'],projDesc=config['project']['description'],projectId=config['project']['id'],mattype=config['project']['MATTYPE'],docycleregress=config['project']['DOCYCLEREGRESS'],sd=subdir
     output: 
      out1=join(workpath,subdir,"{name}/","{pid}.{name}_scrna_initial.html"),
      out2=join(workpath,subdir,"{name}/","{pid}.{name}_initial_seurat_object.rds")
     shell: "mkdir -p {params.dir}/{params.sd}/{wildcards.name}; cp Scripts/scrna_initial.Rmd {params.dir}/{params.sd}/{wildcards.name}/; module load R/3.5; Rscript Scripts/scrna_initial_call.R '{params.dir}/{params.sd}/{wildcards.name}' '{params.countspath}/{wildcards.name}.rds' '{params.refer}' '{params.projectId}.{wildcards.name}' '{params.projDesc}' '{params.mattype}' '{params.docycleregress}'"


rule scrna_jackstraw: 
   params: rname='pl:scrnajackstraw',batch='--partition=ccr,norm --cpus-per-task=4 --mem=100g --time=48:00:00',dir=config['project']['workpath'],projDesc=config['project']['description'],projectId=config['project']['id'],sd=subdir
   input: so=join(workpath,subdir,"{name}/","{pid}.{name}_initial_seurat_object.rds")
   output:
    out1=join(workpath,subdir,"{name}/","{pid}.{name}_scrna_jackstraw.html"),
    out2=join(workpath,subdir,"{name}/","{pid}.{name}_jackstraw_seurat_object.rds")
   shell: "cp Scripts/scrna_jackstraw.Rmd {params.dir}/{params.sd}/{wildcards.name}/; module load R/3.5; Rscript Scripts/scrna_jackstraw_call.R '{params.dir}/{params.sd}/{wildcards.name}' '{input.so}' '{params.projectId}.{wildcards.name}' '{params.projDesc}'"

rule scrna_cluster: 
   params: rname='pl:scrnacluster',batch='--partition=ccr,norm --cpus-per-task=4 --mem=100g --time=48:00:00',dir=config['project']['workpath'],pcs=config['project']['PCS'],resolution=config['project']['RESOLUTION'],projDesc=config['project']['description'],projectId=config['project']['id'],sd=subdir
   input: so=join(workpath,subdir,"{name}/","{pid}.{name}_initial_seurat_object.rds")
   output:
    out1=join(workpath,subdir,"{name}/","{pid}.{name}"+"_scrna_cluster_{pcs}_{resolution}.html".format(pcs=config['project']['PCS'],resolution=config['project']['RESOLUTION'])),
    out2=join(workpath,subdir,"{name}/","{pid}.{name}"+"_cluster_seurat_object_{pcs}_{resolution}.rds".format(pcs=config['project']['PCS'],resolution=config['project']['RESOLUTION']))
   shell: "cp Scripts/scrna_cluster.Rmd {params.dir}/{params.sd}/{wildcards.name}/; module load R/3.5; Rscript Scripts/scrna_cluster_call.R '{params.dir}/{params.sd}/{wildcards.name}' '{input.so}' '{params.pcs}' '{params.resolution}' '{params.projectId}.{wildcards.name}' '{params.projDesc}'"

rule scrna_cca: 
   params: rname='pl:scrnacca',batch='--partition=ccr,norm --cpus-per-task=4 --mem=100g --time=48:00:00',dir=config['project']['workpath'],projDesc=config['project']['description'],projectId=config['project']['id'],groups=" ".join(config['project']['groups']['rgroups']),sd=subdir
   input: all_so=expand(join(workpath,subdir,"{name}/","{pid}.{name}_initial_seurat_object.rds"),pid=pid,name=samples)
   output:
    out1=join(workpath,subdir,"combined_cca/","{pid}_scrna_cca.html"),
    out2=join(workpath,subdir,"combined_cca/","{pid}_combined_cca_seurat_object.rds")
   shell: "mkdir -p {params.dir}/{params.sd}/combined_cca; cp Scripts/scrna_cca.Rmd {params.dir}/{params.sd}/combined_cca/; module load R/3.5; Rscript Scripts/scrna_cca_call.R '{params.dir}/{params.sd}/combined_cca' '{input.all_so}' '{params.groups}' '{params.projectId}' '{params.projDesc}'"

rule scrna_multicluster: 
   params: rname='pl:scrnamulticluster',batch='--partition=ccr,norm --cpus-per-task=4 --mem=100g --time=48:00:00',dir=config['project']['workpath'],pcs=config['project']['PCS'],resolution=config['project']['RESOLUTION'],projDesc=config['project']['description'],projectId=config['project']['id'],sd=subdir
   input: so=join(workpath,subdir,"combined_cca/","{pid}_combined_cca_seurat_object.rds")
   output:
    out1=join(workpath,subdir,"combined_cca/","{pid}"+"_scrna_multicluster_{pcs}_{resolution}.html".format(pcs=config['project']['PCS'],resolution=config['project']['RESOLUTION'])),
    out2=join(workpath,subdir,"combined_cca/","{pid}"+"_combined_cluster_seurat_object_{pcs}_{resolution}.rds".format(pcs=config['project']['PCS'],resolution=config['project']['RESOLUTION']))
   shell: "cp Scripts/scrna_multicluster.Rmd {params.dir}/{params.sd}/combined_cca/; module load R/3.5; Rscript Scripts/scrna_multicluster_call.R '{params.dir}/{params.sd}/combined_cca' '{input.so}' '{params.pcs}' '{params.resolution}' '{params.projectId}' '{params.projDesc}'"
