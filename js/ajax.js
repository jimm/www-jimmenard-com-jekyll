// Cross-browser XMLHttpRequest instantiation.
function createXMLHttpRequest() {
  if (typeof XMLHttpRequest == 'undefined') {
    XMLHttpRequest = function () {
      var msxmls = ['MSXML3', 'MSXML2', 'Microsoft']
      for (var i=0; i < msxmls.length; i++) {
	try {
	  return new ActiveXObject(msxmls[i]+'.XMLHTTP')
	} catch (e) { }
      }
      throw new Error("No XML component installed!")
    }
  }

  return new XMLHttpRequest();
}

// Replace contents of DOM object id with contents of uri.
function getAndReplace(uri, id) {
  var req = createXMLHttpRequest();
  req.onreadystatechange = function() {
    if (req.readyState == 4 && req.status == 200) {
      var div = document.getElementById(id);
      div.innerHTML = req.responseText;
    }
  }
  req.open("GET", uri, true);
  req.send(null);
}
