/*var ShowBucket = React.createClass({

getInitialState: function() {
        return { data : []}; //Here you could put initial data state
    },
  componentWillMount: function() {
        this.onChange();
    },


  onChange: function(e) {
  $.ajax({
      url: '/strgs',
      type: 'GET',
      dataType: 'json',
      success: function(data) {
                    this.setState({data: data});
                    //alert("data fetched")
      }.bind(this),
      error: function(xhr, status, err) {
        console.error('/strgs', status, err.toString());
      }.bind(this)

   });
    },
  render: function() {
    return (
  <div>
    <div>
      <div className="col-xs-12 col-sm-12 col-md-12 col-lg-12 col-xl-12">
       <div className="row app_box app_storage">
         <div className="col-xs-8 col-sm-4 col-md-3 col-lg-2 col-xl-2 app_cover my_bucket_inner">
          <div className="app_inner">
           <div className="app_new ">
            <span className="glyphicon glyphicon-plus"></span>
              <p>
                Create Storage
              </p>
           </div>
         </div>
        </div>
         <BucketBox data={this.state.data} />
       </div>
       <div className="storage-popup">
       	<ul className="list-unstyled">
       		<li><a href=""><i className="c_icon-cloud-download pull-left"></i>Download File</a></li>
       		<li><a href=""><i className="c_icon-cloud-download pull-left"></i>Download As</a></li>
       		<li><a href=""><i className="c_icon-cloud-del pull-left"></i>Delete Bucket</a></li>
       	</ul>
       </div>
    </div>
  </div>
</div>


    );
    }
  });
var BucketBox = React.createClass({

  render: function() {
   var BucketNodes = this.props.data.map(function (comment) {
     return (
     <div className="col-xs-8 col-sm-4 col-md-3 col-lg-2 col-xl-2 app_cover">
      <div className="app_inner">
       <div className="app">
        <div className="app_head">
         <div className="row app_icon">
          <h5> {comment.bucket_name} </h5>
          <h6> Size: {comment.size} </h6>
         </div>
        </div>
         <div className="app_footer">
          <span > Objects count:{comment.noofobjects}</span>
         </div>
       </div>
      </div>
     </div>
        );
   });
    return (
    <div className="commentList">
        {BucketNodes}
      </div>
    );
  }
});*/
