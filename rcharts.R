library(rCharts)

options(
    rcharts.cdn = FALSE
)

HTML.FILE = "polish-names.html"
CSS.FILE = "custom-style.css"

db = read.csv("db.csv", header=TRUE)
db = db[order(db$name), ]


ip = nPlot(rank ~ year,
           data = db,
           group = "name",
           type = "lineChart")

ip$chart(forceY = c(min(db$rank), max(db$rank)), forceX = c(min(db$year), max(db$year)))
ip$chart(yDomain = c(max(db$rank), min(db$rank)) )

ip$xAxis(axisLabel = 'Year')
ip$yAxis(axisLabel = 'Rank')
ip$addFilters("sex")

ip$chart(margin = list(left=100, right=0, bottom=0))
ip$set(width=1100, height=500)

checked = 5
ip$set(disabled = c(rep(F, checked), rep(T, length(levels(db$name))-checked)))

ip$save(HTML.FILE, standalone=TRUE)

# fixing and customizing HTML page

TITLE = paste("Ranking of Polish newborns' names", paste0("(", min(db$year), "-", max(db$year), ")"))

# load custom css 

con = file(CSS.FILE, open="r")
css = readLines(con)
close(con)

css = paste(unlist(css), collapse ="\r\n")

# load generated html

con = file(HTML.FILE, open="r")
html = readLines(con)
close(con)

html = paste(unlist(html), collapse ="\r\n")

# sub

html.new = gsub("http:", "https:", html)
html.new = gsub("<style>.*</style>", css, html.new)
html.new = gsub("<head>", paste0("<head>\r\n<title>",TITLE,"</title>") , html.new)
html.new = gsub("<body ng-app>", paste0("<body ng-app>\r\n<h3 style=\"text-align: center;\">",TITLE,"</h3>") , html.new)
html.new = gsub("</body>", "<h5 style=\"text-align: center;\">Source: msw.gov.pl</h5></body>", html.new)

# write new file

con = file(HTML.FILE, open="wt")
write(html.new, con)
close(con)
