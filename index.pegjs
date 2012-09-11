start = records:record* { return [].concat(records) }

record
  = recname:openTag data:datum+ closeTag
  {
    var record = {};
    var obj = {};

    // FBO has multiple attribtes with the same key.
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

      trySave(data[i]['key'], data[i]['val']);
    }

    record[recname] = obj;
    return record;
  }

openTag
  = "<" tag:validTag ">" linebreaks
  { return tag }

closeTag
  = "</" validTag ">" linebreaks

datum
  = key:datumName val:datumVal
  {
    var obj = {key: key, val: val};
    return obj;
  }

datumName
  = "<" tag:validAttr ">"
  { return tag }

datumVal
  = chars:validchar* linebreaks
  { return chars.join("").trim() }

linebreaks
  = [\n\r]*

validTag
  = chars: [A-Z]+
  { return chars.join("") }

validAttr
  = chars: [A-Z]+
  { return chars.join("") }

notNewTag = !newTag

newTag = "<" "/"? [A-Z]+ ">"

validchar
  = notNewTag val:.
  { return val }