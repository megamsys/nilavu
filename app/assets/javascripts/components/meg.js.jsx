var HelloMessage = React.createClass({

getInitialState: function () {
   return JSON.parse(this.props.message);
 },

  handleCommentSubmit: function (  event ) {
    event.preventDefault();
   $.ajax({
     url: "/strgs",
     type: "GET",
     success: function ( data ) {
     console.log(data)
     }.bind(this)
   });
 },
 render: function () {
   return (
   <div>
     <div>Title:hello megam welcome   </div>
      <button onclick={ this.handleCommentSubmit }>Click me</button>
     <div>Published: </div>
     <div>Published By: </div>
   </div>
   );
 }
});
