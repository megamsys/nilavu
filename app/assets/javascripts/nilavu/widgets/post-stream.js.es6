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

            prevPost = post;
        }
        return result;
    }
});
