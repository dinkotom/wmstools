var page = 1;
var items = 10;



test("Test Reload table", function() {
	var url = "test_runner/table_data";
    var spy = this.spy(jQuery, "post");
      	
    reload_table(page,items);
    
	ok(spy.calledOnce, "Post requested");
	ok(spy.calledWith(url), "Post requested at " + url);
});

test("Test Refresh Piazza", function() {
	
	var url = "test_runner/piazza_ajax";
    var spy = this.spy(jQuery, "post");
    
    refresh_piazza();
    
	ok(spy.calledOnce, "Post requested");
	ok(spy.calledWith(url), "Post requested at " + url);
});



test("Test Enqueue Task", function() {

	var url = "test_runner/enqueue";
    var spy = this.spy(jQuery, "post");
    
    $.mockjax({
  		url: url,
  		type: "post",
  		responseText: {
    		success: true,
    		data: "ok"
  		}
	});
    
    sinon.stub(window,"validateForm").returns(true);

    enqueue(page, items);
    
	ok(spy.calledOnce, "Post requested");
	ok(spy.calledWith(url), "Post requested at " + url);
	
	$.mockjaxClear();
});


test("Test Remove Task", function() {


	var url_action = "999999/remove_ajax";
	var url = "test_runner/" + url_action;
    var spy = this.spy(jQuery, "post");
    
    $.mockjax({
  		url: url,
  		type: "post",
  		responseText: {
    		success: true,
    		data: "ok"
  		}
	});
    
    exec_action(url_action, page, items);
    
	ok(spy.calledOnce, "Post requested");
	ok(spy.calledWith(url), "Post requested at " + url);
	
	$.mockjaxClear();

});


test("Test Hide Task", function() {
	var url_action = "999999/hide_ajax";
	var url = "test_runner/" + url_action;
    var spy = this.spy(jQuery, "post");
    
    $.mockjax({
  		url: url,
  		type: "post",
  		responseText: {
    		success: true,
    		data: "ok"
  		}
	});
    
    exec_action(url_action, page, items);
    
	ok(spy.calledOnce, "Post requested");
	ok(spy.calledWith(url), "Post requested at " + url);
	
	$.mockjaxClear();

});

test("Test Kill Task", function() {
	var url_action = "999999/kill_ajax";
	var url = "test_runner/" + url_action;
    var spy = this.spy(jQuery, "post");
    
    $.mockjax({
  		url: url,
  		type: "post",
  		responseText: {
    		success: true,
    		data: "ok"
  		}
	});
    
    exec_action(url_action, page, items);
    
	ok(spy.calledOnce, "Post requested");
	ok(spy.calledWith(url), "Post requested at " + url);
	
	$.mockjaxClear();

});

test("Test Save Comment", function() {
	var url_action = "999999/save_comment";
	var url = "test_runner/" + url_action;
    var spy = this.spy(jQuery, "post");
    
    $.mockjax({
  		url: url,
  		type: "post",
  		responseText: {
    		success: true,
    		data: "ok"
  		}
	});
    
    $.post(url,  function(data){
	});
    
	ok(spy.calledOnce, "Post requested");
	ok(spy.calledWith(url), "Post requested at " + url);
	
	$.mockjaxClear();

});

test("Test Create Jira Issue", function() {
	var url_action = "999999/create_issue_ajax";
	var url = "test_runner/" + url_action;
    var spy = this.spy(jQuery, "post");
    
    $.mockjax({
  		url: url,
  		type: "post",
  		responseText: {
    		success: true,
    		data: "ok"
  		}
	});
    
    $.post(url,  function(data){
	});
    
	ok(spy.calledOnce, "Post requested");
	ok(spy.calledWith(url), "Post requested at " + url);
	
	$.mockjaxClear();

});

test("Test Get Comment", function() {
	var url_action = "999999/get_comment";
	var url = "test_runner/" + url_action;
    var spy = this.spy(jQuery, "get");
    
    $.mockjax({
  		url: url,
  		type: "get",
  		responseText: {
    		success: true,
    		data: "ok"
  		}
	});
    
    $.get(url, function(data){
	});
  
	ok(spy.calledOnce, "Get requested");
	ok(spy.calledWith(url), "Get requested at " + url);
	
	$.mockjaxClear();

});

