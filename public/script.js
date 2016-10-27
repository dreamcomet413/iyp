window.onload = function(){
  var frm = document.createElement("iframe");
  frm.setAttribute("src","http://floating-journey-3253.herokuapp.com/?a=1234");
  frm.setAttribute("style","border:0; height: 135px; width: 100%;");
  bd = document.getElementsByTagName("body")[0]
  bd.insertBefore(frm, bd.childNodes[0]);//appendChild(frm);
};