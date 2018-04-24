
#get the number of lines we have
#wc -l outputs the number of lines and file name, use cut just to get the line count which is the first field 
lines=$(wc -l $1 | cut -d' ' -f 1 )

echo "{ \"type\": \"FeatureCollection\", \"features\": [" > $2

for linenum in $(seq 2 $lines) ; do
    line=$(head -n $linenum $1 | tail -1)
    echo "Line: $linenum"
    echo $line
    markercolour=$(echo $line | cut -d, -f 1)
    markersize=$(echo $line | cut -d, -f 2)
    markersymbol=$(echo $line | cut -d, -f 3)
    name=$(echo $line | cut -d, -f 4)
    lon=$(echo $line | cut -d, -f 5)
    lat=$(echo $line | cut -d, -f 6)
    
    echo  "{ \"type\": \"Feature\", \"properties\": { \"marker-color\": \"$markercolour\", \"marker-size\": \"$markersize\", \"marker-symbol\": \"$markersymbol\", \"name\": \"$name\" }," >> $2
    
    #don't put a trailing comma on the last line
    if [ "$linenum" = "$lines" ] ; then
        echo  "\"geometry\": { \"type\": \"Point\", \"coordinates\": [$lon,$lat] } }" >> $2
    else
        echo  "\"geometry\": { \"type\": \"Point\", \"coordinates\": [$lon,$lat] } }," >> $2
    fi
    
done

echo "] }" >> $2


    