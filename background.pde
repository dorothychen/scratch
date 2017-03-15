color serenity_blue = color(137,171,227);


/*
    Convert hex string to RGB array
*/
int[] hexToRgb(hex) {
    int bigint = parseInt(hex, 16);
    int r = (bigint >> 16) & 255;
    int g = (bigint >> 8) & 255;
    int b = bigint & 255;

    // if colors are too dark, lighten them
    // http://stackoverflow.com/questions/12043187/how-to-check-if-hex-color-is-too-black
    float luma = 0.2126 * r + 0.7152 * g + 0.0722 * b; // per ITU-R BT.709
    while (luma < 70) {
        r += 10;
        g += 10;
        b += 10;
        luma = 0.2126 * r + 0.7152 * g + 0.0722 * b;
    }

    return [r, g, b];
}

/*
    given two colors, the index of the unit in question, and the total number
    of units, calculate the intermediate color
*/
color getUnitColor(color1, color2, i, numUnits) {
    int r = color1[0] + ceil( (float(i)/numUnits) * (color2[0] - color1[0]) );
    int g = color1[1] + ceil( (float(i)/numUnits) * (color2[1] - color1[1]) );
    int b = color1[2] + ceil( (float(i)/numUnits) * (color2[2] - color1[2]) );
    return color(r, g, b);
}

/*
    Helper function for drawBlob();
    convert alpha value to a distance from the blob center
*/
int alphaToDistance(alpha, dist) {
    return dist * 2 * log(255.0/alpha);
}

/*
    draw a blob (a collection of circles)
*/
void drawBlob(cx, cy, c, blob_dist) {
    int alpha = 255;
    int r = 54;
    while (alpha > 0) {
        fill(c, alpha);
        int d = alphaToDistance(alpha, blob_dist);
        ellipse(cx + random(-d, d), cy + random(-d, d), r*random(0.95, 1.05), r*random(0.95, 1.05));
        alpha -= 10;
    }
}

/*
    given gradient JSON data, choose a gradient at random and draw all the blobs
*/
void drawAllBlobs(gradientJSON) {
    int i = ceil(random(0, gradientJSON.length() - 1));
    int[] color1 = hexToRgb(gradientJSON[i]["colors"][0].substring(1));
    int[] color2 = hexToRgb(gradientJSON[i]["colors"][1].substring(1));
    console.log(gradientJSON[i]["name"]);

    // if ridiculously big screen, more units
    int numUnits = 10;
    if (window.innerWidth > 1650) {
        numUnits = 15;
    }
    
    for (int i = 0; i < numUnits; i++) {
        color col = getUnitColor(color1, color2, i, numUnits);
        int cx = random(0, window.innerWidth/100.0 * 70);
        int cy = random(0, window.innerHeight/100.0 * 70);

        int blobsPerUnit = 10 + floor(random(-10,10));

        for (int j = 0; j < blobsPerUnit; j++) {
            // size of a blob; i.e. average distance between individual circles
            int blob_dist = 80;

            drawBlob(cx, cy, col, blob_dist);
            cx += random(-120, 120);
            cy += random(-120, 120);
        }        
    }
}

void setup() {
    // set up window
    size(window.innerWidth, window.innerHeight); 
    background("white");
    noStroke();
    smooth();

    // draw color units
    // gradients from 
    // https://github.com/ghosh/uiGradients/blob/master/gradients.json
    loadJSON("gradients.json",
        drawAllBlobs, 
        function(err) {
            console.log("ERROR");
            console.log(err);
        });
}


void draw() {

}
