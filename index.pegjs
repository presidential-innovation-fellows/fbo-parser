start = records:record* { return [].concat(records) }

record
  = recname:openTag data:datum+ closeTag*
  {
    var record = {};
    var obj = {};

    // FBO has multiple attributes with the same key.
    // We'll append a number to the key if it has already been used.
    for (i = 0, len = data.length; i < len; ++i) {
      var trySave = function(key, val, increment) {
        var newKey = (increment === undefined ? key : key + increment)
        if (typeof obj[newKey] === 'undefined') {
          obj[newKey] = val;
        } else {
          increment = (increment === undefined ? 2 : increment + 1)
          trySave(key, val, increment)
        }
      }

      trySave(data[i][0], data[i][1]);
    }

    record[recname] = obj;
    return [record];
  }

openTag
  = "<" tag:validTag ">" linebreaks
  { return tag }

closeTag
  = "</" validTag ">" linebreaks

datum
  = key:datumName val:datumVal
  { return [key, val] }

datumName
  = "<" tag:validAttr ">"
  { return tag }

datumVal
  = chars:validchar* linebreaks
  { return chars.join("").trim() }

linebreaks
  = [\n\r]*

validTag
  = chars: [0-9a-zA-Z \"'=-]+
  { return chars.join("") }

validAttr
  = chars: [A-Z]i+
  { return chars.join("") }

notNewTag = "</EMAIL>" / "<BR>" / "</A>" / "<P>" / !newTag

newTag = "<" "/"? [A-Z]+ ">"

validchar
  = nnt:notNewTag val:.
  { return nnt ? nnt + val : val }
