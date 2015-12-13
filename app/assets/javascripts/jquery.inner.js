( function(){
    'use strict';

    $( function(){

        new Page();

        $( '.cards').each( function(){
            new Cards( $(this) );
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

} )();
