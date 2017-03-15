document.getElementById("editable").focus();

function getTime() {
    var today = new Date();
    var h = today.getHours();
    var m = today.getMinutes();
    document.getElementById("clock").innerHTML = 
        h + ":" + (m < 10 ? "0" + m : m);
   
    // how many seconds until next minute? check in that many seconds
    var diff = 60 - today.getSeconds();
    console.log(today);

    var t = setTimeout(getTime, diff*1000 + 100);
}

getTime();


// http://stackoverflow.com/questions/9838812/how-can-i-open-a-json-file-in-javascript-without-jquery
function loadJSON(path, success, error)
{
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function()
    {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status === 200) {
                if (success)
                    success(JSON.parse(xhr.responseText));
            } else {
                if (error)
                    error(xhr);
            }
        }
    };
    xhr.open("GET", path, true);
    xhr.send();
}
