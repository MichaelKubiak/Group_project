var inner = "none";
function gDropdown(){
    document.getElementById("Graphs").classList.add("show");
    document.getElementById("Spanning").style.display = inner;
}

function gcloseMenu(){
    document.getElementById("Graphs").classList.remove("show");
    inner = "none";
}

function sDropdown(){
    inner = "block";
}

function scloseMenu(){
    inner = "none";
}
