if (!localStorage.accounts) {
  localStorage.accounts = '';
}

$(document).ready(function () {
  $('#send_message_aj').on('click', function (e) {
    e.preventDefault();
    let message = $('.text_message_account').val()
    let datetime = $(".message_time_pick").val()
    $.ajax({
      url: "/customjs/send_notifications",
      type: "post",
      data: { accounts_ids: localStorage.accounts.split(","), message: message, datetime: datetime},
      success: function (result) {
        alert(result.message);
        localStorage.removeItem("accounts");
        window.location.href = window.location.href;
      },
      error: function (error) {
        alert(error.responseJSON.error);
      }
    });
  });
  $('body.admin_users input.collection_selection').on('change', function () {
    if ($(this).prop('checked') == true) {
      if (localStorage.accounts == '') {
        localStorage.accounts = $(this).val();
      } else {
        localStorage.accounts = `${localStorage.accounts},${$(this).val()}`;
      }
    } else {
      if (localStorage.accounts.search(`${$(this).val()}`) > -1) {
        if (localStorage.accounts.search(`${$(this).val()},`) > -1) {
          localStorage.accounts = localStorage.accounts.replace(`${$(this).val()},`, '');
        } else if (localStorage.accounts.search(`,${$(this).val()}`) > -1) {
          localStorage.accounts = localStorage.accounts.replace(`,${$(this).val()}`, '');
        } else {
          localStorage.accounts = localStorage.accounts.replace(`${$(this).val()}`, '');
        }
      }
    }
  });

})
