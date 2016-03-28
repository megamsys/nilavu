import SelectedPostsCount from 'nilavu/mixins/selected-posts-count';
import ModalBodyView from "nilavu/views/modal-body";

export default ModalBodyView.extend(SelectedPostsCount, {
  templateName: 'modal/split-topic',
  title: I18n.t('topic.split_topic.title')
});
