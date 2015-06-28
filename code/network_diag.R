#install.packages('igraph')
library(igraph) # used for network analysis

routes<-read.table('/Users/arman/Documents/StableMarkets/EbolaContagion/data/routes.dat',sep=',')
ports<-read.table('/Users/arman/Documents/StableMarkets/EbolaContagion/data/airports.dat',sep=',')

#### 1. Data Prep ####
# subset to just country and airport columns
ports<-ports[,c('V4','V5')]
names(ports)<-c('country','airport')

# subset to just origin and destination airports
routes<-routes[,c('V3','V5')]
names(routes)<-c('from','to')

# merge on country names to origin and destination airports
m<-merge(routes,ports,all.x=TRUE,by.x=c('from'),by.y=c('airport'))
names(m)[3]<-c('from_c')
m<-merge(m,ports,all.x=TRUE,by.x=c('to'),by.y=c('airport'))
names(m)[4]<-c('to_c')

# aggregate to unique route level...summing # flights per route
m$count<-1
m$id<-paste(m$from_c,m$to_c,sep=',')
a<-aggregate(m$count,list(m$id),sum)
names(a)<-c('id','flights')

a$fr<-substr(a$id,1,regexpr(',',a$id)-1)
a$to<-substr(a$id,regexpr(',',a$id)+1,100)
a<-a[,2:4]

a$perc<-(a$flights/sum(a$flights))*100

# remove routes where origin and destination are in the same country.
# this clutters the network diagram
a<-a[!(a[,2]==a[,3]),]

# create edge list matrix and convert to igraph object
mat<-as.matrix(a[,2:3])
g<-graph.data.frame(mat, directed = T)

# get edges, degree of each node, and list of nodes
edges<-get.edgelist(g)
deg<-degree(g)

#### 2. Community Detection ####
# use spinglass detection algo, requires setting seed for reproducability
set.seed(9)
sgc <- spinglass.community(g)
V(g)$membership<-sgc$membership
table(V(g)$membership)

V(g)[membership==1]$color <- 'pink'
V(g)[membership==2]$color <- 'darkblue'
V(g)[membership==3]$color <- 'darkred'
V(g)[membership==4]$color <- 'purple'
V(g)[membership==5]$color <- 'darkgreen'

#### 3. Plot Full Network ####
plot(g,
     main='Airline Routes Connecting Countries',
     vertex.size=5,
     edge.arrow.size=.1,
     edge.arrow.width=.1,
     vertex.label=ifelse(V(g)$name %in% c('Liberia','United States'),V(g)$name,''),
     vertex.label.color='black')
legend('bottomright',fill=c('darkgreen','darkblue', 'darkred', 'pink', 'purple'),
       c('Africa', 'Europe', 'Asia/Middle East', 'Kiribati, Marshall Islands, Nauru', 'Americas'),
       bty='n')

#### 4. Plot Degree Distribution ####
dplot<-degree.distribution(g,cumulative = TRUE)

plot(dplot,type='l',xlab='Degree',ylab='Frequency',main='Degree Distribution of Airline Network',lty=1)
lines((1:length(dplot))^(-.7),type='l',lty=2)
legend('topright',lty=c(1,2),c('Degree Distribution','Power Law with x^(-.7)'),bty='n')

#### 5. Plot Zoomed-in Network ####

# Subset 1st degree connections from Liberia, and only those 
# 2nd degree connection, only if it is the U.S.
m<-mat[mat[,1]=='Liberia',]
t<-mat[mat[,1] %in% m[,2],]
tt<-t[t[,2]=='United States',]
vec<-c(tt[,1],'Liberia')
names(vec)<-NULL

g2<-graph.data.frame(mat[(mat[,1] %in% vec & mat[,2] == 'United States') | (mat[,1]=='Liberia'),], directed = T)
V(g2)$color<-c('darkblue','darkgreen','darkgreen','darkgreen','darkgreen','purple','darkgreen','darkgreen')

plot(g2,
     main='Airline Connections from Liberia to the United States',
     vertex.size=5,
     edge.arrow.size=1,
     edge.arrow.width=.5,
     vertex.label.color='black')
legend('bottomright',fill=c('darkgreen','darkblue','purple'),
       c('Africa', 'Europe', 'Americas'),
       bty='n')

# find average shortest path
s<-shortest.paths(g)
mean(s)





