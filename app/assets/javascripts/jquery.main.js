
( function(){
    var popup = null;

    'use strict';

    if( location.hash == '#_=_'){
        window.history.back();
    }

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
            _headerSubTitle = _header.find('.site__header-title'),
            _scrollIcon = _header.find('.site__header-scroll-icon'),
            _action = true,
            _canScroll = false,
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
                        _setSize();
                    }
                });
                _scrollIcon.on({
                    click: function () {
                        _checkScroll(1);
                    }
                });

            },
            _addEventsOnLoad = function(){
                _window.on({
                    'DOMMouseScroll':function(e){
                        var delta =  e.originalEvent.detail;

                        if( delta && !$('.popup_opened').length ){
                            var direction = ( delta > 0 ) ? 1 : -1;

                            if( !_action ){
                                _checkScroll(direction);
                            }

                            if( _action || !_canScroll ){
                                return false;
                            }
                        }

                    },
                    'mousewheel': function(e){
                        var delta = e.originalEvent.wheelDelta;

                        if( delta && !$('.popup_opened').length ){
                            var direction = ( delta > 0 ) ? -1 : 1;


                            if( !_action ){
                                _checkScroll(direction);
                            }

                            if( _action || !_canScroll ){
                                return false;
                            }
                        }



                    }
                });
            },
            _checkScroll = function(direction){
                if( direction > 0 && !_canScroll ){
                    _hideHeader();
                    _canScroll = true;
                } else if(direction < 0 && _canScroll && ( _site.scrollTop() == 0 ) ){
                    _showHeader();
                    _canScroll = false;
                }

                if(direction > 0 && _header.hasClass('site__header_hidden') && !_header.hasClass('site__header_hidden_out')  && !_action ){
                    _header.addClass('site__header_hidden_out');
                }

                if(direction < 0 && _header.hasClass('site__header_hidden_out') && !_action ){
                    _header.removeClass('site__header_hidden_out');
                }

            },
            _draw = function(time){
                var fillPercent = ( time - _startAnimationTime )/_duration;
                _addCircle(fillPercent);
                if ( fillPercent == 1 ){
                    _canDraw = false;
                }
            },
            _hideHeader = function(){
                if(!_action){
                    _action = true;

                    _header.addClass('site__header_hidden');

                    //for css animation
                    setTimeout(function(){
                        _action = false;
                    }, 1000);
                }
            },
            _init = function () {
                _body[0].page = _self;

                if(device.ios()){
                    _site.niceScroll({
                        horizrailenabled: false
                    });
                }
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
            _showHeader = function(){
                if(!_action){
                    _action = true;

                    _header.removeClass('site__header_hidden_out');
                    _header.removeClass('site__header_hidden');

                    //for css animation
                    setTimeout(function(){
                        _action = false;
                    }, 1000);
                }
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
                    _headerSubTitle.addClass('site__header-title_loaded');
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
            _window = $( window ),
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
                    _loadKid( $(this).data('id'), $(this).data('url') );

                    window.history.pushState({}, $(this).find('.card__name').text(), $(this).data('url').replace('kids','kid'));
                } );
                $('.kid').on( 'click', '.popup__close', function(){
                    console.log(location.href.substr(0,location.href.indexOf('/kid')));
                    window.history.pushState({}, 'GoodDeal', location.href.substr(0,location.href.indexOf('/kid')));
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
                _window[0].onpopstate = function(){
                    if( location.pathname.indexOf('/kid/') >= 0 ){
                        _openPopupById();
                    }
                };
                _window.on( {
                    load: function(){
                        if( location.pathname.indexOf('/kid/') >= 0 ){
                            _openPopupById();
                        }

                    }
                } );

            },
            _addSharing = function(){
                _makeTweeter();
                _makeFacebook();
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
            _makeTweeter = function(){
                var link = $( '.kid' ).find( '.share_t' ),
                    data = $( '.kid__share' ).data( "kid"),
                    url = data.name + ". Ты можешь подарить ребенку радость. &amp;image=" +  data.tweet;

                url = ( 'https://twitter.com/intent/tweet?url=' + location.href  + '&amp;text=' + url + '&amp;source=webclient');

                link.attr({
                    href: url
                });
            },
            _makeFacebook = function(){
                var links = $( '.kid' ).find( '.share_f' ),
                    data = $( '.kid__share' ).data( "kid"),
                    picture = '&picture=' + 'http://gooddeal.my-dis.com/assets/baner.jpg',//data.photo,
                    name = '&name=' + data.name,
                    link = '&link=' + location.href,
                    description = '&description=' + $('.kid__description').text(),
                    url = '&redirect_uri=http://www.' + location.host;

                url = ( 'https://www.facebook.com/dialog/feed?app_id=1518935931767463&display=page' + name + link + description + url + picture);

                links.attr({
                    href: url
                });
            },
            _openPopupById = function(){
                var id = location.pathname.substr( location.pathname.lastIndexOf('/') + 1 );

                popup.core.show('card');
                _loadKid( id, '/kids/' + id );
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
                        popup.core.centerWrap();
                        _addSharing();
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
