/*
 ** Copyright [2013-2015] [Megam Systems]
 **
 ** Licensed under the Apache License, Version 2.0 (the "License");
 ** you may not use this file except in compliance with the License.
 ** You may obtain a copy of the License at
 **
 ** http://www.apache.org/licenses/LICENSE-2.0
 **
 ** Unless required by applicable law or agreed to in writing, software
 ** distributed under the License is distributed on an "AS IS" BASIS,
 ** WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 ** See the License for the specific language governing permissions and
 ** limitations under the License.
 */
jQuery(document).ready(function() {

	// "ajax:beforeSend" and "ajax:complete" event hooks are
	// provided by Rails's jquery-ujs driver.
	jQuery("*[data-spinlock]").on('ajax:beforeSend', function(e) {
		$(this).spin("large", "Black");
		//$('#loading').fadeIn();
		console.log('spinlock started');
		//e.stopPropagation();
	}).on("ajax:success", function(xhr, data, status) {
		console.log('spinlock success');
		return false;
	}).on("ajax:complete", function(xhr, status) {
		$(this).spin(false);
		// $('#loading').fadeOut();
		console.log('spinlock complete');
		return false;
	}).on("ajax:error", function(xhr, status, error) {
		console.log('error ' + error + "status=" + status);
		var errorStr = "An error occurred when the attemping an ajax request. [status :" + xhr.status + ",   Status Text :" + xhr.status + ",   Exception :" + error + "]";
		console.log('Error ' + errorStr + "\n" + xhr.reponseText);
		return false;
	});

	var inProgress = false;
	Array.prototype.slice.call(document.querySelectorAll('#la-button')).forEach(function(el, i) {
		var anim = el.getAttribute('data-anim');
		var animEl = document.querySelector('.' + anim);
		el.addEventListener('click', function() {
			if (inProgress)
				return false;

			alert("Keep it on for testing.");

			inProgress = true;
			NProgress.start();

			classie.add(animEl, 'la-animate');
			NProgress.inc(0.2);
			setTimeout(function() {
				classie.remove(animEl, 'la-animate');
				inProgress = false;
				NProgress.done(true);
			}, 6000);
		});
	});

});

function removeAt(selector_to_remove) {
	$(selector_to_remove).remove();
	console.log('removed :' + selector_to_remove);
}

function insertAt(location, content_to_insert) {
	$(location).html(content_to_insert);
	console.log('inserted :' + location + ' =>' + content_to_insert);
}

function repWith(location, content_to_replace) {
	$(location).replaceWith(content_to_replace);
	console.log('replaced :' + location + ' =>' + content_to_replace);
}
