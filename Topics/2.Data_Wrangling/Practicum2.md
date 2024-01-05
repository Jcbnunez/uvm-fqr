<!DOCTYPE html>
<html>

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Topic2: Genome Manipulation in Unix</title>
  <link rel="stylesheet" href="https://stackedit.io/style.css" />
</head>

<body class="stackedit">
  <div class="stackedit__html"><h1 id="data-challenge-my-genome-file-and-my-annotation-file-do-not-match-mon-dieu"><em>Data challenge</em> my genome file and my annotation file do not match! <em>mon dieu!</em></h1>
<p>A problem as old as time (not really, but humor me). As computational biologists we are often interested in investigating DNA sequences not just at the level of nucleotides but their potential funtional consequences. The challenge, however, is that, due to the inherent data complexity of DNA data, sequence data, variation data, and functional data are stored in different format that may not integrate into each other in an intuitive way. For example</p>
<ol>
<li>The <em>standard</em> way of storing DNA sequences is the FASTA file</li>
</ol>
<pre><code>&gt;NAME of sequences (e.g., "chromosome 2L" gene, chromosome scaffold); ind1"
ACTGACTGACTGCGTGGCC...
&gt;NAME of sequences (e.g., "chromosome 2L" gene, chromosome scaffold); ind2"
ACTGACTGACTGCGCGGCC...
&gt;NAME of sequences (e.g., "chromosome 2L" gene, chromosome scaffold); ind3"
ACTGACTGACTGCCTGGCC...
</code></pre>
<ol start="2">
<li>The <em>standard</em> way of storing variation among sequences is the VCF file</li>
</ol>
<pre><code>&gt;##fileformat=VCFv4.3
##fileDate=...
##source=...
##reference=...
##contig=&lt;taxonomy=info&gt;
##phasing=....
##INFO=&lt;....&gt;
##FILTER=&lt;....&gt;
##FORMAT=&lt;....&gt;
</code></pre>

<table>
<thead>
<tr>
<th>CHROM</th>
<th>POS</th>
<th>ID</th>
<th>REF</th>
<th>ALT</th>
<th>QUAL</th>
<th>FILTER</th>
<th>INFO</th>
<th>FORMAT</th>
<th>ind1</th>
<th>ind2</th>
<th>ind3</th>
</tr>
</thead>
<tbody>
<tr>
<td>X</td>
<td>12345</td>
<td>snp_111</td>
<td>G</td>
<td>A</td>
<td>29</td>
<td>PASS</td>
<td>NS=3;DP=14;AF=0.5;DB;H2</td>
<td>GT:GQ:DP:HQ</td>
<td>0/0:48:1:51,51</td>
<td>1/0:48:8:51,51</td>
<td>1/1:43:5:.,.</td>
</tr>
<tr>
<td>2L</td>
<td>1258</td>
<td>snp_125</td>
<td>C</td>
<td>T</td>
<td>29</td>
<td>PASS</td>
<td>NS=3;DP=14;AF=0.5;DB;H2</td>
<td>GT:GQ:DP:HQ</td>
<td>0/0:89:1:25,51</td>
<td>0/1:48:8:78,51</td>
<td>1/0:43:5:.,.</td>
</tr>
</tbody>
</table><ol start="3">
<li>The <em>standard</em> way of storing annotations in genomes is some form of GFF file (gene/generic/general feature files; or similar)</li>
</ol>

