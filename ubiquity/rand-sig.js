// <link rel="commands" href="http://www.jimmenard.com/ubiquity/rand-sig.js" name="rand-sig" />
var SIG_URL = 'http://www.jimmenard.com/random_sig.cgi?style=plain';

CmdUtils.CreateCommand({
  name: "rand-sig",
  homepage: "http://www.jimmenard.com/",
  author: {
    name: "Jim Menard",
    email: "jim@jimmenard.com"
  },
  help: "Inserts a random email signature quote.",
  preview: "Inserts a random email signature quote.",
  execute: function() {
    jQuery.get(SIG_URL, {}, function(text) {
                 CmdUtils.setSelection("\n-- \n" + text);
               });
  }
});
