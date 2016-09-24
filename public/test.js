function testHomePage() {
    $.ajax({
        type: 'POST',
        //type: 'GET',
        //url: 'http://localhost:3000/web_pages/list',
        //url: 'http://localhost:3000/web_pages/register',
        url: '/web_pages/parse/1',
        //http://884879e7.ngrok.io/web_pages/parse/980190969
       // data: {url: 'http://www.html5rocks.com/en/tutorials/developertools/async-call-stack/'},
        success: function(data) {
            console.log(data);
        },
        error: function(jqXHR, textStatus, errorThrown) {
            console.log(jqXHR);
            console.log(errorThrown);
            console.log(textStatus);
        }
      });    
}
testHomePage();
