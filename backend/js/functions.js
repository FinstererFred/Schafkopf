function formatDate(sDate) {
  pad = '00';
  sDate = (pad + sDate.getDate()).slice(-pad.length)+'.'+
  (pad + sDate.getMonth()).slice(-pad.length)+'.'+
  sDate.getFullYear();

  return sDate;
}

function ucwords(str) {
  return (str + '')
    .replace(/^([a-z\u00E0-\u00FC])|\s+([a-z\u00E0-\u00FC])/g, function($1) {
      return $1.toUpperCase();
    });
}

String.prototype.lowercaseFirstLetter = function() {
    return this.charAt(0).toLowerCase() + this.slice(1);
};
