var ShowBucket = React.createClass({

//  componentDidMount: function() {
  //  this.onChange();
//  },
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
    <div className="row">
     <div className="col-xs-12 col-sm-12 col-md-12 col-lg-12 col-xl-12">
        <div className="row app_box">
         <div className="row">
          <div className="col-lg-12 col-md-12 col-sm-12 col-xs-12">
           <div className="col-xs-12 col-sm-6 col-md-4 col-lg-3 col-xl-3 app_cover ">
            <div className="app_inner">
             <div className="app_new">
               <span className="glyphicon glyphicon-plus"></span>
               <p>
                  Create Storage
               </p>
            </div>
            </div>
           </div>
           <BucketBox data={this.state.data} />
          </div>

        </div>
       </div>
     </div>
    </div>
    <div class="storage-popup" >
	<ul class="list-unstyled">
		<li><a href=""><i class="c_icon-cloud-download pull-left"></i>Download File</a></li>
		<li><a href=""><i class="c_icon-cloud-download pull-left"></i>Download As</a></li>
		<li><a href=""><i class="c_icon-cloud-del pull-left"></i>Delete Bucket</a></li>
	</ul>
</div>
</div>
    );
  }
});
var BucketBox = React.createClass({

  render: function() {
   var BucketNodes = this.props.data.map(function (comment) {
     return (
     <div className="col-xs-12 col-sm-6 col-md-4 col-lg-3 col-xl-3 app_cover">
      <div className="app_inner">
       <div className="app">
        <div className="app_head">
         <div className="row app_icon">
          <h5> {comment.bucket_name} </h5>
         </div>
        </div>
         <div className="app_footer">
          <span > Size: {comment.size} </span>
          <span > {comment.create_at} </span>
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
});
