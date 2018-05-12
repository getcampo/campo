application.register "post", class extends Stimulus.Controller
  reply: (event) ->
    replyToInput = document.querySelector('#comment_reply_to_comment_id')
    replyToInput.value = this.element.dataset.commentId
    replyToInput.disabled = false
    document.querySelector('#comment-form .reply-to-message-name').textContent = this.element.dataset.creatorName
    document.querySelector('#comment-form .reply-to-message').classList.add('show')
    document.querySelector('#comment-form textarea').focus()
