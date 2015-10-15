$(function() {
  console.log('Hello, MEGAM...............!')
$('#file_upload').fileupload({
  forceIframeTransport: true,    // VERY IMPORTANT.  you will get 405 Method Not Allowed if you don't add this.
  autoUpload: true,
  add: function (event, data) {
    $.ajax({
      url: "/documents",
      type: 'POST',
      dataType: 'json',
      data: {doc: {title: data.files[0].name}},
      async: false,
      success: function(retdata) {
        // after we created our document in rails, it is going to send back JSON of they key,
        // policy, and signature.  We will put these into our form before it gets submitted to amazon.
        $('#file_upload').find('input[name=key]').val(retdata.key);
        $('#file_upload').find('input[name=policy]').val(retdata.policy);
        $('#file_upload').find('input[name=signature]').val(retdata.signature);
      }

    });

    data.submit();
  },
  send: function(e, data) {
    // show a loading spinner because now the form will be submitted to amazon,
    // and the file will be directly uploaded there, via an iframe in the background.
    $('#loading').show();
  },
  fail: function(e, data) {
    console.log('fail');
    console.log(data);
  },
  done: function (event, data) {
    // here you can perform an ajax call to get your documents to display on the screen.
    $('#your_documents').load("/documents?for_item=1234");

    // hide the loading spinner that we turned on earlier.
    $('#loading').hide();
  },
});
});
