# Set a global container for all rules
#container: "rocker/r-ver:4.0.5"  # Example: A Docker image with R


configfile: "config.yaml"

rule all:
    input:
        expand("output/{version}/5-Clustering.html", version=config["filtering_versions"].keys()),
        expand("output/{version}/clustering.rds", version=config["filtering_versions"].keys())

rule filtering_QC:
    input:
        rmd="1-Filtering_QC.Rmd",
        data_dir="input/filtered_gene_bc_matrices/hg19"
    output:
        html="output/{version}/1-Filter_qc.html",
        rds="output/{version}/filtered_pbmc.rds"
    params:
        filtering_params = lambda wildcards: ", ".join(f"{k}={v}" for k, v in config["filtering_versions"][wildcards.version]["params"].items())
    shell:
        """
        Rscript -e "rmarkdown::render('{input.rmd}', output_file='{output.html}', params=list(data_dir='{input.data_dir}', output_rds='{output.rds}', {params.filtering_params}))"
        """

rule normalize:
    input:
        rmd="2-Normalization.Rmd",
        rds="output/{version}/filtered_pbmc.rds"
    output:
        html="output/{version}/2-Normalize.html",
        rds="output/{version}/normalized_pbmc.rds"
    shell:
        """
        Rscript -e "rmarkdown::render('{input.rmd}', output_file='{output.html}', params=list(input_rds='{input.rds}', output_rds='{output.rds}'))"
        """

rule variable_features:
    input:
        rmd="3-HVF.Rmd",
        rds="output/{version}/normalized_pbmc.rds"
    output:
        html="output/{version}/3-Variable_features.html",
        rds="output/{version}/variable_features.rds"
    params:
        features_params = lambda wildcards: ", ".join(f"{k}={v}" for k, v in config["variable_features"]["params"].items())
    shell:
        """
        Rscript -e "rmarkdown::render('{input.rmd}', output_file='{output.html}', params=list(input_rds='{input.rds}', output_rds='{output.rds}', {params.features_params}))"
        """

rule dim_reduction:
    input:
        rmd="4-Dimensionality reduction.Rmd",
        rds="output/{version}/variable_features.rds"
    output:
        html="output/{version}/4-Dim_reduction.html",
        rds="output/{version}/dim_reduction.rds"
    shell:
        """
        Rscript -e "rmarkdown::render('{input.rmd}', output_file='{output.html}', params=list(input_rds='{input.rds}', output_rds='{output.rds}'))"
        """

rule clustering:
    input:
        rmd="5-Clustering.Rmd",
        rds="output/{version}/dim_reduction.rds"
    output:
        html="output/{version}/5-Clustering.html",
        rds="output/{version}/clustering.rds"
    params:
        pca_params = lambda wildcards: ", ".join(f"{k}={v}" for k, v in config["pca"]["params"].items())
    shell:
        """
        Rscript -e "rmarkdown::render('{input.rmd}', output_file='{output.html}', params=list(input_rds='{input.rds}', output_rds='{output.rds}', {params.pca_params}))"
        """

rule merge_htmls:
    input:
        htmls=lambda wildcards: list(Path("output").rglob("*.html"))
    output:
        "output/index.html"
    shell:
        "python merge_htmls.py"
