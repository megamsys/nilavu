
var ReactS3Uploader = React.createClass({

    uploadFile: function() {
        S3Upload(findDOMNode(this));
    },

    render: function() {
     //return React.DOM.input(objectAssign({}, this.props, {type: 'file', onChange: this.uploadFile}));
      //return <div><p> Megam Systems </p></div>
      //return <input type="file" onChange={this.uploadFile} />
    }

});

function findDOMNode(cmp) {
    return React.findDOMNode ? React.findDOMNode(cmp) : cmp.getDOMNode();
}

function S3Upload(fileElement) {
  /*  if (options == null) {
        options = {};
    }
    for (var option in options) {
        if (options.hasOwnProperty(option)) {
            this[option] = options[option];
        }
    }*/
    var files = fileElement ? fileElement.files : files || [];
    handleFileSelect(files);
}

function handleFileSelect(files) {
    onProgress(0, 'Waiting');
    var result = [];
    for (var i=0; i < files.length; i++) {
        var f = files[i];
        result.push(uploadFile(f));
    }
    return result;
};

 function uploadFile(file) {
    return executeOnSignedUrl(file, function(signResult) {
        return uploadToS3(file, signResult);
    }.bind(this));
};

function onProgress(percent, status) {
    return console.log('base.onProgress()', percent, status);
};

function executeOnSignedUrl(file, callback) {
    var xhr = new XMLHttpRequest();
    var fileName = file.name.replace(/\s+/g, "_");

    xhr.open('GET',"/sign_auth", true);

    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4 && xhr.status === 200) {
            var result;
            try {
                result = JSON.parse(xhr.responseText);
            } catch (error) {
                console.log('Invalid signing server response JSON: ' + xhr.responseText);
                return false;
            }
            return callback(result);
        } else if (xhr.readyState === 4 && xhr.status !== 200) {
        console.log('Invalid signing server response JSON: ' + xhr.responseText);
        console.log('Could not contact request signing server. Status = ' + xhr.status)
        return false;
            //return this.onError('Could not contact request signing server. Status = ' + xhr.status);
        }
    }.bind(this);
    return xhr.send();
};

function uploadToS3(file, signResult) {
    var fileName = file.name.replace(/\s+/g, "_");
    var xhr = createCORSRequest('PUT', "http://192.168.1.102/test_megam2711/"+ fileName + signResult.signedUrl);
    if (!xhr) {
        console.log('CORS not supported');
    } else {
        xhr.onload = function() {
            if (xhr.status === 200) {
                onProgress(100, 'Upload completed.');
                return onFinishS3Put(signResult);
            } else {
                return console.log('Upload error: ' + xhr.status);
            }
        }.bind(this);
        xhr.onerror = function() {
            return console.log('XHR error.' + xhr.status);
        }.bind(this);
        xhr.upload.onprogress = function(e) {
            var percentLoaded;
            if (e.lengthComputable) {
                percentLoaded = Math.round((e.loaded / e.total) * 100);
                return onProgress(percentLoaded, percentLoaded === 100 ? 'Finalizing' : 'Uploading');
            }
        }.bind(this);
    }
    xhr.setRequestHeader('Content-Type', file.type);
    var contentDisposition = "auto";
    if (contentDisposition) {
        var disposition = contentDisposition;
        if (disposition === 'auto') {
            if (file.type.substr(0, 6) === 'image/') {
                disposition = 'inline';
            } else {
                disposition = 'attachment';
            }
        }

        xhr.setRequestHeader('Content-Disposition', disposition + '; filename=' + fileName);
        xhr.setRequestHeader('Access-Control-Request-Method', 'PUT');
        xhr.setRequestHeader('Access-Control-Allow-Origin', '192.168.1.231:3000')
        }

        /*
        if (uploadRequestHeaders) {
        var uploadRequestHeaders = uploadRequestHeaders;
        Object.keys(uploadRequestHeaders).forEach(function(key) {
            var val = uploadRequestHeaders[key];
            xhr.setRequestHeader(key, val);
        });
    } else { */

        xhr.setRequestHeader('x-amz-acl', 'public-read');
    //}
    this.httprequest = xhr;
    return xhr.send(file);

};
function createCORSRequest(method, url) {
    var xhr = new XMLHttpRequest();

    if (xhr.withCredentials != null) {
        xhr.open(method, url, true);
    }
    else if (typeof XDomainRequest !== "undefined") {
        xhr = new XDomainRequest();
        xhr.open(method, url);
    }
    else {
        xhr = null;
    }
    return xhr;
};

function onFinishS3Put(signResult) {
   return console.log('base.onFinishS3Put()', signResult.signedUrl);
};
