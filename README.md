# KEGG-KO-htext-file-parser
The rscript to parse KEGG-KO htext file
1. download KEGG-KO htext file 
Visit KEGG-KO htext website, [KEGG Orthology (KO)](https://www.kegg.jp/kegg-bin/get_htext?htext=ko00001), click "Download json" to download json file.
2. use the Rscript to prase
```
Rscript kegg_ko_htext_json_parse.R -i ko00001.json
```
