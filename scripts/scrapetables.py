# Script for scraping drug resistance information into TSV file from KEGG, as API does not seem to return
# this information, currently
# requirements: beatifulsoup4

#reference:  https://stackoverflow.com/questions/18966368/python-beautifulsoup-scrape-tables
from urllib.request import urlopen
from bs4 import BeautifulSoup

# the first page has 8 columns as opposed to 6, for the rest
url = "https://www.genome.jp/kegg/annotation/br01553.html"
page = urlopen(url)
soup = BeautifulSoup(page, "html.parser")
resistantTo = "beta-Lactamase"
linecount = 0
with open('keggcombined.tsv', 'w') as f:
    for tr in soup.find_all('tr')[2:]:
        tds = tr.find_all('td')
        if len(tds) == 8:
            linecount += 1
            if linecount == 1:
                resistance = "Resistance"
            else:
                resistance = resistantTo
            f.write((tds[0].text + '\t' + tds[2].text + '\t' + tds[3].text + '\t' +
                     tds[4].text + '\t' + tds[5].text + '\t' + tds[6].text + '\t' + resistance + '\t' +
                     tds[1].text + '\t' + tds[7].text +
                     '\n'))

f.close()

urlList = ["https://www.genome.jp/kegg/annotation/br01554.html",
           "https://www.genome.jp/kegg/annotation/br01555.html",
           "https://www.genome.jp/kegg/annotation/br01556.html",
           "https://www.genome.jp/kegg/annotation/br01557.html"]
filecount = 2
for url in urlList:
    linecount = 0
    page = urlopen(url)
    soup = BeautifulSoup(page, "html.parser")
    if filecount == 2:
        resistantTo = "Aminoglycoside"
    if filecount == 3:
        resistantTo = "Macrolide-Lincosamide-Streptogramin"
    if filecount == 4:
        resistantTo = "Tetracycline"
    if filecount == 5:
        resistantTo = "Other"  # need to change this later -- this page has multiple tables that we can not differentiate from for now

    with open('keggcombined.tsv', 'a') as f:
        for tr in soup.find_all('tr')[2:]:
            tds = tr.find_all('td')
            if len(tds) == 7:
                linecount += 1
                if linecount > 1:
                    f.write((tds[0].text + '\t' + tds[1].text + '\t' + tds[2].text + '\t' +
                             tds[3].text + '\t' + tds[4].text + '\t' + tds[5].text + '\t' +
                             resistantTo + '\t\t\n'))
    f.close()
    filecount += 1
