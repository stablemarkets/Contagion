# Modeling Ebola Contagion Using Airline Networks. 
Please Cite when sharing.

Files supporting ebola contagion analysis at Stable markets.
https://stablemarkets.wordpress.com/2015/05/30/modeling-contagion-using-airline-networks-in-r/

# Raw Data & Codebook
The raw data and variable descriptions can be found here:
http://openflights.org/data.html

# File Descriptions
- Data
  - I use two datasets called: "routes.dat" and "airports.dat." The unit of obsercation in the former dataset is a trip from one airport to another. The unit of observation in the latter is a single airport, including which country the airport is located in.
- Code
  - This code produces the visualizations in the Stable Markets posts: the full network diagram, the zoomed-in network diagram, and the degree distribution of the full network.
  - The code proceeds by merging the airports in "routes.dat" with the country information of the origin and destination airports, found in "airports.dat". It then finds unique country-to-country routes, excluding routes which originate and end in the same country.
  - Note: the network diagram is rotated everytime it is plotted. When you run the code, the rotation may not match the rotation of the plot in my post. However, the plot will be identical in every other respect.
- Output
  - Containts all visualizations found in the Stable Markets post.
