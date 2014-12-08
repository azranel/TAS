$(document).ready(function(){
    $('.add_debtor').click(function() {
        var $form = $(this).parent().find(".residents_list");
        if ($form.hasClass("hidden")) {
            $form.removeClass("hidden");
        } else {
            $form.addClass("hidden");
            $form.find("input:checked").trigger('click');
        }
    });
    $('.btn-adddebtor').click(function() {
        var $form = $(this).parent(),
            list_of_checked_debtors = $form.find("input:checked");
        if (list_of_checked_debtors.length > 0) {
            var list_of_ids = [];
            for (var i=0; i<list_of_checked_debtors.length; i++) {
                list_of_ids.push(list_of_checked_debtors[i].name);
            }
            var href = $form.find(".add_debtor").attr("href");
            $form.find(".add_debtor").attr("href", href + list_of_ids.join());
            $form.find(".add_debtor")[0].click();
        }
    });
});