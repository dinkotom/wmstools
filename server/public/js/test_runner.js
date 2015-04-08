var table;
var table_items_num = $("#table_items_num").val();
var current_page = $("#table_page").val();

var filter_test_suite = $("#test_suits").val();
var filter_environment = $("#environments").val();


var reload_in_ms = 5000;

$(document).ready(function () {

    Messenger.options = {
        extraClasses: 'messenger-fixed messenger-on-top messenger-on-right',
        theme: 'block'
    };

    if ((typeof table_items_num !== 'undefined') && (typeof current_page !== 'undefined')) {
        reload_table(current_page, table_items_num, filter_test_suite, filter_environment);
        setInterval(function () {
            reload_table(current_page, table_items_num, filter_test_suite, filter_environment);
        }, reload_in_ms);
    }

    //reload select lists
    $("#environment").change();

});

function reload_table(page, items, test_suite, environment) {
    if (typeof $.cookie('environment') !== 'undefined') {
        environment = $.cookie('environment');
        $("#environments").val(environment);
    }
    else {
        environment = 'false'
    }

    if (typeof $.cookie('test_suite') !== 'undefined') {
        test_suite = $.cookie('test_suite');
        $("#test_suits").val(test_suite);
    }
    else {
        test_suite = 'false'
    }


    if (typeof $.cookie('page') !== 'undefined') {
        page = parseInt($.cookie('page'));
    }
    else {
        page = 1
    }

    $("#table_page").val(page);

    parse_table = function (data) {
        var displayed_rows = 0;
        var rows = "";
        var odd = true;
        //console.log(data);
        JSON.parse(data).forEach(function (r) {

            if (r.items_count) {
                tmp1 = Math.floor(r.items_count / table_items_num);
                tmp2 = r.items_count % table_items_num;

                current_page = $("#table_page").val();
                var from = ((table_items_num * current_page) - table_items_num) + 1;

                var to = table_items_num * current_page;
                if (displayed_rows < table_items_num) {
                    to = r.items_count;
                }

                if (tmp2 != 0) {
                    tmp1++;
                }

                var button = "";
                for (var i = 1; i < tmp1 + 1; i++) {
                    button += '<button type="button" ';

                    if (i == current_page) {
                        button += 'class="paginate_active" ';
                    }
                    else {
                        button += 'class="paginate_button" ';
                    }

                    button += 'onclick="switch_page(' + i + "," + table_items_num + ')"';
                    button += '>' + i + '</button>';
                }
                $("#table_pagination").empty();
                $("#table_pagination").append(button);
            }
            else {
                odd = !odd;

                if (odd) {
                    rows += '<tr class="odd_row">';
                }
                else {
                    rows += '<tr>';
                }

                rows += '<td style="text-align: center;white-space: nowrap;">';

                rows += '<a href="/test_runner/' + r.id + '?back=test_runner">' + r.started_at + '</a>';


                rows += '</td>';

                rows += '<td style="text-align: center;">' + (r._for) + '</td>';
                rows += '<td style="text-align: center;white-space: nowrap;">' + r.test_suite_name + '</td>';
                rows += '<td style="text-align: center;">' + r.environment_name + '</td>';

                //failed tests
                rows += '<td style="text-align: center;">' + r.failed_tests + '</td>';

                //passed tests
                rows += '<td style="text-align: center;">' + r.passed_tests + '</td>';

                rows += '<td style="text-align: center;">' + r.status + '</td>';
                rows += '<td style="text-align: center;">' + r.node_id + '</td>';

                //duration
                if (r.duration == null) {
                    rows += '<td style="text-align: center;"></td>';
                }
                else {
                    rows += '<td style="text-align: center;">' + r.duration + '</td>';
                }

                //result
                var regex_success = new RegExp("^PASSED", "g");
                var regex_failure = new RegExp("^FAILED", "g");
                if (regex_success.test(r.result)) {
                    rows += '<td style="text-align: center;"><div class="success">' + r.result + '</div></td>';
                }
                else if (regex_failure.test(r.result)) {
                    rows += '<td style="text-align: center;"><div class="failure">' + r.result + '</div></td>';
                }
                else {
                    rows += '<td style="text-align: center;"><div class="unknown">' + r.result + '</div></td>';
                }


                //revision
                if (r.revision == null) {
                    rows += '<td style="text-align: center;"></td>';
                }
                else {
                    rows += '<td style="text-align: center;">' + r.revision + '</td>';
                }


                //jira
                rows += '<td style="white-space: nowrap;">' + r.jira_issue + '</td>';

                //comment
                rows += '<td style="white-space: nowrap;"><input type="hidden" value="' + r.id + '" /><img class="clickable_img" src="/img/comment.png"/>&nbsp;&nbsp;';
                if (r.comment == null) {
                    rows += '<span></span>';
                }
                else {
                    if (r.comment.length > 54) {
                        rows += '<span>' + r.comment.substring(0, 49) + '...</span>';
                    }
                    else {
                        rows += '<span>' + r.comment + '</span>';
                    }
                }
                rows += '</td>';

                //action
                rows += '<td style="text-align: center;">';
                if (r.status == 'Finished' || r.status == 'Failed') {
                    rows += '<button type="button" class="tiui-btn-rmv tiui-blue" onclick="exec(';
                    rows += "'" + r.id + "/hide_ajax'";
                    rows += ');">Hide</button>';
                }
                if (r.status == 'Pending') {
                    rows += '<button type="button" class="tiui-btn-rmv tiui-blue" onclick="exec(';
                    rows += "'" + r.id + "/remove_ajax'";
                    rows += ');">Remove</button>';
                }
                if (r.status == 'Running') {
                    rows += '<button type="button" class="tiui-btn-rmv tiui-blue" onclick="return confirmation(';
                    rows += "'" + r.id + "/kill'";
                    rows += ');">Kill</button>';

                }
                rows += '</td>';

                rows += "</tr>";

                displayed_rows++;
            }
        });
        $('#data_table > tbody:last').html(rows);

        $(".loading_circle").hide();
    };

    $.post("test_runner/table_data",
        {
            'page': page,
            'items': items,
            'test_suite': test_suite,
            'environment': environment
        })
        .done(parse_table);
}

