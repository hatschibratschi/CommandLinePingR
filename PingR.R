library(pingr)
library(data.table)
#print('args: timeout rows')

# info ####
# create a file myserver.R with:
# servers = list(
#   amazonDE = 'amazon.de'
#   , sohoRadio = 'sohoradiolondon.com'
#   , gateway = '192.168.0.1'
# )
source('myservers.R')

beginListFromHead = TRUE

args = commandArgs(trailingOnly = TRUE)
timeout = 10;rows = 7
if (length(args) > 0){
  timeout = args[1]
  rows = args[2]
}

getPing = function(servers){
  d = sapply(servers, function(x){
    p = ping(destination = x, count = 1)
    round(p, 0)
  })
  d = (as.data.table(as.list(d)))
  d = cbind(data.table(time = format(Sys.time(), "%H:%M:%S")), d)
  d
}

# prepare empty data.table
p = as.data.table(servers)
p = cbind(data.table(time = format(Sys.time(), "%H:%M:%S")), p)
p[1,] = '' # set all lines to ''
p = do.call("rbind", replicate(rows, p, simplify = FALSE))

while(TRUE){
  if(beginListFromHead){
    p = rbind(getPing(servers), p)
    p = head(p, rows)
  } else {
    p = rbind(p, getPing(servers))
    p = tail(p, rows)
  }
  print(p)
  Sys.sleep(timeout)
}
