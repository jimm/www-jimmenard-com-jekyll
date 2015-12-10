function abc(e) {
  console.log(e);
  if (!e.shiftKey && !e.ctrlKey && !e.altGraphKey && !e.altKey)
    document.getElementById('screen').textContent = String.fromCharCode(e.keyCode).toUpperCase();
}

window.onload = function() {
  document.onkeydown = abc;
}
