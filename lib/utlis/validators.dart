String validateEmail(String? value) {
  String? _msg;
  RegExp regexp = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );
  
  if (value!.isEmpty) {
    _msg = "Your username is required";
  } else if (!regexp.hasMatch(value)) {
    _msg = "Please enter a valid email address";
  } else {
    _msg = ''; 
  }

  return _msg;
}
