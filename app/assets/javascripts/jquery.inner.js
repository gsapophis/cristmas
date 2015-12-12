( function(){
    'use strict';

    $( function(){

        new Page();

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
                _ctx.strokeStyle="#96c11f";
                _ctx.stroke();
            },
            _addEvents = function () {
                _window.on({
                    load: function(){
                        _showSite();
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

} )();