<table>
<thead>
<tr>
<th>seqid</th>
<th>source</th>
<th>type</th>
<th>start</th>
<th>end</th>
<th>score</th>
<th>strand</th>
<th>phase</th>
<th>attributes</th>
</tr>
</thead>
<tbody>
<tr>
<td>chr2L</td>
<td>MAKER</td>
<td>gene</td>
<td>5600</td>
<td>8900</td>
<td>0.95</td>
<td>+</td>
<td>2</td>
<td>gene QXD1</td>
</tr>
<tr>
<td>chr3R</td>
<td>BUSCO</td>
<td>exon</td>
<td>15899</td>
<td>157800</td>
<td>0.65</td>
<td>-</td>
<td>0</td>
<td>gene ppk785</td>
</tr>
</tbody>
</table><h2 id="case-study-for-pycnopodia">Case study for <em>Pycnopodia</em></h2>
<p><strong>A haplotype of interest</strong>: A study in the sea star <em>Pycnopodia</em> has identified several genes of  interest. We would like to extract these genes from the genome of pycno for further study.</p>
<p>I have already downloaded the genome from NCBI and have stored it in our shared VACC repository.</p>
<pre><code>ls /gpfs1/cl/biol6990/prac2/pycno_genome.fasta
</code></pre>
<h2 id="adquiring-the-genome">Adquiring the genome</h2>
<ol>
<li>Move to your scratch directory <strong>(known skill!)</strong></li>
<li>create a working folder for this challenge</li>
</ol>
<pre><code>mkdir pycno_challenge
</code></pre>
<ol start="3">
<li>move into your new folder</li>
</ol>
<pre><code>cd pycno_challenge
</code></pre>
<ol start="4">
<li>Check what is inside this new folder</li>
</ol>
<pre><code>ls -l ./
##this is the same as just ls -l
</code></pre>
<ol start="5">
<li>Copy the genome from the repo to your folder</li>
</ol>
<pre><code>cp /gpfs1/cl/biol6990/prac2/pycno_genome.fasta ./
## cp &lt;from+file&gt; &lt;to&gt;
</code></pre>
<ol start="6">
<li>Check what is inside this new folder… again.</li>
</ol>
<pre><code>ls -l ./
</code></pre>
<h2 id="exploring-the-genome">Exploring the genome</h2>
<p>Explore the heads and tails command</p>
<pre><code>head -n 50 pycno_genome.fasta
## head -n &lt;nlines&gt; &lt;file&gt;
</code></pre>
<pre><code>tail -n 50 pycno_genome.fasta
## tail -n &lt;nlines&gt; &lt;file&gt;
</code></pre>
<h2 id="adquiring-the-gene-feature-file">Adquiring the gene feature file</h2>
<pre><code>cp /netfiles/nunezlab/FQR_files/GeneFeatureFile.gtf
head -n 10 GeneFeatureFile.gtf
</code></pre>
<p>Do we observe something strange?  … What is going on?</p>
<h2 id="emailing-the-author...">Emailing the author…</h2>
<p><strong>You</strong>: Dear author, I am interested in conducting follow up analyses on the genome of <em>Pycnopodia</em> that you published in 2018. I am interested in extracting  some loci. Yet, when I download the genome from NCBI, the chromosomes are labebled with the standard NCBI genomic nomenclature (JASTWB0100…) and I cannot cross-validate scaffold “pycn_heli.0008”. Do you have any thoughts about how to cross-validate scaffolds?</p>
<hr>
<p><strong>Author</strong>: Dear X, my appologies that you are experiencing this road block! Our analyses was conducted before the genome was made public using our own chromosome nomenclature. Here is a file with the corresponding association of the “pycn_heli” names with the JASTWB ids.</p>
<pre><code>cp /gpfs1/cl/biol6990/prac2/JASTWB01_contigs.tsv ./
</code></pre>
<hr>
<h2 id="exploring-the-corresponding-file">Exploring the corresponding file</h2>
<pre><code>head JASTWB01_contigs.tsv
</code></pre>
<h1 id="what-to-do">What to do?</h1>
<pre class=" language-mermaid"><svg id="mermaid-svg-bENpKMuBhqbNskie" width="100%" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" height="159.4375" style="max-width: 627.96875px;" viewBox="0 0 627.96875 159.4375"><style>#mermaid-svg-bENpKMuBhqbNskie{font-family:"trebuchet ms",verdana,arial,sans-serif;font-size:16px;fill:#000000;}#mermaid-svg-bENpKMuBhqbNskie .error-icon{fill:#552222;}#mermaid-svg-bENpKMuBhqbNskie .error-text{fill:#552222;stroke:#552222;}#mermaid-svg-bENpKMuBhqbNskie .edge-thickness-normal{stroke-width:2px;}#mermaid-svg-bENpKMuBhqbNskie .edge-thickness-thick{stroke-width:3.5px;}#mermaid-svg-bENpKMuBhqbNskie .edge-pattern-solid{stroke-dasharray:0;}#mermaid-svg-bENpKMuBhqbNskie .edge-pattern-dashed{stroke-dasharray:3;}#mermaid-svg-bENpKMuBhqbNskie .edge-pattern-dotted{stroke-dasharray:2;}#mermaid-svg-bENpKMuBhqbNskie .marker{fill:#666;stroke:#666;}#mermaid-svg-bENpKMuBhqbNskie .marker.cross{stroke:#666;}#mermaid-svg-bENpKMuBhqbNskie svg{font-family:"trebuchet ms",verdana,arial,sans-serif;font-size:16px;}#mermaid-svg-bENpKMuBhqbNskie .label{font-family:"trebuchet ms",verdana,arial,sans-serif;color:#000000;}#mermaid-svg-bENpKMuBhqbNskie .cluster-label text{fill:#333;}#mermaid-svg-bENpKMuBhqbNskie .cluster-label span{color:#333;}#mermaid-svg-bENpKMuBhqbNskie .label text,#mermaid-svg-bENpKMuBhqbNskie span{fill:#000000;color:#000000;}#mermaid-svg-bENpKMuBhqbNskie .node rect,#mermaid-svg-bENpKMuBhqbNskie .node circle,#mermaid-svg-bENpKMuBhqbNskie .node ellipse,#mermaid-svg-bENpKMuBhqbNskie .node polygon,#mermaid-svg-bENpKMuBhqbNskie .node path{fill:#eee;stroke:#999;stroke-width:1px;}#mermaid-svg-bENpKMuBhqbNskie .node .label{text-align:center;}#mermaid-svg-bENpKMuBhqbNskie .node.clickable{cursor:pointer;}#mermaid-svg-bENpKMuBhqbNskie .arrowheadPath{fill:#333333;}#mermaid-svg-bENpKMuBhqbNskie .edgePath .path{stroke:#666;stroke-width:1.5px;}#mermaid-svg-bENpKMuBhqbNskie .flowchart-link{stroke:#666;fill:none;}#mermaid-svg-bENpKMuBhqbNskie .edgeLabel{background-color:white;text-align:center;}#mermaid-svg-bENpKMuBhqbNskie .edgeLabel rect{opacity:0.5;background-color:white;fill:white;}#mermaid-svg-bENpKMuBhqbNskie .cluster rect{fill:hsl(210,66.6666666667%,95%);stroke:#26a;stroke-width:1px;}#mermaid-svg-bENpKMuBhqbNskie .cluster text{fill:#333;}#mermaid-svg-bENpKMuBhqbNskie .cluster span{color:#333;}#mermaid-svg-bENpKMuBhqbNskie div.mermaidTooltip{position:absolute;text-align:center;max-width:200px;padding:2px;font-family:"trebuchet ms",verdana,arial,sans-serif;font-size:12px;background:hsl(-160,0%,93.3333333333%);border:1px solid #26a;border-radius:2px;pointer-events:none;z-index:100;}#mermaid-svg-bENpKMuBhqbNskie:root{--mermaid-font-family:"trebuchet ms",verdana,arial,sans-serif;}#mermaid-svg-bENpKMuBhqbNskie flowchart{fill:apa;}</style><g><g class="output"><g class="clusters"></g><g class="edgePaths"><g class="edgePath LS-A LE-B" id="L-A-B" style="opacity: 1;"><path class="path" d="M62.875,71.83250719725112L203.6875,31.359375L344.5,31.359375" marker-end="url(https://stackedit.io/app#arrowhead622)" style="fill:none"></path><defs><marker id="arrowhead622" viewBox="0 0 10 10" refX="9" refY="5" markerUnits="strokeWidth" markerWidth="8" markerHeight="6" orient="auto"><path d="M 0 0 L 10 5 L 0 10 z" class="arrowheadPath" style="stroke-width: 1; stroke-dasharray: 1, 0;"></path></marker></defs></g><g class="edgePath LS-A LE-C" id="L-A-C" style="opacity: 1;"><path class="path" d="M62.875,87.60499280274888L203.6875,128.078125L390.4921875,128.078125" marker-end="url(https://stackedit.io/app#arrowhead623)" style="fill:none"></path><defs><marker id="arrowhead623" viewBox="0 0 10 10" refX="9" refY="5" markerUnits="strokeWidth" markerWidth="8" markerHeight="6" orient="auto"><path d="M 0 0 L 10 5 L 0 10 z" class="arrowheadPath" style="stroke-width: 1; stroke-dasharray: 1, 0;"></path></marker></defs></g></g><g class="edgeLabels"><g class="edgeLabel" transform="translate(203.6875,31.359375)" style="opacity: 1;"><g transform="translate(-84.1171875,-13.359375)" class="label"><rect rx="0" ry="0" width="168.234375" height="26.71875"></rect><foreignObject width="168.234375" height="26.71875"><div xmlns="http://www.w3.org/1999/xhtml" style="display: inline-block; white-space: nowrap;"><span id="L-L-A-B" class="edgeLabel L-LS-A' L-LE-B">Manual local extraction</span></div></foreignObject></g></g><g class="edgeLabel" transform="translate(203.6875,128.078125)" style="opacity: 1;"><g transform="translate(-115.8125,-13.359375)" class="label"><rect rx="0" ry="0" width="231.625" height="26.71875"></rect><foreignObject width="231.625" height="26.71875"><div xmlns="http://www.w3.org/1999/xhtml" style="display: inline-block; white-space: nowrap;"><span id="L-L-A-C" class="edgeLabel L-LS-A' L-LE-C">Global relabeling of the genome</span></div></foreignObject></g></g></g><g class="nodes"><g class="node default" id="flowchart-A-4640" transform="translate(35.4375,79.71875)" style="opacity: 1;"><rect rx="0" ry="0" x="-27.4375" y="-23.359375" width="54.875" height="46.71875" class="label-container"></rect><g class="label" transform="translate(0,0)"><g transform="translate(-17.4375,-13.359375)"><foreignObject width="34.875" height="26.71875"><div xmlns="http://www.w3.org/1999/xhtml" style="display: inline-block; white-space: nowrap;">DATA</div></foreignObject></g></g></g><g class="node default" id="flowchart-B-4641" transform="translate(482.234375,31.359375)" style="opacity: 1;"><rect rx="5" ry="5" x="-137.734375" y="-23.359375" width="275.46875" height="46.71875" class="label-container"></rect><g class="label" transform="translate(0,0)"><g transform="translate(-127.734375,-13.359375)"><foreignObject width="255.46875" height="26.71875"><div xmlns="http://www.w3.org/1999/xhtml" style="display: inline-block; white-space: nowrap;">Output just the chromosome I want</div></foreignObject></g></g></g><g class="node default" id="flowchart-C-4643" transform="translate(482.234375,128.078125)" style="opacity: 1;"><rect rx="5" ry="5" x="-91.7421875" y="-23.359375" width="183.484375" height="46.71875" class="label-container"></rect><g class="label" transform="translate(0,0)"><g transform="translate(-81.7421875,-13.359375)"><foreignObject width="163.484375" height="26.71875"><div xmlns="http://www.w3.org/1999/xhtml" style="display: inline-block; white-space: nowrap;">All genome is renamed</div></foreignObject></g></g></g></g></g></g></svg></pre>
<p>What is  the <strong>best use of your time</strong>? … What is the <strong>best use of <em>future you’s</em> time</strong>? For example what about if later on you want to look at many other loci… or if you had multiple loci to extract to begin with. I submit to you that a global solution that re-labels the genome is the overall most efficient solution, despite having a larger initial investment (i.e., having to code the relabeling pipeline) it will be an overall more efficient use of research resources.</p>
<h2 id="breaking-down-the-code-lets-take-a-reverse-engineering-approach.">Breaking down the code (lets take a reverse engineering approach!).</h2>
<p>Lets break down what is going on here … the <em>stack overflow</em> approach!</p>
<blockquote>
<p><strong>lets talk about stack overflow</strong> for one minute…</p>
</blockquote>
<pre><code>master_file=./JASTWB01_contigs.tsv
working_file=./pycno_genome.fasta 

cp $working_file ./pycno_genome_modnames.fasta

ith=$(cat $master_file | sed '1d' | wc -l)

for i in $(seq $ith)
 do
  name1=$(cat $master_file |  sed '1d' | awk '{print $1}' | sed "${i}q;d" )
  name2=$(cat $master_file |  sed '1d' | awk '{print $2}' | sed "${i}q;d" )
   echo "im an changing " $name2 " to " $name1 " as per " $i
   sed -E -i "s/${name2}.+/${name1}/g" pycno_genome_modnames.fasta
 done
</code></pre>
<h3 id="annotated-code...">Annotated code…</h3>
<pre><code>### Variables declared by the user... &lt;more details&gt;
master_file=./JASTWB01_contigs.tsv
working_file=./pycno_genome.fasta 

### File generated in situ (to create data redundancy!; failsafe) ... &lt;more details&gt;
cp $working_file ./pycno_genome_modnames.fasta

### Create a varible with number of itherations ... &lt;more details
ith=$(cat $master_file | sed '1d' | wc -l)

### Loop around the genome to rename all the chromosomes to a different name
for i in $(seq $ith)
 do
  name1=$(cat $master_file |  sed '1d' | awk '{print $1}' | sed "${i}q;d" )
  name2=$(cat $master_file |  sed '1d' | awk '{print $2}' | sed "${i}q;d" )
   echo "im an changing " $name2 " to " $name1 " as per " $i
   sed -E -i "s/${name2}.+/${name1}/g" pycno_genome_modnames.fasta
 done
</code></pre>
<h2 id="what-are-the-parts-of-the-code">What are the parts of the code?</h2>
<h3 id="variables-declared-by-the-user">Variables declared by the user</h3>
<pre><code>master_file=./JASTWB01_contigs.tsv
working_file=./pycno_genome.fasta 
</code></pre>
<p>here we are declaring environmental variables. This is a convient way to pass information to our script, code, multiple times while having user provided imput just once. Imagine how cumbersone it would to have to change one small paramter 30 times across a script… vs. declaring a global parameter once … and changing just that!</p>
<p>In unix, variables are often declared with the <code>=</code> simbol and recalled with the <code>$</code> symbol. We can always spot check a variable using <code>echo</code>. lets explore some variables… <strong>NO SPACES ALLOWED between <code>=</code> and the other stuff!</strong></p>
<h3 id="file-generated-in-situ-to-create-data-redundancy-failsafe">File generated in situ (to create data redundancy!; <em>failsafe</em>)</h3>
<p>Why is the code asking us to do this? The reality is that it is not necessary but it is a failsafe custom. Basically, the way this code works, it constantly overwrites the original file. What about if we get this wrong? An easy solution is to introduce redundancy and safety copies to the process.</p>
<pre><code>cp $working_file ./pycno_genome_modnames.fasta
</code></pre>
<h4 id="commands-to-keep-in-mind">Commands to keep in mind:</h4>
<ol>
<li><code>cp</code> copy <code>cp &lt;file&gt; &lt;location&gt;</code></li>
<li><code>mv</code> move or (oddly) rename <code>mv &lt;file&gt; &lt;location&gt;</code></li>
</ol>
<h3 id="create-a-varible-with-number-of-itherations--introduction-to-loops">Create a varible with number of itherations &amp; introduction to loops</h3>
<p>Before we can get at what the the <code>ith</code> varaiable means, we first need to take a deep dive into <em>loops</em>.</p>
<pre><code>ith=$(cat $master_file | sed '1d' | wc -l)
</code></pre>
<pre class=" language-mermaid"><svg id="mermaid-svg-Da4EXb1Gtt0TUg5g" width="100%" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" height="89.4375" style="max-width: 581.5625px;" viewBox="0 0 581.5625 89.4375"><style>#mermaid-svg-Da4EXb1Gtt0TUg5g{font-family:"trebuchet ms",verdana,arial,sans-serif;font-size:16px;fill:#000000;}#mermaid-svg-Da4EXb1Gtt0TUg5g .error-icon{fill:#552222;}#mermaid-svg-Da4EXb1Gtt0TUg5g .error-text{fill:#552222;stroke:#552222;}#mermaid-svg-Da4EXb1Gtt0TUg5g .edge-thickness-normal{stroke-width:2px;}#mermaid-svg-Da4EXb1Gtt0TUg5g .edge-thickness-thick{stroke-width:3.5px;}#mermaid-svg-Da4EXb1Gtt0TUg5g .edge-pattern-solid{stroke-dasharray:0;}#mermaid-svg-Da4EXb1Gtt0TUg5g .edge-pattern-dashed{stroke-dasharray:3;}#mermaid-svg-Da4EXb1Gtt0TUg5g .edge-pattern-dotted{stroke-dasharray:2;}#mermaid-svg-Da4EXb1Gtt0TUg5g .marker{fill:#666;stroke:#666;}#mermaid-svg-Da4EXb1Gtt0TUg5g .marker.cross{stroke:#666;}#mermaid-svg-Da4EXb1Gtt0TUg5g svg{font-family:"trebuchet ms",verdana,arial,sans-serif;font-size:16px;}#mermaid-svg-Da4EXb1Gtt0TUg5g .label{font-family:"trebuchet ms",verdana,arial,sans-serif;color:#000000;}#mermaid-svg-Da4EXb1Gtt0TUg5g .cluster-label text{fill:#333;}#mermaid-svg-Da4EXb1Gtt0TUg5g .cluster-label span{color:#333;}#mermaid-svg-Da4EXb1Gtt0TUg5g .label text,#mermaid-svg-Da4EXb1Gtt0TUg5g span{fill:#000000;color:#000000;}#mermaid-svg-Da4EXb1Gtt0TUg5g .node rect,#mermaid-svg-Da4EXb1Gtt0TUg5g .node circle,#mermaid-svg-Da4EXb1Gtt0TUg5g .node ellipse,#mermaid-svg-Da4EXb1Gtt0TUg5g .node polygon,#mermaid-svg-Da4EXb1Gtt0TUg5g .node path{fill:#eee;stroke:#999;stroke-width:1px;}#mermaid-svg-Da4EXb1Gtt0TUg5g .node .label{text-align:center;}#mermaid-svg-Da4EXb1Gtt0TUg5g .node.clickable{cursor:pointer;}#mermaid-svg-Da4EXb1Gtt0TUg5g .arrowheadPath{fill:#333333;}#mermaid-svg-Da4EXb1Gtt0TUg5g .edgePath .path{stroke:#666;stroke-width:1.5px;}#mermaid-svg-Da4EXb1Gtt0TUg5g .flowchart-link{stroke:#666;fill:none;}#mermaid-svg-Da4EXb1Gtt0TUg5g .edgeLabel{background-color:white;text-align:center;}#mermaid-svg-Da4EXb1Gtt0TUg5g .edgeLabel rect{opacity:0.5;background-color:white;fill:white;}#mermaid-svg-Da4EXb1Gtt0TUg5g .cluster rect{fill:hsl(210,66.6666666667%,95%);stroke:#26a;stroke-width:1px;}#mermaid-svg-Da4EXb1Gtt0TUg5g .cluster text{fill:#333;}#mermaid-svg-Da4EXb1Gtt0TUg5g .cluster span{color:#333;}#mermaid-svg-Da4EXb1Gtt0TUg5g div.mermaidTooltip{position:absolute;text-align:center;max-width:200px;padding:2px;font-family:"trebuchet ms",verdana,arial,sans-serif;font-size:12px;background:hsl(-160,0%,93.3333333333%);border:1px solid #26a;border-radius:2px;pointer-events:none;z-index:100;}#mermaid-svg-Da4EXb1Gtt0TUg5g:root{--mermaid-font-family:"trebuchet ms",verdana,arial,sans-serif;}#mermaid-svg-Da4EXb1Gtt0TUg5g flowchart{fill:apa;}</style><g><g class="output"><g class="clusters"></g><g class="edgePaths"><g class="edgePath LS-B LE-C" id="L-B-C" style="opacity: 1;"><path class="path" d="M169.671875,31.90261695344398L236.171875,21.359375L302.671875,36.450070203400124" marker-end="url(https://stackedit.io/app#arrowhead624)" style="fill:none"></path><defs><marker id="arrowhead624" viewBox="0 0 10 10" refX="9" refY="5" markerUnits="strokeWidth" markerWidth="8" markerHeight="6" orient="auto"><path d="M 0 0 L 10 5 L 0 10 z" class="arrowheadPath" style="stroke-width: 1; stroke-dasharray: 1, 0;"></path></marker></defs></g><g class="edgePath LS-C LE-A" id="L-C-A" style="opacity: 1;"><path class="path" d="M375.546875,44.71875L435.109375,44.71875L494.671875,44.71875" marker-end="url(https://stackedit.io/app#arrowhead625)" style="fill:none"></path><defs><marker id="arrowhead625" viewBox="0 0 10 10" refX="9" refY="5" markerUnits="strokeWidth" markerWidth="8" markerHeight="6" orient="auto"><path d="M 0 0 L 10 5 L 0 10 z" class="arrowheadPath" style="stroke-width: 1; stroke-dasharray: 1, 0;"></path></marker></defs></g><g class="edgePath LS-C LE-B" id="L-C-B" style="opacity: 1;"><path class="path" d="M302.671875,52.987429796599876L236.171875,68.078125L169.671875,57.53488304655602" marker-end="url(https://stackedit.io/app#arrowhead626)" style="fill:none"></path><defs><marker id="arrowhead626" viewBox="0 0 10 10" refX="9" refY="5" markerUnits="strokeWidth" markerWidth="8" markerHeight="6" orient="auto"><path d="M 0 0 L 10 5 L 0 10 z" class="arrowheadPath" style="stroke-width: 1; stroke-dasharray: 1, 0;"></path></marker></defs></g></g><g class="edgeLabels"><g class="edgeLabel" transform="translate(236.171875,21.359375)" style="opacity: 1;"><g transform="translate(-41.5,-13.359375)" class="label"><rect rx="0" ry="0" width="83" height="26.71875"></rect><foreignObject width="83" height="26.71875"><div xmlns="http://www.w3.org/1999/xhtml" style="display: inline-block; white-space: nowrap;"><span id="L-L-B-C" class="edgeLabel L-LS-B' L-LE-C">pick a label</span></div></foreignObject></g></g><g class="edgeLabel" transform="translate(435.109375,44.71875)" style="opacity: 1;"><g transform="translate(-34.5625,-13.359375)" class="label"><rect rx="0" ry="0" width="69.125" height="26.71875"></rect><foreignObject width="69.125" height="26.71875"><div xmlns="http://www.w3.org/1999/xhtml" style="display: inline-block; white-space: nowrap;"><span id="L-L-C-A" class="edgeLabel L-LS-C' L-LE-A">overwrite</span></div></foreignObject></g></g><g class="edgeLabel" transform="translate(236.171875,68.078125)" style="opacity: 1;"><g transform="translate(-23.671875,-13.359375)" class="label"><rect rx="0" ry="0" width="47.34375" height="26.71875"></rect><foreignObject width="47.34375" height="26.71875"><div xmlns="http://www.w3.org/1999/xhtml" style="display: inline-block; white-space: nowrap;"><span id="L-L-C-B" class="edgeLabel L-LS-C' L-LE-B">repeat</span></div></foreignObject></g></g></g><g class="nodes"><g class="node default" id="flowchart-A-4653" transform="translate(534.1171875,44.71875)" style="opacity: 1;"><rect rx="0" ry="0" x="-39.4453125" y="-23.359375" width="78.890625" height="46.71875" class="label-container"></rect><g class="label" transform="translate(0,0)"><g transform="translate(-29.4453125,-13.359375)"><foreignObject width="58.890625" height="26.71875"><div xmlns="http://www.w3.org/1999/xhtml" style="display: inline-block; white-space: nowrap;">Genome</div></foreignObject></g></g></g><g class="node default" id="flowchart-B-4654" transform="translate(88.8359375,44.71875)" style="opacity: 1;"><rect rx="0" ry="0" x="-80.8359375" y="-23.359375" width="161.671875" height="46.71875" class="label-container"></rect><g class="label" transform="translate(0,0)"><g transform="translate(-70.8359375,-13.359375)"><foreignObject width="141.671875" height="26.71875"><div xmlns="http://www.w3.org/1999/xhtml" style="display: inline-block; white-space: nowrap;">Correspondance list</div></foreignObject></g></g></g><g class="node default" id="flowchart-C-4655" transform="translate(339.109375,44.71875)" style="opacity: 1;"><rect rx="0" ry="0" x="-36.4375" y="-23.359375" width="72.875" height="46.71875" class="label-container"></rect><g class="label" transform="translate(0,0)"><g transform="translate(-26.4375,-13.359375)"><foreignObject width="52.875" height="26.71875"><div xmlns="http://www.w3.org/1999/xhtml" style="display: inline-block; white-space: nowrap;">Relabel</div></foreignObject></g></g></g></g></g></g></svg></pre>
<h4 id="a-basic-loop-1">A basic loop 1</h4>
<pre><code>for i in A B C
do
echo $i
done
</code></pre>
<h4 id="creating-a-sequence-with-seq">Creating a sequence with <code>seq</code></h4>
<pre><code>seq 10
#seq --help
</code></pre>
<h4 id="a-basic-loop-2">A basic loop 2</h4>
<pre><code>for i in $(seq 10)
do
echo $i
done
</code></pre>
<p>Here we are using the power of the <code>$()</code> construction to transform the output of the <code>seq</code> function into a variable that is, at the same time, the input of the loop itself. This reveals the first path to “scaling up the code” because we can <strong>nest</strong> these variables into each other… <code>$(seq $a)</code>.</p>
<pre><code>a=15
for i in $(seq $a)
do
echo $i
done
</code></pre>
<h4 id="on-local-vs.-global-variables">On local vs. global variables</h4>
<p>Notice that our loop has two variables… it has <code>a</code>, that is globally set, and it has <code>i</code>, that iterates inside the loop… <strong>keep track of your variables!</strong></p>
<h3 id="what-does-loops-have-to-do-with-ith">What does <em>loops</em> have to do with <code>ith</code></h3>
<p>At this point we have covered loops. Yet, notice that we have always given the loop… either the actual objects to iterate over (<code>A B C</code>) or a number of given iterations <code>seq 15</code>. What about if we dont know how many iteration our loop may need?  That is the purpose of defining <code>ith</code></p>
<pre><code>master_file=./JASTWB01_contigs.tsv
ith=$(cat $master_file | sed '1d' | wc -l)
</code></pre>
<h4 id="the-layers-of-ith">The layers of <code>ith</code></h4>
<ol>
<li><code>ith</code> is a global variable</li>
<li><code>ith</code> is the output of nested commands … <code>$()</code></li>
<li>These command a <strong>piped workflow</strong> of commands <code>cat</code> --&gt; <code>sed</code> --&gt; <code>wc</code></li>
</ol>
<h4 id="a.-piped-workflow">a. Piped workflow</h4>
<p>Its a coding tool that uses the <code>|</code> symbol. This symbol “re-routes” the output of a function to another function, instead of reporting it to the user.</p>
<pre><code>seq 15
</code></pre>
<pre><code>seq 15 | head -n 3
seq 15 | tail -n 3
</code></pre>
<h4 id="b.-the-cat-command">b. The <code>cat</code> command</h4>
<p>Stands for <em>concatenate</em> it is a versatile command with a few uses. Its most basic form is used to load the contents of a file into memory. Yet, a fancier application is to merge two, or more, files into 1. For example:</p>
<pre><code># assume that file_1.txt and file_2.txt exist
cat file_1.txt file_2.txt &gt; newfile.txt
</code></pre>
<ol>
<li>Notice we have a new symbol here: <code>&gt;</code> is the universal unix symbol for <strong>save to</strong>. In enflish this command would translate to <em>concatenate</em> file_1.txt and file_2.txt and <em>save to</em> newfile.txt.</li>
</ol>
<h4 id="making-a-chimera-mini-challenge">Making a chimera [mini challenge]</h4>
<p>Can you create a code that takes the first 5 line of the genome and the last 5 lines of the gene feature file and merges them into an ungodly new chimeric file? can you make it a “<strong>one liner command</strong>”?</p>
<h4 id="c.-the-sed-command">c. The <code>sed</code> command</h4>
<p><code>sed</code> is a <a href="https://www.gnu.org/software/sed/manual/sed.html">stream editor</a>. It is a very versatile program capable of manipulating text in variety of ways, some of which we will cover in this course… though, an entire course could be devoted to <code>sed</code>.</p>
<blockquote>
<p>What funcions will we use <code>sed</code> for in this class?</p>
</blockquote>
<ol>
<li>Removing a row of text</li>
<li>Selecting a row of text</li>
<li>Search and replace a set of characters in a line(s) of text.</li>
</ol>
<h4 id="c.-1-sed-to-remove-rowslines-of-text">c. 1 <code>sed</code> to remove rows/lines of text</h4>
<pre><code>seq 10
seq 10 | sed "5d"
</code></pre>
<h4 id="c.-2-sed-to-select-rowslines-of-text">c. 2 <code>sed</code> to select rows/lines of text</h4>
<pre><code>seq 10 | sed "5q;d"
</code></pre>
<h4 id="c.-3-sed-to-find-and-replace">c. 3 <code>sed</code> to find and replace</h4>
<p>One of the most powerful and widely used utilities of the program</p>
<pre><code>echo "groovy UV cool cats"
echo "groovy UV cool cats" | sed "s/cats/mooses/g"
</code></pre>
<p>The general structure is <code>s/original/replacement/g</code>. In this particular sintax, the <code>s</code> a the front means to use the <em>substitute</em> function and the <code>g</code> at the end means to apply this function <em>globally</em>. There are other options one can give <code>sed</code> but you will have to dig into the manual to learn these, which, is actually super interesting!</p>
<ul>
<li>Here is one example:</li>
</ul>
<pre><code>head JASTWB01_contigs.tsv

head JASTWB01_contigs.tsv | sed "s/pycn_heli/SOMETHINGNEW/g"
</code></pre>
<h4 id="lets-circle-back-to-ith">Lets circle back to <code>ith</code></h4>
<pre><code>ith=$(cat $master_file | sed '1d' | wc -l)
</code></pre>
<h3 id="implementing-a-loop-with-a-replacement-command-in-it">Implementing a loop with a replacement command in it!</h3>
<pre><code>for i in $(seq $ith)
 do
  name1=$(cat $master_file |  sed '1d' | awk '{print $1}' | sed "${i}q;d" )
  name2=$(cat $master_file |  sed '1d' | awk '{print $2}' | sed "${i}q;d" )
   echo "im an changing " $name2 " to " $name1 " as per " $i
   sed -E -i "s/${name2}.+/${name1}/g" pycno_genome_modnames.fasta
 done
</code></pre>
</div>
</body>

</html>
