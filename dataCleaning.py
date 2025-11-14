import csv

with open("data/countries-aggregated.csv", 'r') as raw:
    reader = csv.reader(raw)
    data = list(reader)

with open("cleanedData/countries-aggregated.csv", 'w') as cleaned:
    cleaned.write("Index,Confirmed,Recovered,Deaths\n")
    firstFound = False
    for i in range(1, len(data)):
        if data[i][1] == "US":
            if not firstFound:
                firstIdx = i
                firstFound = True
            cleaned.write(f'{i - firstIdx},{data[i][2]},{data[i][3]},{data[i][4]}\n')
