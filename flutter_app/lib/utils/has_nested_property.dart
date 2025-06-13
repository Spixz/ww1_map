bool hasNestedProperty(Map<String, dynamic> body, List<String> properties) {
  var stack = body;
  for (var property in properties) {
    if (stack.containsKey(property)) {
      if (property == properties.last) {
        return true;
      }
      if (stack[property] is Map<String, dynamic>) {
        stack = stack[property];
      }
    } else {
      return false;
    }
  }
  return true;
}
