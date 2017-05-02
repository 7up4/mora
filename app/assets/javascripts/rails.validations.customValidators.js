window.ClientSideValidations.validators.local['date'] = function(element, options) {
  var given = new Date(element.val()).setHours(0,0,0,0);
  var now = new Date().setHours(0,0,0,0);
  if (given > now ) {
    return options.message;
  }
}
