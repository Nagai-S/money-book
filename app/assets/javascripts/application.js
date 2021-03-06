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

    $('.delete_account').click(function(){
        if(document.getElementById('delete_open')) {
            let element = $('.delete_wrapper');
            $('.delete_wrapper').slideUp();
            element.attr('id', 'delete_close');
        }else {
            let element = $('.delete_wrapper');
            element.attr('id', 'delete_open');
            $('.delete_wrapper').slideDown();
        }
    });

    $('#select_js2').change(function() {
      // 選択されているvalue属性値を取り出す
      var val = $('#select_js2').val();
      if (val=="0") {
        $('.date_area_none').slideUp();
      }else{
        $('.date_area_none').slideDown();
      }
    });
    $('#select_js2').change(function() {
      // 選択されているvalue属性値を取り出す
      var val = $('#select_js2').val();
      if (val=="0") {
        $('.date_area_block').slideUp();
      }else{
        $('.date_area_block').slideDown();
      }
    });

  $('#select_js3').change(function() {
    // 選択されているvalue属性値を取り出す
    var val = $('#select_js3').val();
    if (val=="0") {
      $('.money_area_none').slideUp();
    }else{
      $('.money_area_none').slideDown();
    }
  });

  $('#select_js3').change(function() {
    // 選択されているvalue属性値を取り出す
    var val = $('#select_js3').val();
    if (val=="0") {
      $('.money_area_block').slideUp();
    }else{
      $('.money_area_block').slideDown();
    }
  });

  $('#select_js4').change(function() {
    // 選択されているvalue属性値を取り出す
    var val = $('#select_js4').val();
    if (val!="0") {
      $('#select_js1').val('0');
    }
  });

});
