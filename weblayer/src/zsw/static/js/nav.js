$(document).ready(function(){
    $(".nav").find('li').removeClass('active');
    $('.navi-' + window.location.pathname.slice(1).replace("/", "")).addClass('active');
});