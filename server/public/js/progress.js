function progress(percent, $element) {
    var progressBarWidth = percent * $element.width() / 100;

    if (percent < 4) {
        $element.find('div').width(progressBarWidth).html("&nbsp;" + percent + "%&nbsp;").css("color", "#000000");
        ;
    }
    else {
        $element.find('div').width(progressBarWidth).html("&nbsp;" + percent + "%&nbsp;").css("color", "#ffffff");
        ;
    }
}

function refresh_piazza() {
    $.post("test_runner/piazza_ajax", function (data) {
        var text = "";
        var json = JSON.parse(data);

        var prog_num = 0;
        json.forEach(function (prog) {
            text += "<div>";
            text += "<fieldset>";
            text += "<legend>" + prog.branch + "(" + prog.name + ")" + "</legend>";


            if (prog.result == 'Success.') {
                text += '<div class="overall_tests piazza_success">SUCCESS</div>';
            }
            else {
                text += '<div class="overall_tests piazza_failure">FAILURE</div>';
            }

            for (var i = 0; i < prog.tests.length; i++) {
                text += '<div class="piazza_test_container">';

                if (prog.tests[i].running) {
                    text += '<div class="piazza_1 piazza_running">';
                }
                else {
                    text += '<div class="piazza_1 ' + (prog.tests[i].result == 'PASSED' ? 'piazza_success' : 'piazza_failure') + '">';
                }


                text += prog.tests[i].name + " #" + prog.tests[i].revision;
                text += '</div>';

                if (prog.tests[i].running) {
                    text += '<div class="piazza_2">';
                    text += '<div class="progressBar_' + prog_num + '_' + i + ' progressBar"><div></div></div>';
                    text += '</div>';
                }


                if (prog.tests[i].running) {
                    text += '<div class="piazza_3">';
                    text += '<table class="tests_so_far">';
                    text += '<tr><td>Tests passed: </td><td><b>&nbsp;&nbsp;' + prog.tests[i].passed_so_far + '</b></td></tr>';
                    if (prog.tests[i].failed_so_far > 0) {
                        text += '<tr class="piazza_failure">';
                    }
                    else {
                        text += '<tr>';
                    }

                    text += '<td>Tests failed: </td><td><b>&nbsp;&nbsp;' + +prog.tests[i].failed_so_far + '</b></td></tr>';
                    text += '</table>';
                    text += '</div>';
                }

                text += "</div>";

            }

            text += "</fieldset>";
            text += "</div>";

            prog_num++;
        });

        $("#piazza").html(text);

        prog_num = 0;
        json.forEach(function (prog) {
            for (var i = 0; i < prog.tests.length; i++) {
                progress((prog.tests[i].progress == null ? "0" : prog.tests[i].progress ), $('.progressBar_' + prog_num + '_' + i));
            }
            prog_num++;
        });

    });
}
