/*
Copyright (c) 2011 Vitaly Puzrin <vitaly@rcdesign.ru>
Copyright (c) 2012 Jason Garber <jg@jasongarber.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

(function () {

  CKEDITOR.plugins.add('yaspeller', {
    lang: ['en', 'ru'],

    init: function (editor) {
      separator = ".,\"'?!;: ";
      cinstance = '';
      focusafter = true;

      editor.on('contentDom', function () {
        var doc = editor.document;
        body = doc.getBody();
        html = doc.getDocumentElement();
        doc.on('keyup', checkSpell, editor);
        doc.appendStyleSheet(CKEDITOR.plugins.getPath('yaspeller') + 'css/yaspeller.css');
        if (typeof yaspeller_errors === "undefined") {
          yaspeller_errors = {};
        }
        yaspeller_errors[editor.name] = {};
        checkSpellInit(body, editor.name);
      });
      
      var dataProcessor = editor.dataProcessor;
      htmlFilter = dataProcessor && dataProcessor.htmlFilter;
      if (htmlFilter) {
        htmlFilter.addRules({
          elements: {
            span: function (element) {
              if (element.attributes['data-spell-word']) {
                delete element.name;
                return element;
              }
            }
          }
        });
      }

      var elementsPathFilters, spellFilter = function (element) {
          if (element.hasAttribute('data-spell-word')) {
            return false;
          }
      };
      if (editor._.elementsPath && !!(elementsPathFilters = editor._.elementsPath.filters)) {
        elementsPathFilters.push(spellFilter);
      }
      editor.addRemoveFormatFilter && editor.addRemoveFormatFilter(spellFilter);

      if (editor.addMenuItem) {
        editor.addMenuGroup('yaspellergroup', -1);
      }
      if (editor.contextMenu) {
        editor.contextMenu.addListener(function (element, selection) {
          if (element && element.is('span') && element.getAttribute('data-spell-word')) {
            var e_word = element.getText();
            var ea = {};
            if (yaspeller_errors[editor.name][e_word].s.length > 0) {
              var i;
              for (i = 0; i < yaspeller_errors[editor.name][e_word].s.length; i++) {
                editor.addMenuItem('yaspelleritem' + yaspeller_errors[editor.name][e_word].s[i], {
                  label: yaspeller_errors[editor.name][e_word].s[i],
                  onClick: function () {
                    replaceWord(this.editor, this.label);
                  },
                  group: 'yaspellergroup',
                  order: -1
                });
                ea['yaspelleritem' + yaspeller_errors[editor.name][e_word].s[i]] = CKEDITOR.TRISTATE_OFF;
              }
            } else {
              editor.addMenuItem('yaspellerno', {
                label: 'No variants for "' + e_word + '"',
                group: 'yaspellergroup',
                order: -1
              });
              ea['yaspellerno'] = CKEDITOR.TRISTATE_DISABLED;
            }
            return ea;
          } else {
            return null;
          }
        });
      }
    }

  });

  CKEDITOR.plugins.yaspeller = {
    check: function (text) {
      var i;
      temp_err = [];
      for (i = 0; i < text.length; i++) {
        temp_err.push(text[i].word);
      }
      for (i = 0; i < text.length; i++) {
        yaspeller_errors[cinstance][text[i].word] = text[i];
      }
      if (focusafter) {
        var range = CKEDITOR.instances[cinstance].getSelection().getRanges()[0];
        if (inWord(range)) {
          st = getWordStart(range);
          if (inArray(temp_err, getWordContent(range))) {
            range.setStart(range.startContainer, st);
            range.setEnd(range.startContainer, st);
          }
          var s = range.createBookmark(true);
        } else {
          var s = range.createBookmark(true);
        }
      }
      var errs = CKEDITOR.instances[cinstance].document.getElementsByTag('span');
      var errs_len = errs.count();
      if (errs_len > 0) {
        for (i = errs_len - 1; i >= 0; i--) {
          if (errs.getItem(i).hasClass('yaspeller_error')) {
            errs.getItem(i).remove(true);
          }
        }
      }
      var current_text = CKEDITOR.instances[cinstance].getSnapshot();
      for (word in yaspeller_errors[cinstance]){
        var length = word.length;
        var translated_position = current_text.indexOf(word);
        current_text = current_text.substr(0,translated_position) + 
          '<span class="yaspeller_error" data-spell-word="'+word+'">'+word+'</span>' + 
          current_text.substr(translated_position + length);
        // current_text = current_text.replace(
        // new RegExp('\\b' + word + '\\b', 'g'),
        //   '<span class="yaspeller_error" data-spell-word="'+word+'">'+word+'</span>'
        // );
      }
      CKEDITOR.instances[cinstance].loadSnapshot(current_text);
      if (focusafter) {
        var newRange = new CKEDITOR.dom.range(range.document);
        newRange.moveToBookmark(s);
        newRange.select();
      }
      cinstance = '';
    }
  };

  String.prototype.replaceAll = function (search, replace) {
    return this.split(search).join(replace);
  };


  function getWordStart(range) {
    var word_start = 0;
    var first_part = range.startContainer.getText().substr(0, range.startOffset);
    var i;
    for (i = 0; i < separator.length; i++) {
      cs = first_part.lastIndexOf(separator[i]);
      if (cs > word_start) {
        word_start = cs + 1;
      }
    }
    return word_start;
  }


  function getWordContent(range) {
    var word_start = 0;
    var word_end = 500;
    var text = range.startContainer.getText();
    var first_part = text.substr(0, range.startOffset);
    var second_part = text.substr(range.startOffset);
    var i;
    for (i = 0; i < separator.length; i++) {
      cs = first_part.lastIndexOf(separator[i]);
      if (cs > word_start) {
        word_start = cs + 1;
      }
      sc = second_part.indexOf(separator[i]);
      if (sc !== -1 && sc < word_end) {
        word_end = sc;
      }
    }
    if (word_start === -1) {
      word_start = 0;
    }
    if (word_end === 500) {
      word_end = text.length;
    } else {
      word_end = range.startOffset - word_start + word_end;
    }
    return text.substr(word_start, word_end);
  }



  function inWord(range) {
    var pl = range.startContainer.getText().substr(range.startOffset - 1, 1);
    var i;
    for (i = 0; i < separator.length; i++) {
      if (pl === separator[i]) {
        return false;
      }
    }
    var ll = range.startContainer.getText().substr(range.startOffset, 1);
    for (i = 0; i < separator.length; i++) {
      if (ll === separator[i]) {
        return false;
      }
    }
    return true;
  }

  function replaceWord(editor, word) {
    if (CKEDITOR.env.ie) {
      editor.focus();
    }
    var range = editor.getSelection().getRanges()[0];
    var parent = range.startContainer.getParent();
    if (CKEDITOR.env.ie) {
      parent.getChildren().getItem(0).$.data = '';
      range.startContainer.$.data = word;
    } else {
      range.startContainer.$.replaceWholeText(word);
    }
    parent.remove(true);
    editor.focus();
    range.select();
  }

  function getCharset() {
    var CharSet = document.characterSet;
    if (CharSet === undefined) {
      CharSet = document.charset;
    }
    if (CharSet.toLowerCase() === 'windows-1251') {
      return '1251';
    } else {
      return 'utf-8';
    }
  }

  function checkSpell(e) {
    if ((e.data.$.keyCode < 37 || e.data.$.keyCode > 40)) {
      cinstance = this.name;
      var range = this.getSelection().getRanges()[0];
      var parent = range.startContainer.getParent();
      checkSpellExec.apply(this);
      if (parent.hasAttribute('data-spell-word')) {
        parent.remove(true);
        range.select();
      }
    }
  }

  function checkWord(txt, charset) {
    cinstance = cinstance;
    var text = txt; //.substring(0, txt.length - 1);
    // DEBUG: only mark 'tetsing' as misspelled
    if(text.indexOf("tetsing") >= 0) {
      // CKEDITOR.plugins.yaspeller.check([{"code":1,"pos":8,"row":0,"col":8,"len":7,"word":"tetsing","s":["testing"]}]);
      CKEDITOR.plugins.yaspeller.check([{"word":"tetsing","s":["testing"]}]);
    } else {
      CKEDITOR.plugins.yaspeller.check([]);
    }
  }


  function splitText(txt) {
    var words = [];
    var seps = [];
    var text = txt.replace(/([.,\"'?!;: ]+$)/g, "") + ' ';
    
    var i;
    for (i = 0; i < text.length; i++) {
      if (/[.,\"'?!;: ]/gm.test(text[i])) {
        seps.push(i);
      }
    }
    if (seps.length === 0) {
      words.push(text);
    } else {
      for (i = 0; i < seps.length; i++) {
        if (!seps[i - 1]) {
          words.push(text.slice(0, seps[i]).replace(/(^\s+)|(\s+$)/g, ""));
        } else {
          if (!seps[i + 1]) {
            words.push(text.slice(seps[i - 1] + 1, seps[i]).replace(/(^\s+)|(\s+$)/g, ""));
            words.push(text.slice(seps[i] + 1).replace(/(^\s+)|(\s+$)/g, ""));
          } else {
            words.push(text.slice(seps[i - 1] + 1, seps[i]).replace(/(^\s+)|(\s+$)/g, ""));
          }
        }
      }
    }
    return words;
  }

  function uniqueArray(a) {
    var r = [], i, x;
    o: for (i = 0, n = a.length; i < n; i++) {
      for (x = 0, y = r.length; x < y; x++) {
        if (r[x] === a[i]) { continue o; }
      }
      r[r.length] = a[i];
    }
    return r;
  }

  function inArray(array, value) {
    var i;
    for (i = 0; i < array.length; i++) {
      if (array[i] === value) { return true; }
    }
    return false;
  }

  function removeHTMLTags(text) {
    var strInputCode = text;
    var strTagStrippedText = strInputCode.replace(/<\/?[^>]+(>|$)/g, "");
    return strTagStrippedText;
  }

  function checkSpellExec() {
    var range = this.getSelection().getRanges()[0];
    range.shrink(CKEDITOR.SHRINK_TEXT);
    var send_text = '';
    cinstance = this.name;
    var text = this.document.getBody().getHtml().replace('<br/>', ' ').replace('<br>', ' ');
    var splitted_text = uniqueArray(splitText(removeHTMLTags(text)));
    for (word in yaspeller_errors[cinstance]) {
      if (!inArray(splitted_text, word)) {
        delete yaspeller_errors[cinstance][word];
      }
    }
    if (splitted_text.length > 0) {
      for (i = 0; i < splitted_text.length; i++) {
        send_text += splitted_text[i] + ' ';
      }
      focusafter = true;
      checkWord(send_text, getCharset());
    }
  }

  function checkSpellInit(body, name) {
    var send_text = '';
    if (body.getChild(0) !== null) {
      var text = body.getHtml().replace('<br/>', ' ').replace('<br>', ' ');
      var splitted_text = uniqueArray(splitText(text));
      if (cinstance === '') {
        cinstance = name;
        for (word in yaspeller_errors[cinstance]) {
          if (!inArray(splitted_text, word)) {
            delete yaspeller_errors[cinstance][word];
          }
        }
        if (splitted_text.length > 0) {
          var i;
          for (i = 0; i < splitted_text.length; i++) {
            send_text += splitted_text[i] + ' ';
          }
          focusafter = false;
          checkWord(send_text, getCharset());
        }
      } else {
        CKEDITOR.tools.setTimeout(checkSpellInit, 100, this, [body, name]);
      }
    }
  }

})();
