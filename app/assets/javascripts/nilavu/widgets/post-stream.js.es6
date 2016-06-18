import { createWidget } from 'nilavu/widgets/widget';
import transformPost from 'nilavu/lib/transform-post';
import { Placeholder } from 'nilavu/lib/posts-with-placeholders';
import { addWidgetCleanCallback } from 'nilavu/components/mount-widget';

const CLOAKING_ENABLED = !window.inTestEnv;
const DAY = 1000 * 60 * 60 * 24;

const _dontCloak = {};
let _cloaked = {};

export function preventCloak(postId) {
    _dontCloak[postId] = true;
}

export function cloak(post, component) {
    if (!CLOAKING_ENABLED || _cloaked[post.id] || _dontCloak[post.id]) {
        return; }

    const $post = $(`#post_${post.post_number}`);
    _cloaked[post.id] = $post.outerHeight();
    Ember.run.debounce(component, 'queueRerender', 1000);
}

export function uncloak(post, component) {
    if (!CLOAKING_ENABLED || !_cloaked[post.id]) {
        return; }
    _cloaked[post.id] = null;
    component.queueRerender();
}

addWidgetCleanCallback('post-stream', () => _cloaked = {});

/*
<section class="cd-faq">
<div class="cd-faq-items">
  <ul id="basics" class="cd-faq-group">
    <li class="">
      <a class="cd-faq-trigger" href="#0">How do I change my password?</a>
      <div class="cd-faq-content">
        <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Quae quidem blanditiis delectus corporis, possimus officia sint sequi ex tenetur id impedit est pariatur iure animi non a ratione reiciendis nihil sed consequatur atque repellendus fugit perspiciatis rerum et. Dolorum consequuntur fugit deleniti, soluta fuga nobis. Ducimus blanditiis velit sit iste delectus obcaecati debitis omnis, assumenda accusamus cumque perferendis eos aut quidem! Aut, totam rerum, cupiditate quae aperiam voluptas rem inventore quas, ex maxime culpa nam soluta labore at amet nihil laborum? Explicabo numquam, sit fugit, voluptatem autem atque quis quam voluptate fugiat earum rem hic, reprehenderit quaerat tempore at. Aperiam.</p>
      </div> <!-- cd-faq-content -->
    </li>

    <li>
      <a class="cd-faq-trigger" href="#0">How do I sign up?</a>
      <div class="cd-faq-content">
        <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Quasi cupiditate et laudantium esse adipisci consequatur modi possimus accusantium vero atque excepturi nobis in doloremque repudiandae soluta non minus dolore voluptatem enim reiciendis officia voluptates, fuga ullam? Voluptas reiciendis cumque molestiae unde numquam similique quas doloremque non, perferendis doloribus necessitatibus itaque dolorem quam officia atque perspiciatis dolore laudantium dolor voluptatem eligendi? Aliquam nulla unde voluptatum molestiae, eos fugit ullam, consequuntur, saepe voluptas quaerat deleniti. Repellendus magni sint temporibus, accusantium rem commodi?</p>
      </div> <!-- cd-faq-content -->
    </li>

    <li>
      <a class="cd-faq-trigger" href="#0">Can I remove a post?</a>
      <div class="cd-faq-content">
        <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Blanditiis provident officiis, reprehenderit numquam. Praesentium veritatis eos tenetur magni debitis inventore fugit, magnam, reiciendis, saepe obcaecati ex vero quaerat distinctio velit.</p>
      </div> <!-- cd-faq-content -->
    </li>

    <li>
      <a class="cd-faq-trigger" href="#0">How do reviews work?</a>
      <div class="cd-faq-content">
        <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Blanditiis provident officiis, reprehenderit numquam. Praesentium veritatis eos tenetur magni debitis inventore fugit, magnam, reiciendis, saepe obcaecati ex vero quaerat distinctio velit.</p>
      </div> <!-- cd-faq-content -->
    </li>
  </ul> <!-- cd-faq-group -->

</div> <!-- cd-faq-items -->
</section> <!-- cd-faq -->
<!-- <div class="">
    <div class="row c_pading-b25">
        <div class="bottom-divider"></div>
        <h3>
            <span>deploy one</span>
            <i class="circle_green pull-right blink-me"></i>
            <i class="c_icon-star pull-right" style="padding-right:30px"></i>
        </h3>
        <h3>
            <span>deploy one</span>
            <i class="circle_green pull-right blink-me"></i>
            <i class="c_icon-star pull-right" style="padding-right:30px"></i>
        </h3>
    </div>
</div>


<div class="cd-faq-items">
      <ul id="basics" class="style:none; cd-faq-group">
          <li class="style:none">
              <div class="cd-faq-trigger">
                How do I sign up?
                <i class="circle_green pull-right"> </i>
               </div>
              <!-- cd-faq-content -->
          </li>
      </ul>
      <!-- cd-faq-group -->
  </div>
*/
export default createWidget('post-stream', {
    tagName: 'ul.cd-faq-group',

    html(attrs) {
        const posts = attrs.posts || [];
        const postArray = posts.toArray();

        const result = [];

        const before = attrs.gaps && attrs.gaps.before ? attrs.gaps.before : {};
        const after = attrs.gaps && attrs.gaps.after ? attrs.gaps.after : {};

        let prevPost;
        let prevDate;

        const mobileView = this.site.mobileView;
        for (let i = 0; i < postArray.length; i++) {
            const post = postArray[i];

            const nextPost = (i < postArray.length - 1) ? postArray[i + 1] : null;

            result.push(this.attach('post', post, { model: post }));

            const afterGap = after[post.id];
            if (afterGap) {
                result.push(this.attach('post-gap', { pos: 'after', postId: post.id, gap: afterGap }, { model: post }));
            }

            prevPost = post;
        }
        //alert ("post=stream =>" +JSON.stringify(result));
        return result;
    }
});