function switch_page(page, items) {
    $("#table_page").val(page);

    $.cookie('page', page, { expires: 0.1, path: '/' });

    $(".loading_circle").show();

    reload_table(page, items, filter_test_suite, filter_environment);
}

function exec(url) {
    exec_action(url, current_page, table_items_num);
}

function exec_action(url, page, items) {
    $(".loading_circle").show();
    $.post("test_runner/" + url, function (data) {
        if (data == "1") {
            reload_table(current_page, table_items_num, filter_test_suite, filter_environment);

            Messenger().post({
                message: 'Action performed',
                type: 'success',
                hideAfter: 5
            });
        }
        else {
            $(".loading_circle").hide();
            Messenger().post({
                message: 'Error performing aciton',
                type: 'error',
                hideAfter: 5

            });
        }
    });
}

function confirmation(url) {
    var answer = confirm("Do you really want to kill running test execution?");

    if (answer == true) {
        exec_action(url, current_page, table_items_num);
    }
}

var position;
var id;
var clicked_td;
var comment = {
    message: null,
    init: function () {
        $('#data_table').on("click", ".clickable_img", function (e) {
            e.preventDefault();

            id = $(this).parent().children().first().val();
            clicked_td = $(this).parent();
            position = $(this).position();

            var doc = document.documentElement;
            var left_scroll = (window.pageXOffset || doc.scrollLeft) - (doc.clientLeft || 0);
            var top_scroll = (window.pageYOffset || doc.scrollTop)  - (doc.clientTop || 0);

            var modal_position_top;
            var modal_position_left;

            // if click is on the bottom of the screen then position of modal is on top of click
            if((position.top - top_scroll + 280) > screen.height) 
            {
                modal_position_top = position.top - top_scroll - 170 - 7;
            }
            else
            {
                modal_position_top = position.top - top_scroll + 20;
            }

            modal_position_left = position.left - left_scroll - 6;
            
            $.get("/test_runner/" + id + "/get_comment", function (data) {

                $("#comment_area").html(data);
                $("#modal_container").modal({
                    position: ["15%", ],
                    onOpen: comment.open,
                    onShow: comment.show,
                    onClose: comment.close,
                    position: [modal_position_top, modal_position_left],
                    closeClass: "modal-close"
                });
            });

        });
    },
    open: function (dialog) {
        $(".loading_circle").show();

        dialog.overlay.fadeIn(1, function () {
            dialog.container.fadeIn(1, function () {
                dialog.data.fadeIn(1, function () {

                    var area = $("#comment_area");
                    var strLength = area.val().length;
                    area.focus();
                    area[0].setSelectionRange(strLength, strLength);
                    $(".loading_circle").hide();
                });
            });
        });
    },
    close: function (dialog) {
        dialog.data.fadeOut(200, function () {
            dialog.container.fadeOut(200, function () {
                dialog.overlay.fadeOut(200, function () {

                    $.modal.close();
                });
            });
        });
    },
    error: function (xhr) {
        alert(xhr.statusText);
    },
    showError: function () {
        $('#comment-container .comment-message')
            .html($('<div class="comment-error"></div>').append(comment.message))
            .fadeIn(200);
    }
};
comment.init();


