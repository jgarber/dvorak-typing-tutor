/*
Copyright (c) 2011 Vitaly Puzrin <vitaly@rcdesign.ru>

This spellchecker plugin is based on CKEditor sources
and keeps the same open source licences (GPLv2, lGPLv2.1, MPLv1.1)

Developed as part of Nodeca project http://nodeca.com
Source codes: https://github.com/nodeca/ckeditor-openscayt
*/

/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/


// Callbacks for JSONP requests
window.scayt = window.scayt || {};

(function () {
  var
    plugin_name = 'openscayt',
    commandName  = 'scaytcheck',
    openPage = '';

//====== Global garbage, that should be removed after algorythm change ===============

  var separator = ".,\"'?!;: ";
  var cinstance = '';
  var focusafter = true;
  var checkSpellTimer = null;

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

//================== Garbage finished ========================================

  /*
   * Helper primitives
   */
    function in_array( needle, haystack )
    {
        var found = 0,
            key;
        for ( key in haystack )
        {
            if ( haystack[ key ] == needle )
            {
                found = 1;
                break;
            }
        }
        return found;
    }


  /*
   * Spellchecker low-level deals. Implements:
   *
   * - "ajax" requests
   * - marks/replacements local store (for current editor)
   * - visual errors marking
   */
  function Speller( _editor ) {
    if (!(this instanceof Speller)) { return new Speller(editor); }

    this.editor = _editor;

    /*
     * We have 2 timeouts, when new request arives:
     *
     *  - keyboard inactivity. When user types, we don't need to check
     *    every char, wait a bit. ~1-3 sec
     *
     *  - total timeout. When user types without stop. We should check
     *    new changes anyway, sometime. ~5-10 sec
     *
     */
    this.inactivityTimer = null;
    this.uncheckedTimer = null;

    this.inactivityInterval = 2000;
    this.uncheckedInterval  = 500;

    this.inactivityTimerActive = true;
    this.uncheckedTimerActive  = true;

    this._enabled = false;

    this.errors = {}; // error words
    this.fixes = {};  // replacements offers
    this.splits = []; // seems, 'partials' of document to clear
  }

  Speller.prototype = {

    destroy : function() {
      this.editor = null;
    },

    /*
     * Enable/Disable spellchecker
     */
    enable : function(state) {

      this._enabled = (state === undefined) ? true : state;

      // Sync button state
      var cmd = this.editor.getCommand(commandName);
      cmd.setState( this._enabled ? CKEDITOR.TRISTATE_ON : CKEDITOR.TRISTATE_OFF );

      if ( this._enabled ) {
        // check all document
// !! Dirty. Rewrite after algorythm change.
        this.exec();
      } else {
        // remove markup when spellchecker disabled,
        // & kill dictionaries
        var
          marks = this.editor.document.getElementsByTag('span'),
          i;
        for (i = marks.count() - 1; i >= 0; i--) {
          if (marks.getItem(i).hasClass('scayt-error')) {
            this.removeMark( marks.getItem(i) ); // true = preserve content
          }
        }
        this.errors = {};
        this.fixes = {};
        this.splits = {};
      }
    },

    isEnabled : function() {
      return this._enabled;
    },

    /*
     * Retreive replacement suggestions for given word
     *
     * returns Array of suggestions, of null if nothing
     */
    getSuggestion : function( word ) {
      var suggestion = this.errors[word];
      if ( !suggestion || !suggestion.s || !suggestion.s.length) {
        return null;
      }

      return suggestion.s;
    },

    /*
     * Replace text of given element with new wird,
     * preserving markup
     *
     * (!) currently in simple mode, for text only
     */
    replace : function( element, word ) {

// Do it better !!! Should support not text-only too
// new "find" algorythm will give us better replace method

      element.setText( word );
      this.removeMark( element ); //.mergeSiblings();
    },

    /*
     * Remove element markup
     */
    removeMark : function( element ) {
      element.remove(true)
    },

    /*
     * Here postponed spellcheck starts
     *
     * Temporary "as is", with old bullshit
     *
     */
    pushRequest : function(keyCode) {
      if (!this.isEnabled()) {
        return;
      }

// Later - filter cursor move and so on. Place requests only on content change

      var range = this.editor.getSelection().getRanges()[0];
      var parent = range.startContainer.getParent();

      // don't touch "unchecked" timer, if already counts
      if (this.uncheckedTimerActive)
          this.uncheckedTimer = this.uncheckedTimer || CKEDITOR.tools.setTimeout(this.exec, this.uncheckedInterval, this);

      // reset inactivity timeout every time
      clearTimeout(this.inactivityTimer);
      if (this.inactivityTimerActive)
          this.inactivityTimer = CKEDITOR.tools.setTimeout(this.exec, this.inactivityInterval, this);

      if (parent.hasAttribute('data-scayt_word')) {
        parent.remove(true);
        range.select();
      }
    },

    /*
     * Real Spellcheck Begins here :)
     *
     */
    exec : function() {
      clearTimeout(this.inactivityTimer);
      clearTimeout(this.uncheckedTimer);
      this.inactivityTimer = null;
      this.uncheckedTimer = null;

      var range = this.editor.getSelection().getRanges()[0];
      range.shrink(CKEDITOR.SHRINK_TEXT);

      var send_text = '';

      var text = this.editor.document.getBody().getHtml().replace('<br/>', ' ').replace('<br>', ' ');
      var splitted_text = uniqueArray(splitText(removeHTMLTags(text)));
      for (word in this.errors) {
        if (!inArray(splitted_text, word)) {
          delete this.errors[word];
        }
      }
      for (word in this.fixes) {
        if (!inArray(splitted_text, word)) {
          delete this.fixes[word];
        }
      }
      if (splitted_text.length > 0) {
        for (i = 0; i < splitted_text.length; i++) {
          if (!this.errors[splitted_text[i]] && !this.fixes[splitted_text[i]]) {
            this.splits.push(splitted_text[i]);
            send_text += splitted_text[i] + ' ';
          }
        }
        focusafter = true;
        this.askRemote(send_text);
      }
    },


    /*
     * Call Remote Spellchecker service, and process results
     */
    askRemote : function(txt) {
      // Not unicode? Really? Who cares about loosers..

      var self = this;
      var hookname = "cb" + this.editor.name;

// Temporary ugly hack. Remove later.
      var text = txt.substring(0, txt.length - 1);

      // webhook
      window.scayt[hookname] = function(text) {
        // check validity later
        var editor = self.editor;

        var i;
        temp_err = [];
        for (i = 0; i < text.length; i++) {
          temp_err.push(text[i].word);
        }
        for (i = 0; i < editor.speller.splits.length; i++) {
          if (!inArray(temp_err, editor.speller.splits[i])) {
            editor.speller.fixes[editor.speller.splits[i]] = 1;
          }
        }
        for (i = 0; i < text.length; i++) {
          editor.speller.errors[text[i].word] = text[i];
        }
        if (focusafter) {
          var range = editor.getSelection().getRanges()[0];
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
        var errs = editor.document.getElementsByTag('span');
        var errs_len = errs.count();
        if (errs_len > 0) {
          for (i = errs_len - 1; i >= 0; i--) {
            if (errs.getItem(i).hasClass('scayt-error')) {
              errs.getItem(i).remove(true);
            }
          }
        }
        var current_text = editor.getData();
        for (word in editor.speller.errors){
          current_text = current_text.replace(
          new RegExp('\\b' + word + '\\b', 'g'),
            "<span class='scayt-error' data-scayt_word='"+word+"'>"+word+"</span>"
          );

        }
        editor.document.getBody().setHtml(current_text);
        if (focusafter) {
          var newRange = new CKEDITOR.dom.range(range.document);
          newRange.moveToBookmark(s);
          newRange.select();
        }

        window.scayt[hookname] = null;
      }

      app.scayt.check(text, window.scayt[hookname])
    }
  };


//----------------------------------------------------------------
//----------------------------------------------------------------
//----------------------------------------------------------------

  /*
   * Set text/html filters, to exclude speller marks for different actions
   *
   */
  function initFilters(editor) {

    // IE6-7 does not support CSS Selectors, so we use class, to
    // hilight errors. Code, that should clear <span> fixed accordingly.

    // Delete error's span-s when text pasting in editor (#6921)
    var dataFilter = editor.dataProcessor && editor.dataProcessor.dataFilter;
    var dataFilterRules =
      {
        elements :
          {
            span : function( element )
              {
                var attrs = element.attributes;
//                if ( attrs && attrs[ 'data-scaytid' ] ) {
                if ( attrs && attrs[ 'data-scayt_word' ] ) {
                  delete element.name;
                }
              }
          }
      };
    if (dataFilter) {
      dataFilter.addRules( dataFilterRules );
    }

    // Prevent word marker line from displaying in elements path
    var scaytFilter = function( element )
      {
//        if ( element.hasAttribute( 'data-scaytid' ) ) {
        if ( element.hasAttribute( 'data-scayt_word' ) ) {
          return false;
        }
      };
    if ( editor._.elementsPath ) {
      var elementsPathFilters = editor._.elementsPath.filters;
      if ( elementsPathFilters ) {
        elementsPathFilters.push( scaytFilter );
      }
    }
    // Also remove marking when "cleaning" format.
        if ( editor.addRemoveFormatFilter ) {
      editor.addRemoveFormatFilter( scaytFilter );
    }

    // Wrap marked element write
        var dataProcessor = editor.dataProcessor,
            htmlFilter = dataProcessor && dataProcessor.htmlFilter;
        if ( htmlFilter )
        {
            htmlFilter.addRules(
                {
                    elements :
                    {
                        span : function( element )
                        {
//                          if ( element.attributes[ 'data-scayt_word' ]
//                                  && element.attributes[ 'data-scaytid' ] )
                            if ( element.attributes[ 'data-scayt_word' ] )
                            {
                                delete element.name;
                                return element;
                            }
                        }
                    }
                }
            );
        }

        // Override Image.equals method avoid CK snapshot module
    // to add SCAYT markup to snapshots. (#5546)
/*
        var undoImagePrototype = CKEDITOR.plugins.undo.Image.prototype;
        undoImagePrototype.equals = CKEDITOR.tools.override( undoImagePrototype.equals, function( org )
        {
            return function( otherImage )
            {
                var thisContents = this.contents,
                    otherContents = otherImage.contents;
                var scayt_instance = plugin.getScayt( this.editor );
                // Making the comparison based on content without SCAYT word markers.
                if ( scayt_instance && plugin.isScaytReady( this.editor ) )
                {
                    // scayt::reset might return value undefined. (#5742)
                    this.contents = scayt_instance.reset( thisContents ) || '';
                    otherImage.contents = scayt_instance.reset( otherContents ) || '';
                }

                var retval = org.apply( this, arguments );

                this.contents = thisContents;
                otherImage.contents = otherContents;
                return retval;
            };
        });
    */
  }

  /*
   * Build toolbar button dropdown
   */
  function initToolbar(editor) {

    // Register Scayt command.
        var command = editor.addCommand( commandName, {
      preserveState : true,
      canUndo : false,
      exec: function( editor ) {
        // Reverse spellchecker state
        editor.speller.enable(!editor.speller.isEnabled());
// Check if need to tweak focus
      }
    });

    var lang = editor.lang.scayt;

    var uiTabs = editor.config.scayt_uiTabs.split( ',' );

    var menuGroup = 'scaytButton';
    editor.addMenuGroup( menuGroup );
    // combine menu items to render
    var uiMenuItems = {};

    // on/off always added
    uiMenuItems.scaytToggle =
      {
        label : lang.enable,
        command : commandName,
        group : menuGroup
      };

    if ( parseInt(uiTabs[0],10) === 1 ) {
      uiMenuItems.scaytOptions =
                {
                    label : lang.options,
                    group : menuGroup,
                    onClick : function()
                    {
                        openPage = 'options';
//                      editor.openDialog( commandName );
          }
        };
    }

    if ( parseInt(uiTabs[1],10) === 1 ) {
      uiMenuItems.scaytLangs =
                {
                    label : lang.langs,
                    group : menuGroup,
                    onClick : function()
                    {
                        openPage = 'langs';
//                      editor.openDialog( commandName );
                    }
                };
    }

    if ( parseInt(uiTabs[2],10) === 1 ) {
      uiMenuItems.scaytDict =
                {
                    label : lang.dictionariesTab,
                    group : menuGroup,
                    onClick : function()
                    {
                        openPage = 'dictionaries';
//                      editor.openDialog( commandName );
                    }
                };
    }

    // 'about' always added
    uiMenuItems.scaytAbout =
      {
        label : editor.lang.scayt.about,
        group : menuGroup,
        onClick : function()
        {
          openPage = 'about';
//                  editor.openDialog( commandName );
        }
      };

    /*
     * There are 2 modes of toolbar button:
     *
     *   Full-featured: with popup menu & additional settings
     *
     *   Simple: just toggle on/off
     *
     * If you need "simple" button - set `scayt_uiTabs.split`
     * variable in cofig to EMPTY string.
     */
    if ( editor.config.scayt_uiTabs !== '' ) {
      editor.addMenuItems( uiMenuItems );

      editor.ui.add( 'Scayt', CKEDITOR.UI_MENUBUTTON,
        {
          label : lang.title,
          title : CKEDITOR.env.opera ? lang.opera_title : lang.title,
          className : 'cke_button_scayt',
          modes : { wysiwyg : 1 },

          onRender: function()
          {
            command.on( 'state', function()
              {
                this.setState( command.state );
              },
              this);
          },

          onMenu : function()
          {
            var isEnabled = editor.speller.isEnabled();

            editor.getMenuItem( 'scaytToggle' ).label = lang[ isEnabled ? 'disable' : 'enable' ];

            return {
              scaytToggle  : CKEDITOR.TRISTATE_OFF,
              scaytOptions : isEnabled && uiTabs[0] ? CKEDITOR.TRISTATE_OFF : CKEDITOR.TRISTATE_DISABLED,
              scaytLangs   : isEnabled && uiTabs[1] ? CKEDITOR.TRISTATE_OFF : CKEDITOR.TRISTATE_DISABLED,
              scaytDict    : isEnabled && uiTabs[2] ? CKEDITOR.TRISTATE_OFF : CKEDITOR.TRISTATE_DISABLED,
              scaytAbout   : CKEDITOR.TRISTATE_OFF
            };
          }
      });
    } else {
      // Simple menu
      editor.ui.addButton('Scayt', {
        label: lang.title,
        title : CKEDITOR.env.opera ? lang.opera_title : lang.title,
        className : 'cke_button_scayt',
        command: commandName
      });
    }
  }

  /*
   * Set config default vaules, if not defined
   */
  function initConfigDefaults(editor) {
    editor.config.scayt_autoStartup =
      (editor.config.scayt_autoStartup === undefined) ?
        true : editor.config.scayt_autoStartup;

    editor.config.scayt_uiTabs =
      (editor.config.scayt_uiTabs === undefined) ?
// No popup now. Implement later.
//        "1,1,1" : editor.config.scayt_uiTabs;
        "" : editor.config.scayt_uiTabs;
  }

    // Context menu constructing.
    var addButtonCommand = function( editor, buttonName, buttonLabel, commandName, command, menugroup, menuOrder )
    {
        editor.addCommand( commandName, command );

        // If the "menu" plugin is loaded, register the menu item.
        editor.addMenuItem( commandName,
            {
                label : buttonLabel,
                command : commandName,
                group : menugroup,
                order : menuOrder
            });
    };

  /*
   * Adding plugin to editor
   */
  CKEDITOR.plugins.add( plugin_name, {

        requires : [ 'menubutton' ],

        beforeInit : function( editor )
        {
            var items_order = editor.config.scayt_contextMenuItemsOrder
                    || 'suggest|moresuggest|control',
                items_order_str = "";

            items_order = items_order.split( '|' );

            if ( items_order && items_order.length )
            {
        var pos;
                for ( pos = 0 ; pos < items_order.length ; pos++ ) {
                    items_order_str +=
            'scayt_' + items_order[ pos ] +
            ( items_order.length !== parseInt( pos, 10 ) + 1 ? ',' : '' );
        }
            }

            // Put it on top of all context menu items (#5717)
            editor.config.menu_groups =  items_order_str + ',' + editor.config.menu_groups;
        },

    init : function( editor )
    {
      initConfigDefaults( editor );

      // Speller data instance for each editor
      editor.speller = new Speller( editor );

            var lang = editor.lang.scayt;

      initFilters( editor );

      initToolbar(editor);

      editor.on('contentDom', function () {
        editor.document.on('keydown', function() {
          // do nothing on disabled spellchecker
          if ( !editor.speller.isEnabled() ) { return; }

          editor.speller.pushRequest(this);
        });

        // Since we use assets pipeline we don't need that
        //editor.document.appendStyleSheet(
          //CKEDITOR.plugins.getPath(plugin_name) + 'css/scayt.css'
        //);

//        checkSpellInit(editor);
      });

      editor.on( 'instanceReady', function() {
        editor.speller.enable( editor.config.scayt_autoStartup );
      });

      if (editor.addMenuItem) {
        editor.addMenuGroup('yaspellergroup', -1);
      }

      // Store menu items (to release old on next creation)
            var
        moreSuggestions = {},
                mainSuggestions = {};

            // If the "contextmenu" plugin is loaded, register the listeners.
            if ( editor.contextMenu && editor.addMenuItems )
            {
                editor.contextMenu.addListener( function( element, selection )
                    {
            if ( !editor.speller.isEnabled()
              || selection.getRanges()[ 0 ].checkReadOnly() )
            return null;

            if (!element || !element.is('span'))
              return null;

            var word = element.getAttribute('data-scayt_word');

            if ( !word )
              return null;

            var
              _r = {},
              items_suggestion = editor.speller.getSuggestion( word );

                        if ( !items_suggestion )
                            return null;

                        // Remove unused commands and menuitems
                        for ( i in moreSuggestions )
                        {
                            delete editor._.menuItems[ i ];
                            delete editor._.commands[ i ];
                        }
                        for ( i in mainSuggestions )
                        {
                            delete editor._.menuItems[ i ];
                            delete editor._.commands[ i ];
                        }
                        moreSuggestions = {};       // Reset items.
                        mainSuggestions = {};

                        var moreSuggestionsUnable = editor.config.scayt_moreSuggestions || 'on';
                        var moreSuggestionsUnableAdded = false;

                        var maxSuggestions = editor.config.scayt_maxSuggestions;
                        ( typeof maxSuggestions != 'number' ) && ( maxSuggestions = 5 );
                        !maxSuggestions && ( maxSuggestions = items_suggestion.length );

                        var contextCommands = editor.config.scayt_contextCommands || 'all';
                        contextCommands = contextCommands.split( '|' );

                        for ( var i = 0, l = items_suggestion.length; i < l; i += 1 )
                        {
                            var commandName = 'scayt_suggestion_' + items_suggestion[i].replace( ' ', '_' );
                            var exec = ( function( el, s )
                                {
                                    return {
                                        exec: function()
                                        {
                                            editor.speller.replace( el, s );
                                        }
                                    };
                                })( element, items_suggestion[i] );

                            if ( i < maxSuggestions )
                            {
                                addButtonCommand( editor, 'button_' + commandName, items_suggestion[i],
                                    commandName, exec, 'scayt_suggest', i + 1 );
                                _r[ commandName ] = CKEDITOR.TRISTATE_OFF;
                                mainSuggestions[ commandName ] = CKEDITOR.TRISTATE_OFF;
                            }
                            else if ( moreSuggestionsUnable == 'on' )
                            {
                                addButtonCommand( editor, 'button_' + commandName, items_suggestion[i],
                                    commandName, exec, 'scayt_moresuggest', i + 1 );
                                moreSuggestions[ commandName ] = CKEDITOR.TRISTATE_OFF;
                                moreSuggestionsUnableAdded = true;
                            }
                        }

                        if ( moreSuggestionsUnableAdded )
                        {
                            // Register the More suggestions group;
                            editor.addMenuItem( 'scayt_moresuggest',
                            {
                                label : lang.moreSuggestions,
                                group : 'scayt_moresuggest',
                                order : 10,
                                getItems : function()
                                {
                                    return moreSuggestions;
                                }
                            });
                            mainSuggestions[ 'scayt_moresuggest' ] = CKEDITOR.TRISTATE_OFF;
                        }

            // more menu items (ignore / ignore all / ...) can be added here later

                        return mainSuggestions;
                    });
            }

    }
  });

})();
