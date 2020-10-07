// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require_tree .
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap

//= require bootstrap-sprockets

$(function(){
    $('.menu').click(function(){
        if(document.getElementById('open')) {
            let element = $('.dropdown_list');
            $('.dropdown_list').slideUp('fast');
            element.attr('id', 'close');
            $('.close').css('display', 'block');
            $('.open').css('display', 'none');
            $('.contents').css('display', 'block')
            $('footer').css('display', 'block')
        }else {
            let element = $('.dropdown_list');
            element.attr('id', 'open');
            $('.dropdown_list').slideDown();
            $('.close').css('display', 'none');
            $('.open').css('display', 'block');
            $('.contents').css('display', 'none')
            $('footer').css('display', 'none')
        }
    });

    $('.search-h').click(function(){
        if(document.getElementById('search_open')) {
            let element = $('.search_wrapper');
            $('.search_wrapper').slideUp();
            element.attr('id', 'search_close');
            $(".search-h").css('border-bottom', 'solid 1px #E8E8E8')
        }else {
            let element = $('.search_wrapper');
            element.attr('id', 'search_open');
            $('.search_wrapper').slideDown();
            $(".search-h").css('border-bottom', 'none')
        }
    });

    $(document).ready(function () {
      if (document.getElementById('login_footer')) {
        $("footer").css("height", 280 + "px");
      }else{
        $("footer").css("height", 100 + "px");
      }
    });
});
