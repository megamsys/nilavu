var ViewBucket = React.createClass({

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
    <div className="row">
    <div className="col-xs-12 col-sm-9 col-md-9 br_grey">
     <div className="" id="app-grid">
      <div className="row app_box app_storage my_bucket">
       <div className="col-xs-12 col-sm-6 col-md-3  app_cover my_bucket_inner">
            <div className="app_inner">
             <div className="app_new">
               <span className="glyphicon glyphicon-plus"></span>
               <p>
                  Create Storage
               </p>
            </div>
            </div>
           </div>
          </div>
          <BucketBox data={this.state.data} />
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


      <div className="col-xs-12 col-sm-9 col-md-9 br_grey">
       <div className="" id="app-grid">
        <div className="row app_box app_storage my_bucket">
         <div className="col-xs-12 col-sm-6 col-md-3  app_cover my_bucket_inner">
          <div className="app_inner">
           <div className="app">
             <div className="app_head">
               <div className="row app_icon">
                 <h5>{comment.bucket_name}</h5>
               </div>
             </div>
             <div className="app_footer">
               <span >Size  {comment.size}	 {comment.create_at}</span>
             </div>
            </div>
          </div>
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
