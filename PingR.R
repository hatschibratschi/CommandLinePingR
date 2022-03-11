library(pingr)
library(data.table)
#print('args: timeout rows')

args = commandArgs(trailingOnly = TRUE)
timeout = 10;rows = 7
if (length(args) > 0){
  timeout = args[1]
  rows = args[2]
}

servers = list(
    amazonDE = 'amazon.de'
  , sohoRadio = 'sohoradiolondon.com'
  , gateway = '192.168.0.1'
)

getPing = function(l){
  d = sapply(servers, function(x){
    p = ping(destination = x, count = 1)
  })
  d = (as.data.table(as.list(d)))
  d = cbind(data.table(time = Sys.time()), d)
  d
}

p = NULL
while(TRUE){
  p = rbind(p, getPing(servers))
  p = tail(p, rows)
  print(p)
  Sys.sleep(timeout)
}