//enter handler
$(document).keypress(function (e) {

    if (e.which == 13 && e.shiftKey && $("#modal_container").css("display") != "none") {
        var text = $("#comment_area").val();
        $("#comment_area").val(text + '\n');
    }
    else if (e.which == 13 && $("#modal_container").css("display") != "none") {
        $.post("test_runner/" + id + "/save_comment", { 'comment': $("#comment_area").val() }, function (data) {
            if (data == "1") {
                var cmnt = $("#comment_area").val();
                $("span:first", clicked_td).html(cmnt.substring(0, 54));

                if (cmnt.length > 54) {
                    $("span:first", clicked_td).append("...");
                }
                $("#button_close_modal").click();

                Messenger().post({
                    message: 'Action performed',
                    type: 'success',
                    hideAfter: 5
                });
            }
            else {
                Messenger().post({
                    message: 'Error performing aciton',
                    type: 'error',
                    hideAfter: 5
                });
            }
        });
    }


});

//disable form submit on enter keypress and enqueue instead
$('#main_form').bind("keypress", function (e) {
    var code = e.keyCode || e.which;
    if (code == 13) {
        e.preventDefault();
        enqueue(current_page, table_items_num);
        return false;
    }
});


$("#save_comment").click(function () {

    $(".loading_circle").show();

    $.post("test_runner/" + id + "/save_comment", { 'comment': $("#comment_area").val() }, function (data) {
        if (data == "1") {
            $("#button_close_modal").click();
            reload_table(current_page, table_items_num, filter_test_suite, filter_environment);
            Messenger().post({
                message: 'Action performed',
                type: 'success',
                hideAfter: 5
            });
        }
        else {
            $(".loading_circle").hide();
            Messenger().post({
                message: 'Error performing aciton',
                type: 'error',
                hideAfter: 5
            });
        }
    });
});

$("#save_jira").click(function () {
    $(".loading_circle").show();
    $.post("test_runner/" + id + "/create_issue_ajax", { 'id': id, 'comment': $("#comment_area").val() }, function (data) {
        r = JSON.parse(data);
        if (r.result == "1") {
            $("#button_close_modal").click();
            reload_table(current_page, table_items_num, filter_test_suite, filter_environment);
            Messenger().post({
                message: 'Action performed',
                type: 'success',
                hideAfter: 5
            });
        }
        else {
            $(".loading_circle").hide();
            Messenger().post({
                message: r.msg,
                type: 'error',
                hideAfter: 5
            });
        }
    });
});


$('#for').on('input', function () {
    var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
    if (regex.test(this.value)) {
        $(this).attr("class", "piazza_success");
    }
    else {
        $(this).attr("class", "piazza_failure");
    }

    if (this.value == null || this.value == "") {
        $(this).attr("class", "");
    }
});

$("#enqueue").click(function () {

    current_page = 1;
    switch_page(current_page, table_items_num);
    enqueue(current_page, table_items_num);
});


//filter select

$("#test_suits").change(function () {
    filter_test_suite = $("#test_suits").val();

    $.cookie('test_suite', filter_test_suite, { expires: 0.1, path: '/' });

    $("#table_page").val("1");
    current_page = 1;

    switch_page(current_page, table_items_num)
});

$("#environments").change(function () {

    filter_environment = $("#environments").val();
    $.cookie('environment', filter_environment, { expires: 0.1, path: '/' });

    $("#table_page").val("1");
    current_page = 1;

    reload_table(current_page, table_items_num, filter_test_suite, filter_environment);
});

//menu environment select list
$("#environment, #test_scope").change(function () {

    $.post("test_runner/test_suites",
        {
            'environment': $("#environment").val(),
            'scope': $("#test_scope").val()
        },
        function (data) {

            var html = "";
            var first = true;

            JSON.parse(data).forEach(function (suite) {

                if (first) {
                    first = false;
                    html += '<option value="' + suite.value + '" selected="selected">' + suite.value + '</option>';
                }
                else {
                    html += '<option value="' + suite.value + '">' + suite.value + '</option>';
                }

            });

            $("#test_suite_name").empty().append(html);
        }
    );

});

function get_test_suits() {

}

function enqueue(page, items) {

    if (validateForm())
        if (true) {
            $(".loading_circle").show();

            $.post("test_runner/enqueue",
                {
                    'for': $("#for").val(),
                    'test_suite_name': $("#test_suite_name option:selected").val(),
                    'environment': $("#environment option:selected").val()
                },
                function (data) {

                    if (data == "1") {
                        reload_table(page, items, filter_test_suite, filter_environment);

                        $("#for").val("");

                        Messenger().post({
                            message: 'Action performed',
                            type: 'success',
                            hideAfter: 5
                        });
                    }
                    else {
                        $("#for").val("");
                        $(".loading_circle").hide();

                        Messenger().post({
                            message: 'Error performing aciton',
                            type: 'error',
                            hideAfter: 5
                        });
                    }
                }
            );
        }
}

function validateForm() {
//        var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;

    var regex = /[a-zA-Z0-9_.+-]+/;
    if (regex.test($("#for").val())) {
        return true;
    }
    else {
        alert("Field For has to have at least one character.");
        return false;
    }
}