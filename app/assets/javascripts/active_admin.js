//= require active_admin/base
//= require activeadmin_addons/all
//= require ckeditor/init

document.cookie = "timezone_region="+Intl.DateTimeFormat().resolvedOptions().timeZone;

$("document").ready(function(){
  $('#bx_block_custom_ads_custom_ad_timezone').val(Intl.DateTimeFormat().resolvedOptions().timeZone);
  if ( $('#page_title')[0].innerHTML == 'Terms And Conditions' ) {
    $('#page_title')[0].innerHTML = "Terms and Conditions"
    $('span.action_item').children('a')[0].text = 'New Terms and Conditions'
    $('div.panel').children('h3')[0].innerText = 'Terms and Conditions Details'
  }
  if ( $('#page_title')[0].innerHTML == 'Terms and Conditions Details' ) {
    $('span.action_item').children('a')[0].text = 'Edit Terms and Conditions'
  }
  if ( $('#page_title')[0].innerHTML == 'Edit Terms And Conditions' ) {
    $('#page_title')[0].innerHTML = "Edit Terms and Conditions"
  }
});

