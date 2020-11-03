ARRAY = range(1, 3)

rule all:
	input:
		expand("outputs/sorted.chr{chr}.vcf.gz.tbi", chr=ARRAY),

rule bcftools:
	input:
		"inputs/chr{chr}.vcf",
	output:
		temp("outputs/bcftools/chr.{chr}.sorted.vcf"),
	shell:
		"bcftools sort {input} -o {output}"

rule bgzip:
	input:
		rules.bcftools.output
	output:
		"outputs/sorted.chr{chr}.vcf.gz",
	shell:
		"bgzip -c {input} > {output}"

rule tabix:
	input:
		rules.bgzip.output,
	output:
		"outputs/sorted.chr{chr}.vcf.gz.tbi",
	shell:
		"tabix -p vcf {input}"

