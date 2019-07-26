var inner = "none";
function gDropdownOG(){
    document.getElementById("Graphs").classList.add("show");
    document.getElementById("Spanning").style.display = inner;
}

function gcloseMenuOG(){
    document.getElementById("Graphs").classList.remove("show");
    inner = "none";
}

function sDropdownOG(){
    inner = "block";
}

function scloseMenuOG(){
    inner = "none";
}

function gDropdownNew(){
    document.getElementById("GraphsNew").classList.add("show");
}

function gcloseMenuNew(){
    document.getElementById("GraphsNew").classList.remove("show");

}