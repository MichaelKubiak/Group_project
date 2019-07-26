var inner = "none";
var clust = "none";
function gDropdownOG(){
    document.getElementById("Graphs").classList.add("show");
    document.getElementById("Spanning").style.display = inner;
    document.getElementById("Clustering").style.display = clust;
}

function gcloseMenuOG(){
    document.getElementById("Graphs").classList.remove("show");
    inner = "none";
    clust = "none";
}

function sDropdownOG(){
    inner = "block";
}

function scloseMenuOG(){
    inner = "none";
}

function cDropdownOG(){
    clust = "block";
}

function ccloseMenuOG(){
    clust = "none";
}

function gDropdownNew(){
    document.getElementById("GraphsNew").classList.add("show");
}

function gcloseMenuNew(){
    document.getElementById("GraphsNew").classList.remove("show");

}