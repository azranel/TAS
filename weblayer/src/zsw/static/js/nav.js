$(document).ready(function(){
  // $(".nav").find('li').click(function(){
    // $(".nav").find('li').removeClass('active');
    // $(this).addClass('active');
  // });
    $(".nav").find('li').removeClass('active');
    $('.navi-' + window.location.pathname.slice(1)).addClass('active');
});