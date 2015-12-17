( function(){
    'use strict';
    var popup = null;

    $( function(){

        new Page();

        $( '.cards').each( function(){
            new Cards( $(this) );
        } );

        $('.popup').each(function(){

            popup = new Popup( $(this) );

        });

    } );

    var Page = function () {

        //private properties
        var _self = this,
            _window = $( window ),
            _preloader = $('.preloader'),
            _preloaderWrap = _preloader.find(">div"),
            _preloaderCanvas = document.createElement('canvas'),
            _ctx = _preloaderCanvas.getContext('2d'),
            _site = $('.site'),
            _startAnimationTime = 0,
            _selfTime = 0,
            _duration = 500,
            _canDraw = false,
            _header = $('.site__header'),
            _action = true,
            _body = $('body');

        _preloaderCanvas.width = _preloaderCanvas.height = _preloaderWrap.width() + 4;
        _preloaderWrap.append($(_preloaderCanvas));

        //private methods
        var _addCircle = function( fillPercent ){
                _ctx.clearRect(0, 0, _preloaderCanvas.width, _preloaderCanvas.height );
                _ctx.beginPath();
                _ctx.arc(101, 101, 99, 1.5*Math.PI, (1.5 + 2*fillPercent) * Math.PI);

                _ctx.lineWidth=3;
                _ctx.strokeStyle="#ff1a1a";
                _ctx.stroke();
            },
            _addEvents = function () {
                _window.on({
                    load: function(){
                        _showSite();
                    },
                    resize: function(){
                        _setSize()
                    }
                });

            },
            _addEventsOnLoad = function(){
                _window.on({
                    'DOMMouseScroll':function(e){
                        var delta =  e.originalEvent.detail;

                        if( delta ){

                        }

                    },
                    'mousewheel': function(e){
                        var delta = e.originalEvent.wheelDelta;

                        if( delta ){

                        }



                    }
                });
            },
            _draw = function(time){
                var fillPercent = ( time - _startAnimationTime )/_duration;
                _addCircle(fillPercent);
                if ( fillPercent == 1 ){
                    _canDraw = false;
                }
            },
            _init = function () {
                _body[0].page = _self;

                _setSize();
                _addEvents();

                _loop(0);
            },
            _loop = function(time){
                _selfTime = time;

                if ( _canDraw ){
                    _draw(time);
                }
                requestAnimationFrame(_loop);

            },
            _showSite = function(){
                //For css animation
                setTimeout(function(){
                    _startAnimationTime = _selfTime;
                    _canDraw = true;
                },500);
                //For css animation
                setTimeout(function(){
                    _preloader.addClass('preloader_loaded');
                    setTimeout(function(){
                        _action = false;
                        _preloader.remove();
                        _addEventsOnLoad();
                    },500);
                }, 1000 );
            },
            _setSize = function(){
                $('.site__content').height( 'auto' );

                if($('.site__content').outerHeight() < $( window ).height() ){
                    $('.site__content').outerHeight(  $( window ).height()  );
                }

            };

        //public properties

        //public methods


        _init();
    };

    var Cards = function ( obj ) {

        //private properties
        var _self = this,
            _obj = obj,
            _moreForm = _obj.find('.cards__more'),
            _content = _obj.find('ul'),
            _filterItems = _obj.find('.cards__filter a'),
            _request = new XMLHttpRequest();

        //private methods
        var _addEvents = function () {
                _moreForm.on({
                    submit: function(){
                        _loadMoreCards();

                        return false;
                    }
                });
                _obj.on( 'click', '.card', function(){
                    if( $( '.sign-out' ).length ){
                        _loadKid( $(this).data('id'), $(this).data('url') );

                    } else {
                        alert( 'Необходимо залогинится' );
                        return false;
                    }
                } );
                $('.kid').on( 'click', '.kid__ok', function(){
                    var curBtn = $(this);


                    _request.abort();
                    _request = $.ajax({
                        url: curBtn.data('url'),
                        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
                        dataType: 'script',
                        timeout: 20000,
                        type: curBtn.data('method'),
                        success: function ( msg ) {
                        },
                        error: function (XMLHttpRequest) {
                            if (XMLHttpRequest.statusText != "abort") {

                            }
                        }
                    });
                    //  _loadKid( $(this).data('id'), $(this).data('url') );
                } );
                $('.kid').on( 'click', '.kid__cancel', function(){
                    var curBtn = $(this);


                    _request.abort();
                    _request = $.ajax({
                        url: curBtn.data('url'),
                        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
                        dataType: 'script',
                        timeout: 20000,
                        type: curBtn.data('method'),
                        success: function ( msg ) {
                        },
                        error: function (XMLHttpRequest) {
                            if (XMLHttpRequest.statusText != "abort") {

                            }
                        }
                    });
                    //  _loadKid( $(this).data('id'), $(this).data('url') );
                } );
                _filterItems.on( {
                    click: function(){
                        var curFilter = $( this );
                        if( !curFilter.hasClass('active') ){
                            _filterItems.removeClass('active');
                            curFilter.addClass('active');
                            _loadFiltered(curFilter.attr('href'));
                        }

                        return false;
                    }
                } );
            },
            _loadFiltered = function(url){
                _request.abort();
                _request = $.ajax({
                    url: url,
                    beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
                    dataType: 'script',
                    timeout: 20000,
                    type: 'GET',
                    success: function ( msg ) {
                        _obj.find('.hidden').each( function(i){
                            _showCard($(this), i+1);
                        } );
                    },
                    error: function (XMLHttpRequest) {
                        if (XMLHttpRequest.statusText != "abort") {

                        }
                    }
                });
            },
            _init = function () {
                _addEvents();
                _obj[0].cards = _self;
            },
            _loadMoreCards = function(){
                _request.abort();
                _request = $.ajax({
                    url: _moreForm.attr('action'),
                    beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
                    dataType: 'script',
                    data: {
                        page: Math.floor( _obj.find('li').length / 6 )+1
                    },
                    timeout: 20000,
                    type: 'GET',
                    success: function ( msg ) {
                        //if( !msg.has_items ){
                        //    _moreForm.remove();
                        //}
                        _obj.find('.hidden').each( function(i){
                            _showCard($(this), i+1);
                        } );
                    },
                    error: function (XMLHttpRequest) {
                        if (XMLHttpRequest.statusText != "abort") {

                        }
                    }
                });
            },
            _showCard = function( card, i ){

                setTimeout(function(){
                    card.removeClass('hidden')
                }, 100 * i)

            },
            _loadKid = function( id, url ){
                _request.abort();
                _request = $.ajax({
                    url: url,
                    beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
                    dataType: 'script',
                    data: {
                        id: id
                    },
                    timeout: 20000,
                    type: 'GET',
                    success: function ( msg ) {
                    },
                    error: function (XMLHttpRequest) {
                        if (XMLHttpRequest.statusText != "abort") {

                        }
                    }
                });
            };

        //public properties

        //public methods


        _init();
    };

    var Popup = function( obj ){
        this.popup = obj;
        this.btnShow =  $('.popup__open');
        this.btnClose = obj.find( '.popup__close, .popup__cancel' );
        this.wrap = obj.find($('.popup__wrap'));
        this.contents = obj.find($('.popup__content'));
        this.window = $( window );
        this.scrollConteiner = $( 'html' );
        this.timer = setTimeout( function(){},1 );

        this.init();
    };
    Popup.prototype = {
        init: function(){
            var self = this;
            self.core = self.core();
            self.core.build();
        },
        core: function (){
            var self = this;

            return {
                build: function (){
                    self.core.controls();
                },
                centerWrap: function(){
                    if ( self.window.height() - 40 - self.wrap.height() > 0 ) {
                        self.wrap.css({top: ( ( self.window.height() - 40 )- self.wrap.height())/2});
                    } else {
                        self.wrap.css({top: 0});
                    }
                },
                controls: function(){
                    self.window.on( {
                        resize: function(){
                            self.core.centerWrap();
                        }
                    } );
                    $('body').on( 'click','.popup__open',  function(){
                        var curItem = $( this );

                        self.core.show( curItem.attr( 'data-popup' ) );
                    } );
                    self.wrap.on( {
                        click: function( event ){
                            event = event || window.event;

                            if (event.stopPropagation) {
                                event.stopPropagation();
                            } else {
                                event.cancelBubble = true;
                            }
                        }
                    } );
                    self.popup.on( {
                        click: function(){
                            self.btnClose.trigger('click');
                            return false;
                        }
                    } );
                    self.btnClose.on( {
                        click: function(){
                            self.core.hide();
                        }
                    } );
                },
                hide: function(){
                    self.popup.css ({
                        'overflow-y': "hidden"
                    });
                    self.scrollConteiner.css( {
                        "overflow-y": "scroll",
                        paddingRight: 0
                    } );
                    self.popup.removeClass('popup_opened');
                    self.popup.addClass('popup_hide');
                    location.hash = '';
                    setTimeout( function(){
                        self.popup.css ({
                            'overflow-y': "scroll"
                        });
                        self.popup.removeClass('popup_hide');
                    }, 300 );

                },
                getScrollWidth: function (){
                    var scrollDiv = document.createElement("div");
                    scrollDiv.className = "popup__scrollbar-measure";
                    document.body.appendChild(scrollDiv);

                    var scrollbarWidth = scrollDiv.offsetWidth - scrollDiv.clientWidth;
                    document.body.removeChild(scrollDiv);

                    return scrollbarWidth;
                },
                show: function( className ){
                    self.core.setPopupContent( className );

                    self.scrollConteiner.css( {
                        overflow: "hidden",
                        paddingRight: self.core.getScrollWidth()
                    } );
                    self.popup.addClass('popup_opened');
                    self.core.centerWrap();

                    $('.popup_opened').find('textarea').focus();
                },
                setPopupContent: function( className ){
                    var curContent = self.contents.filter( '.popup__' + className );

                    self.contents.css( { display: 'none' } );
                    curContent.css( { display: 'block' } );
                }

            };
        }
    };

} )();
