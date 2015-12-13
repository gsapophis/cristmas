( function(){
    'use strict';

    $( function(){

        new Page();

        $( '.cards').each( function(){
            new Cards( $(this) );
        } );

        $( '.snow' ).each( function(){
            new Snow('this');
        } );

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

                        if( delta ){
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

                        if( delta ){
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
            _request = new XMLHttpRequest();

        //private methods
        var _addCards = function( cards ){
                $.each( cards, function(){
                    _content.append( ' <li class="hidden"><div class="card"></div></li>' );

                    _obj.find('.hidden').each( function(i){
                        _showCard($(this), i+1);
                    } );
                } );
            },
            _addEvents = function () {
                _moreForm.on({
                    submit: function(){
                        _loadMoreCards();

                        return false;
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

            };

        //public properties

        //public methods


        _init();
    };

    var Snow = function (obj) {

        //private properties
        var _self = this,
            _obj = obj,
            _canvas = _obj[0];

        //private methods
        var _addEvents = function () {
            
            },
            _init = function () {
                _addEvents();
                _obj[0].snow = _self;
                _loop( 0 )
            },
            _loop = function(time){

                requestAnimationFrame(loop)
            };

        //public properties

        //public methods


        _init();
    };

    var Snowflake = function (obj) {

        //private properties
        var _self = this,
            _obj = obj;

        //private methods
        var _addEvents = function () {

            },
            _init = function () {
                _addEvents();
                _obj[0].snowflake = _self;
            };

        //public properties

        //public methods


        _init();
    };

} )();
